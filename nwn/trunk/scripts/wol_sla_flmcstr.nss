/**
 * @file
 * Spellscript for Flamecaster's Bolt SLAs
 *
 */

#include "prc_inc_template"
#include "prc_inc_sp_tch"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    object oTarget = PRCGetSpellTargetObject();
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_FlamecastersBolt");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;  

    switch(nSLA){
        case WOL_FC_MARK_TARGET:
        {
            if(PRCDoRangedTouchAttack(oTarget) > 0)
            {        
                nCasterLevel = 5;
                nSpell = SPELL_FAERIE_FIRE;
                nUses = 999;
            }    
            break;
        } 
        case WOL_FC_MORALE:
        {
            nCasterLevel = 5;
            nSpell = SPELL_BLESS;
            nUses = 1;
            break;
        }   
        case WOL_FC_FIREBALL:
        {
            if (20 > GetHitDice(oPC))
            {
                nSpell = SPELL_FIREBALL; 
                nCasterLevel = 7;   
                nUses = 1;
            }  
            else if (GetHitDice(oPC) >= 20)
            {
                nSpell = SPELL_FIREBALL; 
                nCasterLevel = 7;   
                nUses = 1;
                location lTarget = GetLocation(oPC);
                int nAlly, nEnemy;
                
                // Counts allies and enemies
                oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
                while (GetIsObjectValid(oTarget))
                {
                    if (GetIsFriend(oTarget, oPC)) nAlly++;
                    else if (GetIsEnemy(oTarget, oPC)) nEnemy++;

                    oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
                }
                // 50% more enemies than allies gives free uses
                if (nEnemy > FloatToInt(nAlly * 1.5)) nUses = 999;
                else if (PRCMySavingThrow(SAVING_THROW_WILL, oPC, 17)) nUses = 999; // We want success here, not failure
            }             
            break;
        } 
    }
    
    // Check uses per day
    if (GetLegacyUses(oPC, nSLA) >= nUses)
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