//::///////////////////////////////////////////////
//:: Greater Psionic Weapon spellscript
//:: psi_g_psi_weapon
//::///////////////////////////////////////////////
/*
    Performs an attack round with +4d6 damage bonus
    on the first attack.
    Requires that the user is wielding a melee
    weapon.

    Using Greater Psionic Weapon requires expending
    psionic focus.
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
    object oTarget  = PRCGetSpellTargetObject();
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

    PerformAttackRound(oTarget, oPC, eDummy, 0.0, 0, d6(4), DAMAGE_TYPE_MAGICAL, FALSE, "Greater Psionic Weapon Hit", "Greater Psionic Weapon Miss");
}