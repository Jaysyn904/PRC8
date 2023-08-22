//::///////////////////////////////////////////////
//:: Anvil of Thunder
//:: prc_ft_anvlthndr.nss
//::///////////////////////////////////////////////
/*
    If you hit the same creature with both your axe 
    and your hammer in the same round, it must make 
    a Fortitude saving throw (DC 10 + 1/2 your 
    character level + your Str modifier) or be dazed 
    for 1 round.
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 11.11.2018
//:://////////////////////////////////////////////

#include "prc_inc_combat"

int AnvilThunder(object oRight, object oLeft)
{
    if ((GetBaseItemType(oRight) == BASE_ITEM_BATTLEAXE ||
         GetBaseItemType(oRight) == BASE_ITEM_DWARVENWARAXE ||
         GetBaseItemType(oRight) == BASE_ITEM_HANDAXE) && 
        (GetBaseItemType(oLeft) == BASE_ITEM_LIGHTHAMMER ||
         GetBaseItemType(oLeft) == BASE_ITEM_WARHAMMER)) return TRUE;
         
    if ((GetBaseItemType(oLeft) == BASE_ITEM_BATTLEAXE ||
         GetBaseItemType(oLeft) == BASE_ITEM_DWARVENWARAXE ||
         GetBaseItemType(oLeft) == BASE_ITEM_HANDAXE) && 
        (GetBaseItemType(oRight) == BASE_ITEM_LIGHTHAMMER ||
         GetBaseItemType(oRight) == BASE_ITEM_WARHAMMER)) return TRUE;
         
    return FALSE;     
}

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eDummy;
    
    object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oLeft  = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    
    if (AnvilThunder(oRight, oLeft))
    {
        int nHit;
        // Main hand
        PerformAttack(oTarget, oPC, eDummy, 0.0, 0, 0, 0, "Anvil of Thunder Hit", "Anvil of Thunder Miss");
        if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack")) 
        {
            nHit += 1;
            DeleteLocalInt(oTarget, "PRCCombat_StruckByAttack");
        }    
        // Off Hand
        PerformAttack(oTarget, oPC, eDummy, 0.0, 0, 0, 0, "Anvil of Thunder Hit", "Anvil of Thunder Miss", FALSE, OBJECT_INVALID, OBJECT_INVALID, TRUE);
        if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack")) nHit += 1;
        
        if (nHit > 1)
        {
            int nDC = 10 + GetHitDice(oPC)/2 + GetAbilityModifier(ABILITY_STRENGTH, oPC);
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE, oPC))
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectDazed()), oTarget, RoundsToSeconds(1));
        }
    }
    else
    {
        FloatingTextStringOnCreature("You do not have the right weapons equipped for Anvil of Thunder", oPC, FALSE);
        PerformAttackRound(oTarget, oPC, eDummy);
    }    
}
