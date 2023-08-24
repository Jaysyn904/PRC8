//::///////////////////////////////////////////////
//:: Name       Demetrious' Supply Based Rest
//:: FileName   SBR_onrest
//:://////////////////////////////////////////////
// http://nwvault.ign.com/Files/scripts/data/1055903555000.shtml

/*
This script belongs in the module level properties
in the OnPlayerRest event script.  Includes an alert
to all DMs.
*/
//:://////////////////////////////////////////////
//:: Created By:    Demetrious
//:://////////////////////////////////////////////
//:: Credit to: Timo "Lord Gsox" Bischoff (NWN Nick: Kihon)
//::            and the HCR team for the subroutines and effects
//::            If not copied, at least I used their ideas. :)
#include "prc_alterations"
#include "sbr_include"

void ApplySleepEffects(object oPC)
{
    if (GetIsDM(oPC) || GetIsDMPossessed(oPC)) return;

    // Signal the module that a player is resting.
    SignalEvent(GetModule(), EventUserDefined(SBR_EVENT_REST));

    LogMessage(LOG_DM_40, oPC, "Rest Alert:  "+GetName(oPC) + " is resting.");
    SetLocalInt(oPC,SBR_RESTING,1);

    effect eSnore = EffectVisualEffect(VFX_IMP_SLEEP);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSnore, oPC, 7.0);

    //insert special effects here. I tried EffectSleep along with different
    //animations. They either get overrode by the rest anim or cancel the rest.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSnore, oPC, 7.0);
    FadeToBlack(oPC);
    SetPanelButtonFlash(oPC,PANEL_BUTTON_REST,0);
}

void RemoveSleepBlindness(object oPC)
{
    FadeFromBlack(oPC);
}



// The main function placed in the onRest event
void main()
{
// Script Settings (Variable Declaration)


object oPC = GetLastPCRested();
object oArea = GetArea(oPC);
int nLastRestType = GetLastRestEventType();

if (nLastRestType == REST_EVENTTYPE_REST_STARTED)
        {
            int Supplykit=FALSE;
            object oItem = GetFirstItemInInventory(oPC);
            while (GetIsObjectValid(oItem))
                {
                if ((GetTag(oItem)==SBR_KIT_REGULAR)|| (GetTag(oItem)==SBR_KIT_WOODLAND))
                    {
                    Supplykit =TRUE;
                    break;
                    }
                    else
                    {
                    oItem = GetNextItemInInventory(oPC);

                    }
                }
            // if you have supplies in your inventory - this is TRUE

            int n=1; string sTag; int SupplyNearby=FALSE;
                while (n<5)
                {
                switch (n)
                    {
                    case 1: sTag = "campingbedroll";break;
                    case 2: sTag = "restfulbed";break;
                    case 3: sTag = "restfulbedroll";break;
                    case 4: sTag = "restfulcot";break;
                    }
                object oN = GetNearestObjectByTag(sTag, oPC, 1);

                if (GetIsObjectValid(oN) && (GetDistanceBetween(oN, oPC)<SBR_DISTANCE))
                    {
                    SupplyNearby=TRUE;
                    break;
                    }
                n=n+1;
                }
            // if you clicked a restful object OR there is one near - this is TRUE

           if (GetLocalInt (oPC, SBR_SUPPLIES)==1) //check for safe condition already done
                {
                ApplySleepEffects(oPC);
                SetLocalInt(oPC, SBR_SUPPLIES, 0);
                return;
                }

           if ((Supplykit) || (SupplyNearby) || (GetLocalInt (oPC, SBR_USED_KIT) ==1))

                    {
                    //code here for the version 1.3 trigger.
                    if (NotOnSafeRest(oPC)==TRUE)
                        {
                        LogMessage(LOG_PARTY_30, oPC, "You should find a secure area before trying to rest.");
                        LogMessage(LOG_DM_20, oPC, "Resting Alert: "+ GetName(oPC)+ " prevented from resting by Bioware resting trigger.");
                        AssignCommand (oPC, ClearAllActions());
                        return;
                        }
                    //code here for the DM resting widget.
                    if (!CanIRest(oPC))
                        {
                        LogMessage(LOG_PARTY_30, oPC, "The danger present in the region prevents resting.");
                        LogMessage(LOG_DM_20, oPC, "Resting Prevented:  "+ GetName(oPC)+ " in area:  "+GetName(GetArea(oPC)) +" by Rest Widget settings.");
                        AssignCommand (oPC, ClearAllActions());
                        return;
                        }

                    // 3 options
                    if (GetLocalInt(oPC, SBR_USED_KIT)==1)
                        {
                        DestroyObject(oItem);
                        object Bedroll = CreateObject(OBJECT_TYPE_PLACEABLE, "campingbedroll", GetLocation(oPC), TRUE);//This is now a campfire rather than a bedroll but same resref
                        DelayCommand(2.0, AssignCommand(Bedroll, PlaySound("al_cv_firecppot1")));
                        DestroyObject(Bedroll, 300.0);
                        DeleteLocalInt(oPC, SBR_USED_KIT);
                        LogMessage(LOG_PARTY_30, oPC, GetName(oPC)+" quickly puts together a nice campsite.");
                        ApplySleepEffects(oPC);
                        return;
                        }

                     if (SupplyNearby)
                        {
                        ApplySleepEffects(oPC);
                        return;
                        }
                        else
                        {
                        // if you are here then you have hit 'r' and have supplies so warn.
                        if (GetLocalInt(oPC, "REST_CLICK")!=1)
                            {
                            AssignCommand(oPC, ClearAllActions());
                            SetLocalInt(oPC, "REST_CLICK", 1);
                            DelayCommand(15.0, DeleteLocalInt(oPC, "REST_CLICK"));
                            LogMessage(LOG_PC, oPC, "There is no 'restful' object nearby.  Press 'r' again to build a campsite with supplies.");
                            return;
                            }
                            else
                            {
                            DestroyObject(oItem);
                            object Bedroll = CreateObject(OBJECT_TYPE_PLACEABLE, "campingbedroll", GetLocation(oPC), TRUE);//This is now a campfire rather than a bedroll but same resref
                            DelayCommand(2.0, AssignCommand(Bedroll, PlaySound("al_cv_firecppot1")));
                            DestroyObject(Bedroll, 300.0);
                            DeleteLocalInt(oPC, SBR_USED_KIT);
                            LogMessage(LOG_PARTY_30, oPC, GetName(oPC)+" quickly puts together a nice campsite.");
                            ApplySleepEffects(oPC);
                            }
                         }//close else 162

                     }//close if 124
                else
                    {
                    AssignCommand (oPC, ClearAllActions());                                 // Prevent Resting
                    LogMessage(LOG_PC, oPC, "You do not have adequate supplies to rest here.");
                    }

    }//close Rest_started



    if (nLastRestType == REST_EVENTTYPE_REST_FINISHED || nLastRestType == REST_EVENTTYPE_REST_CANCELLED)
    {
        RemoveSleepBlindness(oPC);
    }


}   // close main


