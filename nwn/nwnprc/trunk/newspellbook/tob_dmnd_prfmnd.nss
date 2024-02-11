/*
   ----------------
   Moment of Perfect Mind

   tob_dmnd_prfclry.nss
   ----------------

    29/03/07 by Stratovarius
*/ /** @file

    Moment of Perfect Mind

    Diamond Mind (Counter)
    Level: Swordsage 1, Warblade 1
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: 1 Round

    Your mental focus and martial study have rendered your will into an 
    unbreakable iron wall. When someone targets you with a spell that seeks 
    to erode your willpower, you steel yourself against the attack.
    
    You replace the next Will save you make this round with a Concentration check.
    The DC of the check is the same as that of the spell.
    A result of 1 on the roll is not an automatic failure.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

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
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SPELL_FAIL_HEA), oTarget);
	SetLocalInt(oTarget, "MomentOfPerfectMind", TRUE);
	DelayCommand(6.0, DeleteLocalInt(oTarget, "MomentOfPerfectMind"));
    }
}