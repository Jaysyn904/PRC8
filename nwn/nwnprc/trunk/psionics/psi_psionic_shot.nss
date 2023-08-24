//::///////////////////////////////////////////////
//:: Psionic Shot spellscript
//:: psi_psionic_shot
//::///////////////////////////////////////////////
/*
    Performs an attack round with +2d6 damage bonus
    on the first attack.
    Requires that the user is wielding a ranged
    weapon.

    Using Psionic Shot requires expending psionic focus.
*/
//:://////////////////////////////////////////////
//:: Modified By: Ornedan
//:: Modified On: 23.03.2005
//:://////////////////////////////////////////////

#include "prc_inc_combat"
#include "prc_feat_const"
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
       !GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)))
    {
        SendMessageToPC(oPC, "You must be wielding a ranged weapon to use this feat");
        return;
    }

    PerformAttackRound(oTarget, oPC, eDummy, 0.0, 0, d6(2), DAMAGE_TYPE_MAGICAL, FALSE, "Psionic Shot Hit", "Psionic Shot Miss");
}