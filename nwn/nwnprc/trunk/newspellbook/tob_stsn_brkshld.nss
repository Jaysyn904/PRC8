/*
   ----------------
   Strike of the Broken Shield

   tob_stsn_brkshld
   ----------------

   19/08/07 by Stratovarius
*/ /** @file

    Strike of the Broken Shield

    Setting Sun (Strike)
    Level: Swordsage 4
    Prerequisite: Two Setting Sun maneuvers
    Initiation Action: 1 Standard action
    Range: Melee Attack.
    Target: One Creature.
    Save: Reflex partial; see text

    You study your opponent and deliver an attack precisely aimed to ruin his defenses
    and force him to scramble for balance. While he struggles to ready himself, he becomes
    more vulnerable to your attack.
    
    You make an attack that deals 4d6 extra damage. If it connects, the target must save or be 
    flatfooted for one round.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
    	effect eNone;
    	
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, d6(4), 0, "Strike of the Broken Shield Hit", "Strike of the Broken Shield Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
			int nDC = 14 + GetAbilityModifier(ABILITY_STRENGTH, oInitiator);
			int nBladeMed = HasBladeMeditationForDiscipline(oInitiator, GetDisciplineByManeuver(PRCGetSpellId()));;
			if (nBladeMed)
			{
				nDC += 1;
			}	
		// Saving Throw
    		if (!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC))
    		{
			AssignCommand(oTarget, ClearAllActions(TRUE));
		}
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