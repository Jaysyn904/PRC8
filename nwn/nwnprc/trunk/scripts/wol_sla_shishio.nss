/**
 * @file
 * Spellscript for Shishi-O SLAs
 *
 */

#include "prc_inc_template"
#include "prc_inc_shifting"

void ShiMehO(object oPC)
{
    UnShift(oPC);
}    

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Shishio");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;  

    switch(nSLA){
        case WOL_SHISHIO_CHARM:
        {
            nCasterLevel = 5;
            nSpell = SPELL_CHARM_PERSON_OR_ANIMAL;
            nUses = 999;
            nDC = 11;            
            if (11 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                nDC = 11 + GetAbilityModifier(ABILITY_CHARISMA, oPC);             
            break;
        } 
        case WOL_SHISHIO_SUMMON:
        {
            // Check uses per day.
            nUses = 1;
            if (nUses > GetLegacyUses(oPC, nSLA))
            {     
                SetLegacyUses(oPC, nSLA);
                MultisummonPreSummon();
                string sSummon = "prc_sum_lion";
                if (GetHitDice(oPC) >= 12) sSummon = "nw_s_diretiger";
                ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectSummonCreature(sSummon, VFX_FNF_SUMMON_MONSTER_2), PRCGetSpellTargetLocation(), RoundsToSeconds(10));
    
                DelayCommand(0.5, AugmentSummonedCreature(sSummon));                
            }         
            break;
        }         
        case WOL_SHISHIO_POLY:
        {
            // Check uses per day.
            nUses = 1;
            if (nUses > GetLegacyUses(oPC, nSLA))
            {     
                SetLegacyUses(oPC, nSLA);
                ShiftIntoResRef(oPC, SHIFTER_TYPE_NONE, "nw_diretiger");    
                DelayCommand(TurnsToSeconds(10), ShiMehO(oPC));                
            }         
            break;
        }   
        case WOL_SHISHIO_SHOUT:
        {
            nCasterLevel = 15;
            nSpell = SPELL_SHOUT_GREATER;
            nUses = 1;
            nDC = 22;            
            if (18 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                nDC = 18 + GetAbilityModifier(ABILITY_CHARISMA, oPC); 
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
        