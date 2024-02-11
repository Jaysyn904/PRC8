/*
1/1/20 by Stratovarius

Dissolving Spittle

Descriptors: Acid 
Classes: Incarnate 
Chakra: Throat
Saving Throw: None

Incarnum forms a metallic blue-green torc around your neck. The ends of the torc resemble black or copper dragons facing each other in front of your throat. A constant bitter taste floods your mouth, but it seems to make the flavor of certain foods more enjoyable — particularly well-cooked meat.

As a standard action, you can spit a glob of acid at a target within 30 feet. This requires a ranged touch attack to hit and deals 1d6 points of acid damage. Using dissolving spittle provokes attacks of opportunity. 

Essentia: Every point of essentia you invest in your dissolving spittle increases the damage dealt by 1d6 points. 

Chakra Bind (Throat) 

Instead of a torc around your neck, the writhing shape of a twoheaded dragon arcs around your throat in blue-green scales. Tendrils of midnight blue extend up your neck and down into your shoulders like diseased veins.

When you use your ability to spit acid at an opponent, you also roll again for damage 1 round later. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_DISSOLVING_SPITTLE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_DISSOLVING_SPITTLE_SPIT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}