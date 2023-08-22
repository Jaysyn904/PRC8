/*
02/03/21 by Stratovarius

Focalor, Prince of Tears
  
Granted Abilities: 
Focalor gives you the ability to breathe water, strike foes down with lightning, blind enemies with a puff of your breath, and cause creatures to be stricken with grief in your presence.

Aura of Sadness: You emit an aura of depression and anguish that overtakes even the strongest-willed creatures. Every adjacent creature is overcome with grief, which manifests as a 
–2 penalty on attack rolls, saving throws, and skill checks, for as long as it remains adjacent to you. You can suppress or activate this ability as a standard action. Aura of sadness is a mind-affecting ability.

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
    if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oBinder) && oTarget != oBinder)
    {
    	effect eReturn = EffectAttackDecrease(2);
    	       eReturn = EffectLinkEffects(eReturn, EffectSavingThrowDecrease(SAVING_THROW_ALL, 2));
    	       eReturn = EffectLinkEffects(eReturn, EffectSkillDecrease(SKILL_ALL_SKILLS, 2));		
    	       
    	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eReturn), oTarget);   
    	//FloatingTextStringOnCreature(GetName(oTarget)+" Aura of Sadness effect applied", oBinder, FALSE);
    }
}
