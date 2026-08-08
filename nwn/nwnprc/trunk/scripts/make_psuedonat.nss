/* Psuedonatural Creature Template

	By: Jaysyn 
	Created: 2025-11-23 10:21:24	

	Past the timeless eons that lie between the stars pseudonatural 
	creatures dwell beyond the planes as we know them, nestled in far 
	realms of insanity. When summoned to the Material Plane, they 
	often take on the form and abilities of familiar creatures, 
	though they are more gruesome in appearance than their earthly 
	counterparts. Alternatively, they might appear in a manner more 
	consistent with their origins, manifesting as masses of writhing 
	tentacles or other even more terrible-looking forms.
	
*/

#include "nw_inc_gff"
#include "prc_inc_spells"
#include "prc_inc_util"
#include "inc_debug"
#include "prc_inc_json"
#include "inc_ecl"

//:: Applies the Psuedonatural template to an existing creature object  
object MakePsuedonaturalCreatureFromObject(object oBaseCreature)  
{  
    if (!GetIsObjectValid(oBaseCreature))  
    {  
        DoDebug("make_psuedonat >> MakePsuedonaturalCreatureFromObject failed — invalid creature object.");  
        return OBJECT_INVALID;  
    }  
  
    location lSpawnLoc = GetLocation(oBaseCreature);  
  
    json jPsuedo = ObjectToJson(oBaseCreature, TRUE);  
    if (jPsuedo == JsonNull())  
    {  
        DoDebug("make_psuedonat >> MakePsuedonaturalCreatureFromObject: ObjectToJson failed.");  
        return OBJECT_INVALID;  
    }  
  
    //:: Get current HD  
    int nCurrentHD = json_GetCreatureHD(jPsuedo);  
    if (nCurrentHD <= 0)  
    {  
        DoDebug("MakePsuedonaturalCreatureFromObject >> json_GetCreatureHD failed — creature missing HD data.");  
        return OBJECT_INVALID;  
    }  
  
    //:: Get current CR  
    int nBaseCR = FloatToInt(GetChallengeRating(oBaseCreature));  
    if (nBaseCR <= 0)  
        nBaseCR = 1;  
  
    //:: Adds True Strike 1x / day to jCreature.  
    jPsuedo = json_AddPsuedonaturalPowers(jPsuedo);  
    if (jPsuedo == JsonNull())  
    {  
        DoDebug("MakePsuedonaturalCreatureFromObject >> json_AddPsuedonaturalPowers: ObjectToJson failed.");  
        return OBJECT_INVALID;  
    }  
    //:: Change jCreature's racialtype to outsider  
    jPsuedo = json_ModifyRacialType(jPsuedo, RACIAL_TYPE_OUTSIDER);  
    if (jPsuedo == JsonNull())  
    {  
        DoDebug("MakePsuedonaturalCreatureFromObject >> json_ModifyRacialType: ObjectToJson failed.");  
        return OBJECT_INVALID;  
    }
    //:: Enforce minimum Intelligence 3  
    int nCurrentInt = JsonGetInt(GffGetByte(jPsuedo, "Int"));  
    if (nCurrentInt < 3)  
        jPsuedo = GffReplaceByte(jPsuedo, "Int", 3);  
    if (jPsuedo == JsonNull())  
    {  
        DoDebug("make_psuedonat >> MakePsuedonaturalCreatureFromObject: INT update failed.");  
        return OBJECT_INVALID;  
    }	
	//:: Update jCreature's Challenge Rating
    jPsuedo = json_UpdatePsuedonaturalCR(jPsuedo, nBaseCR, nCurrentHD);  
    if (jPsuedo == JsonNull())  
    {  
        DoDebug("MakePsuedonaturalCreatureFromObject >> json_UpdatePsuedonaturalCR: CR update failed.");  
        return OBJECT_INVALID;  
    }  
    //:: Destroy the base creature
    string sBaseName = GetName(oBaseCreature);  
    AssignCommand(oBaseCreature, ClearAllActions(TRUE));  
    effect eBlank = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlank, oBaseCreature, 6.0f);  
    DestroyObject(oBaseCreature, 0.1f);  
  
    //:: Spawn the creature  
    object oPsuedo = JsonToObject(jPsuedo, lSpawnLoc); 

	//:: Apply Resistance / Damage Reduction / Spell Resistance
	ApplyPseudonaturalEffects(oPsuedo); 	
  
    //:: Set variables  
    SetLocalInt(oPsuedo, "TEMPLATE_PSUEDONATURAL", 1);  
    SetName(oPsuedo, "Psuedonatural " + sBaseName);  
  
    return oPsuedo;  
}

void main()
{
    
	object oBaseCreature = OBJECT_SELF;
	
	GetObjectUUID(oBaseCreature);
	
	//:: No Template Stacking
	if(GetLocalInt(oBaseCreature, "TEMPLATE_PSUEDONATURAL") > 0)
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
	
	MakePsuedonaturalCreatureFromObject(oBaseCreature);

}


/* void main ()
{
//:: Declare major variables
	object oBaseCreature = OBJECT_SELF;
	object oNewCreature;
	
	location lSpawnLoc = GetLocation(oBaseCreature);
	
	GetObjectUUID(oBaseCreature);
	
//:: No Template Stacking
	if(GetLocalInt(oBaseCreature, "TEMPLATE_PSUEDONATURAL") > 0)
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
} */