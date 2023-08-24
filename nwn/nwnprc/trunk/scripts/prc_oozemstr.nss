//::///////////////////////////////////////////////
//:: [Oozemaster Feats]
//:: [prc_oozemstr.nss]
//:://////////////////////////////////////////////
//:: Check to see which Oozemaster feats a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: DarkGod (Modified by Aaon Graywolf)
//:: Created On: Jan 7, 2004
//:://////////////////////////////////////////////

#include "prc_class_const"
#include "prc_feat_const"
#include "inc_item_props"

// * Applies the Oozemasters's immunities on the object's skin.
// * iType = IP_CONST_IMMUNITYMISC_*
// * sFlag = Flag to check whether the property has already been added
void OozemasterImmunity(object oPC, object oSkin, int iType, string sFlag)
{
    if(GetLocalInt(oSkin, sFlag) == TRUE) return;

    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(iType), oSkin);
    SetLocalInt(oSkin, sFlag, TRUE);
}

// * Applies the Oozemasters's charisma penalty as a composite on the object's skin.
void OozemasterCharismaPenatly(object oPC, object oSkin)
{
    int iPenalty = GetLevelByClass(CLASS_TYPE_OOZEMASTER, oPC) / 2;
    int iTest = GetPersistantLocalInt(oPC, "NWNX_OozemasterCha");
    int nDiff = iPenalty + iTest;

    if(nDiff != 0)
        SetCompositeBonus(oSkin, "OozeChaPen", nDiff, ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_CHA);
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    //Determine which Oozemaster feats the character has
    int bIdAnat  = GetHasFeat(FEAT_INDISCERNIBLE_ANATOMY, oPC);
    int bChaPen = GetHasFeat(FEAT_CHARISMA_PENALITY, oPC);
    int bOneOz = GetHasFeat(FEAT_ONE_WITH_THE_OOZE, oPC);

    //Apply bonuses accordingly
    if(bIdAnat){
        OozemasterImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_CRITICAL_HITS, "IndiscernibleCrit");
        OozemasterImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_BACKSTAB, "IndiscernibleBS");
    }

    if(bOneOz){
        OozemasterImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_MINDSPELLS, "OneOozeMind");
        OozemasterImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_POISON, "OneOozePoison");
        OozemasterImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_PARALYSIS, "OneOozePoison");
    }
    //if(bChaPen) OozemasterCharismaPenatly(oPC, oSkin);
}
