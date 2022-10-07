/*
31/12/19 by Stratovarius

Bloodwar Gauntlets

Descriptors: Evil, Mind-affecting 
Classes: Incarnate 
Chakra: Hands or Arms
Saving Throw: See text

Incarnum forms into black gauntlets that encase your hands and extend in heavy iron bands up your forearms to your elbows, where they end in vicious-looking spikes. They seem large for your hands and actually cover any gloves or gauntlets you might already be wearing, but they move in perfect unison with your fingers and hands. When it is very quiet, you can sometimes hear the sounds of battle coming from the night-black metal of the gauntlets.

While you wear your bloodwar gauntlets, you gain a +1 morale bonus on melee attack rolls.

Essentia:  For every point of essentia you invest in your bloodwar gauntlets, you gain a +1 morale bonus on melee damage rolls. 

Chakra Bind (Arms) 

Your bloodwar gauntlets bind themselves to your wrists and forearms. Instead of separate rings of metal extending up your arms, they now form a solid sheath of completely unreflective metal in which fiendish visages manifest and subside, always contorted with rage and pain.

You can use a standard action to release the soulmeld’s violent energy in a tumultuous blast, unshaping the soulmeld in the process. The blast deals 3d6 points of damage for every point of essentia invested to all creatures within a 20-foot radius burst, excluding you. A successful Fortitude save halves this damage. 

Chakra Bind (Hands) 

Your bloodwar gauntlets bind themselves to your hands, shrinking to better fit them. The metal fingertips of the gauntlets are long and sharply pointed. They sometimes seem to drip blood, though the liquid that falls from them vanishes almost as soon as it touches the ground.

Any weapon you equip gains the keen property
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectAttackIncrease(1);

    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(nEssentia), DAMAGE_TYPE_BASE_WEAPON));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BLOODWAR_GAUNTLETS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_ARMS) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BLOODWAR_GAUNTLETS_ARMS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}