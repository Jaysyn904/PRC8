//::///////////////////////////////////////////////
//:: Sanctified Mind
//:: psi_sancmind.nss
//:://////////////////////////////////////////////
//:: Applies the passive bonuses from Sanctified Mind
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Feb 17, 2006
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_ip_srcost"

void SancMind_PR(object oPC, object oSkin)
{
    if(GetLocalInt(oSkin, "SanctifiedMind_SR") == TRUE) return;
    
    int ipSR;
    int nHD = GetHitDice(oPC);
    
    // Minimum level to take the class is 4
    // Min level to get this ability is 10
    // PR = 5 + Char level
    if (nHD == 40) ipSR = IP_CONST_SPELLRESISTANCEBONUS_45;
    else if (nHD == 39) ipSR = IP_CONST_SPELLRESISTANCEBONUS_44;
    else if (nHD == 38) ipSR = IP_CONST_SPELLRESISTANCEBONUS_43;
    else if (nHD == 37) ipSR = IP_CONST_SPELLRESISTANCEBONUS_42;
    else if (nHD == 36) ipSR = IP_CONST_SPELLRESISTANCEBONUS_41;
    else if (nHD == 35) ipSR = IP_CONST_SPELLRESISTANCEBONUS_40;
    else if (nHD == 34) ipSR = IP_CONST_SPELLRESISTANCEBONUS_39;
    else if (nHD == 33) ipSR = IP_CONST_SPELLRESISTANCEBONUS_38;
    else if (nHD == 32) ipSR = IP_CONST_SPELLRESISTANCEBONUS_37;
    else if (nHD == 31) ipSR = IP_CONST_SPELLRESISTANCEBONUS_36;
    else if (nHD == 30) ipSR = IP_CONST_SPELLRESISTANCEBONUS_35;
    else if (nHD == 29) ipSR = IP_CONST_SPELLRESISTANCEBONUS_34;
    else if (nHD == 28) ipSR = IP_CONST_SPELLRESISTANCEBONUS_33;
    else if (nHD == 27) ipSR = IP_CONST_SPELLRESISTANCEBONUS_32;
    else if (nHD == 26) ipSR = IP_CONST_SPELLRESISTANCEBONUS_31;
    else if (nHD == 25) ipSR = IP_CONST_SPELLRESISTANCEBONUS_30;
    else if (nHD == 24) ipSR = IP_CONST_SPELLRESISTANCEBONUS_29;
    else if (nHD == 23) ipSR = IP_CONST_SPELLRESISTANCEBONUS_28;
    else if (nHD == 22) ipSR = IP_CONST_SPELLRESISTANCEBONUS_27;
    else if (nHD == 21) ipSR = IP_CONST_SPELLRESISTANCEBONUS_26;
    else if (nHD == 20) ipSR = IP_CONST_SPELLRESISTANCEBONUS_25;
    else if (nHD == 19) ipSR = IP_CONST_SPELLRESISTANCEBONUS_24;
    else if (nHD == 18) ipSR = IP_CONST_SPELLRESISTANCEBONUS_23;
    else if (nHD == 17) ipSR = IP_CONST_SPELLRESISTANCEBONUS_22;
    else if (nHD == 16) ipSR = IP_CONST_SPELLRESISTANCEBONUS_21;
    else if (nHD == 15) ipSR = IP_CONST_SPELLRESISTANCEBONUS_20;
    else if (nHD == 14) ipSR = IP_CONST_SPELLRESISTANCEBONUS_19;
    else if (nHD == 13) ipSR = IP_CONST_SPELLRESISTANCEBONUS_18;
    else if (nHD == 12) ipSR = IP_CONST_SPELLRESISTANCEBONUS_17;
    else if (nHD == 11) ipSR = IP_CONST_SPELLRESISTANCEBONUS_16;
    else if (nHD == 10) ipSR = IP_CONST_SPELLRESISTANCEBONUS_15;


    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusSpellResistance(ipSR),oSkin);
    SetLocalInt(oSkin, "SancMind_PR", TRUE);
}

// Applies the Hard to Hold bonus to Discipline
void HardToHold(object oPC, object oSkin, int iLevel)
{
    if(GetLocalInt(oSkin, "SancMind_Discipline") == iLevel) return;

    SetCompositeBonus(oSkin, "SancMind_Discipline", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_DISCIPLINE);
}

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nSanc = GetLevelByClass(CLASS_TYPE_SANCTIFIED_MIND, oPC);

    //if(nSanc >= 4) HardToHold(oPC, oSkin, nSanc);
    if(nSanc >= 6) SancMind_PR(oPC, oSkin);
}
