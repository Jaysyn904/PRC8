/**
 * @file
 * Spellscript for Stalker's Bow SLAs
 *
 */

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_StalkersBow");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;    

    switch(nSLA){
        case WOL_SB_STALK:
        {
            nUses = 1;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {            
                SetLegacyUses(oPC, nSLA);
                effect eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_HIDE, 10), EffectSkillIncrease(SKILL_MOVE_SILENTLY, 10));
                       eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_LISTEN, 10));
                       eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SPOT, 10));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oPC, 600.0);
            } 
            break;
        } 
        case WOL_SB_ETHEREAL:
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectEthereal()), oPC, 60.0);
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
        