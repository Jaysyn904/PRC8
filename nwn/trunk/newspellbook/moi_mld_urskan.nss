/*
12/1/20 by Stratovarius

Urskan Greaves

Descriptors: None
Classes: Totemist
Chakra: Feet (totem)
Saving Throw: None

Incarnum forms steel plates backed with white fur that fit over your shins, covering any clothing, boots, or armor you might wear. When you walk through ice and snow, your feet find solid purchase.

You gain a +5 bonus on Balance checks. 

Essentia: If you invest essentia in your urskan greaves, it also protects you from cold damage. You gain resistance to cold equal to 5 times the number of points of essentia you invest in this soulmeld. 

Chakra Bind (Feet) 

White fur covers your lower legs and your urskan greaves merge into your flesh. Strength seems to radiate up from your greaves through your whole frame, lending power to your attacks when you can build up a good running start.

You gain the ability to make a powerful charge. When you charge, if your melee attack hits, you deal an additional +1d4 points of damage per point of essentia you invest in your urskan greaves. 

Chakra Bind (Totem) 

White fur covers your legs and strength pours through you. No foe can stand in your way when you put all your strength into your charge.

When you attempt to overrun an opponent, the target cannot choose to avoid you. You also gain a +2 bonus on your Strength check to knock down your opponent, with an additional +1 for every point of essentia you invest in your urskan greaves. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectSkillIncrease(SKILL_BALANCE, 5);

    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_COLD, nEssentia * 5));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_URSKAN_GREAVES), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}