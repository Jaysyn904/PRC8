/*
30/12/19 by Stratovarius

Beast Tamer Circlet 

Descriptors: None 
Classes: Totemist 
Chakra: Crown (totem)
Saving Throw: See text

You channel undifferentiated soul energy into a gleaming silver band that encircles your forehead at a distance of about an inch. If you concentrate, you can hear a very quiet murmur of growls, shrieks, and other animal noises — the cacophony of the beast world.

You gain a +2 bonus on Animal Empathy checks. 

Essentia: Every point of essentia you invest in your beast tamer circlet increases the bonus by 2. 

Chakra Bind (Crown) 

Your silver circlet fuses to your head, sending silver-blue tendrils like tiny veins under your skin. The endless clamor of beast noises becomes intelligible to you — you understand the range of needs and emotions that drives these utterances — but you are still able to ignore it with a modicum of concentration.

You gain the ability to charm animals, as the spell. You can use this ability in any round during which you invest essentia in your beast tamer circlet. 

Chakra Bind (Totem) 

Instead of a gleaming silver band around your head, your beast tamer circlet manifests as a ring of silver hair, while all the hair on your head becomes long and coarse like a beast’s mane.

You gain the ability to use animal trance, as the spell. You can use this ability once per minute.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectSkillIncrease(SKILL_ANIMAL_EMPATHY, 2 + (nEssentia*2));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BEAST_TAMER_CIRCLET), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_CROWN) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BEAST_TAMER_CIRCLET_CROWN), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BEAST_TAMER_CIRCLET_TOTEM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}