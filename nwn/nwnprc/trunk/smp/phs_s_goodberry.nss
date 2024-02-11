/*:://////////////////////////////////////////////
//:: Spell Name Goodberry
//:: Spell FileName PHS_S_Goodberry
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    2d4 fresh berries are made magical. Druids only can use the berries and heal
    1 damage when eaten, up to 8 points of curing in 24Hours. Duration is 1 day/
    level.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Goodberry actually adds a permament "goodberry" spell property.

    That spell script (the goodberry one) tracks it so only 8 can be taken in
    24 hours.

    The healing script also checks for a 3rd or higher level of druid, else they
    cannot be used. Of course, the druid can target someone else :-)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// These hold the all important weapon functions. Will seperate later and modify.
#include "prc_x2_itemprop"

void AddBerryEffect(object oTarget)
{
    itemproperty ip_Prop = ItemPropertyCastSpell(PHS_IP_CONST_CASTSPELL_GOODBERRY, IP_CONST_CASTSPELL_NUMUSES_0_CHARGES_PER_USE);
    IPSafeAddItemProperty(oTarget, ip_Prop, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
    return;
}

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_GOODBERRY)) return;

    // Declare major variables
    object oTarget = GetSpellTargetObject(); // Should be a berry item.
    int nCharges = d4(2);// 2d4 "charges"

    // Error checking
    if(!GetIsObjectValid(oTarget) || GetObjectType(oTarget) != OBJECT_TYPE_ITEM) return;

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);

    // Make sure the target has not got the effects
    if(GetTag(oTarget) == "PHS_Berry" &&
      !GetItemHasItemProperty(oTarget, ITEM_PROPERTY_CAST_SPELL))
    {
        // Signal event spell cast at
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_GLOBE_OF_INVUNRABILITY, FALSE);

        // Apply visual effects
        PHS_ApplyVFX(oTarget, eVis);

        // Apply new effect
        AddBerryEffect(oTarget);

        // Set charges to 2d4
        SetItemCharges(oTarget, nCharges);
    }
}
