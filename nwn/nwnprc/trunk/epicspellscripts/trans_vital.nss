#include "inc_nwnx_funcs"
#include "inc_item_props"
#include "prc_x2_itemprop"
// x - moved to prc_feats.nss

/* void main()
{
    //:: Declare major variables
    object oTarget = OBJECT_SELF;
    object oSkin   = GetPCSkin(oTarget);

    int bNWNxEE  	= GetPRCSwitch(PRC_NWNXEE_ENABLED);
	int bPRCx		= GetPRCSwitch(PRC_PRCX_ENABLED);
	
    int bApplied 	= GetPersistantLocalInt(oTarget, "NWNX_TransVital");

    if (DEBUG)
        DoDebug("TransVital: start | NWNxEE=" + IntToString(bNWNxEE)
              + " Applied=" + IntToString(bApplied));

    //:: Set Immunities
    itemproperty ipDis = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE);
    itemproperty ipPoi = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON);

    IPSafeAddItemProperty(oSkin, ipDis, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE);
    IPSafeAddItemProperty(oSkin, ipPoi, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE);

    //:: Set Regeneration
    SetCompositeBonus(oSkin, "TransVitalRegen", 1, ITEM_PROPERTY_REGENERATION);

    //:: No stacking
    if (bApplied)
    {
        if (DEBUG)
            DoDebug("TransVital: already applied, exiting");
        return;
    }

    SetPersistantLocalInt(oTarget, "NWNX_TransVital", 1);

    //:: NWNxEE
    if (bNWNxEE & bPRCx)
    {
        if (DEBUG)
            DoDebug("TransVital: dispatching NWNxEE shim prcx_trans_vital");

        // Fire external NWNxEE-only script
        ExecuteScript("prcx_trans_vital", oTarget);
    }
    //:: Vanilla NWN
    else
    {
        if (DEBUG)
            DoDebug("TransVital: applying vanilla composite CON bonus");

        SetCompositeBonus(oSkin, "TransVitalCon", 5, ITEM_PROPERTY_ABILITY_BONUS, ABILITY_CONSTITUTION);
    }
} */


void main()
{
    //Declare major variables
    object oTarget = OBJECT_SELF;
    object oSkin = GetPCSkin(oTarget);
	
    int nNWNxEE 	= GetPRCSwitch(PRC_NWNXEE_ENABLED);
	int nPRCX 		= GetPRCSwitch(PRC_PRCX_ENABLED);
	int bFuncs 		= (nNWNxEE && nPRCX);
    int iTest 		= GetPersistantLocalInt(oTarget, "NWNX_TransVital");

    //itemproperty ipCON = ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 5);
    itemproperty ipDis = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE);
    itemproperty ipPoi = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON);
    //itemproperty ipReg = ItemPropertyRegeneration(1);

    IPSafeAddItemProperty(oSkin, ipDis, 0.0f,
        X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE);
    IPSafeAddItemProperty(oSkin, ipPoi, 0.0f,
        X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE);
    //IPSafeAddItemProperty(oSkin, ipReg, 0.0f,
    //    X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE);
    SetCompositeBonus(oSkin, "TransVitalRegen", 1, ITEM_PROPERTY_REGENERATION);
    //constitution bonus
    if(bFuncs && !iTest)
    {
        SetPersistantLocalInt(oTarget, "NWNX_TransVital", 1);
        PRC_Funcs_ModAbilityScore(oTarget, ABILITY_CONSTITUTION, 5);
    }
    else if(!bFuncs && !iTest)
        SetCompositeBonus(oSkin, "TransVitalCon", 5, ITEM_PROPERTY_ABILITY_BONUS, ABILITY_CONSTITUTION);
}

