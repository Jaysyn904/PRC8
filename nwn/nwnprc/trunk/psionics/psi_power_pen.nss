//::///////////////////////////////////////////////
//:: (Greater) Power Penetration spellscript
//:: psi_power_pen
//::///////////////////////////////////////////////
/*
    Switches the feat Power Penetration on or off.
    When on, the creature gains +4 to checks to
    bypass power resistance. If the creature has
    the feat Greater Power Penetration, the bonus
    is instead +8.
    Using Power Penetration requires expending
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
    if(!GetLocalInt(oPC, "PowerPenetrationActive") &&
       GetPsionicFocusUsingFeatsActive(oPC) >= GetPsionicFocusUsesPerExpenditure(oPC))
    {
        FloatingTextStringOnCreature(GetStringByStrRef(16826549/*You already have the maximum amount of psionic focus expending feats active.*/), oPC, FALSE);
        return;
    }
    
    SetLocalInt(oPC, "PowerPenetrationActive", !GetLocalInt(oPC, "PowerPenetrationActive"));
    FloatingTextStringOnCreature((GetHasFeat(FEAT_GREATER_POWER_PENETRATION, oPC) ? GetStringByStrRef(16826438):GetStringByStrRef(16826438)) + " " +
                                 (GetLocalInt(oPC, "PowerPenetrationActive") ? GetStringByStrRef(63798/*Activated*/):GetStringByStrRef(63799/*Deactivated*/)), oPC, FALSE);
}