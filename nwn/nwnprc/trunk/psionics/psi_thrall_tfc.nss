/**
 * Thrallherd: Twofold Master
 * 16/04/2005
 * Stratovarius
 * Type of Feat: Class Specific
 * Prerequisite: Thrallherd level 10.
 * Specifics: The Thrallherd gains a second thrall. This thrall's maximum level is equal to the thrallherd's level minus 2.
 * Use: Selected.
 */

#include "inc_rand_equip"
#include "prc_alterations"
#include "nw_o2_coninclude"

void CleanCopy(object oImage)
{
     SetLootable(oImage, FALSE);
     object oItem = GetFirstItemInInventory(oImage);
     while(GetIsObjectValid(oItem))
     {
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyWeightReduction(IP_CONST_REDUCEDWEIGHT_10_PERCENT), oItem);
        SetIdentified(oItem, TRUE);
        oItem = GetNextItemInInventory(oImage);
     }
     int i;
     for(i=0;i<NUM_INVENTORY_SLOTS;i++)//equipment
     {
        oItem = GetItemInSlot(i, oImage);
        SetDroppableFlag(oItem, FALSE);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyWeightReduction(IP_CONST_REDUCEDWEIGHT_10_PERCENT), oItem);
        SetIdentified(oItem, TRUE);
        SetItemCursedFlag(oItem, TRUE);
     }
     TakeGoldFromCreature(GetGold(oImage), oImage, TRUE);
}

void main()
{
    if(GetPRCSwitch(PRC_THRALLHERD_LEADERSHIP))
    {
        FloatingTextStringOnCreature("Please select your thrall via the cohort system.", OBJECT_SELF, FALSE);
        return;
    }
    int nMax = GetMaxHenchmen();

    int i = 1;
    object oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, OBJECT_SELF, i);

    if (GetTag(oHench) == "psi_thrall_twofold")
    {
        FloatingTextStringOnCreature("You are already a Twofold Master", OBJECT_SELF, FALSE);
        return;
    }

    while (GetIsObjectValid(oHench))
    {
        i += 1;
        oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, OBJECT_SELF, i);
        if (GetTag(oHench) == "psi_thrall_twofold")
    {
            FloatingTextStringOnCreature("You are already a Twofold Master", OBJECT_SELF, FALSE);
            return;
        }
    }

    if (i >= nMax) SetMaxHenchmen(i+1);

    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);

   int nHD = GetHitDice(OBJECT_SELF);
   int nLevel = nHD - 2;

   object oCreature = CreateObject(OBJECT_TYPE_CREATURE, "psi_thrall_clc", GetSpellTargetLocation(), FALSE, "psi_thrall_twofold");
   AddHenchman(OBJECT_SELF, oCreature);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oCreature));

   int n;
   for(n=1;n<nLevel;n++)
   {
    LevelUpHenchman(oCreature, CLASS_TYPE_INVALID, TRUE);
   }
   for(n=1;n<nLevel;n++)
   {
    GenerateBossTreasure(oCreature);
   }

   AssignCommand(oCreature, ClearAllActions());
   AssignCommand(oCreature, ActionEquipMostDamagingMelee());
   AssignCommand(oCreature, ActionEquipMostEffectiveArmor());
   EquipMisc(oCreature);
   CleanCopy(oCreature);

   SetMaxHenchmen(nMax);
}
