//::///////////////////////////////////////////////
//:: [Elemental Savant Feats]
//:: [prc_elemsavant.nss]
//:://////////////////////////////////////////////
//:: Check to see which Elemental Savant feats a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius.  Modified by Aaon Graywolf
//:: Created On: Jan 6, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_feat_const"
#include "prc_ipfeat_const"

// * Applies the Elemental Savant's immunities on the object's skin.
// * iType = IP_CONST_IMMUNITYMISC_*
// * sFlag = Flag to check whether the property has already been added
void ElemSavantImmunity(object oPC, object oSkin, int iType, string sFlag)
{
    if(GetLocalInt(oSkin, sFlag) == TRUE) return;

    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(iType), oSkin);
    SetLocalInt(oSkin, sFlag, TRUE);
}

// * Applies the Elemental Savant's resistances on the object's skin.
// * iElem = IP_CONST_DAMAGETYPE_*
// * iLevel = IP_CONST_DAMAGERESIST_*
void ElemSavantResist(object oPC, object oSkin, int iElem, int iLevel)
{
    if(GetLocalInt(oSkin, "ElemSavantResist") == iLevel) return;

    RemoveSpecificProperty(oSkin, ITEM_PROPERTY_DAMAGE_RESISTANCE, iElem, iLevel, 1, "ElemSavantResist");
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(iElem, iLevel), oSkin);
    SetLocalInt(oSkin, "ElemSavantResist", iLevel);
}

// * Applies the Elemental Savant's perfections bonuses on the object's skin.
// * Immunity to Poison, Backstab, Disease and Critical Hits
// * 100% immunity to iElem, 100% vulnerability to opposite of iElem
// * iElem = IP_CONST_DAMAGETYPE_*
void ElemSavantPerfection(object oPC, object oSkin, int iElem)
{
    if(GetLocalInt(oSkin, "ElemSavantPerfection") == TRUE) return;

    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageVulnerability(GetOppositeElement(iElem), IP_CONST_DAMAGEVULNERABILITY_100_PERCENT), oSkin);

    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON), oSkin);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE), oSkin);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB), oSkin);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS), oSkin);

    SetLocalInt(oSkin, "ElemSavantPerfection", TRUE);
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int iElement;

     //Determine which Elemental Savant feats the character has
    if(GetHasFeat(FEAT_ES_FIRE, oPC)) iElement = IP_CONST_DAMAGETYPE_FIRE;
    if(GetHasFeat(FEAT_ES_COLD, oPC)) iElement = IP_CONST_DAMAGETYPE_COLD;
    if(GetHasFeat(FEAT_ES_ACID, oPC)) iElement = IP_CONST_DAMAGETYPE_ACID;
    if(GetHasFeat(FEAT_ES_ELEC, oPC)) iElement = IP_CONST_DAMAGETYPE_ELECTRICAL;

    int iResist = GetHasFeat(FEAT_ES_RESIST_1, oPC) ? IP_CONST_DAMAGERESIST_5 : -1;
        iResist = GetHasFeat(FEAT_ES_RESIST_2, oPC) ? IP_CONST_DAMAGERESIST_10 : iResist;
        iResist = GetHasFeat(FEAT_ES_RESIST_3, oPC) ? IP_CONST_DAMAGERESIST_15 : iResist;
        iResist = GetHasFeat(FEAT_ES_PERFECTION, oPC) ? IP_CONST_DAMAGERESIST_500 : iResist;

    int iTrans1 = GetHasFeat(FEAT_ES_TRANS_1, oPC);
    int iTrans2 = GetHasFeat(FEAT_ES_TRANS_2, oPC);
    int iTrans3 = GetHasFeat(FEAT_ES_TRANS_3, oPC);

    int iPerfect = GetHasFeat(FEAT_ES_PERFECTION, oPC);

    //Apply bonuses accordingly
    if(iResist > -1) ElemSavantResist(oPC, oSkin, iElement, iResist);
    if(iTrans1) ElemSavantImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_MINDSPELLS, "ElemSavantImmMind");
    if(iTrans2) ElemSavantImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_PARALYSIS, "ElemSavantImmParal");
    if(iTrans3) ElemSavantImmunity(oPC, oSkin, IMMUNITY_TYPE_SLEEP, "ElemSavantImmSleep");
    if(iPerfect) ElemSavantPerfection(oPC, oSkin, iElement);
}
