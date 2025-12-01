/*
   ----------------
   Guided Strike

   tob_etbl_guidestr.nss
   ----------------

    11 MAR 09 by GC
*/ /** @file

    Guided Strike

    Your blade guide assesses your enemies, seeking out weak
    points in their armor and offfering you advice on where
    and how to strike.  Your guide grants you advice that can
    render even the most daunting foe impotent.

    For the rest of your turn, you automatically overcome
    your opponent's damage reduction, if any.

    You can use this ability only while you have
    access to your blade guide.
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
    
    // Blade guide check
    if(GetLocalInt(oInitiator, "ETBL_BladeGuideDead"))
    {
        FloatingTextStringOnCreature("*Cannot use ability without blade guide*", oInitiator, FALSE);
        return;
    }
    if(!TakeSwiftAction(oInitiator)) return;
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget, TRUE);
    effect eImp = EffectVisualEffect(VFX_COM_HIT_SONIC); 

    if(move.bCanManeuver)
    {
		SetLocalInt(oInitiator, "MoveIgnoreDR", TRUE);
		DelayCommand(0.0, PerformAttackRound(oTarget, oInitiator, eImp, 0.0, 0, 0, 0, FALSE, "", "", FALSE, FALSE, TRUE));
		// Cleanup
		DelayCommand(3.0, DeleteLocalInt(oInitiator, "MoveIgnoreDR"));
    }
}