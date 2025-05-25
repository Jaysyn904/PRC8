//::///////////////////////////////////////////////
//:: Power Attack script
//:: ft_poweratk
//::///////////////////////////////////////////////
/*
    This script handles the PRC power attack feats.

<Ornedan> For PA, I was thinking 3 radials
<Ornedan> One for the presets
<Ornedan> One for +0, +1, +2, +3, +4
<Ornedan> One for +0, +5, +10, +15, +20
<Ornedan> And a bunch of switches to control it:
<Ornedan> PRC_POWER_ATTACK - 3 values:
<Ornedan> -1 -- Disabled. Never apply the PRC PA feats to hide
<Ornedan> 0 -- Default. As it is now, you can't go higher than the equivalent BW feat you have
<Ornedan> 1 -- Full PnP. Ignores the BW IPA
<Ornedan> PRC_POWER_ATTACK_STACK_WITH_BW
<Ornedan> 0 - Default. Allow people to use both at the same time
<Ornedan> 1 - Add the BW effects in when limiting to BAB
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_combat"
#include "inc_addragebonus"
//#include "prc_inc_sneak"  //for Dragonfire damage type resolving

/*
const int SINGLE_START = 2171;
const int SINGLE_LAST  = 2175;
const int FIVES_START  = 2177;
const int FIVES_LAST   = 2181;
*/

// Converts the given amount of bonus damage to equivalent DAMAGE_BONUS constant
// Due to the bonus cap, bonuses are cropped to +20
int BonusAtk(int nDmg)
{
    switch (nDmg)
    {
        case 1:  return DAMAGE_BONUS_1;
        case 2:  return DAMAGE_BONUS_2;
        case 3:  return DAMAGE_BONUS_3;
        case 4:  return DAMAGE_BONUS_4;
        case 5:  return DAMAGE_BONUS_5;
        case 6:  return DAMAGE_BONUS_6;
        case 7:  return DAMAGE_BONUS_7;
        case 8:  return DAMAGE_BONUS_8;
        case 9:  return DAMAGE_BONUS_9;
        case 10: return DAMAGE_BONUS_10;
        case 11: return DAMAGE_BONUS_11;
        case 12: return DAMAGE_BONUS_12;
        case 13: return DAMAGE_BONUS_13;
        case 14: return DAMAGE_BONUS_14;
        case 15: return DAMAGE_BONUS_15;
        case 16: return DAMAGE_BONUS_16;
        case 17: return DAMAGE_BONUS_17;
        case 18: return DAMAGE_BONUS_18;
        case 19: return DAMAGE_BONUS_19;
        case 20: return DAMAGE_BONUS_20;
		case 21: return DAMAGE_BONUS_21;
		case 22: return DAMAGE_BONUS_22;
		case 23: return DAMAGE_BONUS_23;
		case 24: return DAMAGE_BONUS_24;
		case 25: return DAMAGE_BONUS_25;
		case 26: return DAMAGE_BONUS_26;
		case 27: return DAMAGE_BONUS_27;
		case 28: return DAMAGE_BONUS_28;
		case 29: return DAMAGE_BONUS_29;
		case 30: return DAMAGE_BONUS_30;
		case 31: return DAMAGE_BONUS_31;
		case 32: return DAMAGE_BONUS_32;
		case 33: return DAMAGE_BONUS_33;
		case 34: return DAMAGE_BONUS_34;
		case 35: return DAMAGE_BONUS_35;
		case 36: return DAMAGE_BONUS_36;
		case 37: return DAMAGE_BONUS_37;
		case 38: return DAMAGE_BONUS_38;
		case 39: return DAMAGE_BONUS_39;
		case 40: return DAMAGE_BONUS_40;
		case 41: return DAMAGE_BONUS_41;
		case 42: return DAMAGE_BONUS_42;
		case 43: return DAMAGE_BONUS_43;
		case 44: return DAMAGE_BONUS_44;
		case 45: return DAMAGE_BONUS_45;
		case 46: return DAMAGE_BONUS_46;
		case 47: return DAMAGE_BONUS_47;
		case 48: return DAMAGE_BONUS_48;
		case 49: return DAMAGE_BONUS_49;
		case 50: return DAMAGE_BONUS_50;		
    }
    if(nDmg > 50) return DAMAGE_BONUS_50;

    return -1; // Invalid value received
}

/*
int CalculatePower(object oUser)
{
    int nPower = GetLocalInt(oUser, "PRC_PowerAttack_Level");
    int nSID = GetSpellID();

    // Changing the value of +0,+1,+2,+3,+4 radial
    if(nSID >= SINGLE_START && <= SINGLE_LAST)
    {
        // Extract the old fives value
        nPower = (nPower / 5) * 5;
        // Add in the new single value
        nPower += nSID - SINGLE_START;
    }
    // Changing the value of +0,+5,+10,+15,+20 radial
    else if(nSID >= FIVES_START && <= FIVES_LAST)
    {
        // Extract the old single value
        nPower = nPower % 5;
        // Add in the new fives value
        nPower += (nSID - FIVES_START) * 5;
    }
    // Unknown SpellId
    else
    {
        WriteTimestampedLogEntry("ft_poweratk called with unknown SpellID: " + IntToString(nSID));
        nPower = 0;
    }

    // Cache the new PA level
    SetLocalInt(oUser, "PRC_PowerAttack_Level", nPower);

    return nPower;
}
*/
void main()
{
    object oUser = OBJECT_SELF;
    int nPower = GetLocalInt(oUser, "PRC_PowerAttack_Level");

    // The PRC Power Attack must be active for this to do anything
    if(GetPRCSwitch(PRC_POWER_ATTACK) == PRC_POWER_ATTACK_DISABLED)
        return;

    // Get the old Power Attack, if any
    int nOld = GetLocalInt(oUser, "PRC_PowerAttackSpellID");

    // Remove effects from it
    if(nOld)
    {
        PRCRemoveSpellEffects(nOld, oUser, oUser);
        DeleteLocalInt(oUser, "PRC_PowerAttackSpellID");
        DeleteLocalInt(oUser, "PRC_PowerAttack_DamageBonus");
    }

    // Activate Power Attack if the new value is non-zero
    if(nPower)
    {
        // Requires the appropriate BW PA feat.
        if(!GetHasFeat(FEAT_POWER_ATTACK))
        {
            FloatingTextStrRefOnCreature(16823148, oUser, FALSE); //Prereq: Power Attack feat
            return;
        }
        if(nPower > 5                              &&                   // If the power attack is in BW IPA range
           !GetHasFeat(FEAT_IMPROVED_POWER_ATTACK) &&                   // And they don't have IPA
           GetPRCSwitch(PRC_POWER_ATTACK) != PRC_POWER_ATTACK_FULL_PNP) // And full PnP PA, which ignores BW IPA isn't active
        {
            FloatingTextStrRefOnCreature(16823149, oUser, FALSE); // Prereq: Improved Power Attack feat
            return;
        }

        // This script is for the melee weapon PA. If Power Shot is implemented using the same script
        // at some future date, change this.
        object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oUser);
        int nBase = GetBaseItemType(oWeapon);
        int nThrow = FALSE;
        if (GetIsThrowingWeaponType(nBase) && GetHasFeat(FEAT_POWER_THROW, oUser)) nThrow = TRUE; // Power throw allows power attacking with throwing weapons
        if(GetWeaponRanged(oWeapon) && !nThrow)
        {
            FloatingTextStrRefOnCreature(16823150, oUser, FALSE); // You may not use this feat with a ranged weapon.
            return;
        }

        // All checks are done, initialize variables for calculating the effect.
        int nDamageBonusType = GetDamageTypeOfWeapon(INVENTORY_SLOT_RIGHTHAND, oUser);
        if(GetLocalInt(oUser, "DragonFireAssOn")) nDamageBonusType = GetDragonfireDamageType(oUser);
        int nDmg, nHit, nDex, nTemp;
        effect eDamage;
        effect eToHit;

        // Initialize the calculation with the power attack value given by the user.
        nHit = nPower;

        // Check if we are set to care about BW power attack being active
        if(GetPRCSwitch(PRC_POWER_ATTACK_STACK_WITH_BW))
        {
            nTemp += GetActionMode(oUser, ACTION_MODE_POWER_ATTACK) ? 5 : 0;
            nTemp += GetActionMode(oUser, ACTION_MODE_IMPROVED_POWER_ATTACK) ? 10 : 0;
        }
        // The attack bonus paid to PA is limited to one's BAB
        if(GetBaseAttackBonus(oUser) < (nHit + nTemp))
        {
            nHit = GetBaseAttackBonus(oUser) - ((GetActionMode(oUser, ACTION_MODE_POWER_ATTACK) ? 5 : 0) +
                                                (GetActionMode(oUser, ACTION_MODE_IMPROVED_POWER_ATTACK ? 10 : 0)));
            if(nHit < 0) nHit = 0;

            FloatingTextStrRefOnCreature(16823151, oUser, FALSE); // Your base attack bonus isn't high enough to pay for chosen Power Attack level.
        }

        // Focused Strike adds Dex mod to damage, limited to number of AB paid.
        if(GetHasFeat(FEAT_FOCUSED_STRIKE))
        {
            // Negative Dex mod won't reduce damage
            nDex = GetAbilityModifier(ABILITY_DEXTERITY) > 0 ? GetAbilityModifier(ABILITY_DEXTERITY) : 0;
            if(nDex > nHit) nDex = nHit;
        }
        
        // Calculate in Frenzied Berserker PA feats
        nTemp = GetHasFeat(FEAT_SUPREME_POWER_ATTACK, oUser) ? nHit * 2 :
                GetHasFeat(FEAT_FREBZK_IMPROVED_POWER_ATTACK, oUser) ? FloatToInt(1.5 * nHit) :
                nHit;

        // Calculate the damage. Supreme Power Attack doubles the damage
        nDmg = BonusAtk(nTemp + nDex + GetEssentiaInvestedFeat(oUser, FEAT_COBALT_POWER));

        eDamage = EffectDamageIncrease(nDmg, nDamageBonusType);
        eToHit = EffectAttackDecrease(nHit);

        effect eLink = ExtraordinaryEffect(EffectLinkEffects(eDamage, eToHit));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oUser);

        // Cache the spellid of the power attack used. Also acts as a marker
        //SetLocalInt(oUser, "PRC_PowerAttackSpellID", PRCGetSpellId());
		SetLocalInt(oUser, "PRC_PowerAttackSpellID", SPELL_NUI_POWER_ATTACK); 
        // Cache the amount of damage granted. This is used by the PRC combat engine
        SetLocalInt(oUser, "PRC_PowerAttack_DamageBonus", nDmg);
        // Add an eventscript that makes sure the PC does not use a ranged weapon with Power Attack
        AddEventScript(oUser, EVENT_ONPLAYEREQUIPITEM, "prc_powatk_equ", TRUE, FALSE);

        //                  Power Attack                                      Activated
        string sMes = "*" + GetStringByStrRef(417) + " " + IntToString(nHit) + " " + GetStringByStrRef(63798) + "*";
        FloatingTextStringOnCreature(sMes, oUser, FALSE);

        if (GetHasFeat(FEAT_FAVORED_POWER_ATTACK, oUser))
        {
            ActionCastSpellAtObject(SPELL_UR_FAVORITE_ENEMY, oUser, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
    }
    // Turn Power Attack off
    else
    {
        RemoveEventScript(oUser, EVENT_ONPLAYEREQUIPITEM, "prc_powatk_equ", TRUE);

        //                   Power Attack Mode Deactivated
        string sMes = "* " + GetStringByStrRef(58282) +  " *";
        FloatingTextStringOnCreature(sMes, oUser, FALSE);

        if(GetHasFeat(FEAT_FAVORED_POWER_ATTACK, oUser))
        {
            ActionCastSpellAtObject(SPELL_UR_FAVORITE_ENEMY, oUser, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
    }
}
