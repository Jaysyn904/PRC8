//::///////////////////////////////////////////////
//:: Name      Instant Clarity
//:: FileName  tob_ft_istntclty.nss
//:://////////////////////////////////////////////
/** You can take a swift action to become 
psionically focused after successfully initiating 
a martial strike. You can use this ability three 
times per day.

Author:    Stratovarius
Created:   23.9.2018
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "psi_inc_core"

void main()
{
    object oInitiator = OBJECT_SELF;
    if (!GetHasFeat(FEAT_INSTANT_CLARITY, oInitiator)) return; // Need to have the feat
    
    int nSwitch = GetLocalInt(oInitiator, "InstantClaritySwitch");
    
    if (nSwitch == 2)
    {
        GainPsionicFocus(oInitiator);
        DeleteLocalInt(oInitiator, "InstantClaritySwitch");
    }
    else
    {
        SetLocalInt(oInitiator, "InstantClaritySwitch", 1);
    }
}

