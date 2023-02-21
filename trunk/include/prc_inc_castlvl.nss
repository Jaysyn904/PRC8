

/**
 *  @file
 *
 * This file contains PRCGetCasterLevel() and all its accessory functions.
 * Functions that modify caster level go in this include. Keep out irrelevent
 * functions. If this ends up like prc_inc_spells, you get slapped.
 */

//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

/**
 * Returns the caster level when used in spells.  You can use PRCGetCasterLevel()
 * to determine a caster level from within a true spell script.  In spell-like-
 * abilities & items, it will only return GetCasterLevel.
 *
 * @param oCaster   The creature casting the spell.
 *
 * @return          The caster level the spell was cast at.
 */
int PRCGetCasterLevel(object oCaster = OBJECT_SELF);

/**
 * A lookup for caster level progression for divine and arcane base classes
 * @return an int that can be used in caster level calculations note: these use int division
 */
int GetCasterLevelModifier(int nClass);

/**
 * To override for custom spellcasting classes. Looks for the
 * local int "PRC_CASTERCLASS_OVERRIDE" on oCaster. If set,
 * this is used as the casting class, else GetLastSpellCastClass()
 * is used.
 *
 * @param oCaster   The creature that last cast a spell
 *
 * @return          The class used to cast the spell.
 */
int PRCGetLastSpellCastClass(object oCaster = OBJECT_SELF);

/**
 * Returns if the given class is an arcane class.
 *
 * Arcane base classes are *hardcoded* into here, so new arcane
 * base classes need adding to this function.
 * Note: PrCs with their own spellbook eg. assassin count as base casters for this function
 *
 * @param oCaster   The creature to check (outsiders can have sorc caster levels)
 *
 * @return          TRUE if nClass is an arcane spellcasting class, FALSE otherwise
 */
int GetIsArcaneClass(int nClass, object oCaster = OBJECT_SELF);

/**
 * Returns if the given class is an arcane class.
 *
 * Divine base classes are *hardcoded* into here, so new divine
 * base classes need adding to this function.
 * Note: PrCs with their own spellbook eg. blackguard count as base casters for this function
 *
 * @param oCaster   The creature to check (not currently used)
 *
 * @return      TRUE if nClass is a divine spellcasting class, FALSE otherwise
 */
int GetIsDivineClass(int nClass, object oCaster = OBJECT_SELF);

// Returns the best "natural" arcane levels of the PC in question.  Does not
// consider feats that situationally adjust caster level.
int GetLevelByTypeArcane(object oCaster = OBJECT_SELF);

// Returns the best "natural" divine levels of the PC in question.  Does not
// consider feats that situationally adjust caster level.
int GetLevelByTypeDivine(object oCaster = OBJECT_SELF);

/**
 * Works out the total arcane caster levels from arcane PrCs.
 *
 * Arcane prestige classes are *hardcoded* into this function, so new arcane caster
 * classes need adding to it. Rakshasa RHD count as sorc PrC levels if they also have some levels in sorc
 * note: PrCs with their own spellbook eg. assassin are not PrCs for this function
 *
 * @param oCaster   The creature to check
 * @param nCastingClass   Casting class, only ever used for UM
 *
 * @return          Number of arcane caster levels contributed by PrCs.
 */
int GetArcanePRCLevels(object oCaster, int nCastingClass = CLASS_TYPE_INVALID);

/**
 * Works out the total divine caster levels from arcane PrCs.
 *
 * Divine prestige classes are *hardcoded* into this function, so new divine caster
 * classes need adding to it.
 * note: PrCs with their own spellbook eg. blackguard are not PrCs for this function
 *
 * @param oCaster   The creature to check
 *
 * @return          Number of divine caster levels contributed by PrCs.
 */
int GetDivinePRCLevels(object oCaster);

/**
 * Gets the position of the first arcane base class.
 *
 * @param oCaster   The creature to check
 *
 * @return          The position (1,2 or 3) of the first arcane *base* class of oCaster
 */
int GetFirstArcaneClassPosition(object oCaster = OBJECT_SELF);

/**
 * Gets the position of the first divine base class.
 *
 * @param oCaster   The creature to check
 *
 * @return          The position (1,2 or 3) of the first divine *base* class of oCaster
 */
int GetFirstDivineClassPosition(object oCaster = OBJECT_SELF);

/**
 * Gets the highest or first (by position) *base* arcane class type or,
 * if oCaster has no arcane class levels, returns CLASS_TYPE_INVALID.
 *
 * This will get rakshasa RHD 'class' if oCaster doesn't have sorc levels.
 *
 * @param oCaster   The creature to check
 *
 * @return          CLASS_TYPE_* of first base arcane class or CLASS_TYPE_INVALID
 */
int GetPrimaryArcaneClass(object oCaster = OBJECT_SELF);

/**
 * Gets the highest first (by position) *base* divine class type or,
 * if oCaster has no divine class levels, returns CLASS_TYPE_INVALID.
 *
 * @param oCaster   The creature to check
 *
 * @return          CLASS_TYPE_* of first base divine class or CLASS_TYPE_INVALID
 */
int GetPrimaryDivineClass(object oCaster = OBJECT_SELF);

/**
 * Gets the highest *base* arcane or divine class type or,
 * if oCaster has no spellcasting class levels, returns CLASS_TYPE_INVALID.
 *
 * @param oCaster   The creature to check
 *
 * @return          CLASS_TYPE_* of first base arcane/divine class or CLASS_TYPE_INVALID
 */
int GetPrimarySpellcastingClass(object oCaster = OBJECT_SELF);

/**
 * Gets the caster level adjustment from the Practiced Spellcaster feats.
 *
 * @param oCaster           The creature to check
 * @param iCastingClass     The CLASS_TYPE* that the spell was cast by.
 * @param iCastingLevels    The caster level for the spell calculated so far
 *                          ie. BEFORE Practiced Spellcaster.
 */
int PracticedSpellcasting(object oCaster, int iCastingClass, int iCastingLevels);

/**
 * Returns the spell school of the spell passed to it.
 *
 * @param iSpellId  The spell to get the school of.
 *
 * @return          The SPELL_SCHOOL_* of the spell.
 */
int GetSpellSchool(int iSpellId);

/**
 * Healing spell filter.
 *
 * Gets if the given spell is a healing spell based on a hardcoded list. New
 * healing spells need to be added to this.
 *
 * @author          GaiaWerewolf
 * @date            18 July 2005
 *
 * @param nSpellId  The spell to check
 *
 * @return          TRUE if it is a healing spell, FALSE otherwise.
 */
int GetIsHealingSpell(int nSpellId);

/**
 * Gets the contribution of the archmage's High Arcana Spell Power
 * feat to caster level.
 *
 * @param oCaster   The creature to check
 *
 * @return          caster level modifier from archmage Spell Power feats.
 */
int ArchmageSpellPower(object oCaster);

/**
 * Gets the caster level modifier from the Shadow Weave feat.
 *
 * Schools of Enchantment, Illusion, and Necromancy, and spells with the darkness
 * descriptor altered by +1, Evocation or Transmutation (except spells with the
 * darkness descriptor) altered by -1.
 *
 * @param oCaster       The creature to check
 * @param iSpellID      The spell ID of the spell
 * @param nSpellSchool  The spell school the cast spell is from
 *                      if none is specified, uses GetSpellSchool()
 *
 * @return              caster level modifier for Shadow Weave feat.
 */
int ShadowWeave(object oCaster, int iSpellID, int nSpellSchool = -1);

/**
 * Gets the caster level modifier from the Divination Power class feature.
 *
 * Divination spells +1/3 Unseen Seer levels, all others -1/3 Unseer Seer levels
 *
 * @param oCaster       The creature to check
 * @param iSpellID      The spell ID of the spell
 * @param nSpellSchool  The spell school the cast spell is from
 *                      if none is specified, uses GetSpellSchool()
 *
 * @return              caster level modifier for Divination Power feat.
 */
int DivinationPower(object oCaster, int nSpellSchool);

/**
 * Handles feats that modify caster level of spells with the fire
 * descriptor.
 *
 * Currently this is Disciple of Meph's Fire Adept feat and Bloodline of Fire feat.
 *
 * @param oCaster       The creature to check
 * @param iSpellID      The spell ID of the spell
 *
 * @return              Caster level modifier for fire related feats.
 */
int FireAdept(object oCaster, int iSpellID);

/**
 * Handles feats that modify caster level of spells with the air
 * descriptor.
 *
 * Currently this is the Air Mephling's Type feat
 *
 * @param oCaster       The creature to check
 * @param iSpellID      The spell ID of the spell
 *
 * @return              Caster level modifier for fire related feats.
 */
int AirAdept(object oCaster, int iSpellID);

/**
 * Handles feats that modify caster level of spells with the air
 * descriptor.
 *
 * Currently this is the Air Mephling's Type feat
 *
 * @param oCaster       The creature to check
 * @param iSpellID      The spell ID of the spell
 *
 * @return              Caster level modifier for fire related feats.
 */
int WaterAdept(object oCaster, int iSpellID);

/**
 * Handles feats that modify caster level of spells with the earth
 * descriptor.
 *
 * Currently this is Drift Magic feat.
 *
 * @param oCaster       The creature to check
 * @param iSpellID      The spell ID of the spell
 *
 * @return              Caster level modifier for earth related feats.
 */
int DriftMagic(object oCaster, int iSpellID);

/**
 * Soulcaster boost to caster level based on invested essentia
 *
 * @param oCaster       The creature to check
 * @param iSpellID      The spell ID of the spell
 *
 * @return              Caster level modifier
 */
int Soulcaster(object oCaster, int iSpellID);

/**
 * Gets the caster level modifier from the Storm Magic feat.
 *
 * Get +1 caster level if raining or snowing in area
 *
 * @param oCaster       The creature to check
 *
 * @return              Caster level modifier for Storm Magic feat.
 */
int StormMagic(object oCaster);

/**
 * Gets the caster level modifier from the Cormanthyran Moon Magic feat.
 *
 * Get +1 caster level if outdoors, at night, with no rain.
 *
 * @param oCaster       The creature to check
 *
 * @return              Caster level modifier for Cormanthyran Moon Magic feat.
 */
int CormanthyranMoonMagic(object oCaster);

/**
 * Gets the caster level modifier from various domains.
 *
 * @param oCaster       The creature to check
 * @param nSpellID      The spell ID of the spell
 * @param nSpellSchool  The spell school the cast spell is from
 *                      if none is specified, uses GetSpellSchool()
 *
 * @return              caster level modifier from domain powers
 */
int DomainPower(object oCaster, int nSpellID, int nSpellSchool = -1);

/**
 * Gets the caster level modifier from the Therapeutic Mantle Meld.
 *
 * @param oCaster       The creature to check
 *
 * @return              caster level modifier
 */
int TherapeuticMantle(object oCaster, int nSpellID);

/**
 * Gets the caster level modifier from the antipaladin's Death Knell SLA.
 *
 * @param oCaster       The creature to check
 *
 * @return              caster level modifier from the Death Knell SLA
 */
int DeathKnell(object oCaster);

/**
 * Gets the caster level modifier from the Draconic Power feat.
 *
 * Feat gives +1 to caster level.
 *
 * @param oCaster       The creature to check
 *
 * @return              caster level modifier from the Draconic power feat.
 */
int DraconicPower(object oCaster = OBJECT_SELF);

/**
 * Gets the caster level modifier from Song of Arcane Power effect.
 *
 * @param oCaster       The creature to check
 *
 * @return              caster level modifier from the Draconic power feat.
 */
int SongOfArcanePower(object oCaster = OBJECT_SELF);

/**
 * Gets the caster level modifier to necromancy spells for the
 * True Necromancer PrC (all spellcasting levels are counted, both
 * arcane and divine).
 *
 * @param oCaster       The creature to check
 * @param iSpellID      The spell ID of the spell
 * @param sType         "ARCANE" or "DIVINE" spell
 * @param nSpellSchool  The spell school the cast spell is from
 *                      if none is specified, uses GetSpellSchool()
 *
 * @return              caster level modifier for True Necro
 */
int TrueNecromancy(object oCaster, int iSpellID, string sType, int nSpellSchool = -1);

// Nentyar Hunter casting boost
int Nentyar(object oCaster, int nCastingClass);

// +1 on spells that target armor or shields
int ShieldDwarfWarder(object oCaster);

// +1 while this feat is active
int DarkSpeech(object oCaster);

// Adds 1/2 level in all other casting classes.
int UrPriestCL(object oCaster, int nCastingClass);

// Adds Druid levels to Blighter caster level
int BlighterCL(object oCaster, int nCastingClass);

//ebonfowl: Adds CL boosts from reserve feats
int ReserveFeatCL(object oCaster, int iSpellId);

//////////////////////////////////////////////////
/* Include section                              */
//////////////////////////////////////////////////

//#include "prc_racial_const"
// Not needed as it has acccess via prc_inc_newip
//#include "prc_inc_nwscript" // gets inc_2da_cache, inc_debug, prc_inc_switch
#include "prc_inc_newip"
//#include "prc_inc_spells"
#include "prc_inc_descrptr"

//////////////////////////////////////////////////
/* Internal functions                           */
//////////////////////////////////////////////////

// stolen from prcsp_archmaginc.nss, modified to work in FireAdept() function
string _GetChangedElementalType(int nSpellID, object oCaster = OBJECT_SELF)
{
    string spellType = Get2DACache("spells", "ImmunityType", nSpellID);//lookup_spell_type(spell_id);
    string sType = GetLocalString(oCaster, "archmage_mastery_elements_name");

    if (sType == "") sType = spellType;

    return sType;
}

//ebonfowl: Adding this function to check if a spell belongs to a given domain based on the Reserve Feat 2das
//Only works with Death, Destruction and War domains as only those domain 2das have been created
int GetIsFromDomain (int iSpellId, string sDomain)
{
    string sFile = "prc_desc_" + sDomain;

    int i;
    int nListSpellID;

    for (i = 0; i < 15; i++) // Adjust max i to reflect something close to the highest row number in the 2das
    {
        nListSpellID = StringToInt(Get2DACache(sFile, "SpellID", i));
        if (nListSpellID == iSpellId) return TRUE;
    }
    return FALSE;
}

//////////////////////////////////////////////////
/* Function Definitions                         */
//////////////////////////////////////////////////

int GetCasterLevelModifier(int nClass)
{
    switch(nClass) // do not change to return zero as this is used as a divisor
    {
        // add in new base half-caster classes here
        case CLASS_TYPE_HEXBLADE:
        case CLASS_TYPE_RANGER:
        case CLASS_TYPE_PALADIN:
        case CLASS_TYPE_ANTI_PALADIN:
            return 2;
    }
    return 1; // normal progression
}

int PRCGetCasterLevel(object oCaster = OBJECT_SELF)
{
    int nAdjust = GetLocalInt(oCaster, PRC_CASTERLEVEL_ADJUSTMENT);//this is for builder use
    nAdjust += GetLocalInt(oCaster, "TrueCasterLens");
    nAdjust += GetHasSpellEffect(SPELL_VIRTUOSO_MAGICAL_MELODY, oCaster);

    // For when you want to assign the caster level.
    int iReturnLevel = GetLocalInt(oCaster, PRC_CASTERLEVEL_OVERRIDE);
    if (iReturnLevel)
    {
        if (DEBUG) DoDebug("PRCGetCasterLevel: found override caster level = "+IntToString(iReturnLevel)+" with adjustment = " + IntToString(nAdjust)+", original level = "+IntToString(GetCasterLevel(oCaster)));
        return iReturnLevel+nAdjust;
    }

    // if we made it here, iReturnLevel = 0;

    int iCastingClass = PRCGetLastSpellCastClass(oCaster); // might be CLASS_TYPE_INVALID
    if(iCastingClass == CLASS_TYPE_SUBLIME_CHORD)
        iCastingClass = GetPrimaryArcaneClass(oCaster);
    int iSpellId = PRCGetSpellId(oCaster);
    object oItem = PRCGetSpellCastItem(oCaster);

    // Item Spells
    // this check is unreliable because of Bioware's implementation (GetSpellCastItem returns
    // the last object from which a spell was cast, even if we are not casting from an item)
    if(GetIsObjectValid(oItem))
    {
        int nType = GetBaseItemType(oItem);
        if(DEBUG) DoDebug("PRCGetCasterLevel: found valid item = "+GetName(oItem));
        // double check, just to make sure
        if(GetItemPossessor(oItem) == oCaster) // likely item casting
        {
            if(GetPRCSwitch(PRC_STAFF_CASTER_LEVEL)
                && ((nType == BASE_ITEM_MAGICSTAFF) ||
                    (nType == BASE_ITEM_CRAFTED_STAFF))
                )
            {
                iCastingClass = GetPrimarySpellcastingClass(oCaster);
            }
            else
            {
                //code for getting new ip type
                itemproperty ipTest = GetFirstItemProperty(oItem);
                while(GetIsItemPropertyValid(ipTest))
                {
                    if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_CAST_SPELL_CASTER_LEVEL)
                    {
                        int nSubType = GetItemPropertySubType(ipTest);
                        nSubType = StringToInt(Get2DACache("iprp_spells", "SpellIndex", nSubType));
                        if(nSubType == iSpellId)
                        {
                            iReturnLevel = GetItemPropertyCostTableValue(ipTest);
                            if (DEBUG) DoDebug("PRCGetCasterLevel: caster level from item = "+IntToString(iReturnLevel));
                            break; // exit the while loop
                        }
                    }
                    ipTest = GetNextItemProperty(oItem);
                }
                // if we didn't find a caster level on the item, it must be Bioware item casting
                if(!iReturnLevel)
                {
                    iReturnLevel = GetCasterLevel(oCaster);
                    if (DEBUG) DoDebug("PRCGetCasterLevel: bioware item casting with caster level = "+IntToString(iReturnLevel));
                }
            }

            if(nType == BASE_ITEM_MAGICWAND || nType == BASE_ITEM_ENCHANTED_WAND)
            {   
                if (DEBUG) DoDebug("PRCGetCasterLevel - Casting Item is a Wand at level "+IntToString(iReturnLevel));
                if (GetHasFeat(FEAT_RECKLESS_WAND_WIELDER, oCaster) && GetLocalInt(oCaster, "RecklessWand")) // This burns an extra charge to increase caster level by 2
                {
                    if (DEBUG) DoDebug("PRCGetCasterLevel - Reckless Wand Active");
                    if (GetItemCharges(oItem) > 0) // Make sure we have an extra charge to burn
                    {
                        iReturnLevel += 2;
                        if (!GetLocalInt(oCaster, "RecklessWandDelay")) SetItemCharges(oItem, GetItemCharges(oItem)-1);
                        SetLocalInt(oCaster, "RecklessWandDelay", TRUE);
                        DelayCommand(0.5, DeleteLocalInt(oCaster, "RecklessWandDelay"));
                        if (DEBUG) DoDebug("PRCGetCasterLevel - Reckless Wand Triggered at level "+IntToString(iReturnLevel));
                    }
                }    
                if (GetHasFeat(FEAT_WAND_MASTERY, oCaster))
                    iReturnLevel += 2;
            } 
        }
        if (DEBUG) DoDebug("PRCGetCasterLevel: total item casting caster level = "+IntToString(iReturnLevel));
    }

    // get spell school here as many of the following fns use it
    int nSpellSchool = GetSpellSchool(iSpellId);

    // no item casting, and arcane caster?
    if(!iReturnLevel && GetIsArcaneClass(iCastingClass, oCaster))
    {
        iReturnLevel = GetLevelByClass(iCastingClass, oCaster) / GetCasterLevelModifier(iCastingClass);
        
        // Casting as a sorc but don't have any levels in the class
	    if(iCastingClass == CLASS_TYPE_SORCERER && !GetLevelByClass(CLASS_TYPE_SORCERER, oCaster))
	    {
	        int nRace = GetRacialType(oCaster);
	
	        //if the player has sorcerer levels, then it counts as a prestige class
	        //otherwise use RHD instead of sorc levels
	        if(nRace == RACIAL_TYPE_RAKSHASA)
	            iReturnLevel = GetLevelByClass(CLASS_TYPE_OUTSIDER);
	        else if(nRace == RACIAL_TYPE_DRIDER)
	            iReturnLevel = GetLevelByClass(CLASS_TYPE_ABERRATION);
	        else if(nRace == RACIAL_TYPE_ARKAMOI)
	            iReturnLevel = GetLevelByClass(CLASS_TYPE_MONSTROUS);
	        else if(nRace == RACIAL_TYPE_REDSPAWN_ARCANISS)
	            iReturnLevel = GetLevelByClass(CLASS_TYPE_MONSTROUS)*3/4;	            
	        else if(nRace == RACIAL_TYPE_MARRUTACT)
	            iReturnLevel = (GetLevelByClass(CLASS_TYPE_MONSTROUS)*6/7)-1;	            
			else if(nRace == RACIAL_TYPE_ARANEA)
	            iReturnLevel = GetLevelByClass(CLASS_TYPE_SHAPECHANGER);
			 
	    }     
        // Casting as a bard but don't have any levels in the class
	    if(iCastingClass == CLASS_TYPE_BARD && !GetLevelByClass(CLASS_TYPE_BARD, oCaster))
	    {
	        int nRace = GetRacialType(oCaster);
	
	        //if the player has bard levels, then it counts as a prestige class
	        //otherwise use RHD instead of bard levels
	        if(nRace == RACIAL_TYPE_GLOURA)
	            iReturnLevel = GetLevelByClass(CLASS_TYPE_FEY);	            
	    }   	    

        //Spell Rage ability
        if(GetHasSpellEffect(SPELL_SPELL_RAGE, oCaster)
        && (nSpellSchool == SPELL_SCHOOL_ABJURATION
        || nSpellSchool == SPELL_SCHOOL_CONJURATION
        || nSpellSchool == SPELL_SCHOOL_EVOCATION
        || nSpellSchool == SPELL_SCHOOL_NECROMANCY
        || nSpellSchool == SPELL_SCHOOL_TRANSMUTATION))
        {
            iReturnLevel = GetHitDice(oCaster);
        }

        else if(GetPrimaryArcaneClass(oCaster) == iCastingClass)
            iReturnLevel += GetArcanePRCLevels(oCaster);
        else if(GetLevelByClass(CLASS_TYPE_ULTIMATE_MAGUS, oCaster)) 
        	iReturnLevel += GetArcanePRCLevels(oCaster, iCastingClass);

        iReturnLevel += PracticedSpellcasting(oCaster, iCastingClass, iReturnLevel);

        iReturnLevel += TrueNecromancy(oCaster, iSpellId, "ARCANE", nSpellSchool)
            +  ShadowWeave(oCaster, iSpellId, nSpellSchool)
            +  FireAdept(oCaster, iSpellId)
			+  AirAdept(oCaster, iSpellId)
			+  WaterAdept(oCaster, iSpellId)
            +  ArchmageSpellPower(oCaster)
            +  StormMagic(oCaster)
            +  CormanthyranMoonMagic(oCaster)
            +  DomainPower(oCaster, iSpellId, nSpellSchool)
            +  DivinationPower(oCaster, nSpellSchool)
            +  DeathKnell(oCaster)
            +  DraconicPower(oCaster)
            +  DriftMagic(oCaster, iSpellId)
            +  Soulcaster(oCaster, iSpellId)
            +  TherapeuticMantle(oCaster, iSpellId)
            +  DarkSpeech(oCaster)
            +  ShieldDwarfWarder(oCaster)
            +  SongOfArcanePower(oCaster)
            +  ReserveFeatCL(oCaster, iSpellId);
            
        if (GetLocalInt(oCaster, "CaptureMagic")) 
        {
            iReturnLevel += GetLocalInt(oCaster, "CaptureMagic");
            DeleteLocalInt(oCaster, "CaptureMagic");
        }            

        // Get stance level bonus for Jade Phoenix Mage
        if(GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oCaster))
        {
            if (_GetChangedElementalType(iSpellId, oCaster) == "Fire" && GetLocalInt(oCaster, "ToB_JPM_FireB"))
                iReturnLevel += 3;
            iReturnLevel += GetLocalInt(oCaster, "ToB_JPM_MystP");
        }
       // Abjurant Champion uses its Base AB as Caster Level if higher
        if(GetHasFeat(FEAT_MARTIAL_ARCANIST))
        {
                //Get the caster's base AB
                int nBaseAB = GetBaseAttackBonus(oCaster);
                if(nBaseAB > iReturnLevel)
                {
                 iReturnLevel = nBaseAB;
                }  
        }
        if (DEBUG) DoDebug("PRCGetCasterLevel: total arcane caster level = "+IntToString(iReturnLevel));
    }
	
    // no item casting and divine caster?
    else if(!iReturnLevel && GetIsDivineClass(iCastingClass, oCaster))
    {
        iReturnLevel = GetLevelByClass(iCastingClass, oCaster) / GetCasterLevelModifier(iCastingClass);
        if(GetPrimaryDivineClass(oCaster) == iCastingClass)
            iReturnLevel += GetDivinePRCLevels(oCaster);

        iReturnLevel += PracticedSpellcasting(oCaster, iCastingClass, iReturnLevel);

        iReturnLevel += TrueNecromancy(oCaster, iSpellId, "DIVINE", nSpellSchool)
            +  ShadowWeave(oCaster, iSpellId, nSpellSchool)
            +  FireAdept(oCaster, iSpellId)
            +  StormMagic(oCaster)
            +  CormanthyranMoonMagic(oCaster)
            +  Nentyar(oCaster, iCastingClass)
            +  DomainPower(oCaster, iSpellId, nSpellSchool)
            +  DriftMagic(oCaster, iSpellId)
			+  AirAdept(oCaster, iSpellId)
			+  WaterAdept(oCaster, iSpellId)
            +  Soulcaster(oCaster, iSpellId)
            +  ShieldDwarfWarder(oCaster)
            +  DarkSpeech(oCaster)
            +  DeathKnell(oCaster)
            +  UrPriestCL(oCaster, iCastingClass)
            +  BlighterCL(oCaster, iCastingClass)
            +  ReserveFeatCL(oCaster, iSpellId);
            
        if (DEBUG) DoDebug("PRCGetCasterLevel: total divine caster level = "+IntToString(iReturnLevel));    
    }

    //at this point it must be a SLA or similar
    if(!iReturnLevel)
    {
        iReturnLevel = GetCasterLevel(oCaster);
        if (DEBUG) DoDebug("PRCGetCasterLevel: bioware caster level = "+IntToString(iReturnLevel));
    }

    iReturnLevel -= GetLocalInt(oCaster, "WoLCasterPenalty"); 
    if (GetLocalInt(oCaster, "EldritchDisrupt"))
        iReturnLevel -= 4;  
    if (GetLocalInt(oCaster, "EldritchVortex"))
        iReturnLevel -= 4;         
    if (DEBUG) DoDebug("PRCGetCasterLevel: caster level pre adjust = "+IntToString(iReturnLevel));
    iReturnLevel += nAdjust;
    if (DEBUG) DoDebug("PRCGetCasterLevel: total caster level = "+IntToString(iReturnLevel));

    return iReturnLevel;
}

int PRCGetLastSpellCastClass(object oCaster = OBJECT_SELF)
{
    // note that a barbarian has a class type constant of zero. So nClass == 0 could in principle mean
    // that a barbarian cast the spell, However, barbarians cannot cast spells, so it doesn't really matter
    // beware of Barbarians with UMD, though. Also watch out for spell like abilities
    // might have to provide a fix for these (for instance: if(nClass == -1) nClass = 0;
    int nClass = GetLocalInt(oCaster, PRC_CASTERCLASS_OVERRIDE);
    if(nClass)
    {
        if(DEBUG) DoDebug("PRCGetLastSpellCastClass: found override caster class = "+IntToString(nClass)+", original class = "+IntToString(GetLastSpellCastClass()));
        return nClass;
    }
    nClass = GetLastSpellCastClass();
    //if casting class is invalid and the spell was not cast form an item it was probably cast from the new spellbook
    int NSB_Class = GetLocalInt(oCaster, "NSB_Class");
    if(nClass == CLASS_TYPE_INVALID && GetSpellCastItem() == OBJECT_INVALID && NSB_Class)
        nClass = NSB_Class;
        
    if(DEBUG) DoDebug("PRCGetLastSpellCastClass: returning caster class = "+IntToString(nClass)+" NSB_Class = "+IntToString(NSB_Class));    
    return nClass;
}

int GetIsArcaneClass(int nClass, object oCaster = OBJECT_SELF)
{
    return nClass == CLASS_TYPE_ASSASSIN
         || nClass == CLASS_TYPE_BARD
         || nClass == CLASS_TYPE_BEGUILER
         || nClass == CLASS_TYPE_CELEBRANT_SHARESS
         || nClass == CLASS_TYPE_CULTIST_SHATTERED_PEAK
         || nClass == CLASS_TYPE_DREAD_NECROMANCER
         || nClass == CLASS_TYPE_DUSKBLADE
         || nClass == CLASS_TYPE_HARPER
         || nClass == CLASS_TYPE_HEXBLADE
         || nClass == CLASS_TYPE_KNIGHT_WEAVE
         || nClass == CLASS_TYPE_SHADOWLORD
         || nClass == CLASS_TYPE_SORCERER
         || nClass == CLASS_TYPE_SUBLIME_CHORD
         || nClass == CLASS_TYPE_SUEL_ARCHANAMACH
         || nClass == CLASS_TYPE_WARMAGE
         || nClass == CLASS_TYPE_WIZARD
		 || (nClass == CLASS_TYPE_SHAPECHANGER
				&& GetRacialType(oCaster) == RACIAL_TYPE_ARANEA
                && !GetLevelByClass(CLASS_TYPE_SORCERER))
         || (nClass == CLASS_TYPE_OUTSIDER
                && GetRacialType(oCaster) == RACIAL_TYPE_RAKSHASA
                && !GetLevelByClass(CLASS_TYPE_SORCERER))
         || (nClass == CLASS_TYPE_ABERRATION
                && GetRacialType(oCaster) == RACIAL_TYPE_DRIDER
                && !GetLevelByClass(CLASS_TYPE_SORCERER))
         || (nClass == CLASS_TYPE_MONSTROUS
                && GetRacialType(oCaster) == RACIAL_TYPE_ARKAMOI
                && !GetLevelByClass(CLASS_TYPE_SORCERER))
         || (nClass == CLASS_TYPE_MONSTROUS
                && GetRacialType(oCaster) == RACIAL_TYPE_REDSPAWN_ARCANISS
                && !GetLevelByClass(CLASS_TYPE_SORCERER))
         || (nClass == CLASS_TYPE_MONSTROUS
                && GetRacialType(oCaster) == RACIAL_TYPE_MARRUTACT
                && !GetLevelByClass(CLASS_TYPE_SORCERER))                
         || (nClass == CLASS_TYPE_FEY
                && GetRacialType(oCaster) == RACIAL_TYPE_GLOURA
                && !GetLevelByClass(CLASS_TYPE_BARD));
}

int GetIsDivineClass(int nClass, object oCaster = OBJECT_SELF)
{
    return nClass == CLASS_TYPE_ARCHIVIST
         || nClass == CLASS_TYPE_BLACKGUARD
         || nClass == CLASS_TYPE_BLIGHTER
         || nClass == CLASS_TYPE_CLERIC
         || nClass == CLASS_TYPE_DRUID
         || nClass == CLASS_TYPE_FAVOURED_SOUL
         || nClass == CLASS_TYPE_HEALER
         || nClass == CLASS_TYPE_JUSTICEWW
         || nClass == CLASS_TYPE_KNIGHT_CHALICE
         || nClass == CLASS_TYPE_KNIGHT_MIDDLECIRCLE
         || nClass == CLASS_TYPE_NENTYAR_HUNTER
         || nClass == CLASS_TYPE_OCULAR
         || nClass == CLASS_TYPE_PALADIN
         || nClass == CLASS_TYPE_RANGER
         || nClass == CLASS_TYPE_SHAMAN
         || nClass == CLASS_TYPE_SLAYER_OF_DOMIEL
         || nClass == CLASS_TYPE_SOHEI
         || nClass == CLASS_TYPE_SOLDIER_OF_LIGHT
         || nClass == CLASS_TYPE_UR_PRIEST
         || nClass == CLASS_TYPE_VASSAL
         || nClass == CLASS_TYPE_VIGILANT;
}

int GetArcanePRCLevels(object oCaster, int nCastingClass = CLASS_TYPE_INVALID)
{
   int nArcane;
   int nOozeMLevel  = GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);
   int nUM          = GetLevelByClass(CLASS_TYPE_ULTIMATE_MAGUS, oCaster);
   int nFirstClass  = GetClassByPosition(1, oCaster);
   int nSecondClass = GetClassByPosition(2, oCaster);
   int nThirdClass  = GetClassByPosition(3, oCaster);
   
   if (GetFirstArcaneClassPosition(oCaster)) nArcane += GetLevelByClass(CLASS_TYPE_SOULCASTER, oCaster);

   nArcane += GetLevelByClass(CLASS_TYPE_ABJURANT_CHAMPION, oCaster)
           +  GetLevelByClass(CLASS_TYPE_ALIENIST,        oCaster)
           +  GetLevelByClass(CLASS_TYPE_ANIMA_MAGE,      oCaster)
           +  GetLevelByClass(CLASS_TYPE_ARCANE_HIEROPHANT, oCaster)
           +  GetLevelByClass(CLASS_TYPE_ARCHMAGE,        oCaster)
           +  GetLevelByClass(CLASS_TYPE_ARCTRICK,        oCaster)
           +  GetLevelByClass(CLASS_TYPE_CEREBREMANCER,   oCaster)
           +  GetLevelByClass(CLASS_TYPE_DIABOLIST,       oCaster)
           +  GetLevelByClass(CLASS_TYPE_DRAGONHEART_MAGE, oCaster)
           +  GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster)
           +  GetLevelByClass(CLASS_TYPE_ELDRITCH_THEURGE, oCaster)
           +  GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT,oCaster)
           +  GetLevelByClass(CLASS_TYPE_FMM,             oCaster)
           +  GetLevelByClass(CLASS_TYPE_FROST_MAGE,      oCaster)
           +  GetLevelByClass(CLASS_TYPE_HARPERMAGE,      oCaster)
           +  GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oCaster)
           +  GetLevelByClass(CLASS_TYPE_MAGEKILLER,      oCaster)
           +  GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster)
           +  GetLevelByClass(CLASS_TYPE_MASTER_HARPER,   oCaster)
           +  GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE,  oCaster)
           +  GetLevelByClass(CLASS_TYPE_NOCTUMANCER,     oCaster)
           +  GetLevelByClass(CLASS_TYPE_SPELLDANCER,     oCaster)
           +  GetLevelByClass(CLASS_TYPE_TRUENECRO,       oCaster)
           +  GetLevelByClass(CLASS_TYPE_RED_WIZARD,      oCaster)
           +  GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT,    oCaster)
           +  GetLevelByClass(CLASS_TYPE_SUBLIME_CHORD,   oCaster)
           +  GetLevelByClass(CLASS_TYPE_UNSEEN_SEER,     oCaster)
           +  GetLevelByClass(CLASS_TYPE_VIRTUOSO,        oCaster)
           +  GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oCaster)
           
           +  (GetLevelByClass(CLASS_TYPE_BLADESINGER,        oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER,   oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_PALEMASTER,         oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_HATHRAN,            oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_HAVOC_MAGE,         oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_SPELLSWORD,         oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT,    oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_RAGE_MAGE,          oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_WAYFARER_GUIDE,     oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;
           
           int nClass = GetLevelByClass(CLASS_TYPE_WILD_MAGE, oCaster); 
           if (nClass)
            nArcane += nClass - 3 + d6();

    //The following changes are to prevent a mage/invoker from gaining bonus caster levels in both base classes.

    if(GetLocalInt(oCaster, "INV_Caster") == 1 ||
            (!GetLevelByClass(CLASS_TYPE_WARLOCK, oCaster) && !GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT, oCaster)))
        nArcane += (GetLevelByClass(CLASS_TYPE_ACOLYTE,              oCaster) + 1) / 2
                +  (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2
                +  (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT,      oCaster) + 1) / 2
                +   GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST,      oCaster)
                +   GetLevelByClass(CLASS_TYPE_MAESTER,              oCaster);


    /* oozemaster levels count towards arcane caster level if:
     *
     * first class slot is arcane OR
     * first class slot is NOT divine AND second class slot is arcane OR
     * first AND second class slot is NOT divine AND 3rd class slot is arcane
     */
   if (nOozeMLevel)
   {
       if (GetIsArcaneClass(nFirstClass, oCaster)
           || (!GetIsDivineClass(nFirstClass, oCaster)
                && GetIsArcaneClass(nSecondClass, oCaster))
           || (!GetIsDivineClass(nFirstClass, oCaster)
                && !GetIsDivineClass(nSecondClass, oCaster)
                && GetIsArcaneClass(nThirdClass, oCaster)))
           nArcane += nOozeMLevel / 2;
   }
	
	if (nUM)
	{
		int nBoost = nUM - 1; //Prep caster always loses a level on first level of the class
		if (nUM >= 4) nBoost = nUM - 2;
		if (nUM >= 7) nBoost = nUM - 3;
		nArcane += nBoost;
		
		if (nCastingClass == CLASS_TYPE_SORCERER)
		{
			int nBoost = 1; //Sorcerer gets the lost levels back
			if (nUM >= 4) nBoost = 2;
			if (nUM >= 7) nBoost = 3;
			nArcane += nBoost; 		
		}
	}
    if(GetLevelByClass(CLASS_TYPE_SORCERER, oCaster))
    {    
        int nRace = GetRacialType(oCaster);

        //includes RHD HD as sorc
        //if they have sorcerer levels, then it counts as a prestige class
        //otherwise its used instead of sorc levels
		if(nRace == RACIAL_TYPE_ARANEA)
            nArcane += GetLevelByClass(CLASS_TYPE_SHAPECHANGER);
        if(nRace == RACIAL_TYPE_RAKSHASA)
            nArcane += GetLevelByClass(CLASS_TYPE_OUTSIDER);
        if(nRace == RACIAL_TYPE_DRIDER)
            nArcane += GetLevelByClass(CLASS_TYPE_ABERRATION);
        if(nRace == RACIAL_TYPE_ARKAMOI)
            nArcane += GetLevelByClass(CLASS_TYPE_MONSTROUS);
        if(nRace == RACIAL_TYPE_REDSPAWN_ARCANISS)
            nArcane += GetLevelByClass(CLASS_TYPE_MONSTROUS)*3/4;            
        if(nRace == RACIAL_TYPE_MARRUTACT)
            nArcane += (GetLevelByClass(CLASS_TYPE_MONSTROUS)*6/7)-1;             
    }
    
    if(GetLevelByClass(CLASS_TYPE_BARD, oCaster))
    {
        int nRace = GetRacialType(oCaster);

        //includes RHD HD as bard
        //if they have bard levels, then it counts as a prestige class
        //otherwise its used instead of bard levels
        if(nRace == RACIAL_TYPE_GLOURA)
            nArcane += GetLevelByClass(CLASS_TYPE_FEY);         
    }    

    return nArcane;
}

int GetDivinePRCLevels(object oCaster)
{
   int nDivine;
   int nOozeMLevel = GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);
   int nFirstClass = GetClassByPosition(1, oCaster);
   int nSecondClass = GetClassByPosition(2, oCaster);
   int nThirdClass = GetClassByPosition(3, oCaster);

   // This section accounts for full progression classes
   nDivine += GetLevelByClass(CLASS_TYPE_ARCANE_HIEROPHANT, oCaster)
           +  GetLevelByClass(CLASS_TYPE_BLIGHTLORD,        oCaster)
           +  GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC,      oCaster)
           +  GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE,     oCaster)
           +  GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster)
		   +  GetLevelByClass(CLASS_TYPE_FORESTMASTER,    	oCaster)
           +  GetLevelByClass(CLASS_TYPE_FISTRAZIEL,        oCaster)
           +  GetLevelByClass(CLASS_TYPE_HEARTWARDER,       oCaster)
           +  GetLevelByClass(CLASS_TYPE_HIEROPHANT,        oCaster)
           +  GetLevelByClass(CLASS_TYPE_HOSPITALER,        oCaster)
           +  GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster)
           +  GetLevelByClass(CLASS_TYPE_MORNINGLORD,       oCaster)
           +  GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE,    oCaster)
           +  GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE,   oCaster)
           +  GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR,   oCaster)
           +  GetLevelByClass(CLASS_TYPE_RUNECASTER,        oCaster)
           +  GetLevelByClass(CLASS_TYPE_SACREDPURIFIER,    oCaster)
           +  GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oCaster)
           +  GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster)
           +  GetLevelByClass(CLASS_TYPE_STORMLORD,         oCaster)
           +  GetLevelByClass(CLASS_TYPE_SWIFT_WING,        oCaster)
           +  GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster)

           +  (GetLevelByClass(CLASS_TYPE_BFZ,                   oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER,     oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_HATHRAN,               oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_OLLAM,                 oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_ORCUS,                 oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_SHINING_BLADE,         oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_TEMPUS,                oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_WARPRIEST,             oCaster) + 1) / 2

           +  (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;

   if (!GetHasFeat(FEAT_SF_CODE, oCaster))
   {
       nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
   }

   if (nOozeMLevel)
   {
       if (GetIsDivineClass(nFirstClass, oCaster)
           || (!GetIsArcaneClass(nFirstClass, oCaster)
                && GetIsDivineClass(nSecondClass, oCaster))
           || (!GetIsArcaneClass(nFirstClass, oCaster)
                && !GetIsArcaneClass(nSecondClass, oCaster)
                && GetIsDivineClass(nThirdClass, oCaster)))
           nDivine += nOozeMLevel / 2;
   }

   return nDivine;
}

int GetFirstArcaneClassPosition(object oCaster = OBJECT_SELF)
{
    int i;
    for(i = 1; i < 4; i++)
    {
        if(GetIsArcaneClass(GetClassByPosition(i, oCaster), oCaster))
            return i;
    }

    return 0;
}

int GetFirstDivineClassPosition(object oCaster = OBJECT_SELF)
{
    int i;
    for(i = 1; i < 4; i++)
    {
        if(GetIsDivineClass(GetClassByPosition(i, oCaster), oCaster))
            return i;
    }

    return 0;
}

int GetPrimaryArcaneClass(object oCaster = OBJECT_SELF)
{
    int nClass;

    if(GetPRCSwitch(PRC_CASTERLEVEL_FIRST_CLASS_RULE))
    {
        int iArcanePos = GetFirstArcaneClassPosition(oCaster);
        if (!iArcanePos) return CLASS_TYPE_INVALID; // no arcane casting class

        nClass = GetClassByPosition(iArcanePos, oCaster);
    }
    else
    {
        int i, nClassTmp, nClassLvl;
        for(i = 1; i < 4; i++)
        {
            nClassTmp = GetClassByPosition(i, oCaster);
            if(GetIsArcaneClass(nClassTmp, oCaster) && nClassTmp != CLASS_TYPE_SUBLIME_CHORD)
            {
                if(GetLevelByClass(nClassTmp, oCaster) > nClassLvl)
                {
                    nClass = nClassTmp;
                    nClassLvl = GetLevelByClass(nClass, oCaster);
                }
            }
        }
        if(!nClassLvl)
            return CLASS_TYPE_INVALID;
    }

    //raks, Arkamoi, driders and dragons cast as sorcs
    if(nClass == CLASS_TYPE_OUTSIDER
	|| nClass == CLASS_TYPE_SHAPECHANGER
    || nClass == CLASS_TYPE_ABERRATION
    || nClass == CLASS_TYPE_DRAGON
    || nClass == CLASS_TYPE_MONSTROUS)
        nClass = CLASS_TYPE_SORCERER;
        
    if(nClass == CLASS_TYPE_FEY)
        nClass = CLASS_TYPE_BARD;        

    return nClass;
}

int GetPrimaryDivineClass(object oCaster = OBJECT_SELF)
{
    int nClass;

    if(GetPRCSwitch(PRC_CASTERLEVEL_FIRST_CLASS_RULE))
    {
        int iDivinePos = GetFirstDivineClassPosition(oCaster);
        if (!iDivinePos) return CLASS_TYPE_INVALID; // no Divine casting class

        nClass = GetClassByPosition(iDivinePos, oCaster);
    }
    else
    {
        int i, nClassTmp, nClassLvl;
        for(i = 1; i < 4; i++)
        {
            nClassTmp = GetClassByPosition(i, oCaster);
            if(GetIsDivineClass(nClassTmp, oCaster))
            {
                if(GetLevelByClass(nClassTmp, oCaster) > nClassLvl)
                {
                    nClass = nClassTmp;
                    nClassLvl = GetLevelByClass(nClass, oCaster);
                }
            }
        }
        if(!nClassLvl)
            return CLASS_TYPE_INVALID;
    }

    return nClass;
}

int GetPrimarySpellcastingClass(object oCaster = OBJECT_SELF)
{
    int bFirst = GetPRCSwitch(PRC_CASTERLEVEL_FIRST_CLASS_RULE);
    int nClass;

    int i, nClassTmp, nClassLvl;
    for(i = 1; i < 4; i++)
    {
        nClassTmp = GetClassByPosition(i, oCaster);
        if(GetIsArcaneClass(nClassTmp, oCaster)
        || GetIsDivineClass(nClassTmp, oCaster)
        && nClassTmp != CLASS_TYPE_SUBLIME_CHORD)
        {
            if(bFirst)
            {
                return nClass;
            }
            else if(GetLevelByClass(nClassTmp, oCaster) > nClassLvl)
            {
                nClass = nClassTmp;
                nClassLvl = GetLevelByClass(nClass, oCaster);
            }
        }
    }
    if(!nClassLvl)
        return CLASS_TYPE_INVALID;

    return nClass;
}

int PracticedSpellcasting(object oCaster, int iCastingClass, int iCastingLevels)
{
    int nFeat;
    int iAdjustment = GetHitDice(oCaster) - iCastingLevels;
    if (iAdjustment > 4) iAdjustment = 4;
    if (iAdjustment < 0) iAdjustment = 0;

    switch(iCastingClass)
    {
        case CLASS_TYPE_BARD:                nFeat = FEAT_PRACTICED_SPELLCASTER_BARD;                break;
        case CLASS_TYPE_SORCERER:            nFeat = FEAT_PRACTICED_SPELLCASTER_SORCERER;            break;
        case CLASS_TYPE_WIZARD:              nFeat = FEAT_PRACTICED_SPELLCASTER_WIZARD;              break;
        case CLASS_TYPE_CLERIC:              nFeat = FEAT_PRACTICED_SPELLCASTER_CLERIC;              break;
        case CLASS_TYPE_DRUID:               nFeat = FEAT_PRACTICED_SPELLCASTER_DRUID;               break;
        case CLASS_TYPE_PALADIN:             nFeat = FEAT_PRACTICED_SPELLCASTER_PALADIN;             break;
        case CLASS_TYPE_RANGER:              nFeat = FEAT_PRACTICED_SPELLCASTER_RANGER;              break;
        case CLASS_TYPE_ASSASSIN:            nFeat = FEAT_PRACTICED_SPELLCASTER_ASSASSIN;            break;
        case CLASS_TYPE_BLACKGUARD:          nFeat = FEAT_PRACTICED_SPELLCASTER_BLACKGUARD;          break;
        case CLASS_TYPE_OCULAR:              nFeat = FEAT_PRACTICED_SPELLCASTER_OCULAR;              break;
        case CLASS_TYPE_HEXBLADE:            nFeat = FEAT_PRACTICED_SPELLCASTER_HEXBLADE;            break;
        case CLASS_TYPE_DUSKBLADE:           nFeat = FEAT_PRACTICED_SPELLCASTER_DUSKBLADE;           break;
        case CLASS_TYPE_HEALER:              nFeat = FEAT_PRACTICED_SPELLCASTER_HEALER;              break;
        case CLASS_TYPE_KNIGHT_CHALICE:      nFeat = FEAT_PRACTICED_SPELLCASTER_KNIGHT_CHALICE;      break;
        case CLASS_TYPE_NENTYAR_HUNTER:      nFeat = FEAT_PRACTICED_SPELLCASTER_NENTYAR;             break;
        case CLASS_TYPE_VASSAL:              nFeat = FEAT_PRACTICED_SPELLCASTER_VASSAL;              break;
        case CLASS_TYPE_UR_PRIEST:           nFeat = FEAT_PRACTICED_SPELLCASTER_UR_PRIEST;           break;
        case CLASS_TYPE_SOLDIER_OF_LIGHT:    nFeat = FEAT_PRACTICED_SPELLCASTER_SOLDIER_OF_LIGHT;    break;
        case CLASS_TYPE_SHADOWLORD:          nFeat = FEAT_PRACTICED_SPELLCASTER_SHADOWLORD;          break;
        case CLASS_TYPE_JUSTICEWW:           nFeat = FEAT_PRACTICED_SPELLCASTER_JUSTICEWW;           break;
        case CLASS_TYPE_KNIGHT_MIDDLECIRCLE: nFeat = FEAT_PRACTICED_SPELLCASTER_KNIGHT_MIDDLECIRCLE; break;
        case CLASS_TYPE_SHAMAN:              nFeat = FEAT_PRACTICED_SPELLCASTER_SHAMAN;              break;
        case CLASS_TYPE_SLAYER_OF_DOMIEL:    nFeat = FEAT_PRACTICED_SPELLCASTER_SLAYER_OF_DOMIEL;    break;
        case CLASS_TYPE_SUEL_ARCHANAMACH:    nFeat = FEAT_PRACTICED_SPELLCASTER_SUEL_ARCHANAMACH;    break;
        case CLASS_TYPE_FAVOURED_SOUL:       nFeat = FEAT_PRACTICED_SPELLCASTER_FAVOURED_SOUL;       break;
        case CLASS_TYPE_SOHEI:               nFeat = FEAT_PRACTICED_SPELLCASTER_SOHEI;               break;
        case CLASS_TYPE_CELEBRANT_SHARESS:   nFeat = FEAT_PRACTICED_SPELLCASTER_CELEBRANT_SHARESS;   break;
        case CLASS_TYPE_WARMAGE:             nFeat = FEAT_PRACTICED_SPELLCASTER_WARMAGE;             break;
        case CLASS_TYPE_DREAD_NECROMANCER:   nFeat = FEAT_PRACTICED_SPELLCASTER_DREAD_NECROMANCER;   break;
        case CLASS_TYPE_CULTIST_SHATTERED_PEAK: nFeat = FEAT_PRACTICED_SPELLCASTER_CULTIST;               break;
        case CLASS_TYPE_ARCHIVIST:           nFeat = FEAT_PRACTICED_SPELLCASTER_ARCHIVIST;           break;
        case CLASS_TYPE_BEGUILER:            nFeat = FEAT_PRACTICED_SPELLCASTER_BEGUILER;            break;
        case CLASS_TYPE_BLIGHTER:            nFeat = FEAT_PRACTICED_SPELLCASTER_BLIGHTER;            break;
        case CLASS_TYPE_HARPER:              nFeat = FEAT_PRACTICED_SPELLCASTER_HARPER;              break;
        default: return 0;
    }

    if(GetHasFeat(nFeat, oCaster))
        return iAdjustment;

    return 0;
}

int GetSpellSchool(int iSpellId)
{
    string sSpellSchool = Get2DACache("spells", "School", iSpellId);//lookup_spell_school(iSpellId);

    if (sSpellSchool == "A") return SPELL_SCHOOL_ABJURATION;
    else if (sSpellSchool == "C") return SPELL_SCHOOL_CONJURATION;
    else if (sSpellSchool == "D") return SPELL_SCHOOL_DIVINATION;
    else if (sSpellSchool == "E") return SPELL_SCHOOL_ENCHANTMENT;
    else if (sSpellSchool == "V") return SPELL_SCHOOL_EVOCATION;
    else if (sSpellSchool == "I") return SPELL_SCHOOL_ILLUSION;
    else if (sSpellSchool == "N") return SPELL_SCHOOL_NECROMANCY;
    else if (sSpellSchool == "T") return SPELL_SCHOOL_TRANSMUTATION;
    else return SPELL_SCHOOL_GENERAL;

    return -1;
}

/*int GetIsHealingSpell(int nSpellId)
{
    if (  nSpellId == SPELL_CURE_CRITICAL_WOUNDS
       || nSpellId == SPELL_CURE_LIGHT_WOUNDS
       || nSpellId == SPELL_CURE_MINOR_WOUNDS
       || nSpellId == SPELL_CURE_MODERATE_WOUNDS
       || nSpellId == SPELL_CURE_SERIOUS_WOUNDS
       || nSpellId == SPELL_GREATER_RESTORATION
       || nSpellId == SPELL_HEAL
       || nSpellId == SPELL_HEALING_CIRCLE
       || nSpellId == SPELL_MASS_HEAL
       || nSpellId == SPELL_MONSTROUS_REGENERATION
       || nSpellId == SPELL_REGENERATE
       //End of stock NWN spells
       || nSpellId == SPELL_MASS_CURE_LIGHT
       || nSpellId == SPELL_MASS_CURE_MODERATE
       || nSpellId == SPELL_MASS_CURE_SERIOUS
       || nSpellId == SPELL_MASS_CURE_CRITICAL
       || nSpellId == SPELL_PANACEA
       )
        return TRUE;

    return FALSE;
}*/

int ArchmageSpellPower(object oCaster)
{
    if(GetHasFeat(FEAT_SPELL_POWER_V,   oCaster))
        return 5;
    if(GetHasFeat(FEAT_SPELL_POWER_IV,  oCaster))
        return 4;
    if(GetHasFeat(FEAT_SPELL_POWER_III, oCaster))
        return 3;
    if(GetHasFeat(FEAT_SPELL_POWER_II,  oCaster))
        return 2;
    if(GetHasFeat(FEAT_SPELL_POWER_I,   oCaster))
        return 1;

    return 0;
}

int ShadowWeave(object oCaster, int iSpellID, int nSpellSchool = -1)
{
   if(!GetHasFeat(FEAT_SHADOWWEAVE,oCaster))
       return 0;

   if (nSpellSchool == -1)
       nSpellSchool = GetSpellSchool(iSpellID);

   // Bonus for spells of Enhancement, Necromancy and Illusion schools and spells with Darkness descriptor
   if(nSpellSchool == SPELL_SCHOOL_ENCHANTMENT
   || nSpellSchool == SPELL_SCHOOL_NECROMANCY
   || nSpellSchool == SPELL_SCHOOL_ILLUSION
   || GetHasDescriptor(iSpellID, DESCRIPTOR_DARKNESS))
   {
       return 1;
   }
   // Penalty to spells of Evocation and Transmutation schools, except for those with Darkness descriptor
   else if(nSpellSchool == SPELL_SCHOOL_EVOCATION
   || nSpellSchool == SPELL_SCHOOL_TRANSMUTATION)
   {
       return -1;
   }

   return 0;
}

int AirAdept(object oCaster, int iSpellID)
{
    if(!GetHasDescriptor(iSpellID, DESCRIPTOR_AIR))
        return 0;

    int nBoost = 0;

    if(GetHasFeat(FEAT_AIR_MEPHLING, oCaster))
        nBoost += 1;

    return nBoost;
}

int WaterAdept(object oCaster, int iSpellID)
{
    if(!GetHasDescriptor(iSpellID, DESCRIPTOR_WATER))
        return 0;

    int nBoost = 0;

    if(GetHasFeat(FEAT_WATER_MEPHLING, oCaster))
        nBoost += 1;

    return nBoost;
}

int FireAdept(object oCaster, int iSpellID)
{
    if(!GetHasDescriptor(iSpellID, DESCRIPTOR_FIRE))
        return 0;

    int nBoost = 0;

    if(GetHasFeat(FEAT_FIRE_ADEPT, oCaster))
        nBoost += 1;
		
    if(GetHasFeat(FEAT_FIRE_MEPHLING, oCaster))
        nBoost += 1;		

    if(GetHasFeat(FEAT_BLOODLINE_OF_FIRE, oCaster))
        nBoost += 2;
        
    if(GetRacialType(oCaster) == RACIAL_TYPE_REDSPAWN_ARCANISS)
    	nBoost += 2;

    return nBoost;
}

int DriftMagic(object oCaster, int iSpellID)
{
    if(!GetHasDescriptor(iSpellID, DESCRIPTOR_EARTH))
        return 0;

    int nBoost = 0;

    if(GetHasFeat(FEAT_DRIFT_MAGIC, oCaster))
        nBoost += 1;
		
    if(GetHasFeat(FEAT_EARTH_MEPHLING, oCaster))
        nBoost += 1;		

    return nBoost;
}
/*int DriftMagic(object oCaster, int iSpellID)
{
    if(GetHasDescriptor(iSpellID, DESCRIPTOR_EARTH) && GetHasFeat(FEAT_DRIFT_MAGIC, oCaster))
        return 1;
		
    else if(GetHasDescriptor(iSpellID, DESCRIPTOR_EARTH) && GetHasFeat(FEAT_EARTH_MEPHLING, oCaster))
        return 1;
		
    return 0;
}*/

int Soulcaster(object oCaster, int iSpellID)
{
    if(GetLocalInt(oCaster, "SpellEssentia"+IntToString(iSpellID)))
    {
    	int nReturn = GetLocalInt(oCaster, "SpellEssentia"+IntToString(iSpellID));
    	DelayCommand(1.0, DeleteLocalInt(oCaster, "SpellEssentia"+IntToString(iSpellID)));
        return nReturn;
    }    

    return 0;
}

int StormMagic(object oCaster)
{
    if(!GetHasFeat(FEAT_STORMMAGIC, oCaster) && !GetHasFeat(FEAT_FROZEN_MAGIC, oCaster)) return 0;
    
    int nBoost = 0;

    int nWeather = GetWeather(GetArea(oCaster));
    if(nWeather == WEATHER_RAIN && GetHasFeat(FEAT_STORMMAGIC, oCaster))
        nBoost += 1;
    if(nWeather == WEATHER_SNOW && GetHasFeat(FEAT_STORMMAGIC, oCaster))
        nBoost += 1;        
    if(nWeather == WEATHER_SNOW && GetHasFeat(FEAT_FROZEN_MAGIC, oCaster))
        nBoost += 2;                
    if (GetLocalInt(GetArea(oCaster),"FrozenMagic") && GetHasFeat(FEAT_FROZEN_MAGIC, oCaster) && nWeather != WEATHER_SNOW)
        nBoost += 2;
    
    return nBoost;
}

int DivinationPower(object oCaster, int nSpellSchool)
{
    int nClass = GetLevelByClass(CLASS_TYPE_UNSEEN_SEER, oCaster);
    if(!nClass) return 0;
    
    int nBoost = (nClass + 2) / 3;   
        
    if (nSpellSchool != SPELL_SCHOOL_DIVINATION)
        nBoost *= -1; // Negative if it's not a divination spell
    
    return nBoost;
}

int CormanthyranMoonMagic(object oCaster)
{
    if (!GetHasFeat(FEAT_CORMANTHYRAN_MOON_MAGIC, oCaster)) return 0;

    object oArea = GetArea(oCaster);

    // The moon must be visible. Thus, outdoors, at night, with no rain.
    if (GetWeather(oArea) != WEATHER_RAIN && GetWeather(oArea) != WEATHER_SNOW &&
        GetIsNight() && !GetIsAreaInterior(oArea))
    {
        return 2;
    }
    return 0;
}

int Nentyar(object oCaster, int nCastingClass)
{
    if (nCastingClass == CLASS_TYPE_NENTYAR_HUNTER)
    {
        int nBonus = GetLevelByClass(CLASS_TYPE_DRUID, oCaster) + GetLevelByClass(CLASS_TYPE_CLERIC, oCaster) + GetLevelByClass(CLASS_TYPE_RANGER, oCaster)/2;
        return nBonus;
    }
    return 0;
}

int ShieldDwarfWarder(object oCaster)
{
	if (!GetHasFeat(FEAT_SHIELD_DWARF_WARDER, oCaster)) return 0;
	
	object oTarget = PRCGetSpellTargetObject();
	// If it's an item that grants an AC bonus
    int nBase = GetBaseItemType(oTarget);
    if (nBase == BASE_ITEM_SMALLSHIELD || nBase == BASE_ITEM_LARGESHIELD || nBase == BASE_ITEM_TOWERSHIELD || nBase == BASE_ITEM_ARMOR)	
        return 1;

    return 0;
}

int DarkSpeech(object oCaster)
{
	if (GetHasSpellEffect(SPELL_DARK_SPEECH_POWER, oCaster)) 
	{
		ExecuteScript("prc_dark_power", oCaster);		
        return 1;
	}
    return 0;
}

int DomainPower(object oCaster, int nSpellID, int nSpellSchool = -1)
{
    int nBonus = 0;
    if (nSpellSchool == -1)
       nSpellSchool = GetSpellSchool(nSpellID);

    // Boosts Caster level with the Illusion school by 1
    if (nSpellSchool == SPELL_SCHOOL_ILLUSION && GetHasFeat(FEAT_DOMAIN_POWER_GNOME, oCaster))
        nBonus += 1;

    // Boosts Caster level with the Illusion school by 1
    if (nSpellSchool == SPELL_SCHOOL_ILLUSION && GetHasFeat(FEAT_DOMAIN_POWER_ILLUSION, oCaster))
        nBonus += 1;

    // Boosts Caster level with healing spells
    if (GetIsOfSubschool(nSpellID, SUBSCHOOL_HEALING) && GetHasFeat(FEAT_HEALING_DOMAIN_POWER, oCaster))
        nBonus += 1;

    // Boosts Caster level with the Divination school by 1
    if (nSpellSchool == SPELL_SCHOOL_DIVINATION && GetHasFeat(FEAT_KNOWLEDGE_DOMAIN_POWER, oCaster))
        nBonus += 1;

    // Boosts Caster level with evil spells by 1
    if (GetHasDescriptor(nSpellID, DESCRIPTOR_EVIL) && GetHasFeat(FEAT_EVIL_DOMAIN_POWER, oCaster))
        nBonus += 1;

    // Boosts Caster level with good spells by 1
    if (GetHasDescriptor(nSpellID, DESCRIPTOR_GOOD) && GetHasFeat(FEAT_GOOD_DOMAIN_POWER, oCaster))
        nBonus += 1;

    return nBonus;
}

int TherapeuticMantle(object oCaster, int nSpellID)
{
	int nReturn;
    // Boosts Caster level with healing spells
    if (GetIsMeldBound(oCaster, MELD_THERAPEUTIC_MANTLE) == CHAKRA_SHOULDERS && GetIsOfSubschool(nSpellID, SUBSCHOOL_HEALING))
		nReturn = GetEssentiaInvested(oCaster, MELD_THERAPEUTIC_MANTLE);
	
	return nReturn;
}

int DeathKnell(object oCaster)
{
    // If you do have the spell effect, return a +1 bonus to caster level
    return GetHasSpellEffect(SPELL_DEATH_KNELL, oCaster);
}

int DraconicPower(object oCaster = OBJECT_SELF)
{
    return GetHasFeat(FEAT_DRACONIC_POWER, oCaster);
}

int SongOfArcanePower(object oCaster = OBJECT_SELF)
{
    int nBonus = GetLocalInt(oCaster, "SongOfArcanePower");
    DeleteLocalInt(oCaster, "SongOfArcanePower");
    
    int nLevel = GetLevelByClass(CLASS_TYPE_ULTIMATE_MAGUS, oCaster);
    nBonus += (nLevel + 2)/3;
    
    if(nBonus)
        return nBonus;

    return 0;
}

int TrueNecromancy(object oCaster, int iSpellID, string sType, int nSpellSchool = -1)
{
    int iTNLevel = GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster);
    if (!iTNLevel)
        return 0;
    if (nSpellSchool == -1)
        nSpellSchool = GetSpellSchool(iSpellID);
    if (nSpellSchool != SPELL_SCHOOL_NECROMANCY)
        return 0;

    if (sType == "ARCANE")
        return GetLevelByTypeDivine(oCaster); // TN and arcane levels already added.

    if (sType == "DIVINE")
        return GetLevelByTypeArcane(oCaster);

    return 0;
}

int UrPriestCL(object oCaster, int nCastingClass)
{
	// Add 1/2 levels in all other casting classes except cleric
    if (nCastingClass == CLASS_TYPE_UR_PRIEST)
    {
    	int nTotal = 0;
	    int iFirstDivine = GetPrimaryDivineClass(oCaster);
	    int iBest = 0;
	    int iClass1 = GetClassByPosition(1, oCaster);
	    int iClass2 = GetClassByPosition(2, oCaster);
	    int iClass3 = GetClassByPosition(3, oCaster);
	    int iClass1Lev = GetLevelByPosition(1, oCaster);
	    int iClass2Lev = GetLevelByPosition(2, oCaster);
	    int iClass3Lev = GetLevelByPosition(3, oCaster);
	
	    /*if (iClass1 == CLASS_TYPE_PALADIN || iClass1 == CLASS_TYPE_RANGER) iClass1Lev = (iClass1Lev >= 4) ? (iClass1Lev / 2) : 0;
	    if (iClass2 == CLASS_TYPE_PALADIN || iClass2 == CLASS_TYPE_RANGER) iClass2Lev = (iClass2Lev >= 4) ? (iClass2Lev / 2) : 0;
	    if (iClass3 == CLASS_TYPE_PALADIN || iClass3 == CLASS_TYPE_RANGER) iClass3Lev = (iClass3Lev >= 4) ? (iClass3Lev / 2) : 0;

	    if (iClass1 == iFirstDivine) iClass1Lev += GetDivinePRCLevels(oCaster);
	    if (iClass2 == iFirstDivine) iClass2Lev += GetDivinePRCLevels(oCaster);
	    if (iClass3 == iFirstDivine) iClass3Lev += GetDivinePRCLevels(oCaster);

	    iClass1Lev += PracticedSpellcasting(oCaster, iClass1, iClass1Lev);
	    iClass2Lev += PracticedSpellcasting(oCaster, iClass2, iClass2Lev);
	    iClass3Lev += PracticedSpellcasting(oCaster, iClass3, iClass3Lev);

	    if (!GetIsDivineClass(iClass1, oCaster) || iClass1 == CLASS_TYPE_UR_PRIEST) iClass1Lev = 0;
	    if (!GetIsDivineClass(iClass2, oCaster) || iClass2 == CLASS_TYPE_UR_PRIEST) iClass2Lev = 0;
	    if (!GetIsDivineClass(iClass3, oCaster) || iClass3 == CLASS_TYPE_UR_PRIEST) iClass3Lev = 0;
	    
	    nTotal += iClass1Lev + iClass2Lev + iClass3Lev;
	    if (DEBUG) DoDebug("UrPriestCL Divine - iClass1Lev "+IntToString(iClass1Lev)+" iClass2Lev "+IntToString(iClass2Lev)+" iClass3Lev "+IntToString(iClass3Lev));*/
	    
    	int iFirstArcane = GetPrimaryArcaneClass(oCaster);
    	iClass1 = GetClassByPosition(1, oCaster);
    	iClass2 = GetClassByPosition(2, oCaster);
    	iClass3 = GetClassByPosition(3, oCaster);
    	iClass1Lev = GetLevelByPosition(1, oCaster);
    	iClass2Lev = GetLevelByPosition(2, oCaster);
    	iClass3Lev = GetLevelByPosition(3, oCaster);

    	if (iClass1 == CLASS_TYPE_HEXBLADE) iClass1Lev = (iClass1Lev >= 4) ? (iClass1Lev / 2) : 0;
    	if (iClass2 == CLASS_TYPE_HEXBLADE) iClass2Lev = (iClass2Lev >= 4) ? (iClass2Lev / 2) : 0;
    	if (iClass3 == CLASS_TYPE_HEXBLADE) iClass3Lev = (iClass3Lev >= 4) ? (iClass3Lev / 2) : 0;

    	if (iClass1 == iFirstArcane) iClass1Lev += GetArcanePRCLevels(oCaster);
    	if (iClass2 == iFirstArcane) iClass2Lev += GetArcanePRCLevels(oCaster);
    	if (iClass3 == iFirstArcane) iClass3Lev += GetArcanePRCLevels(oCaster);

    	iClass1Lev += PracticedSpellcasting(oCaster, iClass1, iClass1Lev);
    	iClass2Lev += PracticedSpellcasting(oCaster, iClass2, iClass2Lev);
    	iClass3Lev += PracticedSpellcasting(oCaster, iClass3, iClass3Lev);

    	if (!GetIsArcaneClass(iClass1, oCaster)) iClass1Lev = 0;
    	if (!GetIsArcaneClass(iClass2, oCaster)) iClass2Lev = 0;
    	if (!GetIsArcaneClass(iClass3, oCaster)) iClass3Lev = 0;
    	
    	nTotal += iClass1Lev + iClass2Lev + iClass3Lev;
    	if (DEBUG) DoDebug("UrPriestCL Arcane - iClass1Lev "+IntToString(iClass1Lev)+" iClass2Lev "+IntToString(iClass2Lev)+" iClass3Lev "+IntToString(iClass3Lev));
    	if (DEBUG) DoDebug("UrPriestCL Total - nTotal "+IntToString(nTotal));
    	return nTotal/2;
    }
    return 0;
}

int BlighterCL(object oCaster, int nCastingClass)
{
    if (nCastingClass == CLASS_TYPE_BLIGHTER)
    {
        int nBonus = GetLevelByClass(CLASS_TYPE_DRUID, oCaster);
        return nBonus;
    }
    return 0;
}

int ReserveFeatCL(object oCaster, int iSpellId)
{
    int nSpellSchool = GetSpellSchool(iSpellId);
    int nCLBonus = 0;

    if (GetLocalInt(oCaster, "ReserveFeatsRunning") == TRUE)
    {
        if (GetHasDescriptor(iSpellId, DESCRIPTOR_ACID) && GetHasFeat(FEAT_ACIDIC_SPLATTER, oCaster)) nCLBonus += 1;
        if (GetHasDescriptor(iSpellId, DESCRIPTOR_FIRE) && GetHasFeat(FEAT_FIERY_BURST, oCaster)) nCLBonus += 1;
        if (GetHasDescriptor(iSpellId, DESCRIPTOR_COLD) && GetHasFeat(FEAT_WINTERS_BLAST, oCaster)) nCLBonus += 1;
        if (GetHasDescriptor(iSpellId, DESCRIPTOR_ELECTRICITY) && GetHasFeat(FEAT_STORM_BOLT, oCaster)) nCLBonus += 1;
        if (GetHasDescriptor(iSpellId, DESCRIPTOR_SONIC) && GetHasFeat(FEAT_CLAP_OF_THUNDER, oCaster)) nCLBonus += 1;
        if (GetIsOfSubschool(iSpellId, SUBSCHOOL_HEALING) && GetHasFeat(FEAT_TOUCH_OF_HEALING, oCaster)) nCLBonus += 1;
        if (GetIsOfSubschool(iSpellId, SUBSCHOOL_TELEPORTATION) && GetHasFeat(FEAT_DIMENSIONAL_JAUNT, oCaster)) nCLBonus += 1;
        if (nSpellSchool == SPELL_SCHOOL_ABJURATION && GetHasFeat(FEAT_MYSTIC_BACKLASH, oCaster)) nCLBonus += 1;
        if (nSpellSchool == SPELL_SCHOOL_NECROMANCY && GetHasFeat(FEAT_SICKENING_GRASP, oCaster)) nCLBonus += 1;
        if (GetIsFromDomain(iSpellId, "wardom") && GetHasFeat(FEAT_HOLY_WARRIOR, oCaster)) nCLBonus += 1;
        if (GetHasDescriptor(iSpellId, DESCRIPTOR_EARTH) && GetHasFeat(FEAT_CLUTCH_OF_EARTH, oCaster)) nCLBonus += 1;
        if (GetHasDescriptor(iSpellId, DESCRIPTOR_AIR) && GetHasFeat(FEAT_BORNE_ALOFT, oCaster)) nCLBonus += 1;
        if ((nSpellSchool == SPELL_SCHOOL_ABJURATION) && GetHasFeat(FEAT_PROTECTIVE_WARD, oCaster)) nCLBonus += 1;
        if (GetHasDescriptor(iSpellId, DESCRIPTOR_DARKNESS) && GetHasFeat(FEAT_SHADOW_VEIL, oCaster)) nCLBonus += 1;
        if (GetHasDescriptor(iSpellId, DESCRIPTOR_LIGHT) && GetHasFeat(FEAT_SUNLIGHT_EYES, oCaster)) nCLBonus += 1;
        if ((nSpellSchool == SPELL_SCHOOL_ENCHANTMENT) && GetHasFeat(FEAT_TOUCH_OF_DISTRACTION, oCaster)) nCLBonus += 1;
        if (GetIsFromDomain(iSpellId, "dethdom") && GetHasFeat(FEAT_CHARNEL_MIASMA, oCaster)) nCLBonus += 1;
        if (GetHasDescriptor(iSpellId, DESCRIPTOR_WATER) && GetHasFeat(FEAT_DROWNING_GLANCE, oCaster)) nCLBonus += 1;
        if (GetHasDescriptor(iSpellId, DESCRIPTOR_FORCE) && GetHasFeat(FEAT_INVISIBLE_NEEDLE, oCaster)) nCLBonus += 1;
        if (GetIsOfSubschool(iSpellId, SUBSCHOOL_SUMMONING) && GetHasFeat(FEAT_SUMMON_ELEMENTAL, oCaster)) nCLBonus += 1;
        if (GetIsOfSubschool(iSpellId, SUBSCHOOL_SUMMONING) && GetHasFeat(FEAT_DIMENSIONAL_REACH, oCaster)) nCLBonus += 1;
        if (GetHasDescriptor(iSpellId, DESCRIPTOR_AIR) && GetHasFeat(FEAT_HURRICANE_BREATH, oCaster)) nCLBonus += 1;
        if (GetIsOfSubschool(iSpellId, SUBSCHOOL_POLYMORPH) && GetHasFeat(FEAT_MINOR_SHAPESHIFT, oCaster)) nCLBonus += 1;
        if (GetIsOfSubschool(iSpellId, SUBSCHOOL_GLAMER) && GetHasFeat(FEAT_FACECHANGER, oCaster)) nCLBonus += 1;
        return nCLBonus;
    }
    else return 0;
}

int GetLevelByTypeArcane(object oCaster = OBJECT_SELF)
{
    int iFirstArcane = GetPrimaryArcaneClass(oCaster);
    int iBest = 0;
    int iClass1 = GetClassByPosition(1, oCaster);
    int iClass2 = GetClassByPosition(2, oCaster);
    int iClass3 = GetClassByPosition(3, oCaster);
    int iClass1Lev = GetLevelByPosition(1, oCaster);
    int iClass2Lev = GetLevelByPosition(2, oCaster);
    int iClass3Lev = GetLevelByPosition(3, oCaster);

    if (iClass1 == CLASS_TYPE_HEXBLADE) iClass1Lev = (iClass1Lev >= 4) ? (iClass1Lev / 2) : 0;
    if (iClass2 == CLASS_TYPE_HEXBLADE) iClass2Lev = (iClass2Lev >= 4) ? (iClass2Lev / 2) : 0;
    if (iClass3 == CLASS_TYPE_HEXBLADE) iClass3Lev = (iClass3Lev >= 4) ? (iClass3Lev / 2) : 0;

    if (iClass1 == iFirstArcane) iClass1Lev += GetArcanePRCLevels(oCaster);
    if (iClass2 == iFirstArcane) iClass2Lev += GetArcanePRCLevels(oCaster);
    if (iClass3 == iFirstArcane) iClass3Lev += GetArcanePRCLevels(oCaster);

    iClass1Lev += PracticedSpellcasting(oCaster, iClass1, iClass1Lev);
    iClass2Lev += PracticedSpellcasting(oCaster, iClass2, iClass2Lev);
    iClass3Lev += PracticedSpellcasting(oCaster, iClass3, iClass3Lev);

    if (!GetIsArcaneClass(iClass1, oCaster)) iClass1Lev = 0;
    if (!GetIsArcaneClass(iClass2, oCaster)) iClass2Lev = 0;
    if (!GetIsArcaneClass(iClass3, oCaster)) iClass3Lev = 0;

    if (iClass1Lev > iBest) iBest = iClass1Lev;
    if (iClass2Lev > iBest) iBest = iClass2Lev;
    if (iClass3Lev > iBest) iBest = iClass3Lev;

    return iBest;
}

int GetLevelByTypeDivine(object oCaster = OBJECT_SELF)
{
    int iFirstDivine = GetPrimaryDivineClass(oCaster);
    int iBest = 0;
    int iClass1 = GetClassByPosition(1, oCaster);
    int iClass2 = GetClassByPosition(2, oCaster);
    int iClass3 = GetClassByPosition(3, oCaster);
    int iClass1Lev = GetLevelByPosition(1, oCaster);
    int iClass2Lev = GetLevelByPosition(2, oCaster);
    int iClass3Lev = GetLevelByPosition(3, oCaster);

    if (iClass1 == CLASS_TYPE_PALADIN || iClass1 == CLASS_TYPE_RANGER) iClass1Lev = (iClass1Lev >= 4) ? (iClass1Lev / 2) : 0;
    if (iClass2 == CLASS_TYPE_PALADIN || iClass2 == CLASS_TYPE_RANGER) iClass2Lev = (iClass2Lev >= 4) ? (iClass2Lev / 2) : 0;
    if (iClass3 == CLASS_TYPE_PALADIN || iClass3 == CLASS_TYPE_RANGER) iClass3Lev = (iClass3Lev >= 4) ? (iClass3Lev / 2) : 0;

    if (iClass1 == iFirstDivine) iClass1Lev += GetDivinePRCLevels(oCaster);
    if (iClass2 == iFirstDivine) iClass2Lev += GetDivinePRCLevels(oCaster);
    if (iClass3 == iFirstDivine) iClass3Lev += GetDivinePRCLevels(oCaster);

    iClass1Lev += PracticedSpellcasting(oCaster, iClass1, iClass1Lev);
    iClass2Lev += PracticedSpellcasting(oCaster, iClass2, iClass2Lev);
    iClass3Lev += PracticedSpellcasting(oCaster, iClass3, iClass3Lev);

    if (!GetIsDivineClass(iClass1, oCaster)) iClass1Lev = 0;
    if (!GetIsDivineClass(iClass2, oCaster)) iClass2Lev = 0;
    if (!GetIsDivineClass(iClass3, oCaster)) iClass3Lev = 0;

    if (iClass1Lev > iBest) iBest = iClass1Lev;
    if (iClass2Lev > iBest) iBest = iClass2Lev;
    if (iClass3Lev > iBest) iBest = iClass3Lev;

    return iBest;
}