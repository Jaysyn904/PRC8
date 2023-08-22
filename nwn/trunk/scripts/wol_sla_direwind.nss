/**
 * @file
 * Spellscript for Sling of the Dire Wind SLAs
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
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_SlingDireWind");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;  

    switch(nSLA){
        case WOL_DIREWIND_STUN:
        {
            nUses = 3;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {        
                object oTarget = PRCGetSpellTargetObject();
                PerformAttackRound(oTarget, oPC, eNone, 0.0, 0, 0, 0, FALSE, "Stunning Stone Hit", "Stunning Stone Miss");
                SetLegacyUses(oPC, nSLA);
                if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
                {
                    int nDC = 11;
                    if (11 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                        nDC = 11 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
                        
                    //Make a fortitude save to avoid stunning
                    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                    {
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, 6.0);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_ROCK), oTarget);
                    }                        
                }  
            }
            break;
        } 
        case WOL_DIREWIND_GUST:
        {
            nCasterLevel = 5;
            nSpell = SPELL_GUST_OF_WIND;
            nUses = 1;              
            break;
        }   
        case WOL_DIREWIND_WALL:
        {
            nUses = 3;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {        
                SetLegacyUses(oPC, nSLA);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectConcealment(80, MISS_CHANCE_TYPE_VS_RANGED), oPC, 60.0); 
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
        