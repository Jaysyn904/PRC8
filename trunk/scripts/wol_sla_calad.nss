/**
 * @file
 * Spellscript for Caladbolg SLAs
 *
 */

#include "prc_inc_template"
#include "prc_inc_combat"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Caladbolg");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;  

    switch(nSLA){
        case WOL_CALAD_IMPRISON:
        {
            nUses = 1;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {        
                object oTarget = PRCGetSpellTargetObject();
                PerformAttackRound(oTarget, oPC, eNone, 0.0, 0, 0, 0, FALSE, "Imprisoning Stroke Hit", "Imprisoning Stroke Miss");
                SetLegacyUses(oPC, nSLA);
                if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
                {
                    // Check Spell Resistance
                    if(!PRCDoResistSpell(oPC, oTarget, 17))
                    {                
                        nDC = 23;
                        if (19 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                            nDC = 19 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
                            
                        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                        {
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(9999, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_ENERGY), oTarget);
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_IMPRISONMENT), oTarget);
                        }    
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
        