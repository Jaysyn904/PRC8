/**
 * @file
 * Spellscript for Steadfast SLAs
 *
 */

#include "prc_inc_template"
#include "prc_inc_combat"

void main()
{
    object oPC = OBJECT_SELF;
    int nUses;
    int nSLA = GetSpellId();
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Steadfast");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;    

    switch(nSLA){
        case WOL_STEADFAST_VIGOR:
        {
            nUses = 1;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {            
                SetLegacyUses(oPC, nSLA);
                int nStop = FALSE;
                effect eBad = GetFirstEffect(oPC);
                //Search for negative effects
                while(GetIsEffectValid(eBad) && !nStop)
                {
                    if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE)
                    {
                        RemoveEffect(oPC, eBad);
                        nStop = TRUE; // One effect only
                    }

                    eBad = GetNextEffect(oPC);
                }        
            } 
            break;
        }    
        case WOL_STEADFAST_SLOW:
        {
            nUses = 1;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {        
                object oTarget = PRCGetSpellTargetObject();
                SetLocalInt(oPC, "IHDancingBladeForm", TRUE);
                PerformAttackRound(oTarget, oPC, eNone, 0.0, 0, 0, 0, FALSE, "Slow Hit", "Slow Miss");
                DeleteLocalInt(oPC, "IHDancingBladeForm");
                SetLegacyUses(oPC, nSLA);
                if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
                {
                    int nDC = 14;
                    if (13 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                        nDC = 13 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
                        
                    //Make a fortitude save to avoid death
                    if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC)) //, OBJECT_SELF, 3.0))
                    {
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSlow(), oTarget, RoundsToSeconds(7));
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SLOW), oTarget);
                    }                        
                }  
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
}
        