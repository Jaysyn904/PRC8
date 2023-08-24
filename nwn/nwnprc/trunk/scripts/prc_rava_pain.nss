//::///////////////////////////////////////////////
//:: Pain Touch
//:: rava_visage
//::
//:://////////////////////////////////////////////
/*
    Touched Target takes damage depending upon Ravager Level,
    and if carrying something in the left hand
    (1d4 + level), or unarmed (1d8 + level)
    The +12/10 is to symbolize the base damage
*/
//:://////////////////////////////////////////////
//:: Created By: aser
//:: Created On: Feb/21/04
//:://////////////////////////////////////////////

#include "prc_inc_combat"

void main()
{
    //Declare major variables

    int ravaLevel = GetLevelByClass(CLASS_TYPE_RAVAGER,OBJECT_SELF);
    int unarmDamage = d8(1) + ravaLevel;
    int armedDamage = d4(1) + ravaLevel;
    int iDam;

    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

    string sSuccess = "*Pain Touch Hit*";
    string sMiss = "*Pain Touch Miss*";

    object oTarget = PRCGetSpellTargetObject();

    if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF)))
        iDam = armedDamage;
    else
        iDam = unarmDamage;

    PerformAttackRound(oTarget, OBJECT_SELF, eVis, 0.0, 0, iDam, DAMAGE_TYPE_NEGATIVE, FALSE, sSuccess, sMiss);
ActionAttack(oTarget);
}

