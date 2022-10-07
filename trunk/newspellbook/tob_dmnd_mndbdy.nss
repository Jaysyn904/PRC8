/*
   ----------------
   Mind Over Body

   tob_dmnd_mndbdy.nss
   ----------------

    15/07/07 by Stratovarius
*/ /** @file

    Mind Over Body

    Diamond Mind (Counter)
    Level: Swordsage 3, Warblade 3
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: 1 Round

    Your training and mental toughness allow you to use your focus to overcome 
    physical threats. By focusing your mind, you ignore the effects of a deadly
    poison or a debilitating sickness.
    
    You replace the next Fortitude save you make this round with a Concentration check.
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
	SetLocalInt(oTarget, "MindOverBody", TRUE);
	DelayCommand(6.0, DeleteLocalInt(oTarget, "MindOverBody"));
    }
}