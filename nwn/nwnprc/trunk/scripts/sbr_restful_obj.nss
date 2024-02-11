//::///////////////////////////////////////////////
//:: Name       Demetrious' Rest System
//:: FileName   sbr_restful_obj
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
// http://nwvault.ign.com/Files/scripts/data/1055903555000.shtml

/*
This script is fired by using the "restful" objects.
It will always allow the player to rest and immediately
force a rest, and reset the time.
*/
//:://////////////////////////////////////////////
//:: Created By:    Demetrious
//:: Created On:    February 27th, 2003.
//:://////////////////////////////////////////////
//#include "prc_alterations"
#include "sbr_include"
//#include "nw_i0_plot"

void main()
{
object oPC = GetLastUsedBy();

//this section deals with the system to report rest statistics to the DM

if (GetIsDM(oPC) || GetIsDMPossessed(oPC))
    {
    LogMessage(LOG_PC, oPC, "Reporting resting system info because DM used restful object");
    ReportStats(oPC);
    return;
    }


//this is the code for the player to see if they can rest

if (NotOnSafeRest(oPC)==TRUE)
        {
        LogMessage(LOG_PARTY_30, oPC, "You should find a secure area before trying to rest.");
        LogMessage(LOG_DM_20, oPC, "Resting Alert: "+GetName(oPC)+" prevented from resting by Bioware resting trigger.");
        return;
        }
if (!CanIRest(oPC))
        {
        LogMessage(LOG_PARTY_30, oPC, "The danger present in the region prevents resting.");
        LogMessage(LOG_DM_20, oPC, "Resting Prevented:  "+ GetName(oPC)+ " in area:  "+GetName(GetArea(oPC)));
        return;
        }

//LogMessage(LOG_PC, oPC, "This will certainly provide a nice place to rest");
AssignCommand(oPC, ActionRest());
SetLocalInt (oPC, SBR_SUPPLIES, 1);
}
