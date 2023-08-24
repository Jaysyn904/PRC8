//::///////////////////////////////////////////////
//:: Blood Magus
//:: prc_bloodmagus.nss
//:://////////////////////////////////////////////
//:: Check to see which Blood Magus feats a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Sept 3, 2005
//:://////////////////////////////////////////////

#include "prc_alterations"

/// Class level to Conc /////////
void DurableCasting(object oPC, object oSkin, int nBlood)
{

   if(GetLocalInt(oSkin, "DurableCasting") == nBlood) return;

    SetCompositeBonus(oSkin, "DurableCasting", nBlood, ITEM_PROPERTY_SKILL_BONUS, SKILL_CONCENTRATION);
}

void Infusion(object oPC, object oSkin, int iLevel)
{
    string sFlag = "BloodMagusInfusion";

    if(GetLocalInt(oSkin, sFlag) == iLevel) return;

    SetCompositeBonus(oSkin, sFlag, iLevel, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON);
}

void ThickerThanWater(object oPC, object oSkin)
{
    if(GetLocalInt(oSkin, "ThickerThanWater") == TRUE) return;

    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGERESIST_1), oSkin);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SLASHING, IP_CONST_DAMAGERESIST_1), oSkin);
    SetLocalInt(oSkin, "ThickerThanWater", TRUE);
}

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nBlood = GetLevelByClass(CLASS_TYPE_BLOOD_MAGUS, oPC);

    if(nBlood >= 1) DurableCasting(oPC, oSkin, nBlood);
    if(nBlood >= 7) ThickerThanWater(oPC, oSkin);
    if(nBlood >= 9) Infusion(oPC, oSkin, 2);
}
