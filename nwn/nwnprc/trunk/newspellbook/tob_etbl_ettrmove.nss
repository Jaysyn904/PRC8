/*
   ----------------
   Eternal Training maneuver dummy

   tob_etbl_ettrmove.nss
   ----------------

    10 MAR 09 by GC
*/ /** @file

    This is a dummy maneuver for Eternal Training.
    The eternal blade maneuver conv selects the maneuver which
    will be readied and this dummy casts it.  This was done to
    prevent the player from having to search for the maneuver each
    time they ready it and to prevent problems that could arise from
    adding and removing the maneuver normally.

*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void main()
{
    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    int nManeuver        = GetLocalInt(oInitiator, "ETBL_MANEUVER_CURRENT");
    int nClass           = GetPrimaryBladeMagicClass(oInitiator);

    if (!PreManeuverCastCode())
    {
        IncrementRemainingFeatUses(oInitiator, FEAT_ETBL_ETERNAL_TRAINING);
        // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook

    // Blade guide check
    if(GetLocalInt(oInitiator, "ETBL_BladeGuideDead"))
    {
        IncrementRemainingFeatUses(oInitiator, FEAT_ETBL_ETERNAL_TRAINING);
        FloatingTextStringOnCreature("*Cannot use ability without blade guide*", oInitiator, FALSE);
        return;
    }
    // Used in encounter already?
    if(GetLocalInt(oInitiator, "ETBL_Eternal_Training_Expended"))
    {
        IncrementRemainingFeatUses(oInitiator, FEAT_ETBL_ETERNAL_TRAINING);
        FloatingTextStringOnCreature("*Eternal Training expended already*", oInitiator, FALSE);
        return;
    }
    if(nManeuver == -1 || nClass == -1)
    {
        IncrementRemainingFeatUses(oInitiator, FEAT_ETBL_ETERNAL_TRAINING);
        FloatingTextStringOnCreature("*Select a maneuver using the conversation before using ability*", oInitiator, FALSE);
        return;
    }
    
    if(!TakeSwiftAction(oInitiator)) 
    {
        IncrementRemainingFeatUses(oInitiator, FEAT_ETBL_ETERNAL_TRAINING);
        return;
    }
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget, TRUE);

    if(move.bCanManeuver)
    {
        // Let them know what's being cast
        SignalEvent(oTarget, EventSpellCastAt(oInitiator, nManeuver));
        UseManeuver(nManeuver, nClass);

        // Expend ability
        SetLocalInt(oInitiator, "ETBL_Eternal_Training_Expended", TRUE);
    }
    else
            IncrementRemainingFeatUses(oInitiator, FEAT_ETBL_ETERNAL_TRAINING);
}