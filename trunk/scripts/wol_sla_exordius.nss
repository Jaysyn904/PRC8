/**
 * @file
 * Spellscript for Exordius SLAs
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
    int nInstant = FALSE;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Exordius");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;  

    switch(nSLA){
        case WOL_EXORD_GUIDANCE:
        {
            nUses = 1;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {        
                SetLegacyUses(oPC, nSLA);
                effect eLink = EffectLinkEffects(EffectAttackIncrease(2), EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_BASE_WEAPON));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oPC, 180.0);
            }    
            break;
        } 
        case WOL_EXORD_CURE:
        {
            nCasterLevel = 10;
            nSpell = SPELL_CURE_SERIOUS_WOUNDS;
            nUses = 1;
            nInstant = TRUE;
            break;
        }   
        case WOL_EXORD_DISMISSAL:
        {
            nCasterLevel = 10;
            nSpell = SPELL_DISMISSAL;
            nUses = 1;
            nDC = 16;            
            if (14 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC) 
                nDC = 14 + GetAbilityModifier(ABILITY_CHARISMA, oPC); 
            object oTarget = PRCGetSpellTargetObject();
            nDC += GetHitDice(oPC) - GetHitDice(oTarget);
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
        