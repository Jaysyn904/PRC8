/**
 * @file
 * Spellscript for Bow of the Black Archer SLAs
 *
 */

//#include "inc_newspellbook"
#include "prc_inc_template"
#include "prc_inc_combat"
#include "spinc_teleport"

int IsDrow(object oTarget)
{
    int nRace = GetRacialType(oTarget);
    if(nRace == RACIAL_TYPE_DROW_MALE
        || nRace == RACIAL_TYPE_DROW_FEMALE
        || nRace == RACIAL_TYPE_HALFDROW
        || nRace == RACIAL_TYPE_DRIDER
        )
        return TRUE;
        
    int nAppear = GetAppearanceType(oTarget);
    if(nAppear == APPEARANCE_TYPE_DROW_CLERIC ||
       nAppear == APPEARANCE_TYPE_DROW_FEMALE_1 ||
       nAppear == APPEARANCE_TYPE_DROW_FEMALE_2 ||
       nAppear == APPEARANCE_TYPE_DROW_FIGHTER ||
       nAppear == APPEARANCE_TYPE_DROW_MATRON ||
       nAppear == APPEARANCE_TYPE_DROW_SLAVE ||
       nAppear == APPEARANCE_TYPE_DROW_WARRIOR_1 ||
       nAppear == APPEARANCE_TYPE_DROW_WARRIOR_2 ||
       nAppear == APPEARANCE_TYPE_DROW_WARRIOR_3 ||
       nAppear == APPEARANCE_TYPE_DROW_WIZARD ||
       nAppear == APPEARANCE_TYPE_DRIDER ||
       nAppear == APPEARANCE_TYPE_DRIDER_CHIEF ||
       nAppear == APPEARANCE_TYPE_DRIDER_FEMALE)
        return TRUE;
        
    return FALSE;    
}        

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    
    object oBow = GetItemPossessedBy(oPC, "BowoftheBlackArcher");
    
    // You get nothing if you aren't wielding the bow
    if(oBow != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;    

    switch(nSLA){
        case WOL_BBB_EYES_SHADOW:
        {
            nCasterLevel = 5;
            nSpell = SPELL_DARKVISION;
            nUses = 1;
            break;
        }
        case WOL_BBB_LONGSTRIDER:
        {
            nCasterLevel = 5;
            nSpell = SPELL_LONGSTRIDER;
            nUses = 3;
            break;
        }
        case WOL_BBB_SOLACE:
        {
            nCasterLevel = 5;
            nSpell = SPELL_LESSER_RESTORATION;
            nUses = 2;
            break;
        }  
        case WOL_BBB_FRIEND_SHADOWS:
        {
            nCasterLevel = 11;
            nUses = 1;
            
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {     
                Teleport(oPC, nCasterLevel, SPELL_TELEPORT, FALSE, "");
                SetLegacyUses(oPC, nSLA);
            }             
            break;
        }   
        case WOL_BBB_DENY_DEMONWEB:
        {
            nCasterLevel = 10;
            nSpell = SPELL_PROTECTION_FROM_EVIL;
            nUses = 2;
            break;
        }    
        case WOL_BBB_DROWSEEKER:
        {
            int nCount;
            location lTarget = GetLocation(oPC);
            // Hunt for Drow
            object oTest = MyFirstObjectInShape(SHAPE_SPELLCYLINDER, FeetToMeters(60.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oTest))
            {
                if(IsDrow(oTest))
                    nCount++;
                //next object
                oTest = MyNextObjectInShape(SHAPE_SPELLCYLINDER, FeetToMeters(60.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
            }
                                         //You detect the presence of
            FloatingTextStringOnCreature(GetStringByStrRef(16832001) + " " + IntToString(nCount) + " Drow.", oPC, FALSE);
            break;
        } 
        case WOL_BBB_SHOCKING_SHOT:
        {
            nUses = 5;
            if (DEBUG) DoDebug("Shocking Shot 1");
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {     
                if (DEBUG) DoDebug("Shocking Shot 2");
                PerformAttackRound(PRCGetSpellTargetObject(), oPC, eNone, 0.0, 0, d6(5), DAMAGE_TYPE_ELECTRICAL, FALSE, "Shocking Shot Hit", "Shocking Shot Miss");
                SetLegacyUses(oPC, nSLA);
            }    
            if (DEBUG) DoDebug("Shocking Shot 3");
            break;
        } 
        case WOL_BBB_PIERCE_BLACK_HEART:
        {
            nUses = 1;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {            
                object oTarget = PRCGetSpellTargetObject();
                PerformAttackRound(oTarget, oPC, eNone, 0.0, 0, 0, 0, FALSE, "Pierce the Black Heart Hit", "Pierce the Black Heart Miss");
                SetLegacyUses(oPC, nSLA);
                if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack") && IsDrow(oTarget))
                {
                    nDC = 20;
                    if (17 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                        nDC = 17 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
                        
                    //Make a fortitude save to avoid death
                    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DEATH)) //, OBJECT_SELF, 3.0))
                    {
                        DeathlessFrenzyCheck(oTarget);

                        //Apply the delay VFX impact and death effect
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH), oTarget);
                        effect eDeath = EffectDeath();
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget); // no delay
                    }                        
                }        
            }    
            break;
        }         
    }
    
    if (DEBUG) DoDebug("wol_bbb_sla: nSLA "+IntToString(nSLA)+", nCasterLevel "+IntToString(nCasterLevel)+", nSpell "+IntToString(nSpell)+", nUses  "+IntToString(nUses));
    
    // Check uses per day, Drowseeker is infinite
    if (GetLegacyUses(oPC, nSLA) >= nUses && nSLA != WOL_BBB_DROWSEEKER)
    {
        FloatingTextStringOnCreature("You have used " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " the maximum amount of times today.", oPC, FALSE);
        return;
    } 
    if (nSpell > 0) 
    {
        DoRacialSLA(nSpell, nCasterLevel, nDC);
        SetLegacyUses(oPC, nSLA);
        FloatingTextStringOnCreature("You have "+IntToString(nUses - GetLegacyUses(oPC, nSLA))+ " uses of " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " remaining today.", oPC, FALSE);
    }    
}
        