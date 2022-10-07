//::///////////////////////////////////////////////
//:: Divine Impetus
//:: tob_rby_divimp.nss
//:://////////////////////////////////////////////
/*
    Up to [turn undead] times per day the character may gain an additional swift action
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Oct 4, 2008
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "tob_inc_tobfunc"

void main()
{
    object oPC = OBJECT_SELF;
    if(!GetHasFeat(FEAT_TURN_UNDEAD, oPC))
        SpeakStringByStrRef(40550);
    else
    {
        SetLocalInt(oPC, "RKVDivineImpetus", TRUE);
        DecrementRemainingFeatUses(oPC, FEAT_TURN_UNDEAD);
    }
}