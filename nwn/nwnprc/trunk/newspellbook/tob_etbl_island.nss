/*
   ----------------
   Island in Time

   tob_etbl_island.nss
   ----------------

    10 MAR 09 by GC
*/ /** @file

    Island in Time

    You throw yourself into a fight under your blade guide's careful direction.
    You meld with it, allowing it to control your actions while you draw
    upon it's vast combat experience.

    Once per encounter, you can take a turn as an immediate action.
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
    
    if(!TakeSwiftAction(oInitiator)) return;
    // Blade guide check
    if(GetLocalInt(oInitiator, "ETBL_BladeGuideDead"))
    {
        FloatingTextStringOnCreature("*Cannot use ability without blade guide*", oInitiator, FALSE);
        return;
    }
    // Expended already?
    if(GetLocalInt(oInitiator, "ETBL_Island_In_Time_Expended"))
    {
        FloatingTextStringOnCreature("*Island in Time expended already*", oInitiator, FALSE);
        return;
    }

    struct maneuver move = EvaluateManeuver(oInitiator, oTarget, TRUE);
    effect eNone;

    if(move.bCanManeuver)
    {
        DelayCommand(0.0, PerformAttackRound(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, FALSE, "Island in Time Hit", "Island in Time Miss", FALSE, FALSE, FALSE));

        // Expend ability
        SetLocalInt(oInitiator, "ETBL_Island_In_Time_Expended", TRUE);
    }
}