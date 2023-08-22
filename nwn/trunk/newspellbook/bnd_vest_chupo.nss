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

Ethereal Watcher: At will as a move action, you can become ethereal. You can remain on the Ethereal Plane indefinitely if you take no actions, but any movement or
combat causes you to return to the Material Plane. Once you have returned to the Material Plane, you cannot use this ability again for 5 rounds.

Bite: You gain a natural bite attack that deals damage according to your size, as given on the table below.
Size Bite Damage
Diminutive or Fine 1
Tiny 1d2
Small 1d3
Medium 1d4
Large 1d6
Huge 1d8
Gargantuan 2d6
Colossal 2d8

You add your Strength modifier to your damage roll.

Pounce: If you charge a foe, you can make a full attack at the end of the charge.

Soulsense: You notice and locate living creatures within 10 feet as if you possessed the blindsense ability.
*/

#include "bnd_inc_bndfunc"
#include "prc_inc_natweap"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_SANCTUARY), EffectPact(oBinder));
    
    if (!GetIsVestigeExploited(oBinder, VESTIGE_CHUPOCLOPS_DESPAIR))   IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_CHUPOCLOPS_DESPAIR ),   HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (!GetIsVestigeExploited(oBinder, VESTIGE_CHUPOCLOPS_ETHEREAL))  IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_CHUPOCLOPS_ETHEREAL),   HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	if (!GetIsVestigeExploited(oBinder, VESTIGE_CHUPOCLOPS_BITE))      
	{
        string sResRef = "prc_troll_bite_";
        int nSize = PRCGetCreatureSize(oBinder);
        sResRef += GetAffixForSize(nSize);
        AddNaturalSecondaryWeapon(oBinder, sResRef);	
	}
	//if (!GetIsVestigeExploited(oBinder, VESTIGE_CHUPOCLOPS_POUNCE))    Done in prc_inc_combmove
	if (!GetIsVestigeExploited(oBinder, VESTIGE_CHUPOCLOPS_SOULSENSE)) 
	{
		eLink = EffectLinkEffects(eLink, EffectUltravision());
		eLink = EffectLinkEffects(eLink, EffectSeeInvisible());
	}	
	    
    if (!GetLocalInt(oBinder, "PactQuality"+IntToString(VESTIGE_CHUPOCLOPS))) FloatingTextStringOnCreature("You have made a poor pact, and Chupoclops prevents you from succeeding at fear saves!", oBinder, FALSE);    

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}