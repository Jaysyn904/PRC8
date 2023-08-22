/**
 * @file
 * Spellscript for Supernal Clarity SLAs
 *
 */

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    int nInstant = FALSE;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Supernal");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;  

    switch(nSLA){
        case WOL_SUPERNAL_NIGHTMARE_BLADE:
        {
            nCasterLevel = 5;
            nSpell = MOVE_DM_SAPPHIRE_NIGHTMARE;
            nUses = 5;
            break;
        } 
        case WOL_SUPERNAL_PSYCHIC_POISE:
        {
            nUses = 3;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {            
                SetLegacyUses(oPC, nSLA);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectSkillIncrease(SKILL_BALANCE, GetSkillRank(SKILL_CONCENTRATION, oPC))), oPC, 6.0);       
            } 
            break;
        } 
        case WOL_SUPERNAL_HASTE:
        {
            nUses = 5;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {            
                SetLegacyUses(oPC, nSLA);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectHaste()), oPC, 6.0);       
            } 
            break;
        }         
        case WOL_SUPERNAL_FREEDOM:
        {
            nCasterLevel = 1;
            nSpell = SPELL_FREEDOM_OF_MOVEMENT;
            nUses = 1;
            nInstant = TRUE;
            break;
        }   
        case WOL_SUPERNAL_TIMESTOP:
        {
            nCasterLevel = 20;
            nSpell = SPELL_TIME_STOP;
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
        DoRacialSLA(nSpell, nCasterLevel, nDC, nInstant);
        SetLegacyUses(oPC, nSLA);
        FloatingTextStringOnCreature("You have "+IntToString(nUses - GetLegacyUses(oPC, nSLA))+ " uses of " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " remaining today.", oPC, FALSE);
    }     
}
        