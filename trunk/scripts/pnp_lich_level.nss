//::///////////////////////////////////////////////
//:: Name        Lich
//:: FileName    pnp_lich_level
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Shane Hennessy
//:: Created On:
//:://////////////////////////////////////////////
// Completes the level up process by checking the amulet level vs the hide level
// vs the lich level.

// Called by the EvalPRC function
#include "prc_alterations"
#include "pnp_lich_inc"
#include "NW_I0_GENERIC"


void LichLevelUpVFX(object oPC, int nPowerLevel)
{
    // make some fancy fireworks for when the lich levels up
    // VFX for the increase of powers
    if (nPowerLevel < 10)
    {
        effect eFx = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_EVIL);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,oPC);
        eFx = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,oPC);
        eFx = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,oPC);
    }
    else
    {
        effect eFx = EffectVisualEffect(VFX_FNF_WAIL_O_BANSHEES);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,oPC);
    }
}

int GetSoulGemCount(object oPC)
{
    int nNumSoulGems = 0;
    object oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem))
    {
        if (GetResRef(oItem) == "soul_gem") nNumSoulGems++;
        oItem = GetNextItemInInventory(oPC);
    }
    return nNumSoulGems;
}

int DeterminePowerLevel(object oPC)
{
    int nLichLevel = GetLevelByClass(CLASS_TYPE_LICH,oPC);
    if (DEBUG) Assert(nLichLevel > 0, "nLichLevel > 0", "Creature has no levels in Lich class!", "pnp_lich_level", "DeterminePowerLevel()");

    object oAmulet = GetItemPossessedBy(oPC,"lichamulet");

    // The amulet's level represents the number of upgrades performed on it.
    int nAmuletLevel = GetAmuletLevel(oAmulet);
    if (DEBUG) DoDebug("lich amulet level = " + IntToString(nAmuletLevel));

    // Maximum possible power level of the PC, capped at ten. Power level can never exceed the lich level.
    int nMaxPowerLevel = nLichLevel < 10 ? nLichLevel : 10;
    // Maximum power level allowed by the amulet level and soul gem count respectively.
    int nAmuletPowerLevel = nMaxPowerLevel, nSoulGemPowerLevel = nMaxPowerLevel;
    // Number of additional soul gems needed to reach a new power level.
    int nRemainingSoulGems = 0;

    // Note: A "new" power level as referred to in this function is a power level above that of what the player has.
    //       A level 6 lich that has a power level of 5 will have a "new" power level of 6 provided they meet the requirements.
    //       A level 6 lich that has a power level of 1 will have a "new" power level of 2-6 provided they meet the requirements.

    // Power level can also never exceed the amulet level. Player is informed further down if it does.
    if (nAmuletLevel < nMaxPowerLevel)
        // Power level supported with the current amulet level.
        nAmuletPowerLevel = nAmuletLevel;

    // Soul gems are used to attain power levels beyond four.
    if (nMaxPowerLevel > 4)
    {
        // Number of soul gems in the player's inventory.
        int nNumSoulGems = GetSoulGemCount(oPC);
        if (DEBUG) DoDebug("lich soul gem count = " + IntToString(nNumSoulGems));

        // Maximum number of soul gems that can ever be required.
        // Safer to use than nNumSoulGems. A player may have thirty gems when they only need eight and end up confusing the algorithm.
        int nMaxRequiredSoulGems = nNumSoulGems < 5 ? nNumSoulGems + 1 : 8;

        // Total number of soul gems required for a new power level.
        int nRequiredSoulGems;
        if (nLichLevel < 10) nRequiredSoulGems = nMaxPowerLevel - 4 < nMaxRequiredSoulGems ? nMaxPowerLevel - 4 : nMaxRequiredSoulGems;
        else                 nRequiredSoulGems = nMaxRequiredSoulGems;

        // Additional number of soul gems required for a new power level.
        nRemainingSoulGems = nRequiredSoulGems - (nNumSoulGems < nRequiredSoulGems ? nNumSoulGems : nRequiredSoulGems);
        if (nRemainingSoulGems > 0)
            // Power level supported with the current number of soul gems.
            nSoulGemPowerLevel = nRequiredSoulGems <= 5 ? 4 + nRequiredSoulGems - 1 : 9;
    }

    int nNewPowerLevel = nAmuletPowerLevel < nSoulGemPowerLevel ? nAmuletPowerLevel : nSoulGemPowerLevel;

    // Inform the player of what he needs to do if his power level is being restricted.
    if (nNewPowerLevel < nMaxPowerLevel)
    {
        string sMessage = "Power fills your senses... but first you must ";
        if (nAmuletPowerLevel <= nSoulGemPowerLevel) sMessage += "improve your phylactery";
        if (nAmuletPowerLevel == nSoulGemPowerLevel) sMessage += " and ";
        if (nAmuletPowerLevel >= nSoulGemPowerLevel) sMessage += "obtain " + IntToString(nRemainingSoulGems) + " soul gem(s)";
        FloatingTextStringOnCreature(sMessage += ".", oPC);
    }
    return nNewPowerLevel;
}

void TryLichLevelUp(object oPC)
{
    // If they are polymorphed dont run this code
    // this should fix the HOTU sensi amulet bug
    if (PRCGetHasEffect(EFFECT_TYPE_POLYMORPH,oPC))
        return;

    int nPowerLevel = GetPowerLevel(oPC);
    int nNewPowerLevel = DeterminePowerLevel(oPC);

    if (DEBUG) DoDebug("lich power level = " + IntToString(nPowerLevel));
    if (DEBUG) DoDebug("lich new power level = " + IntToString(nNewPowerLevel));

    object oHide = GetPCSkin(oPC);
    LevelUpHide(oPC, oHide, nNewPowerLevel);

    // Only create a visual effect if a power level was gained.
    if (nNewPowerLevel > nPowerLevel)
        LichLevelUpVFX(oPC, nNewPowerLevel);
}

void main()
{
    // being called by EvalPRCFeats
    object oPC = OBJECT_SELF;

    DelayCommand(0.0f, TryLichLevelUp(oPC));
}
