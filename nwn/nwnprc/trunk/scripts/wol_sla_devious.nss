/**
 * @file
 * Spellscript for Devious SLAs
 *
 */

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Devious");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;    

    switch(nSLA){
        case WOL_DEVIOUS_DETECT_THOUGHTS:
        {
            nUses = 1;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {            
                SetLegacyUses(oPC, nSLA);
                effect eLink =                          EffectSkillIncrease(SKILL_BLUFF,      2);
                       eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_PERSUADE,   2));
                       eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_INTIMIDATE, 2));
                       eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
                effect eVis  = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
                float fDuration = RoundsToSeconds(5);
        
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration, TRUE, -1, 5);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);       
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
        
        
