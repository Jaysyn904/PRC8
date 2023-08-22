/*
    prc_pyro

    Passive feats for pyrokineticist

    By: Flaming_Sword
    Created: Dec 6, 2007
    Modified: Dec 7, 2007
*/

#include "prc_alterations"
#include "prc_x2_itemprop"

void main()
{
    object oPC = OBJECT_SELF;
    object oTemp;
    int iClassLevel = (GetLevelByClass(CLASS_TYPE_PYROKINETICIST, oPC));
    if(iClassLevel < 1)
        return;

    int iEquip = GetLocalInt(oPC,"ONEQUIP");  //2 = equip, 1 = unequip
    int iRest = GetLocalInt(oPC,"ONREST");  //1 = rest finished
    int iEnter = GetLocalInt(oPC,"ONENTER");  //1 = entering

    /*if(iEquip == 2) //equip
    {
        if(DEBUG) DoDebug("prc_pyro: Equip event, Proficiency check for other whips");
        oTemp = GetPCItemLastEquipped();
        if(GetBaseItemType(oTemp) == BASE_ITEM_WHIP && GetTag(oTemp) != "PRC_PYRO_LASH_WHIP" && !GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC))
        {
            SendMessageToPC(oPC, "You are not proficient with exotic weapons.");
            if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == oTemp)
                ForceUnequip(oPC, oTemp, INVENTORY_SLOT_RIGHTHAND);
            else
                ForceUnequip(oPC, oTemp, INVENTORY_SLOT_LEFTHAND);
        }
    }*/
    if(iEquip == 1) //OnUnEquip - fires before item is unequipped
    {
        if(DEBUG) DoDebug("prc_pyro: Unequip event, clearing temporary itemprops, destroying lash");
        oTemp = GetPCItemLastUnequipped();
        IPRemoveAllItemProperties(oTemp, DURATION_TYPE_TEMPORARY);
        if(GetTag(oTemp) == "PRC_PYRO_LASH_WHIP")   //Fire Lash is destroyed on unequip or unacquire
            MyDestroyObject(oTemp);
    }
    object oSkin = GetPCSkin(oPC);
    int iDamageType;
    int iIPSaveType;
    int iIPDamgeType;
    int iImpactVFX;
    int iImpactBigVFX;
    int iVis;
    int iBeam;
    int iSave;
    int iBurst;
    string sString;
    if(DEBUG) DoDebug("prc_pyro: Initialisation");
    if(GetHasFeat(FEAT_PYRO_PYROKINETICIST, oPC))
    {
        iDamageType = DAMAGE_TYPE_FIRE;
        iIPSaveType = IP_CONST_SAVEVS_FIRE;
        iIPDamgeType = IP_CONST_DAMAGETYPE_FIRE;
        iImpactVFX = VFX_IMP_FLAME_S;
        iImpactBigVFX = VFX_IMP_FLAME_M;
        iVis = ITEM_VISUAL_FIRE;
        iBeam = VFX_BEAM_FIRE;
        iSave = SAVING_THROW_TYPE_FIRE;
        iBurst = VFX_FNF_FIRESTORM;
        sString = "Fire";
    }
    else if(GetHasFeat(FEAT_PYRO_CRYOKINETICIST, oPC))
    {
        iDamageType =  DAMAGE_TYPE_COLD;
        iIPSaveType = IP_CONST_SAVEVS_COLD;
        iIPDamgeType = IP_CONST_DAMAGETYPE_COLD;
        iImpactVFX = VFX_IMP_FROST_S;
        iImpactBigVFX = VFX_IMP_FROST_L;
        iVis = ITEM_VISUAL_COLD;
        iBeam = VFX_BEAM_COLD;
        iSave = SAVING_THROW_TYPE_COLD;
        iBurst = VFX_FNF_ICESTORM;
        sString = "Cold";
    }
    else if(GetHasFeat(FEAT_PYRO_SONOKINETICIST, oPC))
    {
        iDamageType =  DAMAGE_TYPE_SONIC;
        iIPSaveType = IP_CONST_SAVEVS_SONIC;
        iIPDamgeType = IP_CONST_DAMAGETYPE_SONIC;
        iImpactVFX = VFX_IMP_SONIC;
        iImpactBigVFX = VFX_IMP_SILENCE;
        iVis = ITEM_VISUAL_SONIC;
        iBeam = VFX_BEAM_MIND;
        iSave = SAVING_THROW_TYPE_SONIC;
        iBurst = VFX_FNF_SOUND_BURST;
        sString = "Sonic";
    }
    else if(GetHasFeat(FEAT_PYRO_ELECTROKINETICIST, oPC))
    {
        iDamageType =  DAMAGE_TYPE_ELECTRICAL;
        iIPSaveType = IP_CONST_SAVEVS_ELECTRICAL;
        iIPDamgeType = IP_CONST_DAMAGETYPE_ELECTRICAL;
        iImpactVFX = VFX_IMP_LIGHTNING_S;
        iImpactBigVFX = VFX_IMP_LIGHTNING_M;
        iVis = ITEM_VISUAL_ELECTRICAL;
        iBeam = VFX_BEAM_LIGHTNING;
        iSave = SAVING_THROW_TYPE_ELECTRICITY;
        iBurst = VFX_FNF_DISPEL_GREATER;
        sString = "Lightning";
    }
    else if(GetHasFeat(FEAT_PYRO_ACETOKINETICIST, oPC))
    {
        iDamageType =  DAMAGE_TYPE_ACID;
        iIPSaveType = IP_CONST_SAVEVS_ACID;
        iIPDamgeType = IP_CONST_DAMAGETYPE_ACID;
        iImpactVFX = VFX_IMP_ACID_S;
        iImpactBigVFX = VFX_IMP_ACID_L;
        iVis = ITEM_VISUAL_ACID;
        iBeam = VFX_BEAM_EVIL;
        iSave = SAVING_THROW_TYPE_ACID;
        iBurst = VFX_FNF_HORRID_WILTING;
        sString = "Acid";
    }
    else
    {
        if(DEBUG) DoDebug("prc_pyro: ERROR, character does not have element feat");
        return;
    }
    if(DEBUG) DoDebug("prc_pyro: Setting persistent local vars");
    SetPersistantLocalInt(oPC, "PyroDamageType", iDamageType);
    SetPersistantLocalInt(oPC, "PyroImpactVFX", iImpactVFX);
    SetPersistantLocalInt(oPC, "PyroImpactBigVFX", iImpactBigVFX);
    SetPersistantLocalInt(oPC, "PyroVis", iVis);
    SetPersistantLocalInt(oPC, "PyroBeam", iBeam);
    SetPersistantLocalInt(oPC, "PyroSave", iSave);
    SetPersistantLocalInt(oPC, "PyroBurst", iBurst);
    SetPersistantLocalString(oPC, "PyroString", sString);

    if(iClassLevel >= 2)
    {
        if(DEBUG) DoDebug("prc_pyro: Adding itemprops to hide");
        //Fire Adaptation
        int bFear = (iClassLevel >= 7); //Fear No Fire
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusSavingThrowVsX(iIPSaveType, bFear ? 8 : 4));
        IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(iIPDamgeType, bFear ? IP_CONST_DAMAGERESIST_20 : IP_CONST_DAMAGERESIST_10));

        if(DEBUG) DoDebug("prc_pyro: Adding itemprops to gaunts/weapons/ammo");
        //Hand Afire
        IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC), ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        if(iClassLevel >= 4)
        {   //Weapon Afire
            IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC), ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC), ItemPropertyVisualEffect(iVis), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC), ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC), ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC), ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
        if(iClassLevel >= 5 && GetLocalInt(oPC, "PRC_Pyro_Nimbus"))
        {
            if(DEBUG) DoDebug("prc_pyro: Adding itemprops to armour");
            IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC), ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
}
