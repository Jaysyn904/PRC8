//::///////////////////////////////////////////////
//:: High Sword Low Axe
//:: prc_ft_highlow.nss
//::///////////////////////////////////////////////
/*
    If you hit the same creature with both your 
    sword and your axe in the same round, you may 
    make a free trip attempt against that foe.
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 11.11.2018
//:://////////////////////////////////////////////

#include "prc_inc_combmove"

int AnvilThunder(object oRight, object oLeft)
{
    if ((GetBaseItemType(oRight) == BASE_ITEM_BASTARDSWORD ||
         GetBaseItemType(oRight) == BASE_ITEM_LONGSWORD ||
         GetBaseItemType(oRight) == BASE_ITEM_SCIMITAR) && 
        (GetBaseItemType(oLeft) == BASE_ITEM_BATTLEAXE ||
         GetBaseItemType(oLeft) == BASE_ITEM_DWARVENWARAXE ||
         GetBaseItemType(oLeft) == BASE_ITEM_HANDAXE)) return TRUE;
         
    if ((GetBaseItemType(oLeft) == BASE_ITEM_BASTARDSWORD ||
         GetBaseItemType(oLeft) == BASE_ITEM_LONGSWORD ||
         GetBaseItemType(oLeft) == BASE_ITEM_SCIMITAR) && 
        (GetBaseItemType(oRight) == BASE_ITEM_BATTLEAXE ||
         GetBaseItemType(oRight) == BASE_ITEM_DWARVENWARAXE ||
         GetBaseItemType(oRight) == BASE_ITEM_HANDAXE)) return TRUE;
         
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
        PerformAttack(oTarget, oPC, eDummy, 0.0, 0, 0, 0, "High Sword Low Axe Hit", "High Sword Low Axe Miss");
        if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack")) 
        {
            nHit += 1;
            DeleteLocalInt(oTarget, "PRCCombat_StruckByAttack");
        }    
        // Off Hand
        PerformAttack(oTarget, oPC, eDummy, 0.0, 0, 0, 0, "High Sword Low Axe Hit", "High Sword Low Axe Miss", FALSE, OBJECT_INVALID, OBJECT_INVALID, TRUE);
        if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack")) nHit += 1;
        
        if (nHit > 1)
        {
            DoTrip(oPC, oTarget, 0); 
        }
    }
    else
    {
        FloatingTextStringOnCreature("You do not have the right weapons equipped for High Sword Low Axe", oPC, FALSE);
        PerformAttackRound(oTarget, oPC, eDummy);
    }    
}
