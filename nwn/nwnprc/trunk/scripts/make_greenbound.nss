/* Greenbound Creature Template

	By: Jaysyn 
	Created: 2025-09-06 22:24:15
	
	A greenbound creature looks much like it did before 
	transformation, although certain changes are apparent. 
	The creature's flesh has been replaced by pulpy wood 
	and thickly corded creepers, and tiny branches stick 
	out from its torso, arms, and legs. Any feathers, hair, 
	or fur it once had have been replaced by some combination 
	of green vines, moss, flowers, and leaves.

	Greenbound creatures speak any languages they knew before 
	transformation, although their voices are now deep and 
	gravelly.

/*///////////////////////////////////////////////////////////

#include "nw_inc_gff"
#include "prc_inc_spells"
#include "prc_inc_util"
#include "inc_debug"
#include "prc_inc_json"

//:: Adds Greenbound SLA's to jCreature.
//::
json json_AddGreenboundPowers(json jCreature)
{
    // Get the existing SpecAbilityList (if it exists)
    json jSpecAbilityList = GffGetList(jCreature, "SpecAbilityList");
	
	//:: Get creature's HD
	int iHD = json_GetCreatureHD(jCreature);

    // Create the SpecAbilityList if it doesn't exist
    if (jSpecAbilityList == JsonNull())
    {
        jSpecAbilityList = JsonArray();
    }
    
//:: Add Entangle at will (capped @ 20)
	int i;
    for (i = 0; i < 20; i++)
    {
        json jSpecAbility = JsonObject();
        jSpecAbility = GffAddWord(jSpecAbility, "Spell", 53);
        jSpecAbility = GffAddByte(jSpecAbility, "SpellCasterLevel", iHD);
        jSpecAbility = GffAddByte(jSpecAbility, "SpellFlags", 1);

        // Manually add to the array
        jSpecAbilityList = JsonArrayInsert(jSpecAbilityList, jSpecAbility);
    }

//:: Add Vine Mine 1x / Day
    for (i = 0; i < 1; i++)
    {
        json jSpecAbility = JsonObject();
        jSpecAbility = GffAddWord(jSpecAbility, "Spell", 529);
        jSpecAbility = GffAddByte(jSpecAbility, "SpellCasterLevel", iHD);
        jSpecAbility = GffAddByte(jSpecAbility, "SpellFlags", 1);
        
        // Manually add to the array
        jSpecAbilityList = JsonArrayInsert(jSpecAbilityList, jSpecAbility);
    }

//:: Add the list to the creature
    jCreature = GffAddList(jCreature, "SpecAbilityList", jSpecAbilityList);
	
	return jCreature;
}

//:: Apply Greenbound effects
void ApplyGreenboundEffects(object oCreature, int nBaseHD) 
{
//:: Declare major variables	
	int nNewCR;
	object oSkin	= GetPCSkin(oCreature);
	
	itemproperty ipIP;
	
	effect eGreenbound;
	
//:: Give it a barkskin vfx
	eGreenbound = EffectLinkEffects(eGreenbound, EffectVisualEffect(VFX_DUR_PROT_BARKSKIN));
	
//:: Plant Immunities
	eGreenbound = EffectLinkEffects(eGreenbound, EffectImmunity(IMMUNITY_TYPE_STUN));
	
	ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS);
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

	ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON);
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

	ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS);
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

	ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS);
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	
	ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB);
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

//:: Set maximum hit points for each HD
	int nMaxHP = GetMaxPossibleHP(oCreature);
    SetCurrentHitPoints(oCreature, nMaxHP);
	
	if(DEBUG) DoDebug("nMaxHP is: "+IntToString(nMaxHP)+",");
	
//:: Resistance to Cold and Electricity (Ex): A greenbound creature gains resistance 10 to cold and electricity.
    eGreenbound = EffectLinkEffects(eGreenbound, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 10));
    eGreenbound = EffectLinkEffects(eGreenbound, EffectDamageResistance(DAMAGE_TYPE_COLD, 10));

//:: Damage Reduction (Ex): A greenbound creature has damage reduction 10/magic and slashing.
    eGreenbound = EffectLinkEffects(eGreenbound, EffectDamageReduction(10, DAMAGE_POWER_PLUS_ONE));
	eGreenbound = EffectLinkEffects(eGreenbound, EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 10));
	eGreenbound = EffectLinkEffects(eGreenbound, EffectDamageResistance(DAMAGE_TYPE_PIERCING, 10));

//:: Fast Healing (Ex): A greenbound creature heals 3 points of damage each round so long as it has at least 1 hit point.
    eGreenbound = EffectLinkEffects(eGreenbound, EffectRegenerate(3, 6.0f));

//:: Tremorsense (Ex): Greenbound creatures can automatically sense the location of 
//:: anything within 60 feet that is in contact with the ground.	
	eGreenbound = EffectLinkEffects(eGreenbound, EffectBonusFeat(488));

//:: Grapple Bonus (Ex): The thorny hooks on a greenbound creature's hands and feet 
//:: grant it a +4 bonus on grapple checks. (Imp. Grapple)
	eGreenbound = EffectLinkEffects(eGreenbound, EffectBonusFeat(2804));

//:: Immunity to Critical Hits	
	eGreenbound = EffectLinkEffects(eGreenbound, EffectBonusFeat(3585));
	
//:: Immunity to Sneak Attack	
	eGreenbound = EffectLinkEffects(eGreenbound, EffectBonusFeat(3591));
	
//:: Immunity to Poison	
	eGreenbound = EffectLinkEffects(eGreenbound, EffectBonusFeat(3590));	

//:: Immunity to Mind Effects	
	eGreenbound = EffectLinkEffects(eGreenbound, EffectBonusFeat(3588));	
	
//:: Low-Light Vision	
	eGreenbound = EffectLinkEffects(eGreenbound, EffectBonusFeat(354));		
	
//:: Make *really* permanent	
	eGreenbound = UnyieldingEffect(eGreenbound);
	
//:: Apply everything	
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGreenbound, oCreature);	
	
//:: Add slam attack
	string sResRef;
	int nSize = PRCGetCreatureSize(oCreature);
	//primary weapon
	sResRef = "prc_warf_slam_";
	sResRef += GetAffixForSize(nSize+1);
	AddNaturalPrimaryWeapon(oCreature, sResRef, 1);
	
}


void main ()
{
//:: Declare major variables
	object oBaseCreature = OBJECT_SELF;
	object oNewCreature;
	
	string sBaseName = GetName(oBaseCreature);
	
	GetObjectUUID(oBaseCreature);
	
	int nRacial = MyPRCGetRacialType(oBaseCreature);
		
	//:: No Template Stacking
	if(GetLocalInt(oBaseCreature, "TEMPLATE_GREENBOUND") > 0)
	{
		DoDebug("No Template Stacking");
		return;
	}
	
	//:: Creatures & NPCs only
	if ((GetObjectType(oBaseCreature) != OBJECT_TYPE_CREATURE) || (GetIsPC(oBaseCreature) == TRUE))
	{ 
		DoDebug("Not a creature");
		return;
	}	
/* 	

	A "greenbound creature" is an acquired template that can be added to
	any animal, fey, giant, humanoid, monstrous humanoid, or vermin.

*/
	if(nRacial == RACIAL_TYPE_ABERRATION || nRacial == RACIAL_TYPE_CONSTRUCT || nRacial == RACIAL_TYPE_DRAGON || 
		nRacial == RACIAL_TYPE_ELEMENTAL || nRacial == RACIAL_TYPE_MAGICAL_BEAST || nRacial == RACIAL_TYPE_OOZE || 
		nRacial == RACIAL_TYPE_OUTSIDER || nRacial == RACIAL_TYPE_PLANT || nRacial == RACIAL_TYPE_UNDEAD )
	{
		DoDebug("make_greenbound: Invalid racial type for template.");
		return;
	}			
	
	int nBaseHD = GetHitDice(oBaseCreature);
	int nBaseCR = FloatToInt(GetChallengeRating(oBaseCreature));
	
	location lSpawnLoc = GetLocation(oBaseCreature);
	
	json jBaseCreature = ObjectToJson(oBaseCreature, TRUE);
	json jNewCreature;
	json jFinalCreature;

//:: The creature's type changes to plant with the appropriate augmented subtype.
	jNewCreature = json_ModifyRacialType(jBaseCreature, RACIAL_TYPE_PLANT);

//:: Armor Class: A greenbound creature's natural armor bonus improves by 6 over that of the base creature.	
	jNewCreature = json_IncreaseBaseAC(jNewCreature, 6);

//:: Abilities: Increase from the base creature as follows: Str +6, Dex +2, Con +4, Cha +4.	
	jNewCreature = json_UpdateTemplateStats(jNewCreature, 6, 2, 4, 0, 0, 4);
	
	if (GetIsObjectValid(oBaseCreature))
	{
		AssignCommand(oBaseCreature, ClearAllActions(TRUE));

		// optional fade / vanish visuals
		effect eBlank = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlank, oBaseCreature, 6.0f);

		DestroyObject(oBaseCreature, 0.1f);
	}

//:: Spell-Like Abilities: At will - entangle, pass without trace, speak with plants; 1/day - wall of thorns.
	jNewCreature = json_AddGreenboundPowers(jNewCreature);

//:: Hit Dice: Change all current Hit Dice to d8s.
	jNewCreature = json_RecalcMaxHP(jNewCreature, 8);
	
//:: Challenge Rating: Same as the base creature +2	
	jFinalCreature = json_UpdateCR(jNewCreature, nBaseCR, 2);	
		
//:: Update the creature
    oNewCreature = JsonToObject(jFinalCreature, lSpawnLoc);	
	
//:: Apply the non-json effects	
	ApplyGreenboundEffects(oNewCreature, nBaseHD);
	
//:: Update creature's name
	SetName(oNewCreature, "Greenbound "+ sBaseName);

//:: Update race field	
	SetSubRace(oNewCreature, "Plant (Augmented)");
	
//:: Freshen Up
	//DelayCommand(0.0f, PRCForceRest(oNewCreature));

//:: Set variables	
	SetLocalInt(oNewCreature, "TEMPLATE_GREENBOUND", 1);	
}