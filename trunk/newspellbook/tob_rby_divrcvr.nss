//::///////////////////////////////////////////////
//:: Divine Recovery
//:: tob_rby_divrcvr.nss
//:://////////////////////////////////////////////
/*
    Up to [turn undead] times per day the character may recover a maneuver as a swift action
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Oct 4, 2008
//:://////////////////////////////////////////////

#include "tob_inc_tobfunc"

void main()
{
    object oPC = OBJECT_SELF;
    if(!GetHasFeat(FEAT_TURN_UNDEAD, oPC))
        SpeakStringByStrRef(40550);
    else
    {
        int nList = GetPrimaryBladeMagicClass(oPC);
        int nLast = GetLocalInt(oPC, "ManeuverExpended" + IntToString(nList));
        int nMove = GetLocalInt(oPC, "ManeuverExpended" + IntToString(nList) + IntToString(nLast));
        FloatingTextStringOnCreature(GetManeuverName(nMove) + " is recovered", oPC, FALSE);

        DeleteLocalInt(oPC, "ManeuverExpended" + IntToString(nList) + IntToString(nLast));
        SetLocalInt(oPC, "ManeuverExpended" + IntToString(nList), nLast - 1);
        DecrementRemainingFeatUses(oPC, FEAT_TURN_UNDEAD);
    }
}