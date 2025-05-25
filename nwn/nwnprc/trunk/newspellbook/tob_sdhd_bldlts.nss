//////////////////////////////////////////////////
// Bloodletting Strike
// tob_sdhd_bldlts.nss
// Tenjac   12/11/07
//////////////////////////////////////////////////
/** @file Bloodletting Strike
Shadow Hand (Strike)
Level: Swordsage 5
Prerequisite: Two Shadow Hand maneuvers
Initiation Action: 1 standard action
Range: Melee attack
Target: One creature
Saving Throw: Fortitude partial
Spinning your blade in a butterflylike pattern, you administer a dozen precise cuts in 
an eyeblink. Blood flows from your foe’s opened veins.

As part of this maneuver, you make a single melee attack. If this attack hits, your 
opponent takes 4 points of Constitution damage in addition to your attack’s normal damage.
A successful Fortitude save (DC 15 + your Wis modifier) reduces this Constitution damage
to 2 points, although the foe still takes full normal melee damage.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
	effect eNone;
	
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Bloodletting Strike Hit", "Bloodletting Strike Miss");
	
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
	{
		int nDam = 4;
		
		int nDC = 15 + GetAbilityModifier(ABILITY_WISDOM, oInitiator);
		
		int nBladeMed = HasBladeMeditationForDiscipline(oInitiator, GetDisciplineByManeuver(PRCGetSpellId()));
		if (nBladeMed)
		{
			nDC += 1;
		}	
		if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC)) nDam = 2;
		
		ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDam, DURATION_TYPE_TEMPORARY, TRUE, -1.0);
	}
}

void main()
{
        if (!PreManeuverCastCode())
        {
                // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
                return;
        }
        
        // End of Spell Cast Hook
        
        object oInitiator    = OBJECT_SELF;
        object oTarget       = PRCGetSpellTargetObject();
        struct maneuver move = EvaluateManeuver(oInitiator, oTarget);
        
        
        if(move.bCanManeuver)
        {
                DelayCommand(0.0, TOBAttack(oTarget, oInitiator));
        }
}


