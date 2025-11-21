//Reserve Feat Script
//prc_reservefeat
//by ebonfowl 5/5/2022
//Dedicated to Edgar, the real ebonfowl

//Lookup constants
//Domains
const string RESERVESPELL_DOMAIN_DESTRUCTION             = "destruc";
const string RESERVESPELL_DOMAIN_DEATH                   = "dethdom";
const string RESERVESPELL_DOMAIN_WAR                     = "wardom";

//Descriptors
const string RESERVESPELL_DESCRIPTOR_ACID                = "acid";
const string RESERVESPELL_DESCRIPTOR_AIR                 = "air";
const string RESERVESPELL_DESCRIPTOR_COLD                = "cold";
const string RESERVESPELL_DESCRIPTOR_DARKNESS            = "darknes";
const string RESERVESPELL_DESCRIPTOR_EARTH               = "earth";
const string RESERVESPELL_DESCRIPTOR_ELECTRICITY         = "electri";
const string RESERVESPELL_DESCRIPTOR_FIRE                = "fire";
const string RESERVESPELL_DESCRIPTOR_FORCE               = "force";
const string RESERVESPELL_DESCRIPTOR_GLAMER              = "glamer";
const string RESERVESPELL_DESCRIPTOR_HEALING             = "healing";
const string RESERVESPELL_DESCRIPTOR_LIGHT               = "light";
const string RESERVESPELL_DESCRIPTOR_POLYMORPH           = "polymor";
const string RESERVESPELL_DESCRIPTOR_SONIC               = "sonic";
const string RESERVESPELL_DESCRIPTOR_SUMMONING           = "summon";
const string RESERVESPELL_DESCRIPTOR_TELEPORTATION       = "teleprt";
const string RESERVESPELL_DESCRIPTOR_WATER               = "water";

//Schools
const string RESERVESPELL_SCHOOL_ABJURATION              = "abjurat";
const string RESERVESPELL_SCHOOL_ENCHANTMENT             = "enchant";
const string RESERVESPELL_SCHOOL_NECROMANCY              = "necro";


//Includes
#include "prc_feat_const"
#include "prc_x2_itemprop"
#include "psi_inc_psifunc"

//ebonfowl: this function is not currently used, but I am leaving it in just in case
/*
int GetHighestSpellAvailable(object oPC)
{
    //This will loop all the spells and return the highest level available to cast
    string sFile = "prc_all"; //May need to rename

    int i;
    int nSpellID;
    int nNewSpellLevel;
    int nSpellLevel = 0;

    string sSpellLabel;

    for (i = 0; i < 500; i++) // Adjust max i to reflect something close to the highest row number in the 2das
    {
        nSpellID = StringToInt(Get2DACache(sFile, "SpellID", i));
        sSpellLabel = Get2DACache(sFile, "Label", i);
        if(sSpellLabel != "") // Non-blank row
        {
            if(PRCGetHasSpell(nSpellID, oPC))
            {
                nNewSpellLevel = StringToInt(Get2DACache(sFile, "Innate", i));
                if (nNewSpellLevel > nSpellLevel) nSpellLevel = nNewSpellLevel;
            }    
        }
    }
    return nSpellLevel;
}
*/

int GetHighestSpellAvailableBySchool(object oPC, string sSchool)
{
    //This will loop all spells fpr a given school and return the highest level available to cast
    string sFile = "prc_desc_" + sSchool;

    int i;
    int nSpellID;
    int nNewSpellLevel;
    int nSpellLevel = 0;

    string sSpellLabel;

    for (i = 0; i < 126; i++) // Adjust max i to reflect something close to the highest row number in the 2das
    {
        nSpellID = StringToInt(Get2DACache(sFile, "SpellID", i));
        sSpellLabel = Get2DACache(sFile, "Label", i);
        if(sSpellLabel != "") // Non-blank row
        {
            if(PRCGetHasSpell(nSpellID, oPC))
            {
                nNewSpellLevel = StringToInt(Get2DACache(sFile, "Innate", i));
                if (nNewSpellLevel > nSpellLevel) nSpellLevel = nNewSpellLevel;
            }    
        }
    }
    return nSpellLevel;
}

int GetHighestDomainSpellAvailable(object oPC, string sDomain)  //This will loop all domain spells for a given domain and return the highest level available to cast
{
    string sFile = "prc_desc_" + sDomain;

    int i;
    int nSpellID;
    int nNewSpellLevel;
    int nSpellLevel = 0;

    string sSpellLabel;

    for (i = 0; i < 12; i++) // Adjust max i to reflect something close to the highest row number in the 2das
    {
        nSpellID = StringToInt(Get2DACache(sFile, "SpellID", i));
        sSpellLabel = Get2DACache(sFile, "Label", i);
        if(sSpellLabel != "") // Non-blank row
        {
            if(PRCGetHasSpell(nSpellID, oPC))
            {
                nNewSpellLevel = StringToInt(Get2DACache(sFile, "Innate", i));
                if (nNewSpellLevel > nSpellLevel) nSpellLevel = nNewSpellLevel;
            }    
        }
    }
    return nSpellLevel;
}

int GetHighestSpellAvailableByDescriptor(object oPC, string sDescriptor)
{
    //This will loop all spells fpr a given descriptor and return the highest level available to cast
    string sFile = "prc_desc_" + sDescriptor;

    int i;
    int nSpellID;
    int nNewSpellLevel;
    int nSpellLevel = 0;

    string sSpellLabel;

    for (i = 0; i < 125; i++) // Adjust max i to reflect something close to the highest row number in the 2das
    {
        nSpellID = StringToInt(Get2DACache(sFile, "SpellID", i));
        sSpellLabel = Get2DACache(sFile, "Label", i);
        if(sSpellLabel != "") // Non-blank row
        {
			if (DEBUG) DoDebug("GetHighestSpellAvailableByDescriptor >> Entered function.");
			if (DEBUG) DoDebug("Row " + IntToString(i) + 
                " Label = " + sSpellLabel + 
                " SpellID = " + IntToString(nSpellID) + 
                " HasSpell  " + IntToString(PRCGetHasSpell(nSpellID, oPC)));
				
            if(PRCGetHasSpell(nSpellID, oPC))
            {
                nNewSpellLevel = StringToInt(Get2DACache(sFile, "Innate", i));
                if (nNewSpellLevel > nSpellLevel) nSpellLevel = nNewSpellLevel;
            }    
        }
    }
    return nSpellLevel;
}

void UpdateReserveFeats(object oPC)  //This will check for each reserve feat, call the function to set the bonus, then set the bonus
{
    object oWeapon, oOffHand;
    
    int nBonus;
    int nDamage;

    effect eEffect;
    effect eCheckEffect;

    string sTag;
    
    //Holy Warrior
    if (GetHasFeat(FEAT_HOLY_WARRIOR, oPC)) //Update constant when feat constant is made
    {
        nBonus = GetHighestDomainSpellAvailable(oPC, RESERVESPELL_DOMAIN_WAR);
        nDamage = IPGetDamageBonusConstantFromNumber(nBonus);
        oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        oOffHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
        eEffect = EffectDamageIncrease(nDamage, DAMAGE_TYPE_SLASHING);
        eEffect = TagEffect(eEffect, "HolyWarriorBonus");
        eEffect = SupernaturalEffect(eEffect);
        eCheckEffect = GetFirstEffect(oPC);
            
        while (GetIsEffectValid(eCheckEffect))
        {
            if (GetEffectTag(eCheckEffect) == "HolyWarriorBonus")
            {
                RemoveEffect(oPC, eCheckEffect);
            }
            eCheckEffect = GetNextEffect(oPC);
        }

        if (IPGetIsMeleeWeapon(oWeapon) || 
            IPGetIsMeleeWeapon(oOffHand) || 
            GetWeaponRanged(oWeapon) || 
            GetWeaponRanged(oOffHand))
        {
            if (nBonus > 3) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oPC);
        }
    }

    //Mystic Backlash
    if (GetHasFeat(FEAT_MYSTIC_BACKLASH, oPC)) //Update constant when feat constant is made
    {
        nBonus = GetHighestSpellAvailableBySchool(oPC, RESERVESPELL_SCHOOL_ABJURATION);
        DeleteLocalInt(oPC, "MysticBacklashBonus");
        
        if (nBonus > 4) SetLocalInt(oPC, "MysticBacklashBonus", nBonus);
    }

    //Acidic Splatter
    if(GetHasFeat(FEAT_ACIDIC_SPLATTER, oPC))
    {
        nBonus = GetHighestSpellAvailableByDescriptor(oPC, RESERVESPELL_DESCRIPTOR_ACID);
		
		if((GetHasSpell(SPELL_ACID_FOG, oPC)) || (PRCGetIsRealSpellKnown(SPELL_ACID_FOG, oPC)))
        {
			nBonus = 6;
		}
			
        DeleteLocalInt(oPC, "AcidicSplatterBonus");

        if (nBonus > 1) SetLocalInt(oPC, "AcidicSplatterBonus", nBonus);
    }

    //Fiery Burst
    if(GetHasFeat(FEAT_FIERY_BURST, oPC))
    {
        nBonus = GetHighestSpellAvailableByDescriptor(oPC, RESERVESPELL_DESCRIPTOR_FIRE);
        DeleteLocalInt(oPC, "FieryBurstBonus");

        if (nBonus > 1) SetLocalInt(oPC, "FieryBurstBonus", nBonus);
    }

    //Storm Bolt
    if(GetHasFeat(FEAT_STORM_BOLT, oPC))
    {
        nBonus = GetHighestSpellAvailableByDescriptor(oPC, RESERVESPELL_DESCRIPTOR_ELECTRICITY);
        DeleteLocalInt(oPC, "StormBoltBonus");

        if (nBonus > 2) SetLocalInt(oPC, "StormBoltBonus", nBonus);
    }

    //Winter's Blast
    if(GetHasFeat(FEAT_WINTERS_BLAST, oPC))
    {
        nBonus = GetHighestSpellAvailableByDescriptor(oPC, RESERVESPELL_DESCRIPTOR_COLD);
        DeleteLocalInt(oPC, "WintersBlastBonus");

        if (nBonus > 1) SetLocalInt(oPC, "WintersBlastBonus", nBonus);
    }

    //Clap of Thunder
    if(GetHasFeat(FEAT_CLAP_OF_THUNDER, oPC))
    {
        nBonus = GetHighestSpellAvailableByDescriptor(oPC, RESERVESPELL_DESCRIPTOR_SONIC);
        DeleteLocalInt(oPC, "ClapOfThunderBonus");

        if (nBonus > 2) SetLocalInt(oPC, "ClapOfThunderBonus", nBonus);
    }

    //Sickening Grasp
    if (GetHasFeat(FEAT_SICKENING_GRASP, oPC)) //Update constant when feat constant is made
    {
        nBonus = GetHighestSpellAvailableBySchool(oPC, RESERVESPELL_SCHOOL_NECROMANCY);
        DeleteLocalInt(oPC, "SickeningGraspBonus");
        
        if (nBonus > 2) SetLocalInt(oPC, "SickeningGraspBonus", nBonus);
    }

    //Touch of Healing
    if(GetHasFeat(FEAT_TOUCH_OF_HEALING, oPC))
    {
        nBonus = GetHighestSpellAvailableByDescriptor(oPC, RESERVESPELL_DESCRIPTOR_HEALING);
        DeleteLocalInt(oPC, "TouchOfHealingBonus");

        if (nBonus > 1) SetLocalInt(oPC, "TouchOfHealingBonus", nBonus);
    }

    //Dimensional Jaunt
    if(GetHasFeat(FEAT_DIMENSIONAL_JAUNT, oPC))
    {
        nBonus = GetHighestSpellAvailableByDescriptor(oPC, RESERVESPELL_DESCRIPTOR_TELEPORTATION);
        DeleteLocalInt(oPC, "DimensionalJauntBonus");

        if (nBonus > 3) SetLocalInt(oPC, "DimensionalJauntBonus", nBonus);
    }

    //Clutch of Earth
    if(GetHasFeat(FEAT_CLUTCH_OF_EARTH, oPC))
    {
        nBonus = GetHighestSpellAvailableByDescriptor(oPC, RESERVESPELL_DESCRIPTOR_EARTH);
        DeleteLocalInt(oPC, "ClutchOfEarthBonus");

        if (nBonus > 1) SetLocalInt(oPC, "ClutchOfEarthBonus", nBonus);
    }

    //Borne Aloft
    if(GetHasFeat(FEAT_BORNE_ALOFT, oPC))
    {
        nBonus = GetHighestSpellAvailableByDescriptor(oPC, RESERVESPELL_DESCRIPTOR_AIR);
        DeleteLocalInt(oPC, "BorneAloftBonus");

        if (nBonus > 4) SetLocalInt(oPC, "BorneAloftBonus", nBonus);
    }

    //Protective Ward
    if (GetHasFeat(FEAT_PROTECTIVE_WARD, oPC))
    {
        nBonus = GetHighestSpellAvailableBySchool(oPC, RESERVESPELL_SCHOOL_ABJURATION);
        DeleteLocalInt(oPC, "ProtectiveWardBonus");
        
        if (nBonus > 0) SetLocalInt(oPC, "ProtectiveWardBonus", nBonus);
    }

    //Shadow Veil
    if(GetHasFeat(FEAT_SHADOW_VEIL, oPC))
    {
        nBonus = GetHighestSpellAvailableByDescriptor(oPC, RESERVESPELL_DESCRIPTOR_DARKNESS);
        DeleteLocalInt(oPC, "ShadowVeilBonus");

        if (nBonus > 1) SetLocalInt(oPC, "ShadowVeilBonus", nBonus);
    }

    //Sunlight Eyes
    if(GetHasFeat(FEAT_SUNLIGHT_EYES, oPC))
    {
        nBonus = GetHighestSpellAvailableByDescriptor(oPC, RESERVESPELL_DESCRIPTOR_LIGHT);
        DeleteLocalInt(oPC, "SunlightEyesBonus");

        if (nBonus > 1) SetLocalInt(oPC, "SunlightEyesBonus", nBonus);
    }

    //Touch of Distraction
    if (GetHasFeat(FEAT_TOUCH_OF_DISTRACTION, oPC))
    {
        nBonus = GetHighestSpellAvailableBySchool(oPC, RESERVESPELL_SCHOOL_ENCHANTMENT);
        DeleteLocalInt(oPC, "TouchOfDistractionBonus");
        
        if (nBonus > 2) SetLocalInt(oPC, "TouchOfDistractionBonus", nBonus);
    }

    //Umbral Shroud
    if(GetHasFeat(FEAT_UMBRAL_SHROUD, oPC))
    {
        nBonus = GetHighestSpellAvailableByDescriptor(oPC, RESERVESPELL_DESCRIPTOR_DARKNESS);
        DeleteLocalInt(oPC, "UmbralShroudBonus");

        if (nBonus > 2) SetLocalInt(oPC, "UmbralShroudBonus", nBonus);
    }

    //Charnel Miasma
    if(GetHasFeat(FEAT_CHARNEL_MIASMA, oPC))
    {
        nBonus = GetHighestDomainSpellAvailable(oPC, RESERVESPELL_DOMAIN_DEATH);
        DeleteLocalInt(oPC, "CharnelMiasmaBonus");

        if (nBonus > 1) SetLocalInt(oPC, "CharnelMiasmaBonus", nBonus);
    }

    //Drowning Glance
    if(GetHasFeat(FEAT_DROWNING_GLANCE, oPC))
    {
        nBonus = GetHighestSpellAvailableByDescriptor(oPC, RESERVESPELL_DESCRIPTOR_WATER);
        DeleteLocalInt(oPC, "DrowningGlanceBonus");

        if (nBonus > 3) SetLocalInt(oPC, "DrowningGlanceBonus", nBonus);
    }

    //Invisible Needle
    if(GetHasFeat(FEAT_INVISIBLE_NEEDLE, oPC))
    {
        nBonus = GetHighestSpellAvailableByDescriptor(oPC, RESERVESPELL_DESCRIPTOR_FORCE);
        DeleteLocalInt(oPC, "InvisibleNeedleBonus");

        if (nBonus > 2) SetLocalInt(oPC, "InvisibleNeedleBonus", nBonus);
    }

    //Summon Elemental
    if(GetHasFeat(FEAT_SUMMON_ELEMENTAL, oPC))
    {
        nBonus = GetHighestSpellAvailableByDescriptor(oPC, RESERVESPELL_DESCRIPTOR_SUMMONING);
        DeleteLocalInt(oPC, "SummonElementalBonus");

        if (nBonus > 3) SetLocalInt(oPC, "SummonElementalBonus", nBonus);
    }

    //Dimensional Reach
    if(GetHasFeat(FEAT_DIMENSIONAL_REACH, oPC))
    {
        nBonus = GetHighestSpellAvailableByDescriptor(oPC, RESERVESPELL_DESCRIPTOR_SUMMONING);
        DeleteLocalInt(oPC, "DimensionalReachBonus");

        if (nBonus > 2) SetLocalInt(oPC, "DimensionalReachBonus", nBonus);
    }

    //Hurricane Breath
    if(GetHasFeat(FEAT_HURRICANE_BREATH, oPC))
    {
        nBonus = GetHighestSpellAvailableByDescriptor(oPC, RESERVESPELL_DESCRIPTOR_AIR);
        DeleteLocalInt(oPC, "HurricaneBreathBonus");

        if (nBonus > 1) SetLocalInt(oPC, "HurricaneBreathBonus", nBonus);
    }

    //Minor Shapeshift
    if(GetHasFeat(FEAT_MINOR_SHAPESHIFT, oPC))
    {
        nBonus = GetHighestSpellAvailableByDescriptor(oPC, RESERVESPELL_DESCRIPTOR_POLYMORPH);
        DeleteLocalInt(oPC, "MinorShapeshiftBonus");

        if (nBonus > 3) SetLocalInt(oPC, "MinorShapeshiftBonus", nBonus);
    }

    //Face-Changer
    if(GetHasFeat(FEAT_FACECHANGER, oPC))
    {
        nBonus = GetHighestSpellAvailableByDescriptor(oPC, RESERVESPELL_DESCRIPTOR_GLAMER);
        DeleteLocalInt(oPC, "FaceChangerBonus");

        if (nBonus > 2) SetLocalInt(oPC, "FaceChangerBonus", nBonus);
    }
}

void main()
{
    object oPC = OBJECT_SELF;
    
    if(!GetLocalInt(oPC, "ReserveFeatsRunning"))
    {
        SetLocalInt(oPC, "ReserveFeatsRunning", TRUE);

        //Hook this script into event system so it runs on hooked events
        AddEventScript(oPC, EVENT_ONACTIVATEITEM, "prc_reservefeat", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONACQUIREITEM, "prc_reservefeat", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONCLIENTENTER, "prc_reservefeat", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONCLIENTLEAVE, "prc_reservefeat", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERLEVELDOWN, "prc_reservefeat", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERLEVELUP, "prc_reservefeat", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERRESPAWN, "prc_reservefeat", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM, "prc_reservefeat", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_reservefeat", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONUNAQUIREITEM, "prc_reservefeat", TRUE, FALSE);

        //Update the feat bonuses
        UpdateReserveFeats(oPC);
    }
    else
    {
        UpdateReserveFeats(oPC);
    }
}