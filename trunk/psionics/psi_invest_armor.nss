//::///////////////////////////////////////////////
//:: Invest Armour
//:: psi_invest_armor
//::///////////////////////////////////////////////
/*
    Allows a user to expend focus to give their armour a +3 boost to armour class.

    Using Invest Armour requires expending psionic focus.
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 14.02.2006
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "psi_inc_psifunc"

void main()
{
    object oPC = OBJECT_SELF;
    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST);
    int nArmourType = GetBaseAC(oItem);
    int nFeat = -1;
    // Light Armour
    if (nArmourType > 0 && nArmourType < 4) nFeat = FEAT_ARMOR_PROFICIENCY_LIGHT;
    else if (nArmourType >= 4 && nArmourType <= 5) nFeat = FEAT_ARMOR_PROFICIENCY_MEDIUM;
    else if (nArmourType >= 6) nFeat = FEAT_ARMOR_PROFICIENCY_HEAVY;

    // In case there is ever a way to equip armour without being proficient
    if(nFeat == -1 || !GetHasFeat(nFeat))
    {
        SendMessageToPC(oPC, "You must be wearing armour to use this feat");
        return;
    }
    if(!UsePsionicFocus(oPC))
    {
        SendMessageToPC(oPC, "You must be psionically focused to use this feat");
        return;
    }
    
    // Calculate how much armour is on there so we can boost it
    int nAC = GetACBonus(oItem);
    nAC += 3;
    // Lasts for one round
    AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyACBonus(nAC),oItem, 6.0);
}