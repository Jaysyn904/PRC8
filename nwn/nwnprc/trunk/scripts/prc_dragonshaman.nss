
#include "prc_compan_inc"
#include "pnp_shft_poly"
#include "prc_inc_dragsham"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nTotem = GetLocalInt(oPC, "DragonShamanTotem");

    if(!nTotem)
    {
        nTotem = GetHasFeat(FEAT_DRAGONSHAMAN_BLACK, oPC)  ? FEAT_DRAGONSHAMAN_BLACK:
                 GetHasFeat(FEAT_DRAGONSHAMAN_BLUE, oPC)   ? FEAT_DRAGONSHAMAN_BLUE:
                 GetHasFeat(FEAT_DRAGONSHAMAN_BRASS, oPC)  ? FEAT_DRAGONSHAMAN_BRASS:
                 GetHasFeat(FEAT_DRAGONSHAMAN_BRONZE, oPC) ? FEAT_DRAGONSHAMAN_BRONZE:
                 GetHasFeat(FEAT_DRAGONSHAMAN_COPPER, oPC) ? FEAT_DRAGONSHAMAN_COPPER:
                 GetHasFeat(FEAT_DRAGONSHAMAN_GOLD, oPC)   ? FEAT_DRAGONSHAMAN_GOLD:
                 GetHasFeat(FEAT_DRAGONSHAMAN_GREEN, oPC)  ? FEAT_DRAGONSHAMAN_GREEN:
                 GetHasFeat(FEAT_DRAGONSHAMAN_SILVER, oPC) ? FEAT_DRAGONSHAMAN_SILVER:
                 GetHasFeat(FEAT_DRAGONSHAMAN_WHITE, oPC)  ? FEAT_DRAGONSHAMAN_WHITE:
                 //GetHasFeat(FEAT_DRAGONSHAMAN_RED, oPC)    ? FEAT_DRAGONSHAMAN_RED:// no other totems so Red Dragon will be our default
                 FEAT_DRAGONSHAMAN_RED;//default value - no other totem dragons found

        SetLocalInt(oPC, "DragonShamanTotem", nTotem);
    }

    if(GetHasFeat(FEAT_SHAMANIC_INVOCATION, oPC))
        ExecuteScript("prc_amagsys_gain", oPC);

    // For Draconic Resolve
    if(GetHasFeat(FEAT_DRAGONSHAMAN_RESOLVE, oPC))
    {
        IPSafeAddItemProperty(oSkin, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        IPSafeAddItemProperty(oSkin, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_SLEEP), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        IPSafeAddItemProperty(oSkin, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_FEAR), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }

    // For Draconic Armor
    if(GetHasFeat(FEAT_DRAGONSHAMAN_ARMOR, oPC))
    {
        int nBonus = (GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN, oPC) - 2) / 5;//+1 every 5 levels starting at lvl 7
        SetCompositeBonus(oSkin, "ScaleThicken", nBonus, ITEM_PROPERTY_AC_BONUS);
    }

    //For Energy Immunity
    if(GetHasFeat(FEAT_DRAGONSHAMAN_ENERGY_IMMUNITY, oPC))
    {
        int nDamageType = GetDragonDamageType(nTotem);
        int iIP;

        switch(nDamageType)
        {
            case DAMAGE_TYPE_FIRE:       iIP = IP_CONST_DAMAGETYPE_FIRE; break;
            case DAMAGE_TYPE_ELECTRICAL: iIP = IP_CONST_DAMAGETYPE_ELECTRICAL; break;
            case DAMAGE_TYPE_ACID:       iIP = IP_CONST_DAMAGETYPE_ACID; break;
            case DAMAGE_TYPE_COLD:       iIP = IP_CONST_DAMAGETYPE_COLD; break;
        }

        IPSafeAddItemProperty(oSkin, ItemPropertyDamageImmunity(iIP, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }

    if(GetHasFeat(FEAT_DRAGONSHAMAN_WINGS, oPC) && !GetPersistantLocalInt(oPC, "DragShamanWingsApplied"))
    {
        int nWingType = nTotem == FEAT_DRAGONSHAMAN_BLACK   ? PRC_WING_TYPE_DRAGON_BLACK:
                      nTotem == FEAT_DRAGONSHAMAN_BLUE      ? PRC_WING_TYPE_DRAGON_BLUE:
                      nTotem == FEAT_DRAGONSHAMAN_BRASS     ? PRC_WING_TYPE_DRAGON_BRASS:
                      nTotem == FEAT_DRAGONSHAMAN_BRONZE    ? PRC_WING_TYPE_DRAGON_BRONZE:
                      nTotem == FEAT_DRAGONSHAMAN_COPPER    ? PRC_WING_TYPE_DRAGON_COPPER:
                      nTotem == FEAT_DRAGONSHAMAN_GOLD      ? PRC_WING_TYPE_DRAGON_GOLD:
                      nTotem == FEAT_DRAGONSHAMAN_GREEN     ? PRC_WING_TYPE_DRAGON_GREEN:
                      nTotem == FEAT_DRAGONSHAMAN_SILVER    ? PRC_WING_TYPE_DRAGON_SILVER:
                      nTotem == FEAT_DRAGONSHAMAN_WHITE     ? PRC_WING_TYPE_DRAGON_WHITE:
                      nTotem == FEAT_DRAGONSHAMAN_RED       ? PRC_WING_TYPE_DRAGON_RED:
                      CREATURE_WING_TYPE_DRAGON;

        SetCompositeBonus(oSkin, "WingBonus", 10, ITEM_PROPERTY_SKILL_BONUS, SKILL_JUMP);
        SetCreatureWingType(nWingType, oPC);
        SetPersistantLocalInt(oPC, "DragShamanWingsApplied", TRUE);
    }
}