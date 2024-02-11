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

OnEnter
*/

#include "bnd_inc_bndfunc"

void main()
{
    //Declare major variables
    object oBinder = GetAreaOfEffectCreator();

    //Capture the first target object in the shape.
    object oTarget = GetEnteringObject();
    //FloatingTextStringOnCreature(GetName(oTarget)+" entered Aura of Sadness", oBinder, FALSE);
    if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oBinder) && !GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR, oBinder) && oTarget != oBinder)
    {
    	effect eReturn = EffectAttackDecrease(2);
    	       eReturn = EffectLinkEffects(eReturn, EffectSavingThrowDecrease(SAVING_THROW_ALL, 2));
    	       eReturn = EffectLinkEffects(eReturn, EffectDamageDecrease(2, DAMAGE_TYPE_BLUDGEONING|DAMAGE_TYPE_PIERCING|DAMAGE_TYPE_SLASHING));
    	       eReturn = EffectLinkEffects(eReturn, EffectSkillDecrease(SKILL_ALL_SKILLS, 2));		
    	       
    	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eReturn), oTarget);   
    	//FloatingTextStringOnCreature(GetName(oTarget)+" Aura of Sadness effect applied", oBinder, FALSE);
    }
}
