//::////////////////////////////////////////////////////////  
//:: Body Fuel  
//:: psi_ft_bodyfuel.nss  
//:://////////////////////////////////////////////////////// 
/*  
    Body Fuel (Expanded Psionics Handbook, p. 41)

	[Psionic]

	You can expand your power point total at the 
	expense of your health.
	
	Prerequisite

	Benefit

	You can recover 2 power points by taking 1 point of 
	ability burn damage (see page 67) to each of your three 
	ability scores: Strength, Dexterity, and Constitution. 
	You can recover additional power points for a 
	proportional cost; for example, you could choose to 
	recover 6 power points by taking 3 points of ability 
	burn damage to Strength, Dexterity, and Constitution. 
	These recovered points are added to your power point 
	reserve as if you had gained them by resting overnight.
	Special

	Only living creatures can use this feat. You can take 
	advantage of this feat only while in your own body (if 
	you are under the effect of mind switch or metamorph, 
	for example, you gain no benefit).
 
*/  
//:://////////////////////////////////////////////  
#include "psi_inc_ppoints"  

// The item-property penalty does not alter GetAbilityScore(..., TRUE).
// Check both the burn ledger and the effective score: a stale skin or a
// temporary ability bonus must not buy additional uses with unpaid health.
int BodyFuelCanBurn(object oPC, int nAbility)
{
    return GetAbilityScore(oPC, nAbility) > 3
        && GetAbilityScore(oPC, nAbility, TRUE)
            - GetUnHealableAbilityDamage(oPC, nAbility) > 3;
}

string BodyFuelAbilityKey(int nAbility)
{
    if(nAbility == ABILITY_STRENGTH) return "PRC_UbHealableAbilityDamage_STR";
    if(nAbility == ABILITY_DEXTERITY) return "PRC_UbHealableAbilityDamage_DEX";
    return "PRC_UbHealableAbilityDamage_CON";
}

void BodyFuelFinish(object oPC, object oSkin, int nGeneration, int nScrubGeneration)
{
    if(!GetIsObjectValid(oPC)
        || GetLocalInt(oPC, "BodyFuel_Generation") != nGeneration) return;
    int nBusyUntil = GetLocalInt(oPC, "BodyFuel_BusyUntil");
    DeleteLocalInt(oPC, "BodyFuel_BusyUntil");
    int bPaid = GetIsObjectValid(oSkin)
        && nBusyUntil > GetCurrentUnixTimestamp()
        && GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC) == oSkin
        && GetLocalInt(oPC, "PRC_ScrubPCSkin_Generation") == nScrubGeneration
        && !GetLocalInt(oPC, "ONREST")
        && !GetIsDead(oPC);
    int nAbility;
    for(nAbility = 0; nAbility < 3; nAbility++)
    {
        string sKey = "BodyFuel_Expected_" + IntToString(nAbility);
        int nExpected = GetLocalInt(oPC, sKey);
        int nCount = 0;
        int nTotal = 0;
        itemproperty ip = GetFirstItemProperty(oSkin);
        while(GetIsItemPropertyValid(ip))
        {
            if(GetItemPropertyType(ip) == ITEM_PROPERTY_DECREASED_ABILITY_SCORE
                && GetItemPropertySubType(ip) == nAbility)
            {
                nCount++;
                nTotal += GetItemPropertyCostTableValue(ip);
            }
            ip = GetNextItemProperty(oSkin);
        }
        if(GetUnHealableAbilityDamage(oPC, nAbility) != nExpected
            || GetLocalInt(oSkin, BodyFuelAbilityKey(nAbility)) != nExpected
            || nCount != 1 || nTotal != GetLocalInt(oPC, sKey + "_Total")
            || GetAbilityScore(oPC, nAbility) != GetLocalInt(oPC, sKey + "_Score"))
            bPaid = FALSE;
    }
    if(!bPaid)
    {
        WriteTimestampedLogEntry("Body Fuel: penalty update interrupted; no power points granted to " + GetName(oPC));
        FloatingTextStringOnCreature("Body Fuel's ability burn was interrupted; no power points were gained. Rest before trying again.", oPC, FALSE);
        return;
    }
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE_RED);
    eVis = EffectLinkEffects(eVis, EffectVisualEffect(VFX_IMP_HEALING_S));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    GainPowerPoints(oPC, 2);
    FloatingTextStringOnCreature("You burn your body's vitality to fuel your mind, gaining 2 power points.", oPC, FALSE);
}
  
void main()  
{  
    object oPC = OBJECT_SELF;  

    // The short lock serializes casts until their delayed penalties settle.
    // Wall-clock expiry avoids a saved local permanently locking out a PC
    // whose pending callback was discarded by logout.
    int nNow = GetCurrentUnixTimestamp();
    if(nNow <= 0 || GetLocalInt(oPC, "BodyFuel_BusyUntil") > nNow
        || GetLocalInt(oPC, "ONREST")) return;
  
    if(!PRCGetIsAliveCreature(oPC))  
    {  
        FloatingTextStringOnCreature("Only living creatures can use Body Fuel.", oPC, FALSE);  
        return;  
    }  
  
    if(GetIsPolyMorphedOrShifted(oPC))  
    {  
        FloatingTextStringOnCreature("You cannot use Body Fuel while polymorphed or shifted.", oPC, FALSE);  
        return;  
    }  
  
    if(GetCurrentPowerPoints(oPC) >= GetMaximumPowerPoints(oPC))  
    {  
        FloatingTextStringOnCreature("You already have a full reserve of Power Points.", oPC, FALSE);  
        return;  
    }  
  
    if(!BodyFuelCanBurn(oPC, ABILITY_STRENGTH) ||
       !BodyFuelCanBurn(oPC, ABILITY_DEXTERITY) ||
       !BodyFuelCanBurn(oPC, ABILITY_CONSTITUTION))
    {  
        FloatingTextStringOnCreature("Your Strength, Dexterity, or Constitution is too low (3 or less) to safely use Body Fuel.", oPC, FALSE);  
        return;  
    }  
  
    // Mirror ApplyAbilityDamage()'s guard clauses so Body Fuel cancels outright  
    // rather than silently reducing/blocking burn while still paying out PP.  
    if(GetIsImmune(oPC, IMMUNITY_TYPE_ABILITY_DECREASE))  
    {  
        FloatingTextStringOnCreature("You are immune to ability decrease and cannot use Body Fuel.", oPC, FALSE);  
        return;  
    }  
  
    if(GetLocalInt(oPC, "IncarnumDefenseCE"))  
    {  
        FloatingTextStringOnCreature("Your Incarnum Defense protects your Strength, blocking Body Fuel.", oPC, FALSE);  
        return;  
    }  
  
    if(GetIsMeldBound(oPC, MELD_VITALITY_BELT) == CHAKRA_WAIST || GetIsMeldBound(oPC, MELD_VITALITY_BELT) == CHAKRA_DOUBLE_WAIST)  
    {  
        FloatingTextStringOnCreature("Your bound Vitality Belt protects your Constitution, blocking Body Fuel.", oPC, FALSE);  
        return;  
    }  
  
    if(GetHasSpellEffect(MELD_STRONGHEART_VEST, oPC) ||  
       GetIsMeldBound(oPC, MELD_STRONGHEART_VEST) == CHAKRA_WAIST || GetIsMeldBound(oPC, MELD_STRONGHEART_VEST) == CHAKRA_DOUBLE_WAIST)  
    {  
        FloatingTextStringOnCreature("Your Strongheart Vest reduces ability damage/drain, blocking Body Fuel.", oPC, FALSE);  
        return;  
    }  

	if(DEBUG) DoDebug("psi_ft_bodyfuel: Firing Body Fuel  //////////////////////////////////////////////////////////////////////////////");
	if(DEBUG) DoDebug("/////////////////////////////////////////////////////////////////////////////////////////////////////////////////");
		
    int nBurnPerAbility = 1;  
    int nOldSTR = GetUnHealableAbilityDamage(oPC, ABILITY_STRENGTH);
    int nOldDEX = GetUnHealableAbilityDamage(oPC, ABILITY_DEXTERITY);
    int nOldCON = GetUnHealableAbilityDamage(oPC, ABILITY_CONSTITUTION);
    object oSkin = GetPCSkin(oPC);
    if(!GetIsObjectValid(oSkin)) return;
    // A discarded callback may leave recorded burn without its property.
    // Refuse further spending until normal skin rebuilding restores it.
    int nAbility;
    for(nAbility = 0; nAbility < 3; nAbility++)
    {
        BFRetireStalePenalty(oSkin, nAbility);
        int nTotal = 0;
        itemproperty ip = GetFirstItemProperty(oSkin);
        while(GetIsItemPropertyValid(ip))
        {
            if(GetItemPropertyType(ip) == ITEM_PROPERTY_DECREASED_ABILITY_SCORE
                && GetItemPropertySubType(ip) == nAbility)
                nTotal += GetItemPropertyCostTableValue(ip);
            ip = GetNextItemProperty(oSkin);
        }
        int nBurn = GetUnHealableAbilityDamage(oPC, nAbility);
        if(nTotal >= 50)
        {
            FloatingTextStringOnCreature("Your existing ability penalties cannot accept more Body Fuel burn.", oPC, FALSE);
            return;
        }
        if(GetLocalInt(oSkin, "PRC_BFDec_" + IntToString(nAbility) + "_Pending")
            || GetLocalInt(oSkin, BodyFuelAbilityKey(nAbility)) != nBurn
            || nTotal < nBurn)
        {
            FloatingTextStringOnCreature("Your ability burn is still settling. Rest before trying Body Fuel again.", oPC, FALSE);
            return;
        }
    }
    int nGeneration = GetLocalInt(oPC, "BodyFuel_Generation") + 1;
    SetLocalInt(oPC, "BodyFuel_Generation", nGeneration);
    SetLocalInt(oPC, "BodyFuel_BusyUntil", nNow + 3);
    for(nAbility = 0; nAbility < 3; nAbility++)
    {
        string sKey = "BodyFuel_Expected_" + IntToString(nAbility);
        SetLocalInt(oPC, sKey, GetUnHealableAbilityDamage(oPC, nAbility) + 1);
        SetLocalInt(oPC, sKey + "_Score", GetAbilityScore(oPC, nAbility) - 1);
    }
  
    // Apply ability burn to STR, DEX, CON  
	if(GetPRCSwitch(PRC_ABILITY_BURN_HEAL_ON_REST))  
	{  
		// Rest-based healing: RestFinished() handles recovery, so apply as permanent  
		ApplyAbilityDamage(oPC, ABILITY_STRENGTH,     nBurnPerAbility, DURATION_TYPE_PERMANENT, FALSE);  
		ApplyAbilityDamage(oPC, ABILITY_DEXTERITY,    nBurnPerAbility, DURATION_TYPE_PERMANENT, FALSE);  
		ApplyAbilityDamage(oPC, ABILITY_CONSTITUTION, nBurnPerAbility, DURATION_TYPE_PERMANENT, FALSE);
	}  
	else  
	{  
		// Real-time healing: let ApplyAbilityDamage schedule its own 24h/point recovery  
		ApplyAbilityDamage(oPC, ABILITY_STRENGTH,     nBurnPerAbility, DURATION_TYPE_TEMPORARY, FALSE, -1.0f);  
		ApplyAbilityDamage(oPC, ABILITY_DEXTERITY,    nBurnPerAbility, DURATION_TYPE_TEMPORARY, FALSE, -1.0f);  
		ApplyAbilityDamage(oPC, ABILITY_CONSTITUTION, nBurnPerAbility, DURATION_TYPE_TEMPORARY, FALSE, -1.0f);  
	}  
  
    // ApplyAbilityDamage is void; do not pay PP unless all three costs landed.
    // Do not refund here: the temporary path already scheduled recovery.
    if(GetUnHealableAbilityDamage(oPC, ABILITY_STRENGTH) != nOldSTR + 1
        || GetUnHealableAbilityDamage(oPC, ABILITY_DEXTERITY) != nOldDEX + 1
        || GetUnHealableAbilityDamage(oPC, ABILITY_CONSTITUTION) != nOldCON + 1)
    {
        DeleteLocalInt(oPC, "BodyFuel_BusyUntil");
        WriteTimestampedLogEntry("Body Fuel: incomplete ability-burn payment; no power points granted to " + GetName(oPC));
        FloatingTextStringOnCreature("Body Fuel could not apply its full ability burn; no power points were gained.", oPC, FALSE);
        return;
    }

    for(nAbility = 0; nAbility < 3; nAbility++)
        SetLocalInt(oPC, "BodyFuel_Expected_" + IntToString(nAbility) + "_Total",
            GetLocalInt(oSkin, "PRC_BFDec_" + IntToString(nAbility) + "_Total"));
    int nScrubGeneration = GetLocalInt(oPC, "PRC_ScrubPCSkin_Generation");
    DelayCommand(0.3f, BodyFuelFinish(oPC, oSkin, nGeneration, nScrubGeneration));
}
