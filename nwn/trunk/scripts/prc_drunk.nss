#include "prc_alterations"
#include "prc_class_const"

void SwayingWaist(object oPC, object oSkin, int iLevel)
{
    if(GetLocalInt(oSkin, "DMWaist") == iLevel) return;

    SetCompositeBonus(oSkin, "DrunkenMasterSwayingWaist", iLevel, ITEM_PROPERTY_AC_BONUS);
}

void main ()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nLevel = GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER, oPC);
    int iAC;

    if(nLevel >=9)
        iAC = 4;
    else if(nLevel >= 4)
        iAC = 3;
    else if(nLevel == 3)
        iAC = 2;

    SwayingWaist(oPC, oSkin, iAC);
}