//::///////////////////////////////////////////////
//:: Sleep/Paralysis Immunity feat for Diamond Dragon
//:: psi_diadra_ntrl.nss
//::///////////////////////////////////////////////
/*
    Handles the Sleep/Paralysis neutralization.
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 15, 2007
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "psi_inc_ppoints"
#include "x0_i0_petrify"

void main()
{

    object oPC = OBJECT_SELF;
    effect eEffect = GetFirstEffect(GetFirstPC());
    int bParalyze = FALSE;
    int bSleep = FALSE;
    int nType;
    int nManifesterPP = GetCurrentPowerPoints(oPC);
    
    //check for Paralysis or Sleep effects
    while(GetIsEffectValid(eEffect))
    {
       nType = GetEffectType(eEffect);
       if(nType == EFFECT_TYPE_PARALYZE)
          bParalyze = TRUE;
       else if(nType == EFFECT_TYPE_SLEEP)
          bSleep = TRUE;
       eEffect = GetNextEffect(GetFirstPC());
    }

    //if any are found, charge 1 PP and neutralize, or deactivate if out of PP
    if ((bParalyze == TRUE) || (bSleep == TRUE))
    {
       if(nManifesterPP > 0)
       {
       	   if(bParalyze == TRUE)
       	       RemoveEffectOfType(oPC, EFFECT_TYPE_PARALYZE);
       	   if(bSleep == TRUE)
       	       RemoveEffectOfType(oPC, EFFECT_TYPE_SLEEP);
           LosePowerPoints(oPC, 1, TRUE);
           FloatingTextStringOnCreature("Sleep/Paralysis Effects Neutralized", oPC, FALSE);
       }
       else
       {
           FloatingTextStringOnCreature("Out of PP, deactivating.", oPC, FALSE);
           RemoveEventScript(oPC, EVENT_ONHEARTBEAT, "psi_diadra_ntrl", TRUE, TRUE);
       }
    }
    
}
