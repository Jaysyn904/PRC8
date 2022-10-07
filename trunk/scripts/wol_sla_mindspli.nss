/**
 * @file
 * Spellscript for Mindsplinter SLAs
 *
 */

#include "prc_inc_template"
#include "prc_inc_combat"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    int nKnell = GetHasSpellEffect(SPELL_DEATH_KNELL, oPC);
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Mindsplinter");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;  

    switch(nSLA){
        case WOL_MS_VIRTUE_DENIED:
        {
            nCasterLevel = 5;
            nSpell = SPELL_PROTECTION_FROM_GOOD;
            nUses = 1;
            break;
        } 
        case WOL_MS_KISS_DEATH:
        {
            nCasterLevel = 5;
            nSpell = SPELL_DEATH_KNELL;
            nUses = 2;
            nDC = 13;            
            if (12 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                nDC = 12 + GetAbilityModifier(ABILITY_CHARISMA, oPC);              
            break;
        }   
        case WOL_MS_BATTLE_SHRIEK:
        {
            nCasterLevel = 11;
            nSpell = SPELL_SHOUT;
            nUses = 1;
            nDC = 16;            
            if (14 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                nDC = 14 + GetAbilityModifier(ABILITY_CHARISMA, oPC); 
            if (GetHitDice(oPC) >= 17)
            {
                nSpell = SPELL_SHOUT_GREATER; 
                nCasterLevel = 15;
                nDC = 22;            
                if (18 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                    nDC = 18 + GetAbilityModifier(ABILITY_CHARISMA, oPC);                 
            }        
            break;
        } 
        case WOL_MS_RUINOUS_HOWL:
        {
            nUses = 1;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {        
                object oTarget = PRCGetSpellTargetObject();
                PerformAttackRound(oTarget, oPC, eNone, 0.0, 0, 0, 0, FALSE, "Ruinous Howl Hit", "Ruinous Howl Miss");
                SetLegacyUses(oPC, nSLA);
                if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
                {
                    int nDC = 23;
                    if (19 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                        nDC = 19 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
                        
                    if (nKnell) nDC += 2;     
                        
                    //Make a fortitude save to avoid death
                    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DEATH))
                    {
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH), oTarget);
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
    if (nSpell > 0) 
    {
        if (nKnell) nDC += 2; // Applies to everything
        DoRacialSLA(nSpell, nCasterLevel, nDC);
        SetLegacyUses(oPC, nSLA);
        FloatingTextStringOnCreature("You have "+IntToString(nUses - GetLegacyUses(oPC, nSLA))+ " uses of " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " remaining today.", oPC, FALSE);
    }     
}
        