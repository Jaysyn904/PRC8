/*
12/1/20 by Stratovarius

Vitality Belt

Descriptors: None
Classes: Incarnate
Chakra: Waist
Saving Throw: None

Incarnum forms a stout metallic belt that girds your waist. The metal gleams silver-blue; links of azure chain bind the plates together. Life and health well up from this belt into your body.

While wearing your vitality belt, you gain a +4 morale bonus on Constitution checks and Constitution-based skill checks (but not on Fortitude saves). 

Essentia: For every point of essentia you invest in your vitality belt, you gain temporary hit points equal to your meldshaper level. 

Chakra Bind (Waist) 

A large star sapphire adorns the center of your vitality belt, gleaming vibrantly in any light. Any time you are subjected to an attack that would drain your vitality, the star at the heart of the sapphire dims momentarily, but your health does not suffer.

You are immune to Constitution damage and Constitution drain. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectSkillIncrease(SKILL_CONCENTRATION, 4);

    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectTemporaryHitpoints(nEssentia * GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_INCARNATE, MELD_VITALITY_BELT)));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_VITALITY_BELT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}