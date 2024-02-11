/*
3/1/21 by Stratovarius

Incandescent Strike (Su): You can channel incarnum to increase the damage dealt by your melee attacks. For each
such augmented attack, you gain a bonus on your damage roll equal to the number of points of essentia invested in
this ability. Whenever you have essentia invested in incandescent strike, your hands glow like a light spell.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia      = GetEssentiaInvested(oMeldshaper, MELD_INCANDESCENT_STRIKE);
    effect eLink;

    if (nEssentia) eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20), EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(nEssentia), DAMAGE_TYPE_BASE_WEAPON));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
}