/*
12/03/21 by Stratovarius

Geryon, the Deposed Lord
  
Once a devil of great power, Geryon now exists only as a vestige. He gives binders powers associated with his eyes, as well as the ability to fly at a moment’s notice.

Vestige Level: 5th
Binding DC: 25
Special Requirement: Geryon answers the calls of only those summoners who show an understanding of the relationship between souls and the planes. Thus, you must have at least 5 ranks in Lore to summon him.

Influence: While influenced by Geryon, you become overly trusting of and loyal to those you see as allies, even in the face of outright treachery. Because he values trust, if you make a Sense Motive check or use any ability to read thoughts or detect lies, you rebel against Geryon’s influence.

Granted Abilities: 
Geryon gives you his eyes and his baleful gaze, as well as the ability to fly.

Acidic Gaze: The gaze of your devilish eyes can cause foes to erupt with acid. When you use this ability, each opponent within 30 feet of you must succeed on a Will save or take 2d6 points of acid damage. 
*/

#include "bnd_inc_bndfunc"

void main()
{
	object oBinder = OBJECT_SELF;
    int nDC = GetBinderDC(oBinder, VESTIGE_GERYON);
    location lTarget = GetLocation(oBinder);
    
    if (GetLocalInt(oBinder, "GeryonGaze")) return;
    SetLocalInt(oBinder, "GeryonGaze", TRUE);
	DelayCommand(RoundsToSeconds(1), DeleteLocalInt(oBinder, "GeryonGaze"));
	DelayCommand(RoundsToSeconds(1), FloatingTextStringOnCreature("Geryon's Acidic Gaze is off cooldown", oBinder, FALSE));
    FloatingTextStringOnCreature("You must wait 1 round before using Geryon's Acidic Gaze again", oBinder, FALSE);    
    
    object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oAreaTarget))
    {
        if(oAreaTarget != oBinder && GetIsEnemy(oAreaTarget, oBinder)) // Enemies
        {
			if(!PRCMySavingThrow(SAVING_THROW_WILL, oAreaTarget, nDC, SAVING_THROW_TYPE_ACID))
			{
				int nDamage = d6(2);
	        	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_ACID), oAreaTarget);
        		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ACID_L), oAreaTarget);
	        }	
        }
    //Select the next target within the spell shape.
    oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }    
}