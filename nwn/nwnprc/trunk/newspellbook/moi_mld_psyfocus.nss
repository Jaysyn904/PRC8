/*
31/1/21 by Stratovarius

Psychic Focus
Descriptors: None
Classes: Incarnate, soulborn
Chakra: Throat
Saving Throw: See text

A necklace of turquoise crystals fits around your neck. The crystals shed a faint glow that increases in brightness when you manifest a damaging power.

Drawing upon soul energy of those using psionics, meldshapers who manifest psionic powers can use the incarnum energy to intensify powers that cause harm to others.

You shape incarnum into a periapt or other trinket, known as a psychic focus, which you then wear about your neck. When you manifest a psionic powers that deal damage, your power's damage is increased by 1 point. Powers that divide their damage among multiple targets, such as energy burst, deal the extra damage to each affected target.

This soulmeld does not affect powers that do not deal damage.

Essentia: Every point of essentia you invest in your psychic focus increases the damage by 1 point.

Chakra Bind (Throat)

Barely visible wisps of incarnum writhe from your psychic focus, and these tendrils of soul energy twist into psionic glyphs as you manifest psionic powers. When you manifest a damaging power, the power is accompanied by a blue-green burst of raw incarnum energy.

The energy behind your offensive powers can temporarily overcome your opponents. Whenever you manifest a power that deals damage to a single living creature, that creature must succeed on a Fortitude save (using the soulmeld's save DC, not the power's) or be dazed for 1 round. If the power deals damage to more than one creature, or if the target creature takes no damage from the power (whether because of a successful saving throw, power resistance, or resistance to the damage dealt by the power), this has no effect.
*/

#include "moi_inc_moifunc" 

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
	effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_PSYCHIC_FOCUS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}