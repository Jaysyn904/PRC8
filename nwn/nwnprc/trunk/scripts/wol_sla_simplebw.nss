/**
 * @file
 * Spellscript for Simple Bow SLAs
 *
 */

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    
    object oBow = GetItemPossessedBy(oPC, "WOL_SimpleBow");
    
    // You get nothing if you aren't wielding the bow
    if(oBow != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;    

    switch(nSLA){
        case WOL_SIMPLEBOW_TRUE_SEEING:
        {
            nCasterLevel = 13;
            nSpell = SPELL_TRUE_SEEING;
            nUses = 1;
            break;
        }
        case WOL_SIMPLEBOW_PRESCIENCE:
        {
            nUses = 1;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {     
                //Construct effects
                effect eAttack = EffectAttackIncrease(15);
                effect eDur    = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
                effect eLink   = EffectLinkEffects(eAttack, eDur);
                effect eVis    = EffectVisualEffect(VFX_IMP_HEAD_ODD);

                //Apply VFX impact and bonus effects
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 6.0);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                SetLegacyUses(oPC, nSLA);
            }    
            break;
        } 
        case WOL_SIMPLEBOW_FOCUS:
        {
            nUses = 3;
            // Check uses per day, make sure people don't waste one when it's already in use
            if (nUses > GetLegacyUses(oPC, nSLA) && !GetLocalInt(oPC, "SimpleBow_Focus"))
            {            
                SetLocalInt(oPC, "SimpleBow_Focus", TRUE);
                SetLegacyUses(oPC, nSLA);
            }    
            break;
        }         
    }
    
    // Check uses per day, Drowseeker is infinite
    if (GetLegacyUses(oPC, nSLA) >= nUses && nSLA)
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
        