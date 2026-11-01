/*
13/03/21 by Stratovarius

Chupoclops, Harbinger of Forever
  
A great monster believed to be a harbinger of the apocalypse, Chupoclops became a vestige when slain by mortals. Chupoclops grants its summoner a bite attack and
unnatural senses, plus the ability to pounce on foes, to exist ethereally, and to make enemies despair.

Vestige Level: 6th
Binding DC: 25
Special Requirement: Chupoclops hates Amon for some unknown reason and will not answer your call if you are already bound to him.

Influence: While under the influence of Chupoclops, you can’t help but be pessimistic. At best, you are quietly resigned to your own failure, and at 
worst, you spread your doubts to others, trying to convince them of the hopelessness of their goals. In addition, Chupoclops requires that you voluntarily fail all saving throws against fear effects.

Granted Abilities: 
Chupoclops gives you the power to linger on the Ethereal Plane, sense the living and undead, demoralize foes, and bite enemies.

Aura of Despair: Every creature within 10 feet of you takes a –2 penalty on attack rolls, checks, saves, and weapon damage rolls. Aura of despair is a mind-affecting fear ability.
*/

#include "bnd_inc_bndfunc"

void main()
{
	object oBinder = OBJECT_SELF;
	int nSpellId = PRCGetSpellId();

    if (GetHasSpellEffect(nSpellId, oBinder) || GetLocalInt(oBinder, "ChupoclopsAuraActive"))
    {
    	DeleteLocalInt(oBinder, "ChupoclopsAuraActive");
    	PRCRemoveSpellEffects(nSpellId, oBinder, oBinder);
    	GZPRCRemoveSpellEffects(nSpellId, oBinder, FALSE);
    	effect eCheck = GetFirstEffect(oBinder);
    	while (GetIsEffectValid(eCheck))
    	{
    		if (GetEffectTag(eCheck) == "ChupoclopsAuraDespairEff" || GetEffectSpellId(eCheck) == nSpellId)
    			RemoveEffect(oBinder, eCheck);
    		eCheck = GetNextEffect(oBinder);
    	}
    	FloatingTextStringOnCreature("Chupoclops's Aura of Despair suppressed.", oBinder, FALSE);
	}	
	else
	{
		effect eLink = EffectLinkEffects(EffectAreaOfEffect(VFX_PER_SNARE, "bnd_vest_chupare", "", "bnd_vest_chuparx"), EffectVisualEffect(VFX_DUR_SYMB_SLEEP));
		eLink = TagEffect(SupernaturalEffect(eLink), "ChupoclopsAuraDespairEff");
		SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oBinder);
		SetLocalInt(oBinder, "ChupoclopsAuraActive", TRUE);
		FloatingTextStringOnCreature("Chupoclops's Aura of Despair activated.", oBinder, FALSE);
	}	
}
