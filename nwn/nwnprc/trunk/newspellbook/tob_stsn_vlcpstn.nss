/*
   ----------------
   Clever Positioning

   tob_stsn_vlcpstn.nss
   ----------------

   08/06/07 by Stratovarius
*/ /** @file

    Clever Positioning

    Setting Sun (Strike)
    Level: Swordsage 2
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creatures
    Saving Throw: Reflex partial.

    With a swift flurry of motion, you knock your foe off balance,
    slip into his space, and force him into the spot you just occupied.
    
    Make a single melee attack. If you succesfully hit the creature, and he fails a 
    Reflex save against 12 + your Dexterity modifier, you swap positions with your target.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"
#include "spinc_trans"

void TOBAttack(object oTarget, object oInitiator)
{
	effect eNone;
	
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Clever Positioning Hit", "Clever Positioning Miss");
	int nDC = 12 + GetAbilityModifier(ABILITY_DEXTERITY, oInitiator);
	
	int nBladeMed = HasBladeMeditationForDiscipline(oInitiator, GetDisciplineByManeuver(PRCGetSpellId()));
	if (nBladeMed)
	{
		nDC += 1;
	}
	
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack") && PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE))
	{
		DoTransposition(TRUE, FALSE);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_WIND), oTarget);
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