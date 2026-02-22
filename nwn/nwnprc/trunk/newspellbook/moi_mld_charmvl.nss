/*
31/01/21 by Stratovarius

Charming Veil
Descriptor: None
Classes: Incarnate, soulborn
Chakra: Brow
Saving Throw: None

You create a wispy veil that sparkles in the slightest breeze, but seems to vanish in stillness. When you manifest a charm or compulsion power, tendrils of incarnum writhe and sparkle, enhancing the effects.

You can pull energy into your charm and compulsion powers, reinforcing the power with the power of incarnum. While worn, you gain a +1 insight bonus on the save DCs of your charm and compulsion powers.

Essentia: For every point of essentia you invest into your charming veil, you increase the save DC by +1.

Chakra Bind (Brow)

A dim silver glow emanates from your eyes. A brief flash, visible only to you, scans across your field of vision and periodically outlines creatures and objects while continually heightening your awareness.

When your charming veil is bound to your brow chakra, you gain a bonus on Sense Motive checks equal to the number of points of essentia invested in the veil. You also gain this bonus on saving throws to resist charm and compulsion effects targeting you.
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-21 15:20:30
//::
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia      = GetEssentiaInvested(oMeldshaper);

    effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_BROW || GetIsMeldBound(oMeldshaper) == CHAKRA_DOUBLE_BROW && nEssentia) eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SENSE_MOTIVE, nEssentia));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_CHARMING_VEIL), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}