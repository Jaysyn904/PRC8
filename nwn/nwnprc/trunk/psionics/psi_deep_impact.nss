//::///////////////////////////////////////////////
//:: Deep Impact spellscript
//:: psi_deep_impact
//:://////////////////////////////////////////////
/*
    Expends psionic focus to resolve the first
    attack of the round as a touch attack.

    Can only be used while wielding a melee weapon.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 24.03.2005
//:://////////////////////////////////////////////

#include "prc_inc_combat"
#include "psi_inc_psifunc"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    effect eDummy;

    if(!UsePsionicFocus(oPC)){
        SendMessageToPC(oPC, "You must be psionically focused to use this feat");
        return;
    }

    if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND) == OBJECT_INVALID ||
       GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)))
    {
        SendMessageToPC(oPC, "You must be wielding a melee weapon to use this feat");
        return;
    }

    PerformAttackRound(oTarget, oPC, eDummy, 0.0, 0, 0, 0, FALSE, "Deep Impact Hit", "Deep Impact Miss", FALSE, TRUE);
}