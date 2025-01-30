//:://////////////////////////////////////////////
//:: Switch-based speed alterations
//:: prc_speed
//:://////////////////////////////////////////////
/** @file
    A script called from EvalPRCFeats() that
    applies optional speed modifications.

     - Racial speed
     - Medium or heavier armor speed reduction
     - Removal of PC speed advantage
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    //get the object thats going to apply the effect
    //this strips previous effects too
    object oWP = GetObjectToApplyNewEffect("WP_SpeedEffect", oPC, TRUE);
    
    // This applies fast travel when the PC is in safe areas
    if (GetPRCSwitch(PRC_FAST_TRAVEL_SPEED) && !GetIsInCombat(oPC) && GetIsObjectValid(GetAreaFromLocation(GetLocation(oPC))))
    {
    	AssignCommand(oWP, ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectMovementSpeedIncrease(99)), oPC)));
    	AddEventScript(oPC, EVENT_ONHEARTBEAT, "prc_speed", TRUE, FALSE);
    	return;
    }
    else if (!GetPRCSwitch(PRC_FAST_TRAVEL_SPEED))
    	RemoveEventScript(oPC, EVENT_ONHEARTBEAT, "prc_speed", TRUE, FALSE);

    // Load current speed as determined by previous iterations. Or in case of first iteration, hardcoded to 30
    int nCurrentSpeed = GetLocalInt(oPC, "PRC_SwitchbasedSpeed");
    if(!nCurrentSpeed)
        nCurrentSpeed = 30;

    //30feet is the default speed
    //rather than try to fudge around biowares differences
    //Ill just scale relative to that
    int nNewSpeed = 30;

    // See if we should alter speed based on race
    if(GetPRCSwitch(PRC_PNP_RACIAL_SPEED))
    {
        nNewSpeed = StringToInt(Get2DACache("racialtypes", "Endurance", GetRacialType(oPC)));

        // Some races do not have speed listed, in that case default to current
        if(!nNewSpeed)
            nNewSpeed = 30;
            
        if (DEBUG) DoDebug("Racial Speed equals: "+IntToString(nNewSpeed));            
    }
    
    // Adds a 5 foot boost to speed when 10th level or up
    object oWOL = GetItemPossessedBy(oPC, "WOL_WargirdsArmor");    
    if (GetIsObjectValid(oWOL) && GetHitDice(oPC) >= 10 && GetHasFeat(FEAT_LEAST_LEGACY, oPC)) nNewSpeed += 5;
    // Adds a 5 foot boost to speed when 10th level or up
    oWOL = GetItemPossessedBy(oPC, "BowoftheBlackArcher");    
    if (GetIsObjectValid(oWOL) && GetHitDice(oPC) >= 18 && GetHasFeat(FEAT_GREATER_LEGACY, oPC)) nNewSpeed += 10;
    // Adds a 5 foot boost to speed when 10th level or up
    oWOL = GetItemPossessedBy(oPC, "WOL_Ur");    
    if (GetIsObjectValid(oWOL) && GetHitDice(oPC) >= 6 && GetHasFeat(FEAT_LEAST_LEGACY, oPC)) nNewSpeed += 5;    
    if (GetIsObjectValid(oWOL) && GetHitDice(oPC) >= 11 && GetHasFeat(FEAT_LESSER_LEGACY, oPC)) nNewSpeed += 5; 
    // Adds a 10 foot boost to speed when 11th level or up
    oWOL = GetItemPossessedBy(oPC, "WOL_Treebrother");    
    if (GetIsObjectValid(oWOL) && GetHitDice(oPC) >= 11 && GetHasFeat(FEAT_LESSER_LEGACY, oPC)) nNewSpeed += 10; 
    // Adds a 10 foot boost to speed when 11th level or up
    oWOL = GetItemPossessedBy(oPC, "WOL_Arik");    
    if (GetIsObjectValid(oWOL) && GetHitDice(oPC) >= 10 && GetHasFeat(FEAT_LEAST_LEGACY, oPC)) nNewSpeed += 10;     
    // Adds a 5 foot boost per point of essentia invested
    if(GetEssentiaInvested(oPC, MELD_CERULEAN_SANDALS)) nNewSpeed += (5 * GetEssentiaInvested(oPC, MELD_CERULEAN_SANDALS));
    // Adds a 60 foot boost 
    if (GetLocalInt(oPC, "DreadCarapaceTimer")) nNewSpeed += 60; 
    // 30 foot boost
    if (GetLocalInt(oPC, "IncarnateAvatarSpeed")) nNewSpeed += 30; 
    // 10 foot boost
    if (GetLocalInt(oPC, "LamiaBeltSpeed")) nNewSpeed += 10;    
    // Adds a 5 foot boost per point of essentia invested, plus 5
    if (GetLocalInt(oPC, "WorgPeltSpeed")) nNewSpeed += GetLocalInt(oPC, "WorgPeltSpeed");
	// 10 foot boost
    if (GetLocalInt(oPC, "AstralVambraces") == 2) nNewSpeed += 10; 
	// 10 foot boost
    if (GetLocalInt(oPC, "DesharisSpeed")) nNewSpeed += 10;     
	// Adds a 10 foot boost per point
    if (GetLocalInt(oPC, "SpeedFromPain")) nNewSpeed += GetLocalInt(oPC, "SpeedFromPain") * 10;
    
    // Binding content
    if (GetLevelByClass(CLASS_TYPE_BINDER, oPC) || GetHasFeat(FEAT_PRACTICED_BINDER, oPC))
    {
    	if (GetHasSpellEffect(VESTIGE_RONOVE, oPC) && GetLocalInt(oPC, "ExploitVestige") != VESTIGE_RONOVE_SPRINT) nNewSpeed += 10; 
    }
    
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);    
    //in an onunequip event the armor is still in the slot
    if(GetItemLastUnequipped() == oArmor && GetLocalInt(oPC, "ONEQUIP") == 1)
        oArmor = OBJECT_INVALID;
    int nArmorType = GetArmorType(oArmor);    
        
    // Adds a 5 foot boost per point of essentia invested
    if(GetEssentiaInvested(oPC, MELD_DUSKLING_SPEED) && nArmorType == ARMOR_TYPE_LIGHT) nNewSpeed += (5 * GetEssentiaInvested(oPC, MELD_DUSKLING_SPEED));    
    
    // See if we should remove PC speed advantage
    if(GetPRCSwitch(PRC_REMOVE_PLAYER_SPEED) &&
       (GetIsPC(oPC) || GetMovementRate(oPC) == 0)
       )
    {
        //PCs move at 4.0 NPC "normal" is 3.5
        nNewSpeed = FloatToInt(IntToFloat(nNewSpeed) * (3.5 / 4.0));
        if (DEBUG) DoDebug("Player Speed equals: "+IntToString(nNewSpeed));
    }    


    // See if we should alter speed based on armor. Dwarves ignore this, as does Wargird's Armor, and the Aym Vestige, and Wildren race
    int nAym = FALSE;
    if (GetLocalInt(oPC, "ExploitVestige") != VESTIGE_AYM_DWARVEN_STEP && GetHasSpellEffect(VESTIGE_AYM, oPC)) nAym = TRUE;
    if(GetPRCSwitch(PRC_PNP_ARMOR_SPEED) && MyPRCGetRacialType(oPC) != RACIAL_TYPE_DWARF && oArmor != oWOL && !nAym && GetRacialType(oPC) != RACIAL_TYPE_WILDREN)
    {
        int nCoc = (GetLevelByClass(CLASS_TYPE_COC, oPC));
        int nKnight = (GetLevelByClass(CLASS_TYPE_KNIGHT, oPC));
        if(nArmorType == ARMOR_TYPE_MEDIUM && nCoc < 5 && nKnight < 4)
            nNewSpeed = FloatToInt(IntToFloat(nNewSpeed) * 0.75);
        else if(nArmorType == ARMOR_TYPE_HEAVY && nCoc < 5 && nKnight < 9)
            nNewSpeed = FloatToInt(IntToFloat(nNewSpeed) * 0.666);
            
        if (DEBUG) DoDebug("Armor Speed equals: "+IntToString(nNewSpeed));            
    }

    // In case of no changes
    if(nNewSpeed == nCurrentSpeed)
        return;

    // Only apply the modification in case the PC is in a valid area. Invalid area means log(in|out)
    if(!GetIsObjectValid(GetAreaFromLocation(GetLocation(oPC))))
        return;

    // Store new speed for future checks
    SetLocalInt(oPC, "PRC_SwitchbasedSpeed", nNewSpeed);

    // Determine speed change
    float fSpeedChange = (IntToFloat(nNewSpeed) / 30) - 1.0;
    if(DEBUG) DoDebug("prc_speed: NewSpeed = " + IntToString(nNewSpeed) + "; OldSpeed = " + IntToString(nCurrentSpeed) + "; SpeedChange = " + FloatToString(fSpeedChange));
    if(DEBUG) DoDebug("GetMovementRate() = " + IntToString(GetMovementRate(oPC)));
    if(DEBUG) DoDebug("Speed Change equals: "+FloatToString(fSpeedChange));

    // Speed increase
    if(fSpeedChange > 0.0)
    {
        int nChange = PRCMin(99, PRCMax(0, FloatToInt(fSpeedChange * 100.0)));
        if(DEBUG) DoDebug("prc_speed: Applying an increase in speed: " + IntToString(nChange));
        AssignCommand(oWP, ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectMovementSpeedIncrease(nChange)), oPC)));
    }
    // Speed decrease
    else if(fSpeedChange < 0.0)
    {
        int nChange = PRCMin(99, PRCMax(0, FloatToInt(-fSpeedChange * 100.0)));
        if(DEBUG) DoDebug("prc_speed: Applying an decrease in speed: " + IntToString(nChange));
        AssignCommand(oWP, ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectMovementSpeedDecrease(nChange)), oPC)));
        //ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectMovementSpeedDecrease(nChange)), oPC)
    }
}