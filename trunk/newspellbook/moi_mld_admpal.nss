/*
28/12/19 by Stratovarius

Adamant Pauldrons

Descriptors: None 
Classes: Incarnate 
Chakra: Shoulders
Saving Throw: None

You shape incarnum into blue crystalline plates of shoulder armor. They float slightly above your shoulders, leaving room for 
clothing and other armor. In battle, these pauldrons seem to draw attacks toward them, steering blows away from your most vital areas.

While wearing adamant pauldrons, you gain immunity to sneak attack. 

Essentia:  You gain damage reduction equal to the number of points of essentia invested in this soulmeld. This damage reduction is 
passed by a +2 weapon or greater.

Chakra Bind (Shoulders)

Your incarnate pauldrons settle over your shoulders, and they seem to be joined by a crystalline lattice of blue energy across your back. 
Their power to deflect blows away from vital areas is increased.

While binding adamant pauldrons, you gain immunity to critical hits. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia      = GetEssentiaInvested(oMeldshaper);

    effect eLink = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectDamageReduction(nEssentia, DAMAGE_POWER_PLUS_TWO));
    if (GetIsMeldBound(oMeldshaper)) eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_ADAMANT_PAULDRONS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}