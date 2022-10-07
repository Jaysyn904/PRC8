//::///////////////////////////////////////////////
//:: Name        Assassin Death Attack heartbeat
//:: FileName    prc_assn_da_hb
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Shane Hennessy
//:: Created On:
//:://////////////////////////////////////////////
// Death Attack for the assassin
// this function counts down till they get to perform the DA
// and then adds the slaytarget type property to their weapon

#include "NW_I0_GENERIC"
#include "bnd_inc_bndfunc"

void main()
{
    object oPC = OBJECT_SELF;

    // Currently from the PnP rules they dont have to wait except for the study time
    // So this fWaitTime is not being used at all
    // Are we still counting down before they can do another DA?
    float fWaitTime = GetLocalFloat(oPC,"PRC_ASSN_DEATHATTACK_WAITSEC");
    if (fWaitTime > 0.0)
    {
        // The wait is over they can do another DA
        DeleteLocalFloat(oPC,"PRC_ASSN_DEATHATTACK_WAITSEC");
        return;
    }
    if (!GetTotalSneakAttackDice(oPC) && !GetHasSpellEffect(VESTIGE_MARCHOSIAS, oPC))
    {
        FloatingTextStringOnCreature("You have no sneak attack dice, you can not perform a death attack!", oPC, FALSE);
        DeleteLocalFloat(oPC,"PRC_ASSN_DEATHATTACK_APPLY");
        return;
    }
    
    // We must be counting down until we can apply the slay property
    // Assasain must not be seen
   /* if (!((GetStealthMode(oPC) == STEALTH_MODE_ACTIVATED) ||
         (PRCGetHasEffect(EFFECT_TYPE_INVISIBILITY,oPC)) ||
         !(GetIsInCombat(oPC)) ||
         (PRCGetHasEffect(EFFECT_TYPE_SANCTUARY,oPC))))*/
    // Using the CanSeePlayer function on the target
    if (GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, GetLocalObject(oPC, "PRC_DA_TARGET"), 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN)))
    {
        FloatingTextStringOnCreature("Your target is aware of you, you can not perform a death attack", oPC);
        DeleteLocalFloat(oPC,"PRC_ASSN_DEATHATTACK_APPLY");
        return;
    }
    float fApplyDATime = GetLocalFloat(oPC,"PRC_ASSN_DEATHATTACK_APPLY");
    // We run every 6 seconds
    fApplyDATime -= 6.0;
    SetLocalFloat(oPC,"PRC_ASSN_DEATHATTACK_APPLY",fApplyDATime );

    // Times up, apply the slay to their primary weapon
    if (fApplyDATime <= 0.0)
    {
        object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        int nWeaponType = GetBaseItemType(oWeapon);

        if(nWeaponType == BASE_ITEM_SHORTBOW
        || nWeaponType == BASE_ITEM_LONGBOW
        || nWeaponType == BASE_ITEM_LIGHTCROSSBOW
        || nWeaponType == BASE_ITEM_HEAVYCROSSBOW
        || nWeaponType == BASE_ITEM_SLING)
        {
            if(GetLevelByClass(CLASS_TYPE_JUSTICEWW, oPC) < 10)
            {
                SendMessageToPC(oPC, "You cannot use a ranged death attack.");
                return;
            }
        }

        if(nWeaponType == BASE_ITEM_INVALID)
        {
            oWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS);
        }

        // if we got something add the on hit slay racial type property to it
        // for 3 rounds
        int nSaveDC = 10 + GetLevelByClass(CLASS_TYPE_BFZ, oPC)
                         + GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC)
                         + GetLevelByClass(CLASS_TYPE_SHADOWLORD, oPC)
                         + GetLevelByClass(CLASS_TYPE_CULTIST_SHATTERED_PEAK, oPC)
                         + GetLevelByClass(CLASS_TYPE_JUSTICEWW, oPC)
                         + GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
        int nMarruDC = 10 + (GetHitDice(oPC)/2) + GetAbilityModifier(ABILITY_CHARISMA, oPC);   
        
        if (GetRacialType(oPC) == RACIAL_TYPE_MARRULURK) nSaveDC = nMarruDC;
        if (GetHasSpellEffect(VESTIGE_MARCHOSIAS, oPC)) nSaveDC = GetBinderDC(oPC, VESTIGE_MARCHOSIAS);
        
        // Saves are capped at 70
        if (nSaveDC > 70)
            nSaveDC = 70;
        int nRace = GetLocalInt(oPC,"PRC_ASSN_TARGET_RACE");
        itemproperty ipSlay = ItemPropertyOnHitProps(IP_CONST_ONHIT_SLAYRACE,nSaveDC,nRace);

        if(GetWeaponRanged(oWeapon))
        {
            object oAmmo;
            if(nWeaponType == BASE_ITEM_LONGBOW
            || nWeaponType == BASE_ITEM_SHORTBOW)
            {
                oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS);
            }
            else if(nWeaponType == BASE_ITEM_SLING)
            {
                oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS);
            }
            else if(nWeaponType == BASE_ITEM_LIGHTCROSSBOW
            || nWeaponType == BASE_ITEM_HEAVYCROSSBOW)
            {
                oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS);
            }
            IPSafeAddItemProperty(oAmmo, ipSlay, 7.0);
            SendMessageToPC(oPC,"Death Attack ready, you have 1 round to slay your target");
            return;
        }
        else if (GetIsObjectValid(oWeapon)) 
        {
            IPSafeAddItemProperty(oWeapon, ipSlay, 7.0);
            SendMessageToPC(oPC,"Death Attack ready, you have 1 round to slay your target");
            return;
        }
        else
        {
            FloatingTextStringOnCreature("You do not have a proper melee weapon for the death attack", oPC);
            return;
        }
    }
    else
    {
        SendMessageToPC(oPC,"Your are still studying your target wait "+IntToString(FloatToInt(fApplyDATime))+ " seconds before you can perform the death attack");
        // Run more heartbeats
        DelayCommand(6.0,ExecuteScript("prc_assn_da_hb", oPC));
    }
    return;
}