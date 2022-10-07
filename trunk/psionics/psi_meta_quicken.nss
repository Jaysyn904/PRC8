//::///////////////////////////////////////////////
//:: Quicken Power switch
//:: psi_meta_quicken
//::///////////////////////////////////////////////
/** @file
    Switches the metapsionic feat Quicken Power on or off.

    @author Ornedan
    @date   Created - 2005.01.31
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"

void main()
{
    object oPC = OBJECT_SELF;

    // Can't activate too many feats
    if(!GetLocalInt(oPC, METAPSIONIC_QUICKEN_VAR) &&
       GetPsionicFocusUsingFeatsActive(oPC) >= GetPsionicFocusUsesPerExpenditure(oPC))
    {
        FloatingTextStringOnCreature(GetStringByStrRef(16826549/*You already have the maximum amount of psionic focus expending feats active.*/), oPC, FALSE);
        return;
    }

    SetLocalInt(oPC, METAPSIONIC_QUICKEN_VAR, !GetLocalInt(oPC, METAPSIONIC_QUICKEN_VAR));
    FloatingTextStringOnCreature(GetStringByStrRef(16826651) + " " + (GetLocalInt(oPC, METAPSIONIC_QUICKEN_VAR) ? GetStringByStrRef(63798/*Activated*/):GetStringByStrRef(63799/*Deactivated*/)), oPC, FALSE);
}