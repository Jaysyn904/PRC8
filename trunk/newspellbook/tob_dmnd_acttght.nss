/*
   ----------------
   Action before Thought

   tob_dmnd_acttght.nss
   ----------------

    06/06/07 by Stratovarius
*/ /** @file

    Action before Thought

    Diamond Mind (Counter)
    Level: Swordsage 2, Warblade 2
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: 1 Round

    Your supreme sense of the battlefield, unmatched martial training, and simple,
    intuitive sense of danger allow you to act faster than the speed of thought.
    When a spell or other attack strikes you, you move a split second before
    you are even aware of the threat.
    
    You replace the next Reflex save you make this round with a Concentration check.
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
	SetLocalInt(oTarget, "ActionBeforeThought", TRUE);
	DelayCommand(6.0, DeleteLocalInt(oTarget, "ActionBeforeThought"));
    }
}