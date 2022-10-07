//::///////////////////////////////////////////////
//:: Grapple calling script: 
//:: prc_grapple
//::///////////////////////////////////////////////
/** @file
    Relies on prc_inc_combmove to do various things
    This does all of the grapple stuff that needs to
    happen

    @author Stratovarius
    @date   Created - 2018.9.18
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_combmove"
#include "moi_inc_moifunc"

int OptimalGrapple(object oPC, object oTarget)
{
    int nMauler = GetLevelByClass(CLASS_TYPE_REAPING_MAULER, oPC);
    int nBBC    = GetLevelByClass(CLASS_TYPE_BLACK_BLOOD_CULTIST, oPC);
    int nDC = 10 + nMauler + GetAbilityModifier(ABILITY_WISDOM, oPC);
    
    if (GetLocalInt(oPC, "Flay_Grapple"))
        return GRAPPLE_DAMAGE;    
    
    // You need a greater than 10% chance of it happening to trigger these options
    if (nMauler && (nDC > GetFortitudeSavingThrow(oTarget) + 2))
    {
        if (nMauler == 5 && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)) // Devastating Grapple
            return GRAPPLE_PIN; 
        if (nMauler >= 3 && !GetLocalInt(oTarget, "UnconsciousGrapple") && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)) // Target isn't unconscious
            return GRAPPLE_PIN;    
    }        
    if (GetHasSpellEffect(MOVE_SD_CRUSHING_WEIGHT, oPC))
        return GRAPPLE_TOB_CRUSHING;
    if ((nBBC >= 8 && GetHasSpellEffect(SPELLABILITY_BARBARIAN_RAGE, oPC)) || nBBC >= 10 || GetHasSpellEffect(VESTIGE_ZAGAN, oPC) && GetLocalInt(oPC, "ExploitVestige") != VESTIGE_ZAGAN_CONSTRICT)
        return GRAPPLE_DAMAGE;
    if (GetIsMeldBound(oPC, MELD_RAGECLAWS) == CHAKRA_TOTEM)   
    	return GRAPPLE_ATTACK;
    // You've got an ability that wants a light weapon 
    if (GetHasSpellEffect(MOVE_TC_WOLVERINE_STANCE, oPC) || GetLevelByClass(CLASS_TYPE_WARFORGED_JUGGERNAUT, oPC) || GetLocalInt(oPC, "ScorpionLight"))
        return GRAPPLE_ATTACK;
    if (GetHasFeat(FEAT_EARTHS_EMBRACE, oPC) && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)) // Earth's Embrace
            return GRAPPLE_PIN;         
        
    if (FindUnarmedDamage(oPC) > 2)
        return GRAPPLE_DAMAGE;
    
    object oPCWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oMonster  = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
    int nPCGold;
    int nMonster;
    
    if(GetIsLightWeapon(oTarget)) nMonster = GetGoldPieceValue(oMonster);
    if(GetIsLightWeapon(oPC)) nPCGold = GetGoldPieceValue(oPCWeapon);
    if (nMonster > nPCGold) 
        return GRAPPLE_OPPONENT_WEAPON;
    else if (GetIsLightWeapon(oPC))
        return GRAPPLE_ATTACK;
        
    return GRAPPLE_DAMAGE;    
}

int CanGrapple(object oPlayer)
{
     effect e1 = GetFirstEffect(oPlayer);
     int nType;
     int bRet = TRUE;
     while (GetIsEffectValid(e1) && !bRet)
     {
        nType = GetEffectType(e1);

        if (nType == EFFECT_TYPE_STUNNED || nType == EFFECT_TYPE_PARALYZE ||
            nType == EFFECT_TYPE_SLEEP || nType == EFFECT_TYPE_PETRIFY || nType == EFFECT_TYPE_DAZED)
         {
           bRet = FALSE;
         }
         e1 = GetNextEffect(oPlayer);
     }
    return bRet;
}

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_grapple running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nGrappled = GetGrapple(oPC);
    if(nEvent == EVENT_ONHEARTBEAT && nGrappled) // We're in a grapple
    	oTarget = GetGrappleTarget(oPC);    
    
    if (DEBUG) DoDebug("prc_grapple: oPC "+GetName(oPC)+" oTarget "+GetName(oTarget)+" nGrappled "+IntToString(nGrappled));
    
    if (oTarget == oPC) return; // Don't hit yourself
         
    // We aren't being called from any event, instead from the feat
    if(nEvent == FALSE)
    {
        // Grapple the target
        if (GetIsObjectValid(oTarget))
        {
            if (!GetGrapple(oTarget) && !GetGrapple(oPC))
            {
                // And now we can grab them
                DoGrapple(oPC, oTarget, 0);
            }
        }    
    }       
    else if(nEvent == EVENT_ONHEARTBEAT && nGrappled) // We're in a grapple
    {
        // If you die, clean up right away
        if (GetIsDead(oPC)) 
        {
            EndGrapple(oPC, oTarget);
            // Remove the hooks
            if(DEBUG) DoDebug("prc_grapple: Removing eventhooks");
            RemoveEventScript(oPC, EVENT_ONHEARTBEAT,         "prc_grapple", TRUE, FALSE);  
        }     
        
        if (!GetIsObjectValid(oTarget)) // Clean up if the target is invalid
        {
            EndGrapple(oPC, oTarget);
            // Remove the hooks
            if(DEBUG) DoDebug("prc_grapple: Removing eventhooks");
            RemoveEventScript(oPC, EVENT_ONHEARTBEAT,         "prc_grapple", TRUE, FALSE);  
            FloatingTextStringOnCreature("Your target is invalid, ending grapple", oPC, FALSE);            
        }
        
        // Monsters always try and escape the grapple or pin, have to be able to move to try that though.
        if (CanGrapple(oTarget) && !GetLocalInt(oTarget, "UnconsciousGrapple"))
            DoGrappleOptions(oTarget, oPC, 0, GRAPPLE_ESCAPE);
        
        // If you can't grapple any more, end the grapple
        if (!CanGrapple(oPC))
        {
            EndGrapple(oPC, oTarget);
            // Remove the hooks
            if(DEBUG) DoDebug("prc_grapple: Removing eventhooks");
            RemoveEventScript(oPC, EVENT_ONHEARTBEAT,         "prc_grapple", TRUE, FALSE);  
            FloatingTextStringOnCreature("You are too stunned to grapple, ending grapple", oPC, FALSE);         
        }
        
        // Player's Turn, checks to see if the monster escaped
        if (GetGrapple(oPC))
            DoGrappleOptions(oPC, oTarget, 0, OptimalGrapple(oPC, oTarget));

        // If you kill them with grappling, best to clean up right away
        if (GetIsDead(oTarget)) 
        {
            EndGrapple(oPC, oTarget);
            // Remove the hooks
            if(DEBUG) DoDebug("prc_grapple: Removing eventhooks");
            RemoveEventScript(oPC, EVENT_ONHEARTBEAT,         "prc_grapple", TRUE, FALSE);  
            FloatingTextStringOnCreature("Your target is dead, ending grapple", oPC, FALSE);            
        }        
    }    
         
}