// -----------------------------------------------------------------------------  
// Returns TRUE if the player used the last power to create a power stone  
// -----------------------------------------------------------------------------  
int CICraftCheckImprintPowerStone(object oSpellTarget, object oCaster, int nPowerID = 0)  
{  
    if(nPowerID == 0) nPowerID = PRCGetSpellId();  
  
    // -------------------------------------------------------------------------  
    // check if imprint stone feat is there  
    // -------------------------------------------------------------------------  
    if (GetHasFeat(FEAT_IMPRINT_STONE, oCaster) != TRUE) // Placeholder feat constant  
    {  
      FloatingTextStrRefOnCreature(40487, oCaster); // Item Creation Failed - Don't know how to create that type of item  
      return TRUE;  
    }  
  
    // -------------------------------------------------------------------------  
    // Check if the power is allowed to be used with Imprint Stone  
    // -------------------------------------------------------------------------  
    if (CIGetIsSpellRestrictedFromCraftFeat(nPowerID, FEAT_IMPRINT_STONE))  
    {  
        FloatingTextStrRefOnCreature(83451, oCaster); // can not be used with this feat  
        return TRUE;  
    }  
  
    // -------------------------------------------------------------------------  
    // XP/GP Cost Calculation  
    // -------------------------------------------------------------------------  
    int  nPowerLevel    = CIGetSpellInnateLevel(nPowerID,TRUE); // Using same function for power level  
    int nManifesterLevel = GetManifesterLevel(oCaster); // Placeholder function for manifester level  
    int nCost = nPowerLevel * nManifesterLevel * 25; // Power stone formula: level × manifester level × 25 gp  
  
    struct craft_cost_struct costs = GetModifiedCostsFromBase(nCost, oCaster, FEAT_IMPRINT_STONE, FALSE);  
  
    // -------------------------------------------------------------------------  
    // Does Player have enough gold?  
    // -------------------------------------------------------------------------  
    if(!GetHasGPToSpend(oCaster, costs.nGoldCost))  
    {  
        FloatingTextStrRefOnCreature(3786, oCaster); // Item Creation Failed - not enough gold!  
        return TRUE;  
    }  
  
    int nHD = GetHitDice(oCaster);  
    int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;  
    int nNewXP = GetXP(oCaster) - costs.nXPCost;  
  
    // -------------------------------------------------------------------------  
    // check for sufficient XP to cast power  
    // -------------------------------------------------------------------------  
    if (!GetHasXPToSpend(oCaster, costs.nXPCost))  
    {  
         FloatingTextStrRefOnCreature(3785, oCaster); // Item Creation Failed - Not enough XP  
         return TRUE;  
    }  
  
	//:: Warlocks & Artificers can't craft psionic items.
/*     //check power emulation  
    if(!CheckAlternativeCrafting(oCaster, nPowerID, costs))  
    {  
        FloatingTextStringOnCreature("*Crafting failed!*", oCaster, FALSE);  
        return TRUE;  
    }   */
  
    // -------------------------------------------------------------------------  
    // Here we imprint the power stone  
    // -------------------------------------------------------------------------  
    object oPowerStone = CICraftImprintPowerStone(oCaster, nPowerID); // New function to create power stone  
  
    // -------------------------------------------------------------------------  
    // Verify Results  
    // -------------------------------------------------------------------------  
    if (GetIsObjectValid(oPowerStone))  
    {  
        SetIdentified(oPowerStone,TRUE);  
        ActionPlayAnimation (ANIMATION_FIREFORGET_READ,1.0);  
        SpendXP(oCaster, costs.nXPCost);  
        SpendGP(oCaster, costs.nGoldCost);  
        DestroyObject (oSpellTarget);  
        FloatingTextStrRefOnCreature(8502, oCaster); // Item Creation successful  
  
        //advance time here (1 day per 1000 gp of base price)  
        int nTimeCost = nCost / 1000;  
        if(nTimeCost < 1) nTimeCost = 1;  
        AdvanceTimeForPlayer(oCaster, RoundsToSeconds(nTimeCost * 24 * 60)); // Convert days to rounds  
        return TRUE;  
     }  
     else  
     {  
        FloatingTextStrRefOnCreature(76417, oCaster); // Item Creation Failed  
        return TRUE;  
     }  
  
    return FALSE;  
}


/ -----------------------------------------------------------------------------  
// Create and Return a power stone with an item property  
// matching nPowerID.  
// -----------------------------------------------------------------------------  
object CICraftImprintPowerStone(object oCreator, int nPowerID)  
{  
    if (DEBUG) DoDebug("CICraftImprintPowerStone: Enter (nPowerID=" + IntToString(nPowerID) + ")");  
  
    // Keep original and compute one-step master (if subradial)  
    int nPowerOriginal = nPowerID;  
    int nPowerMaster = nPowerOriginal;  
    if (GetIsSubradialSpell(nPowerOriginal))  
    {  
        nPowerMaster = GetMasterSpellFromSubradial(nPowerOriginal);  
        if (DEBUG) DoDebug("CICraftImprintPowerStone: subradial detected original=" + IntToString(nPowerOriginal) + " master=" + IntToString(nPowerMaster));  
    }  
  
    // Prefer iprp mapping for the original, fallback to master  
    int nPropID = IPGetIPConstCastSpellFromSpellID(nPowerOriginal);  
    int nPowerUsedForIP = nPowerOriginal;  
    if (nPropID < 0)  
    {  
        if (DEBUG) DoDebug("CICraftImprintPowerStone: no iprp for original " + IntToString(nPowerOriginal) + ", trying master " + IntToString(nPowerMaster));  
        nPropID = IPGetIPConstCastSpellFromSpellID(nPowerMaster);  
        nPowerUsedForIP = nPowerMaster;  
    }  
  
    // If neither original nor master has an iprp row, we can still try templates,  
    // but most templates expect a matching iprp. Bail out now if nothing found.  
    if (nPropID < 0)  
    {  
        if (DEBUG) DoDebug("CICraftImprintPowerStone: no iprp_spells entry for original/master -> aborting");  
        FloatingTextStringOnCreature("This power cannot be imprinted (no item property mapping).", oCreator, FALSE);  
        return OBJECT_INVALID;  
    }  
  
    if (DEBUG) DoDebug("CICraftImprintPowerStone: using power " + IntToString(nPowerUsedForIP) + " (iprp row " + IntToString(nPropID) + ") for item property");  
  
    // Material component check (based on resolved iprp row)  
    string sMat = GetMaterialComponentTag(nPropID);  
    if (sMat != "")  
    {  
        object oMat = GetItemPossessedBy(oCreator, sMat);  
        if (oMat == OBJECT_INVALID)  
        {  
            FloatingTextStrRefOnCreature(83374, oCreator); // Missing material component  
            return OBJECT_INVALID;  
        }  
        else  
        {  
            DestroyObject(oMat);  
        }  
    }  
  
    // Resolve manifester class and power stone template  
    int nClass = PRCGetLastSpellCastClass(); // Using same function for power manifestation class  
    string sClass = "";  
    switch (nClass)  
    {  
        case CLASS_TYPE_PSION:      		sClass = "Psion"; break;  
        case CLASS_TYPE_PSYCHIC_WARRIOR:	sClass = "PsychicWarrior"; break;  
        case CLASS_TYPE_WILDER:     		sClass = "Wilder"; break;  
    }  
  
    object oTarget = OBJECT_INVALID;  
    string sResRef = "";  
  
    // Try to find a class-specific power stone template  
    if (sClass != "")  
    {  
        // Try original first (so if you made a subradial-specific template it will be used)  
        sResRef = Get2DACache("des_crft_pwstone", sClass, nPowerOriginal);  
        if (sResRef == "")  
        {  
            // fallback to the power that matched an iprp row (master or original)  
            sResRef = Get2DACache("des_crft_pwstone", sClass, nPowerUsedForIP);  
        }  
        if (sResRef != "")  
        {  
            oTarget = CreateItemOnObject(sResRef, oCreator);  
            if (DEBUG) DoDebug("CICraftImprintPowerStone: created template " + sResRef + " for class " + sClass);  
            // Ensure template uses the correct cast-spell property: replace the template's cast-spell IP with ours  
            if (oTarget != OBJECT_INVALID)  
            {  
                itemproperty ipIter = GetFirstItemProperty(oTarget);  
                while (GetIsItemPropertyValid(ipIter))  
                {  
                    if (GetItemPropertyType(ipIter) == ITEM_PROPERTY_CAST_SPELL)  
                    {  
                        RemoveItemProperty(oTarget, ipIter);  
                        break;  
                    }  
                    ipIter = GetNextItemProperty(oTarget);  
                }  
                itemproperty ipPower = ItemPropertyCastSpell(nPropID, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE);  
                AddItemProperty(DURATION_TYPE_PERMANENT, ipPower, oTarget);  
            }  
        }  
    }  
  
    // If no template or sClass was empty, create generic power stone and add itemprop.  
    if (oTarget == OBJECT_INVALID)  
    {  
        sResRef = "craft_powerstone";  
        oTarget = CreateItemOnObject(sResRef, oCreator);  
        if (oTarget == OBJECT_INVALID)  
        {  
            WriteTimestampedLogEntry("CICraftImprintPowerStone: failed to create craft_powerstone template.");  
            return OBJECT_INVALID;  
        }  
        // Remove existing default IP and add correct one  
        itemproperty ipFirst = GetFirstItemProperty(oTarget);  
        if (GetIsItemPropertyValid(ipFirst))  
            RemoveItemProperty(oTarget, ipFirst);  
  
        itemproperty ipPower = ItemPropertyCastSpell(nPropID, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE);  
        AddItemProperty(DURATION_TYPE_PERMANENT, ipPower, oTarget);  
    }  
  
    // Add PRC metadata (use the same power that matched the iprp row so metadata and IP line up)  
    if (GetPRCSwitch(PRC_SCRIBE_SCROLL_CASTER_LEVEL)) // Reusing same switch for power stones  
    {  
        int nManifesterLevel = GetManifesterLevel(oCreator); // Placeholder function  
        itemproperty ipLevel = ItemPropertyCastSpellCasterLevel(nPowerUsedForIP, nManifesterLevel);  
        AddItemProperty(DURATION_TYPE_PERMANENT, ipLevel, oTarget);  
  
        itemproperty ipMeta = ItemPropertyCastSpellMetamagic(nPowerUsedForIP, PRCGetMetaMagicFeat());  
        AddItemProperty(DURATION_TYPE_PERMANENT, ipMeta, oTarget);  
  
        int nDC = PRCGetSpellSaveDC(nPowerUsedForIP, GetSpellSchool(nPowerUsedForIP), OBJECT_SELF);  
        itemproperty ipDC = ItemPropertyCastSpellDC(nPowerUsedForIP, nDC);  
        AddItemProperty(DURATION_TYPE_PERMANENT, ipDC, oTarget);  
    }  
  
    if (oTarget == OBJECT_INVALID)  
    {  
        WriteTimestampedLogEntry("prc_x2_craft::CICraftImprintPowerStone failed - Resref: " + sResRef + " Class: " + sClass + "(" + IntToString(nClass) + ") " + " PowerID " + IntToString(nPowerID));  
        return OBJECT_INVALID;  
    }  
  
    if (DEBUG) DoDebug("CICraftImprintPowerStone: Success - created power stone " + sResRef + " for power " + IntToString(nPowerUsedForIP));  
    return oTarget;  
}