//::///////////////////////////////////////////////
//:: Snowflake Wardance
//:: prc_snowflake.nss
//:://////////////////////////////////////////////
/*
    By expending one of your daily uses of bardic music, 
    you may perform a deadly style of combat known as 
    the snowflake wardance. Activating a snowflake 
    wardance is a free action, and once activated, you 
    add your Charisma modifier to your attack rolls with 
    any slashing melee weapon you wield in one hand. This 
    bonus to hit stacks with any bonuses you get from a 
    high Strength score (or Dexterity score, if you are 
    using Weapon Finesse). You cannot use this feat if 
    you are carrying a shield, wearing medium or heavy 
    armor, or carrying a medium or heavy load. A snowflake 
    wardance lasts for a number of rounds equal to your 
    ranks in Perform. Performing a snowflake wardance is 
    physically tiresome – when the snowflake wardance ends, 
    you become fatigued for the next 10 minutes.
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Oct 30, 2018
//:://////////////////////////////////////////////
#include "prc_alterations"

int GetIsOnehandedSlashingWeapon(object oWeapon)
{
    if (GetBaseItemType(oWeapon) == BASE_ITEM_LONGSWORD ||
        GetBaseItemType(oWeapon) == BASE_ITEM_BATTLEAXE ||
        GetBaseItemType(oWeapon) == BASE_ITEM_HANDAXE ||
        GetBaseItemType(oWeapon) == BASE_ITEM_KAMA ||
        GetBaseItemType(oWeapon) == BASE_ITEM_KUKRI ||
        GetBaseItemType(oWeapon) == BASE_ITEM_SCIMITAR ||
        GetBaseItemType(oWeapon) == BASE_ITEM_BASTARDSWORD ||
        GetBaseItemType(oWeapon) == BASE_ITEM_SICKLE ||
		GetBaseItemType(oWeapon) == BASE_ITEM_KATANA ||
        GetBaseItemType(oWeapon) == BASE_ITEM_DWARVENWARAXE)
    {
        return TRUE;
    }
    
    return FALSE;    
}

void main()
{
   object oPC = OBJECT_SELF;

    if (PRCGetHasEffect(EFFECT_TYPE_SILENCE,oPC))
    {
        FloatingTextStrRefOnCreature(85764,oPC); // not useable when silenced
        return;
    }
    else if (!GetHasFeat(FEAT_BARD_SONGS, oPC))
    {
        //SpeakStringByStrRef(40550);
        FloatingTextStringOnCreature("You have no bardic music uses left", oPC, FALSE);
        return;
    }
    else
    {
        object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        object oLefthand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);  
        object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
        
        if(4 > GetBaseAC(oArmor) && !GetIsObjectValid(oLefthand) && GetIsOnehandedSlashingWeapon(oWeapon))
        {
            DecrementRemainingFeatUses(oPC, FEAT_BARD_SONGS);
            float fDur = RoundsToSeconds(GetSkillRank(SKILL_PERFORM, oPC, TRUE));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectAttackIncrease(GetAbilityModifier(ABILITY_CHARISMA, oPC))), oPC, fDur);
            DelayCommand(fDur, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectFatigue(), oPC, 600.0));
        }    
    }
}

