/*
09/03/21 by Stratovarius

Balam, the Bitter Angel
  
Once a being of extreme goodness, Balam became a wrathful vestige after taking on an impossible task that ended in failure. She grants her summoners the ability to foresee future difficulties and the intellect to interpret what they see, as well as skill with light arms and a stare that chills flesh.

Vestige Level: 5th
Binding DC: 25
Special Requirement: Balam requires a sacrifice of her summoner. In the process of calling her, you must deal 1 point of slashing damage to yourself.

Influence: Balam’s influence causes you to distrust clerics, paladins, and other devotees of deities. Whenever you enter a temple or some other holy or unholy site, Balam requires that you spit on the floor and utter an invective about the place.

Granted Abilities: 
Balam grants you the power to predict future events. She also teaches cunning and finesse, and gives you the ability to freeze foes with a glance.

Icy Glare: You gain a gaze attack that deals 2d6 points of cold damage to the target. A successful Will save negates this damage.
*/

#include "bnd_inc_bndfunc"

void main()
{
	object oBinder = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
    effect eArrow = EffectVisualEffect(VFX_IMP_MIRV_DN_STEELBLUE);
    int nDC = GetBinderDC(oBinder, VESTIGE_BALAM);
    
    // Only creatures, and PvP check.
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oBinder) && !GetLocalInt(oBinder, "BalamGlare"))
    {
    	SetLocalInt(oBinder, "BalamGlare", TRUE);
		DelayCommand(RoundsToSeconds(1), DeleteLocalInt(oBinder, "BalamGlare"));
		DelayCommand(RoundsToSeconds(1), FloatingTextStringOnCreature("Balam's Glare is off cooldown", oBinder, FALSE));
		FloatingTextStringOnCreature("You must wait 1 round before using Balam's Glare again", oBinder, FALSE);
    	if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_COLD))
    	{
        	int nDamage = d6(2);
        	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_COLD), oTarget);
        	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_L), oTarget);
        }	
    }
}