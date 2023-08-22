//::///////////////////////////////////////////////
//:: Weapon and Torch
//:: prc_ft_wptrch.nss
//::///////////////////////////////////////////////
/*
    While fighting with a one-handed melee weapon 
    and holding a lit torch in the other hand, you 
    can make a special attack as a full-round action. 
    Attack once with your melee weapon. If the attack 
    hits, you also sweep your torch across your foe's 
    eyes, dealing ld6 points of fire damage and 
    dazzling him for 1d4 rounds.
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 11.11.2018
//:://////////////////////////////////////////////

#include "prc_inc_combat"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eDummy;
    
    object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oLeft  = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    
    if (IPGetIsMeleeWeapon(oRight) && GetBaseItemType(oLeft) == BASE_ITEM_TORCH)
    {
        PerformAttack(oTarget, oPC, eDummy, 0.0, 0, 0, 0, "Weapon and Torch Hit", "Weapon and Torch Miss");
    
        if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
        {
            effect eImp = EffectLinkEffects(eVis, EffectDamage(d6(), DAMAGE_TYPE_FIRE));
	        ApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazzle(), oTarget, RoundsToSeconds(d4()));
        }    
    }
    else
    {
        FloatingTextStringOnCreature("You do not have the right weapons equipped for Weapon and Torch", oPC, FALSE);
        PerformAttackRound(oTarget, oPC, eDummy);
    }    
}
