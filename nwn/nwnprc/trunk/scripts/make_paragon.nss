/* Paragon Creature Template

	By: Jaysyn 
	Created: 2024-11-14 08:27:30	

	Among the population of every kind of creature are 
	some specimens that are its weakest, worst representatives. 
	Likewise, every population has its paragons: the strongest, 
	smartest, luckiest, and most powerful of the species. 
	Paragon creatures may represent the mythical First Creature, 
	created in its perfect form by some creator deity, or 
	perhaps the evolutionary endpoint of a race after 
	thousands of years of steady improvement. Sometimes, 
	paragons just spring up accidentally, when all the factors 
	are right. 
*/

#include "nw_inc_gff"
#include "prc_inc_spells"
#include "prc_inc_util"
#include "npc_template_inc"
#include "inc_debug"
#include "prc_inc_json"

void main ()
{
//:: Declare major variables
	object oBaseCreature = OBJECT_SELF;
	object oNewCreature;
	
	location lSpawnLoc = GetLocation(oBaseCreature);
	
	GetObjectUUID(oBaseCreature);
	
//:: No Template Stacking
	if(GetLocalInt(oBaseCreature, "TEMPLATE_PARAGON") > 0)
	{
		if(DEBUG) DoDebug("No Template Stacking");
		return;
	}
	
//:: Creatures & NPCs only
	if ((GetObjectType(oBaseCreature) != OBJECT_TYPE_CREATURE) || (GetIsPC(oBaseCreature) == TRUE))
	{ 
		if(DEBUG) DoDebug("Not a creature");
		return;
	}	
	
	int nBaseHD = GetHitDice(oBaseCreature);
	int nBaseCR = FloatToInt(GetChallengeRating(oBaseCreature));
	
	json jBaseCreature = ObjectToJson(oBaseCreature, TRUE);
	json jNewCreature;
	json jFinalCreature;
	
	jNewCreature 	= json_AddParagonPowers(jBaseCreature);
	jNewCreature 	= json_UpdateParagonCR(jNewCreature, nBaseCR, nBaseHD);
	jNewCreature 	= json_UpdateBaseAC(jNewCreature, 5);
	jFinalCreature 	= json_UpdateCreatureStats(jNewCreature, oBaseCreature, 15, 15, 15, 15, 15, 15);
	
//:: Delete original creature.
	if (GetIsObjectValid(oBaseCreature))
	{
		AssignCommand(oBaseCreature, ClearAllActions(TRUE));

		// optional fade / vanish visuals
		effect eBlank = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlank, oBaseCreature, 6.0f);

		DestroyObject(oBaseCreature, 0.1f);
	}
	
//:: Update the creature
    oNewCreature = JsonToObject(jFinalCreature, lSpawnLoc);

//:: Apply effects
	ApplyParagonEffects(oNewCreature, nBaseHD, nBaseCR); 	
	
//:: Adding extra 12 HP per HD as Temporary HP.
	effect eTempHP = EffectTemporaryHitpoints(nBaseHD * 12);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTempHP, oNewCreature);
	
//:: Update creature's name
	string sBaseName = GetName(oNewCreature);
	SetName(oNewCreature, "Paragon "+ sBaseName);
	
//:: Freshen Up
	//DelayCommand(0.0f, PRCForceRest(oNewCreature));

//:: Set variables	
	SetLocalInt(oNewCreature, "TEMPLATE_PARAGON", 1);
}