//::///////////////////////////////////////////////
//:: Fist of Zuoken
//:: psi_zuoken.nss
//:://////////////////////////////////////////////
//:: Check Fist of Zuoken unarmed attack bonus.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: April 21, 2005
//:://////////////////////////////////////////////

#include "prc_inc_unarmed"

void main()
{
    //Evaluate The Unarmed Strike Feats
    //UnarmedFeats(oPC);
    SetLocalInt(OBJECT_SELF, CALL_UNARMED_FEATS, TRUE);

    //Evaluate Fists
    //UnarmedFists(oPC);
    SetLocalInt(OBJECT_SELF, CALL_UNARMED_FISTS, TRUE);
}
