//::///////////////////////////////////////////////
//:: (Greater) Psionic Endowment spellscript
//:: psi_psionic_endw
//::///////////////////////////////////////////////
/*
    Switches the feat Psionic Endowment on or off.
    When on, the creature gains +2 to power DC
    If the creature has the feat Greater Psionic Endowment,
    the bonus is instead +4.
    
    Using Psionic Endowment requires expending
    psionic focus during the power's manifestation.
*/
//:://////////////////////////////////////////////
//:: Modified By: Ornedan
//:: Modified On: 22.03.2005
//:://////////////////////////////////////////////


#include "prc_alterations"
#include "prc_feat_const"
#include "psi_inc_psifunc"

void main()
{
    object oPC = OBJECT_SELF;
    
    // Can't activate too many feats
    if(!GetLocalInt(oPC, "PsionicEndowmentActive") &&
       GetPsionicFocusUsingFeatsActive(oPC) >= GetPsionicFocusUsesPerExpenditure(oPC))
    {
        FloatingTextStringOnCreature(GetStringByStrRef(16826549/*You already have the maximum amount of psionic focus expending feats active.*/), oPC, FALSE);
        return;
    }
    
    SetLocalInt(oPC, "PsionicEndowmentActive", !GetLocalInt(oPC, "PsionicEndowmentActive"));
                                                                                  //Greater Psionic Endowment   Psionic Endowment
    FloatingTextStringOnCreature((GetHasFeat(FEAT_GREATER_PSIONIC_ENDOWMENT, oPC) ? GetStringByStrRef(16826454):GetStringByStrRef(16826452)) + " " +
                                 (GetLocalInt(oPC, "PsionicEndowmentActive") ? GetStringByStrRef(63798/*Activated*/):GetStringByStrRef(63799/*Deactivated*/)), oPC, FALSE);
}