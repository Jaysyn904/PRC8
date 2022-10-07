//::///////////////////////////////////////////////
//:: Wounding Attack - Melee spellscript
//:: psi_wound_atk_m
//::///////////////////////////////////////////////
/*
    Performs an attack round with 1 Con damage
    on the first attack.
    Requires that the user is wielding a melee
    weapon or is unarmed.

    Using Wounding Attack requires expending
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
    object oTarget = PRCGetSpellTargetObject();
    effect eCon = EffectAbilityDecrease(ABILITY_CONSTITUTION, 1);

    if(!UsePsionicFocus(oPC)){
        SendMessageToPC(oPC, "You must be psionically focused to use this feat");
        return;
    }

    if(GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)))
    {
        SendMessageToPC(oPC, "You may not wield a ranged weapon while using this feat");
        return;
    }

    PerformAttackRound(oTarget, oPC, eCon, 0.0, 0, 0, 0, FALSE, "Wounding Attack Hit", "Wounding Attack Miss");
}