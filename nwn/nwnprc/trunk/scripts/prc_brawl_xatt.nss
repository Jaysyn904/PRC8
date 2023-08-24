
#include "prc_alterations"

void main()
{
    object oCreature = PRCGetSpellTargetObject();
    object oRighthand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature);
    object oLefthand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
    int iExtraAttacks = 0;
    int iBrawlerAttacks = GetLocalInt(oCreature, "BrawlerAttacks");

    // Calculate the number of extra attacks
    if (GetHasFeat(FEAT_BRAWLER_EXTRAATT_1, oCreature))
    {
        if (!GetIsObjectValid(oRighthand))
        {
            if (!GetIsObjectValid(oLefthand) || GetBaseItemType(oLefthand) == BASE_ITEM_TORCH)
            {
                if (!GetLevelByClass(CLASS_TYPE_MONK, oCreature))
                {
                    if (GetHasFeat(FEAT_BRAWLER_EXTRAATT_3, oCreature))
                    {
                        iExtraAttacks = 3;
                        FloatingTextStringOnCreature("*Extra unarmed attacks enabled: Three extra attacks per round*", oCreature, FALSE);
                    }
                    else if (GetHasFeat(FEAT_BRAWLER_EXTRAATT_2, oCreature))
                    {
                        iExtraAttacks = 2;
                        FloatingTextStringOnCreature("*Extra unarmed attacks enabled: Two extra attacks per round*", oCreature, FALSE);
                    }
                    else
                    {
                        iExtraAttacks = 1;
                        FloatingTextStringOnCreature("*Extra unarmed attack enabled: One extra attack per round*", oCreature, FALSE);
                    }
                }
                else FloatingTextStringOnCreature("*Extra unarmed attack not enabled: Cannot stack with monk*", oCreature, FALSE);
            }
            else FloatingTextStringOnCreature("*Extra unarmed attack not enabled: Shield equipped*", oCreature, FALSE);
        }
        else FloatingTextStringOnCreature("*Extra unarmed attack not enabled: Weapon equipped*", oCreature, FALSE);
    }

    // No change, skip doing anything
    if(iExtraAttacks == iBrawlerAttacks) return;


    // Remove the old effects
    if (GetHasSpellEffect(SPELL_BRAWLER_EXTRA_ATT, oCreature))
    {
        PRCRemoveSpellEffects(SPELL_BRAWLER_EXTRA_ATT, oCreature, oCreature);
    }

    if (!iExtraAttacks)
        DeleteLocalInt(oCreature, "BrawlerAttacks");
    else
    {
        SetLocalInt(oCreature, "BrawlerAttacks", iExtraAttacks);

        effect eExtraAttacks = SupernaturalEffect(EffectModifyAttacks(iExtraAttacks));

        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraAttacks, oCreature);
    }
}
