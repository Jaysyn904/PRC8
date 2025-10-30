//::///////////////////////////////////////////////
//:: Warlock
//:: inv_warlock.nss
//::///////////////////////////////////////////////
/*
    Handles the passive bonuses for Warlocks
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Feb 29, 2008
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inv_inc_invfunc"

// Armour and Shield combined, up to Medium/Large shield.
/*void ReducedASF(object oCreature, object oSkin)
{
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
    object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
    int nAC = GetBaseAC(oArmor);
    int iBonus = GetLocalInt(oSkin, "WarlockArmourCasting");
    int nASF = -1;
    itemproperty ip;

    // First thing is to remove old ASF (in case armor is changed.)
    if (iBonus != -1)
        RemoveSpecificProperty(oSkin, ITEM_PROPERTY_ARCANE_SPELL_FAILURE, -1, iBonus, 1, "WarlockArmourCasting");

    // As long as they meet the requirements, just give em max ASF reduction
    // I know it could cause problems if they have increased ASF, but thats unlikely
    if (3 >= nAC && GetBaseItemType(oShield) != BASE_ITEM_TOWERSHIELD && GetBaseItemType(oShield) != BASE_ITEM_LARGESHIELD)
        nASF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_25_PERCENT;

    // Apply the ASF to the skin.
    ip = ItemPropertyArcaneSpellFailure(nASF); 

    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oSkin);
    SetLocalInt(oSkin, "WarlockArmourCasting", nASF);
}*/

void main()
{
    object oSkin = GetPCSkin(OBJECT_SELF);
    int nClass = GetLevelByClass(CLASS_TYPE_WARLOCK);
    int nHellFire = GetLevelByClass(CLASS_TYPE_HELLFIRE_WARLOCK);
    int nTheurge = GetLevelByClass(CLASS_TYPE_ELDRITCH_THEURGE);
    int bMasterOfElements = GetHasFeat(FEAT_MASTER_OF_THE_ELEMENTS) ? IP_CONST_DAMAGERESIST_10 : 0;

    //ReducedASF(OBJECT_SELF, oSkin);

    //Reduction
    if(nClass > 2 || nTheurge)
    {
        int nRedAmt = (nClass + 1) / 4;
            nRedAmt += (nTheurge + 2) / 3;
        effect eReduction = EffectDamageReduction(nRedAmt, DAMAGE_POWER_PLUS_THREE);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eReduction), OBJECT_SELF);
    }

    if(GetHasFeat(FEAT_WARLOCK_SHADOWMASTER))
        AddSkinFeat(FEAT_WARLOCK_SHADOWMASTER_SHADES, IP_CONST_FEAT_SHADOWMASTER_SHADES, oSkin);

    if(GetHasFeat(FEAT_PARAGON_VISIONARY))
    {
        int nSkillBonus = PRCMax(2 * GetAbilityModifier(ABILITY_WISDOM, OBJECT_SELF), 6);
        effect eLink = EffectLinkEffects(EffectUltravision(), EffectSeeInvisible());
               eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SPOT, nSkillBonus));
               eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_LISTEN, nSkillBonus));
               eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SENSE_MOTIVE, nSkillBonus));
               eLink = ExtraordinaryEffect(eLink);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF);
    }

    //Energy Resistance
    int nResistAmt = nClass >= 20 ? IP_CONST_DAMAGERESIST_10 : IP_CONST_DAMAGERESIST_5;

    if(GetHasFeat(FEAT_WARLOCK_RESIST_ACID))
    {
        itemproperty ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, nResistAmt);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }
    if(GetHasFeat(FEAT_WARLOCK_RESIST_COLD))
    {
        itemproperty ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, nResistAmt);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }
    if(GetHasFeat(FEAT_WARLOCK_RESIST_ELEC))
    {
        itemproperty ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, nResistAmt);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }
    if(GetHasFeat(FEAT_WARLOCK_RESIST_SONIC))
    {
        itemproperty ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC, nResistAmt);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

    int nFireResist  = -1;
    if(GetHasFeat(FEAT_WARLOCK_RESIST_FIRE))
        nFireResist = nResistAmt;
    if(nHellFire > 1)
        nFireResist += IP_CONST_DAMAGERESIST_10;
    if(nFireResist)
    {
        itemproperty ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, nFireResist);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

    //Hellfire Warlock
    if(nHellFire)
    {
        if(GetHasInvocation(INVOKE_ELDRITCH_SPEAR))
            AddSkinFeat(FEAT_HELLFIRE_SPEAR, IP_FEAT_HELLFIRE_SPEAR, oSkin);

        if(GetHasInvocation(INVOKE_ELDRITCH_GLAIVE))
            AddSkinFeat(FEAT_HELLFIRE_GLAIVE, IP_FEAT_HELLFIRE_GLAIVE, oSkin);

        if(GetHasInvocation(INVOKE_HIDEOUS_BLOW))
            AddSkinFeat(FEAT_HELLFIRE_BLOW, IP_FEAT_HELLFIRE_BLOW, oSkin);

        if(GetHasInvocation(INVOKE_ELDRITCH_CHAIN))
            AddSkinFeat(FEAT_HELLFIRE_CHAIN, IP_FEAT_HELLFIRE_CHAIN, oSkin);

        if(GetHasInvocation(INVOKE_ELDRITCH_CONE))
            AddSkinFeat(FEAT_HELLFIRE_CONE, IP_FEAT_HELLFIRE_CONE, oSkin);

        if(GetHasInvocation(INVOKE_ELDRITCH_LINE))
            AddSkinFeat(FEAT_HELLFIRE_LINE, IP_FEAT_HELLFIRE_LINE, oSkin);

        if(GetHasInvocation(INVOKE_ELDRITCH_DOOM))
            AddSkinFeat(FEAT_HELLFIRE_DOOM, IP_FEAT_HELLFIRE_DOOM, oSkin);
    }
}