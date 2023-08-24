/*
   ----------------
   Darkness Within Light

   tob_ssn_darkwl.nss
   ----------------

    18 MAR 09 by GC
*/ /** @file

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
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget, TRUE);
    effect eNone;
    if(!TakeSwiftAction(oInitiator)) return;
    if(move.bCanManeuver)
    {
        // Blind character for the turn
        effect eLink = EffectLinkEffects(EffectBlindness(), EffectDeaf());
               eLink = SupernaturalEffect(eLink);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oInitiator, 6.0);

        SetLocalInt(oInitiator, "SSN_DARKWL", TRUE);
            DelayCommand(0.0, PerformAttackRound(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, FALSE, "", "", FALSE, FALSE, FALSE));
        // Cleanup
        DelayCommand(5.0, DeleteLocalInt(oInitiator, "SSN_DARKWL"));
    }
}