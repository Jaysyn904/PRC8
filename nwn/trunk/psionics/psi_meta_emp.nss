//::///////////////////////////////////////////////
//:: Empower Power switch
//:: psi_meta_emp
//::///////////////////////////////////////////////
/*
    Switches the metapsionic feat Empower Power on or off.
*/
//:://////////////////////////////////////////////
//:: Modified By: Ornedan
//:: Modified On: 25.03.2005
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"

void main()
{
    object oPC = OBJECT_SELF;

    // Can't activate too many feats
    if(!GetLocalInt(oPC, METAPSIONIC_EMPOWER_VAR) &&
       GetPsionicFocusUsingFeatsActive(oPC) >= GetPsionicFocusUsesPerExpenditure(oPC))
    {
        FloatingTextStringOnCreature(GetStringByStrRef(16826549/*You already have the maximum amount of psionic focus expending feats active.*/), oPC, FALSE);
        return;
    }

    SetLocalInt(oPC, METAPSIONIC_EMPOWER_VAR, !GetLocalInt(oPC, METAPSIONIC_EMPOWER_VAR));
    FloatingTextStringOnCreature(GetStringByStrRef(16826534) + " " + (GetLocalInt(oPC, METAPSIONIC_EMPOWER_VAR) ? GetStringByStrRef(63798/*Activated*/):GetStringByStrRef(63799/*Deactivated*/)), oPC, FALSE);
}