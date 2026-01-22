
/*
     Script for all racial abilities / penalties that require a heartbeat check
*/

#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;
    object oArea = GetArea(oPC);
    object oSkin = GetPCSkin(oPC);

    int bHasLightSensitive = GetHasFeat(FEAT_LTSENSE, oPC);
    int bHasLightBlindness = GetHasFeat(FEAT_LTBLIND, oPC);

    if(bHasLightSensitive || bHasLightBlindness)
    {
        int bIsEffectedByLight = FALSE;

        if(GetIsObjectValid(oArea)
        && !GetHasFeat(FEAT_DAYLIGHTADAPT, oPC)
        && !GetHasFeat(FEAT_NS_LIGHT_ADAPTION, oPC)
        && GetIsDay()
        && GetIsAreaAboveGround(oArea) == AREA_ABOVEGROUND
        && !GetIsAreaInterior(oArea))
            bIsEffectedByLight = TRUE;

        // light sensitivity
        // those with lightblindess are also sensitive
        if(bIsEffectedByLight)
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazzle(), oPC, 6.5);

        // light blindness
        if(bHasLightBlindness && bIsEffectedByLight)
        {
            // on first entering bright light
            // cause blindness for 1 round
            if(!GetLocalInt(oPC, "EnteredDaylight"))
            {
                effect eBlind = EffectBlindness();
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oPC, 5.99);
                SetLocalInt(oPC, "EnteredDaylight", TRUE);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazzle(), oPC, 6.5);
            }
        }

        if(!bIsEffectedByLight && GetLocalInt(oPC, "EnteredDaylight"))
              DeleteLocalInt(oPC, "EnteredDaylight");
    }

    // imaskari underground hide bonus
    //this is in addition to the normal bonus
    if(GetHasFeat(FEAT_SA_HIDEU, oPC))
    {
        if(GetIsAreaAboveGround(oArea) == AREA_UNDERGROUND)
            SetCompositeBonus(oSkin, "SA_Hide_Underground", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
        else
            SetCompositeBonus(oSkin, "SA_Hide_Underground", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
    }

    // troglodyte underground hide bonus
    //this is in addition to the normal bonus
    if(GetHasFeat(FEAT_SA_HIDE_TROG, oPC))
    {
        if(GetIsAreaAboveGround(oArea) == AREA_UNDERGROUND)
            SetCompositeBonus(oSkin, "SA_Hide_Underground", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
        else
            SetCompositeBonus(oSkin, "SA_Hide_Underground", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
    }

    // forest gnomes bonus to hide in the woods
    //this is in addition to the normal bonus
    if(GetHasFeat(FEAT_SA_HIDEF, oPC) || GetHasFeat(FEAT_BONUS_BAMBOO, oPC))
    {
       if(GetIsAreaNatural(oArea) == AREA_NATURAL
       && GetIsAreaAboveGround(oArea) == AREA_ABOVEGROUND)
           SetCompositeBonus(oSkin, "SA_Hide_Forest", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
       else
           SetCompositeBonus(oSkin, "SA_Hide_Forest", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
    }

    // grig bonus to hide in the woods
    if(GetHasFeat(FEAT_SA_HIDEF_5, oPC))
    {
       if(GetIsAreaNatural(oArea) == AREA_NATURAL && 
          GetIsAreaAboveGround(oArea) == AREA_ABOVEGROUND)
           SetCompositeBonus(oSkin, "SA_Hide_Forest", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
       else
           SetCompositeBonus(oSkin, "SA_Hide_Forest", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
    }

    // ranger Camouflage
    if(GetHasFeat(FEAT_CAMOUFLAGE, oPC))
    {
       if(GetIsAreaNatural(oArea) == AREA_NATURAL && 
          GetIsAreaAboveGround(oArea) == AREA_ABOVEGROUND)
           SetCompositeBonus(oSkin, "Cls_Camouflage", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
       else
           SetCompositeBonus(oSkin, "Cls_Camouflage", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
    }

    //Chameleon Skin Hide bonus for Poison Dusk Lizardfolk
    //+5 to Hide if most of skin is uncovered
    if(GetHasFeat(FEAT_CHAMELEON, oPC))
    {
        if(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC) == OBJECT_INVALID)
            SetCompositeBonus(oSkin, "Chameleon", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
        else
            SetCompositeBonus(oSkin, "Chameleon", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
    }
    
    // Krinth Shadowstrike is done as interior areas, applies to melee only
    if(GetHasFeat(FEAT_SHADOWSTRIKE, oPC) && GetIsAreaInterior(oArea) && IPGetIsMeleeWeapon(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)))
    {
        effect eShadow = EffectLinkEffects(EffectAttackIncrease(1), EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_BASE_WEAPON));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eShadow), oPC, 6.0);
    }  
    
    // Treebrother WOL bonus to Hide/MS
    if(GetIsObjectValid(GetItemPossessedBy(oPC, "WOL_Treebrother")) && GetHitDice(oPC) >= 10)
    {
       if(GetIsAreaNatural(oArea) == AREA_NATURAL && GetIsAreaAboveGround(oArea) == AREA_ABOVEGROUND)
       {
           SetCompositeBonus(oSkin, "TreebrotherH",  5, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
           SetCompositeBonus(oSkin, "TreebrotherMS", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
       }   
       else
       {
           SetCompositeBonus(oSkin, "TreebrotherH",  0, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
           SetCompositeBonus(oSkin, "TreebrotherMS", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
       }
    }    
    
    // Bhuka Sandskimming hackjob
    if(GetRacialType(oPC) == RACIAL_TYPE_BHUKA && GetIsAreaNatural(oArea) == AREA_NATURAL && GetIsAreaAboveGround(oArea) == AREA_ABOVEGROUND)
    {
        effect eLook = GetFirstEffect(oPC);
        while(GetIsEffectValid(eLook))
        {
            if(GetEffectType(eLook) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
            {
                RemoveEffect(oPC, eLook);
            }
            eLook = GetNextEffect(oPC);
        }        
    } 
    
    if(GetRacialType(oPC) == RACIAL_TYPE_FROST_FOLK)
    {
        if(GetWeather(oArea) == WEATHER_SNOW)
           SetCompositeBonus(oSkin, "FrostFolkHide", 8, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
       else
           SetCompositeBonus(oSkin, "FrostFolkHide", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);      
    }    
    if(GetRacialType(oPC) == RACIAL_TYPE_ULDRA)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_COLD), oPC, 6.0);     
    }   
    if(GetRacialType(oPC) == RACIAL_TYPE_SHARAKIM)
    {
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(VersusRacialTypeEffect(EffectAttackIncrease(1), RACIAL_TYPE_HUMANOID_ORC)), oPC, 6.0);

        if(GetIsNight())
        {
           	SetCompositeBonus(oSkin, "Sharakhim_H", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
           	SetCompositeBonus(oSkin, "Sharakhim_S", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
           	SetCompositeBonus(oSkin, "Sharakhim_M", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
           	SetCompositeBonus(oSkin, "Sharakhim_R", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
        }   
       	else
       	{
           	SetCompositeBonus(oSkin, "Sharakhim_H", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
           	SetCompositeBonus(oSkin, "Sharakhim_S", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
           	SetCompositeBonus(oSkin, "Sharakhim_M", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
           	SetCompositeBonus(oSkin, "Sharakhim_R", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);    	
        }   	
    }
    // Underfolk Camo
    if(GetRacialType(oPC) == RACIAL_TYPE_UNDERFOLK)
    {
       if(GetIsAreaNatural(oArea) == AREA_NATURAL)
           SetCompositeBonus(oSkin, "Underfolk_H", 10, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
       else
           SetCompositeBonus(oSkin, "Underfolk_H", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE); // Yes, they always have a +4 minimum
    }   
    
    if (GetIsPC(oPC) == TRUE && GetPRCSwitch(PRC_CHICKEN_INFESTED) && GetLevelByClass(CLASS_TYPE_COMMONER, oPC))
    {
        MultisummonPreSummon();
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectSummonCreature("prc_chicken"), GetLocation(oPC), HoursToSeconds(GetPRCSwitch(PRC_CHICKEN_INFESTED)));
    }    
    
    if (GetRacialType(oPC) == RACIAL_TYPE_SKULK && GetActionMode(oPC, ACTION_MODE_STEALTH))
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectMovementSpeedIncrease(99)), oPC, 6.0);
		
	if (GetRacialType(oPC) == RACIAL_TYPE_HYBSIL)
	{
		if(GetIsAreaNatural(oArea) == AREA_NATURAL && GetIsAreaAboveGround(oArea) == AREA_ABOVEGROUND)
		{	
			SetCompositeBonus(oSkin, "HybsilSearch",  4, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
			SetCompositeBonus(oSkin, "HybsilDisable",  4, ITEM_PROPERTY_SKILL_BONUS, SKILL_DISABLE_TRAP);
		}
		else
		{
			SetCompositeBonus(oSkin, "HybsilSearch",  0, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
			SetCompositeBonus(oSkin, "HybsilDisable",  0, ITEM_PROPERTY_SKILL_BONUS, SKILL_DISABLE_TRAP);
		
		}
	}
	if (GetRacialType(oPC) == RACIAL_TYPE_WARFORGED || GetRacialType(oPC) == RACIAL_TYPE_WARFORGED_SCOUT && !GetHasFeat(FEAT_IMPROVED_FORTIFICATION, oPC) && !GetHasFeat(FEAT_UNARMORED_BODY, oPC))
	{
 		int bFortification = GetLocalInt(oPC, "LIGHT_FORTIFCATION_ACTIVE");
		
		if (!bFortification)
		{
			DoFortification(oPC, FORTIFICATION_LIGHT);
			SetLocalInt(oPC, "LIGHT_FORTIFCATION_ACTIVE", 1);
			if(DEBUG) DoDebug("race_hb >> DoFortification() activated.");			
		}
	}	
	if (GetRacialType(oPC) == RACIAL_TYPE_RETH_DEKALA)
	{
 		int bFortification = GetLocalInt(oPC, "MED_FORTIFCATION_ACTIVE");
		
		if (!bFortification)
		{
			DoFortification(oPC, FORTIFICATION_MEDIUM);
			SetLocalInt(oPC, "MED_FORTIFCATION_ACTIVE", 1);
			if(DEBUG) DoDebug("race_hb >> DoFortification() activated.");			
		}
	}
	if (GetRacialType(oPC) == RACIAL_TYPE_WARFORGED_CHARGER && !GetHasFeat(FEAT_IMPROVED_FORTIFICATION, oPC) && !GetHasFeat(FEAT_UNARMORED_BODY, oPC))
	{
 		int bFortification = GetLocalInt(oPC, "MOD_FORTIFCATION_ACTIVE");
		
		if (!bFortification)
		{
			DoFortification(oPC, FORTIFICATION_MODERATE);
			SetLocalInt(oPC, "MOD_FORTIFCATION_ACTIVE", 1);
			if(DEBUG) DoDebug("race_hb >> DoFortification() activated.");			
		}
	}	
	if (GetRacialType(oPC) == RACIAL_TYPE_WARFORGED || 
		GetRacialType(oPC) == RACIAL_TYPE_WARFORGED_SCOUT || 
		GetRacialType(oPC) == RACIAL_TYPE_WARFORGED_CHARGER && 
		GetHasFeat(FEAT_IMPROVED_FORTIFICATION, oPC))	
	{
 		int bFortification = GetLocalInt(oPC, "HEAVY_FORTIFCATION_ACTIVE");
		
		if (!bFortification)
		{
			DoFortification(oPC, FORTIFICATION_HEAVY);
			SetLocalInt(oPC, "HEAVY_FORTIFCATION_ACTIVE", 1);
			if(DEBUG) DoDebug("race_hb >> DoFortification() activated.");			
		}
	}		
}	 