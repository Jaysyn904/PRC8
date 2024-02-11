//::///////////////////////////////////////////////
//:: Contemplative Class
#include "prc_alterations"
#include "prc_class_const"
#include "prc_feat_const"

// * Applies the Contemplatives's immunities on the object's skin.
// * iType = IP_CONST_IMMUNITYMISC_*
// * sFlag = Flag to check whether the property has already been added
void ContemplativeImmunity(object oPC, object oSkin, int iType, string sFlag)
{
    if(GetLocalInt(oSkin, sFlag) == TRUE) return;

    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(iType), oSkin);
    SetLocalInt(oSkin, sFlag, TRUE);
}

// * Applies the Contemplative's damage reduction bonuses as CompositeBonuses on object's skin.
// * iLevel = IP_CONST_DAMAGEREDUCTION_*
void ContemplativeDR(object oPC, object oSkin, int iLevel)
{
    if(GetLocalInt(oSkin, "ContemplativeDR") == 667) return;
    
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageReduction(iLevel, IP_CONST_DAMAGESOAK_10_HP), oSkin);
    SetLocalInt(oSkin, "ContemplativeDR", 667);
}

/*void ContemplativeSR(object oPC, int nLevel, object oSkin)
{
    //if(GetLocalInt(oSkin, "ContemplativeSR") == nLevel) return;

    int nSR = nLevel + 15;
    effect eSR = EffectSpellResistanceIncrease(nSR);
    eSR = ExtraordinaryEffect(eSR);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSR, oPC);
    SetLocalInt(oSkin, "ContemplativeSR", nLevel);
}*/

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nContemp = GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oPC);

    if(nContemp >= 1) ContemplativeImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_DISEASE, "ContempDisease");
    if(nContemp >= 5) ContemplativeImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_POISON, "ContempPoison");
    //if(nContemp >= 7) ContemplativeSR(oPC, nContemp, oSkin);
    if(nContemp >= 10) ContemplativeDR(oPC, oSkin, IP_CONST_DAMAGEREDUCTION_1);
}
