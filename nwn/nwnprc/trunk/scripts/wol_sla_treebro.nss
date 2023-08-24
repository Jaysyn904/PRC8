/**
 * @file
 * Spellscript for Treebrother SLAs
 *
 */

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Treebrother");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;  

    switch(nSLA){
        case WOL_TREEBRO_SHILL:
        {
            nCasterLevel = 5;
            nSpell = SPELL_SHILLELAGH;
            nUses = 1;              
            break;
        } 
        case WOL_TREEBRO_EMPATHY:
        {
            object oTarget = PRCGetSpellTargetObject();
            if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_PLANT)
            {
                int nCheck = d20() + GetAbilityModifier(ABILITY_CHARISMA, oPC) + GetHitDice(oPC);
                if (nCheck >= 35)
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCharmed(), oTarget, 600.0);
            }    
            break;
        }       
        case WOL_TREEBRO_ENTANGLE:
        {
            nCasterLevel = 5;
            nSpell = SPELL_ENTANGLE;
            nUses = 3;
            nDC = 11;            
            if (11 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                nDC = 11 + GetAbilityModifier(ABILITY_CHARISMA, oPC);              
            break;
        }         
        case WOL_TREEBRO_INSIGHT:
        {
            nCasterLevel = 10;
            nSpell = SPELL_OWLS_INSIGHT;
            nUses = 1;              
            break;
        }  
        case WOL_TREEBRO_CHANGESTAFF:
        {
            nCasterLevel = 1;
            nSpell = SPELL_CHANGESTAFF;
            nUses = 1;              
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
        