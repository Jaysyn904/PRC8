// x - moved to prc_feats.nss
#include "prc_alterations"
/*
int GetIsDragonblooded(object oPC)
{
    int nRace = GetRacialType(oPC);
    if(nRace == RACIAL_TYPE_KOBOLD
    || nRace == RACIAL_TYPE_SPELLSCALE
    || nRace == RACIAL_TYPE_DRAGONBORN
    || nRace == RACIAL_TYPE_STONEHUNTER_GNOME
    || nRace == RACIAL_TYPE_SILVERBROW_HUMAN
    || nRace == RACIAL_TYPE_FORESTLORD_ELF
    || nRace == RACIAL_TYPE_FIREBLOOD_DWARF
    || nRace == RACIAL_TYPE_GLIMMERSKIN_HALFING
    || nRace == RACIAL_TYPE_FROSTBLOOD_ORC
    || nRace == RACIAL_TYPE_SUNSCORCH_HOBGOBLIN
    || nRace == RACIAL_TYPE_VILETOOTH_LIZARDFOLK)
        return TRUE;

    if(GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE, oPC) > 9)
        return TRUE;

    if(GetHasFeat(FEAT_DRAGONTOUCHED, oPC)
    || GetHasFeat(FEAT_DRACONIC_DEVOTEE, oPC)
    || GetHasFeat(FEAT_DRAGON, oPC)
    || GetHasFeat(DRAGON_BLOODED, oPC))
        return TRUE;

    //Draconic Heritage qualifies for dragonblood
    if(GetHasFeat(FEAT_DRACONIC_HERITAGE_BK, oPC)
    || GetHasFeat(FEAT_DRACONIC_HERITAGE_BL, oPC)
    || GetHasFeat(FEAT_DRACONIC_HERITAGE_GR, oPC)
    || GetHasFeat(FEAT_DRACONIC_HERITAGE_RD, oPC)
    || GetHasFeat(FEAT_DRACONIC_HERITAGE_WH, oPC)
    || GetHasFeat(FEAT_DRACONIC_HERITAGE_AM, oPC)
    || GetHasFeat(FEAT_DRACONIC_HERITAGE_CR, oPC)
    || GetHasFeat(FEAT_DRACONIC_HERITAGE_EM, oPC)
    || GetHasFeat(FEAT_DRACONIC_HERITAGE_SA, oPC)
    || GetHasFeat(FEAT_DRACONIC_HERITAGE_TP, oPC)
    || GetHasFeat(FEAT_DRACONIC_HERITAGE_BS, oPC)
    || GetHasFeat(FEAT_DRACONIC_HERITAGE_BZ, oPC)
    || GetHasFeat(FEAT_DRACONIC_HERITAGE_CP, oPC)
    || GetHasFeat(FEAT_DRACONIC_HERITAGE_GD, oPC)
    || GetHasFeat(FEAT_DRACONIC_HERITAGE_SR, oPC))
        return TRUE;

    return FALSE;
}*/

void main()
{/*
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int ipFeat = IP_CONST_FEAT_BONUS_AURA_1;

    if(GetIsDragonblooded(oPC))
    {
        int nHD = GetHitDice(oPC);

        if(nHD > 19)
            ipFeat = IP_CONST_FEAT_BONUS_AURA_4;
        else if(nHD > 13)
            ipFeat = IP_CONST_FEAT_BONUS_AURA_3;
        else if(nHD > 6)
            ipFeat = IP_CONST_FEAT_BONUS_AURA_2;
    }

    IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(ipFeat), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
*/}