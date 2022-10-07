//::///////////////////////////////////////////////
//:: Name       Demetrious' Supply Based Rest
//:: FileName   SBR_onactivate
//:://////////////////////////////////////////////
// http://nwvault.ign.com/Files/scripts/data/1055903555000.shtml

// This script should be executed by your module OnActivateItem event.
#include "prc_alterations"
#include "sbr_include"
#include "nw_i0_plot"

void main()
{
string sItemTag = GetTag(GetItemActivated());
object oPC = GetItemActivator();
object oTarget = GetItemActivatedTarget();

//resting kit stuff up here

if ((sItemTag==SBR_KIT_REGULAR)||(sItemTag==SBR_KIT_WOODLAND))
    {
    if (NotOnSafeRest(oPC)==TRUE)
        {
        LogMessage(LOG_PARTY, oPC, "You should find a secure area before trying to rest.");
        LogMessage(LOG_DM_20, oPC, "Resting Prevented: "+GetName(oPC)+" by Bioware resting trigger.");
        //Delay the create kit to avoid an annoying encumbered message :)
        DelayCommand(1.0, CreateKit(oPC, sItemTag));
        return;
        }

    if (!CanIRest(oPC))
        {
        LogMessage(LOG_PARTY_30, oPC, "The danger present in the region prevents resting.");
        LogMessage(LOG_DM_20, oPC, "Resting Prevented: "+ GetName(oPC)+ " in area:  "+GetName(GetArea(oPC)) +" by Rest Widget settings.");
        DelayCommand(1.0, CreateKit(oPC, sItemTag));
        return;
        }

    SetLocalInt(oPC, SBR_USED_KIT, 1);
    AssignCommand(oPC, ActionRest());
    }

//dm rest widget stuff here

if (sItemTag == SBR_DM_WIDGET)
    {
    //dm clicked himself so this is MODULE level based restriction or we are in simple mode
    int TOGGLEREST =FALSE;

    if (SBR_MAKE_IT_SIMPLE)
        {
        if (oTarget == OBJECT_INVALID)  //if target is ground - toggle
            TOGGLEREST=TRUE;
        if (GetIsPC(oTarget)&&(!(GetIsDM(oTarget)||GetIsDMPossessed(oTarget))))    //is a PC - toggle rest
            TOGGLEREST=TRUE;
        //will be false for some random object and should fall to report stats
        }




    if ((oTarget == oPC)||(TOGGLEREST))
    {
    int nStatus = GetLocalInt(GetModule(), SBR_REST_NOT_ALLOWED);
    if (nStatus==TRUE)
        {
        DeleteLocalInt(GetModule(), SBR_REST_NOT_ALLOWED);
        LogMessage(LOG_DM_ALL, oPC, "Resting is Enabled - MODULE LEVEL by "+GetName(oPC));
        return;
        }
    else   //variable is false
        {
        SetLocalInt(GetModule(), SBR_REST_NOT_ALLOWED, TRUE);
        LogMessage(LOG_DM_ALL, oPC, "Resting is NOT allowed - MODULE LEVEL by "+GetName(oPC));
        return;
        }
    }


    if ((!GetIsObjectValid(oTarget))&& (!SBR_MAKE_IT_SIMPLE)) //dm clicked the ground so use AREA based restriction
    {
    int nStatus = GetLocalInt(GetArea(oPC), SBR_REST_NOT_ALLOWED);
    if (nStatus==TRUE)
        {
        DeleteLocalInt(GetArea(oPC), SBR_REST_NOT_ALLOWED);
        LogMessage(LOG_DM_ALL, oPC, "Resting is Enabled - AREA LEVEL by "+GetName(oPC));
        return;
        }
    else   //variable is false
        {
        SetLocalInt(GetArea(oPC), SBR_REST_NOT_ALLOWED, TRUE);
        LogMessage(LOG_DM_ALL, oPC, "Resting is NOT allowed - AREA LEVEL by "+GetName(oPC));
        return;
        }
    }

    if ((GetIsPC(oTarget)) && (!SBR_MAKE_IT_SIMPLE))      //dm clicked a player so this is PARTY based restriction
    {
    int nStatus = GetLocalInt(oTarget, SBR_REST_NOT_ALLOWED);
    if (nStatus==TRUE)
        {
        SetPLocalInt(oTarget, SBR_REST_NOT_ALLOWED, FALSE);
        LogMessage(LOG_DM_20, oPC, "Resting is ENABLED - PARTY MEMBER: "+GetName(oTarget)+" by "+GetName(oPC));
        return;
        }
    else   //variable is false
        {
        SetPLocalInt(oTarget, SBR_REST_NOT_ALLOWED, TRUE);
        LogMessage(LOG_DM_20, oPC, "Resting is NOT allowed - PARTY MEMBER: "+GetName(oTarget)+" by "+GetName(oPC));
        return;
        }
    }

    //DM clicked either an NPC or some other placeable
    LogMessage(LOG_PC, oPC, "Reporting resting system info because clicked on NPC or placeable");
    ReportStats(oPC);
    }



}
