/*
   ----------------
   Immortal Fortitude, On Hit

   tob_dvsp_imfrtoh
   ----------------

   29/09/07 by Stratovarius
*/ /** @file

    Immortal Fortitude

    Devoted Spirit (Stance)
    Level: Crusader 8
    Prerequisite: Three Devoted Spirit maneuvers
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    Duration: Stance

    Despite the horrific wounds you suffer, the flash of searing spells and the crash of a foe's
    mighty attacks, you stand resolute on the field. So long as the potential for victory exists
    you fight on.
    
    While you remain in this stance, you cannot be killed through loss of hitpoints. Other effects,
    such as death spells, may still kill you. If you take damage that would reduce you below 0 hit points,
    you must make a Fortitude save or die. If you succeed, you have 1 hit point remaining. After enduring
    three saves, the stance ends.
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
////#include "prc_alterations"

void main()
{
	object oInitiator = OBJECT_SELF;
	int nDam = GetTotalDamageDealt();
	// DC of saving through is negative hitpoint value
	int nDC = GetCurrentHitPoints(oInitiator) - nDam;
	
	// Saving Throw
	if (!PRCMySavingThrow(SAVING_THROW_FORT, oInitiator, nDC))
	{
		// Now you die
		SetImmortal(oInitiator, FALSE);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(TRUE), oInitiator);
	}
	else // 3 saves and you're out
	{
		int nCount = GetLocalInt(oInitiator, "DSImmortalFortSave");
		nCount += 1;
		// Just in case it goes over for some reason
		if (nCount >= 3)
		{
			// Reset the count
			DeleteLocalInt(oInitiator, "DSImmortalFortSave");
			// Remove the stance
			PRCRemoveEffectsFromSpell(oInitiator, MOVE_DS_IMMORTAL_FORTITUDE);
			// Got to remove this as well
			SetImmortal(oInitiator, FALSE);
			FloatingTextStringOnCreature("You have saved for Immortal Fortitude 3 times, ending stance", oInitiator, FALSE);
		}
		else // Increment
		{
			SetLocalInt(oInitiator, "DSImmortalFortSave", nCount);
			FloatingTextStringOnCreature("You have saved for Immortal Fortitude " + IntToString(nCount) + " times", oInitiator, FALSE);
		}
	}
}