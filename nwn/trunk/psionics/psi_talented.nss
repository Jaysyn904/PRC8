//::///////////////////////////////////////////////
//:: Talented feat spellscript
//:: psi_talented
//::///////////////////////////////////////////////
/*
    Switches the feat Talented on or off.
    When on, overchanneling a power of 3rd or
    lower level does not cause damage.
    That happening requires expending psionic focus.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 22.03.2005
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"

void main()
{
    object oPC = OBJECT_SELF;
    
    // Can't activate too many feats
    if(!GetLocalInt(oPC, "TalentedActive") &&
       GetPsionicFocusUsingFeatsActive(oPC) >= GetPsionicFocusUsesPerExpenditure(oPC))
    {
        FloatingTextStringOnCreature(GetStringByStrRef(16826549/*You already have the maximum amount of psionic focus expending feats active.*/), oPC, FALSE);
        return;
    }
    
    SetLocalInt(oPC, "TalentedActive", !GetLocalInt(oPC, "TalentedActive"));
    FloatingTextStringOnCreature(GetStringByStrRef(16826499) + " " + (GetLocalInt(oPC, "TalentedActive") ? GetStringByStrRef(63798/*Activated*/):GetStringByStrRef(63799/*Deactivated*/)), oPC, FALSE);
}