/* Evolved Undead

	By: Jaysyn 
	Created: 2024-11-14 17:50:32
	
	An evolved undead is an undead whose body is flushed with more negative
	energy than normal due to an exceptionally long lifetime. Any undead 
	may gain this template, and in doing so, it retains all its previous 
	abilities, but becomes more powerful than before. 
 
 */
#include "nw_inc_gff"
#include "prc_inc_spells"
#include "prc_inc_util"
#include "prc_inc_json"

//:: Adds Evolved SLA's to jCreature.
//::
json json_AddEvolvedPowers(json jCreature, int nBaseHD, int nCasterLevel, int iEvolution)
{
    int nAttempts = 0;
    json jSpecAbilityList = GffGetList(jCreature, "SpecAbilityList");
    if (jSpecAbilityList == JsonNull()) jSpecAbilityList = JsonArray();

    while (nAttempts < 20) // safety cap
    {
        nAttempts++;
        int nRandom = d12(1);
        json jSpecAbility = JsonObject();

        switch(nRandom)
        {
            case 1:
                if (nBaseHD < 6) continue;
                jSpecAbility = GffAddWord(jSpecAbility, "Spell", 18);
                break;
            case 2:
                if (nBaseHD < 5) continue;
                jSpecAbility = GffAddWord(jSpecAbility, "Spell", 23);
                break;
            case 3:
                if (nBaseHD < 4) continue;
                jSpecAbility = GffAddWord(jSpecAbility, "Spell", 25);
                break;
            case 4:
                if (nBaseHD < 3) continue;
                jSpecAbility = GffAddWord(jSpecAbility, "Spell", 26);
                break;
            case 5:
                if (nBaseHD < 3) continue;
                jSpecAbility = GffAddWord(jSpecAbility, "Spell", 27);
                break;
            case 6:
                if (nBaseHD < 7) continue;
                jSpecAbility = GffAddWord(jSpecAbility, "Spell", 364);
                break;
            case 7:
                if (nBaseHD < 5) continue;
                jSpecAbility = GffAddWord(jSpecAbility, "Spell", 67);
                break;
            case 8:
                if (nBaseHD < 4) continue;
                jSpecAbility = GffAddWord(jSpecAbility, "Spell", 88);
                break;
            case 9:
                if (nBaseHD < 3) continue;
                jSpecAbility = GffAddWord(jSpecAbility, "Spell", 78);
                break;
            case 10:
                if (nBaseHD < 4) continue;
                jSpecAbility = GffAddWord(jSpecAbility, "Spell", 82);
                break;
            case 11:
                if (nBaseHD < 2) continue;
                jSpecAbility = GffAddWord(jSpecAbility, "Spell", 157);
                break;
            case 12:
                if (nBaseHD < 5) continue;
                jSpecAbility = GffAddWord(jSpecAbility, "Spell", 566);
                break;
            default:
                jSpecAbility = GffAddWord(jSpecAbility, "Spell", 46); // Doom fallback
                break;
        }

        // If jSpecAbility still empty for some reason, retry
        if (JsonGetType(jSpecAbility) != JSON_TYPE_OBJECT) continue;

        jSpecAbility = GffAddByte(jSpecAbility, "SpellCasterLevel", PRCMax(nCasterLevel, nBaseHD));
        jSpecAbility = GffAddByte(jSpecAbility, "SpellFlags", 1);
        jSpecAbilityList = JsonArrayInsert(jSpecAbilityList, jSpecAbility);
        break;
    }

    return GffAddList(jCreature, "SpecAbilityList", jSpecAbilityList);
}


/* json json_AddEvolvedPowers(json jCreature, int nBaseHD, int nCasterLevel, int iEvolution)
{
    int nRandom = d12(1);

    // Get the existing SpecAbilityList (if it exists)
    json jSpecAbilityList = GffGetList(jCreature, "SpecAbilityList");

    // Create the SpecAbilityList if it doesn't exist
    if (jSpecAbilityList == JsonNull())
    {
        jSpecAbilityList = JsonArray();
    }

    /* 1	circle of death 6
       2	cloudkill 5
       3	cone of cold 4
       4	confusion 3
       5	contagion 27 - 3rd
       6	creeping doom 364 - 7th
       7	greater dispel magic 67 - 5th
       8	greater invisibility 88 - 4th
       9	haste 78 - 3rd
      10	hold monster 82 - 4th
      11	see invisibility 157 - 2nd
      12	unholy blight 566 - 5th    
    */

/*    switch(nRandom)
    {
        case 1:
            if (nBaseHD >= 6)
            {
				int i;
				for (i = 0; i < 1; i++)
                {
                    json jSpecAbility = JsonObject();
                    jSpecAbility = GffAddWord(jSpecAbility, "Spell", 18);
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellCasterLevel", PRCMax(nCasterLevel, nBaseHD));
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellFlags", 1);

                    // Manually add to the array
                    jSpecAbilityList = JsonArrayInsert(jSpecAbilityList, jSpecAbility);
                }
            }
            else
            {
                return json_AddEvolvedPowers(jCreature, nBaseHD, nCasterLevel, iEvolution);
            }
            break;
        case 2:
            if (nBaseHD >= 5)
            {
				int i;
				for (i = 0; i < 1; i++)
                {
                    json jSpecAbility = JsonObject();
                    jSpecAbility = GffAddWord(jSpecAbility, "Spell", 23);
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellCasterLevel", PRCMax(nCasterLevel, nBaseHD));
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellFlags", 1);

                    // Manually add to the array
                    jSpecAbilityList = JsonArrayInsert(jSpecAbilityList, jSpecAbility);
                }
            }
            else
            {
                return json_AddEvolvedPowers(jCreature, nBaseHD, nCasterLevel, iEvolution);
            }
            break;
        case 3:
            if (nBaseHD >= 4)
            {
				int i;
				for (i = 0; i < 1; i++)
                {
                    json jSpecAbility = JsonObject();
                    jSpecAbility = GffAddWord(jSpecAbility, "Spell", 25);
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellCasterLevel", PRCMax(nCasterLevel, nBaseHD));
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellFlags", 1);

                    // Manually add to the array
                    jSpecAbilityList = JsonArrayInsert(jSpecAbilityList, jSpecAbility);
                }
            }
            else
            {
                return json_AddEvolvedPowers(jCreature, nBaseHD, nCasterLevel, iEvolution);
            }
            break;
        case 4:
            if (nBaseHD >= 3)
            {
				int i;
				for (i = 0; i < 1; i++)
                {
                    json jSpecAbility = JsonObject();
                    jSpecAbility = GffAddWord(jSpecAbility, "Spell", 26);
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellCasterLevel", PRCMax(nCasterLevel, nBaseHD));
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellFlags", 1);

                    // Manually add to the array
                    jSpecAbilityList = JsonArrayInsert(jSpecAbilityList, jSpecAbility);
                }
            }
            else
            {
                return json_AddEvolvedPowers(jCreature, nBaseHD, nCasterLevel, iEvolution);
            }
            break;
        case 5:
            if (nBaseHD >= 3)
            {
				int i;
				for (i = 0; i < 1; i++)
                {
                    json jSpecAbility = JsonObject();
                    jSpecAbility = GffAddWord(jSpecAbility, "Spell", 27);
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellCasterLevel", PRCMax(nCasterLevel, nBaseHD));
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellFlags", 1);

                    // Manually add to the array
                    jSpecAbilityList = JsonArrayInsert(jSpecAbilityList, jSpecAbility);
                }
            }
            else
            {
                return json_AddEvolvedPowers(jCreature, nBaseHD, nCasterLevel, iEvolution);
            }
            break;
        case 6:
            if (nBaseHD >= 7)
            {
				int i;
				for (i = 0; i < 1; i++)
                {
                    json jSpecAbility = JsonObject();
                    jSpecAbility = GffAddWord(jSpecAbility, "Spell", 364);
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellCasterLevel", PRCMax(nCasterLevel, nBaseHD));
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellFlags", 1);

                    // Manually add to the array
                    jSpecAbilityList = JsonArrayInsert(jSpecAbilityList, jSpecAbility);
                }
            }
            else
            {
                return json_AddEvolvedPowers(jCreature, nBaseHD, nCasterLevel, iEvolution);
            }
            break;
        case 7:
            if (nBaseHD >= 5)
            {
				int i;
				for (i = 0; i < 1; i++)
                {
                    json jSpecAbility = JsonObject();
                    jSpecAbility = GffAddWord(jSpecAbility, "Spell", 67);
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellCasterLevel", PRCMax(nCasterLevel, nBaseHD));
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellFlags", 1);

                    // Manually add to the array
                    jSpecAbilityList = JsonArrayInsert(jSpecAbilityList, jSpecAbility);
                }
            }
            else
            {
                return json_AddEvolvedPowers(jCreature, nBaseHD, nCasterLevel, iEvolution);
            }
            break;
        case 8:
            if (nBaseHD >= 4)
            {
				int i;
				for (i = 0; i < 1; i++)
                {
                    json jSpecAbility = JsonObject();
                    jSpecAbility = GffAddWord(jSpecAbility, "Spell", 88);
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellCasterLevel", PRCMax(nCasterLevel, nBaseHD));
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellFlags", 1);

                    // Manually add to the array
                    jSpecAbilityList = JsonArrayInsert(jSpecAbilityList, jSpecAbility);
                }
            }
            else
            {
                return json_AddEvolvedPowers(jCreature, nBaseHD, nCasterLevel, iEvolution);
            }
            break;
        case 9:
            if (nBaseHD >= 3)
            {
				int i;
				for (i = 0; i < 1; i++)
                {
                    json jSpecAbility = JsonObject();
                    jSpecAbility = GffAddWord(jSpecAbility, "Spell", 78);
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellCasterLevel", PRCMax(nCasterLevel, nBaseHD));
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellFlags", 1);

                    // Manually add to the array
                    jSpecAbilityList = JsonArrayInsert(jSpecAbilityList, jSpecAbility);
                }
            }
            else
            {
                return json_AddEvolvedPowers(jCreature, nBaseHD, nCasterLevel, iEvolution);
            }
            break;
        case 10:
            if (nBaseHD >= 4)
            {
				int i;
				for (i = 0; i < 1; i++)
                {
                    json jSpecAbility = JsonObject();
                    jSpecAbility = GffAddWord(jSpecAbility, "Spell", 82);
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellCasterLevel", PRCMax(nCasterLevel, nBaseHD));
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellFlags", 1);

                    // Manually add to the array
                    jSpecAbilityList = JsonArrayInsert(jSpecAbilityList, jSpecAbility);
                }
            }
            else
            {
                return json_AddEvolvedPowers(jCreature, nBaseHD, nCasterLevel, iEvolution);
            }
            break;
        case 11:
            if (nBaseHD >= 2)
            {
				int i;
				for (i = 0; i < 1; i++)
                {
                    json jSpecAbility = JsonObject();
                    jSpecAbility = GffAddWord(jSpecAbility, "Spell", 157);
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellCasterLevel", PRCMax(nCasterLevel, nBaseHD));
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellFlags", 1);

                    // Manually add to the array
                    jSpecAbilityList = JsonArrayInsert(jSpecAbilityList, jSpecAbility);
                }
            }
            else
            {
                return json_AddEvolvedPowers(jCreature, nBaseHD, nCasterLevel, iEvolution);
            }
            break;
        case 12:
            if (nBaseHD >= 5)
            {
				int i;
				for (i = 0; i < 1; i++)
                {
                    json jSpecAbility = JsonObject();
                    jSpecAbility = GffAddWord(jSpecAbility, "Spell", 566);
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellCasterLevel", PRCMax(nCasterLevel, nBaseHD));
                    jSpecAbility = GffAddByte(jSpecAbility, "SpellFlags", 1);

                    // Manually add to the array
                    jSpecAbilityList = JsonArrayInsert(jSpecAbilityList, jSpecAbility);
                }
            }
            else
            {
                return json_AddEvolvedPowers(jCreature, nBaseHD, nCasterLevel, iEvolution);
            }
		break;
			default:
            // Fallback to Doom for creatures with 1HD or less.
            int i;
            for (i = 0; i < 1; i++)
            {
                json jSpecAbility = JsonObject();
                jSpecAbility = GffAddWord(jSpecAbility, "Spell", 46); // Doom spell
                jSpecAbility = GffAddByte(jSpecAbility, "SpellCasterLevel", PRCMax(nCasterLevel, nBaseHD));
                jSpecAbility = GffAddByte(jSpecAbility, "SpellFlags", 1);
                jSpecAbilityList = JsonArrayInsert(jSpecAbilityList, jSpecAbility);
            }
            break;			
    }

    return jCreature = GffAddList(jCreature, "SpecAbilityList", jSpecAbilityList);
}
 */

//:: Apply Evolved effects to a non-PC creature
void ApplyEvolvedEffects(object oCreature, int nBaseHD, int nCasterLevel, int iEvolution)
{
//:: Declare major variables
	int bIncorporeal 	= GetIsIncorporeal(oCreature);
	effect eVolved;

//:: Boost caster & SLA level
	SetLocalInt(oCreature, PRC_CASTERLEVEL_ADJUSTMENT, PRCMax(nCasterLevel, nBaseHD));
		
//:: AC Bonuses: +1 natural or +1 deflection if Incorporal
	if(bIncorporeal)
	{
		eVolved = EffectACIncrease(1+iEvolution, AC_DEFLECTION_BONUS);		
	}
	else
	{
		eVolved = EffectACIncrease(1+iEvolution, AC_NATURAL_BONUS);
	}		
	
//:: Fast Healing 3
    eVolved = EffectLinkEffects(eVolved, EffectRegenerate(3, 6.0f));		
		
//:: Make *really* permanent
	eVolved = UnyieldingEffect(eVolved);

//:: Apply everything	
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVolved, oCreature);	
}

 
void main()
{
//:: Declare major variables
	object oBaseCreature = OBJECT_SELF;
	object oNewCreature;
	
	GetObjectUUID(oBaseCreature);
	
	int bIncorporeal	= GetIsIncorporeal(oBaseCreature);
	int iBaseRace 		= MyPRCGetRacialType(oBaseCreature);	
	int nCasterLevel	= PRCGetCasterLevel(oBaseCreature);
	
	int iEvolution = 1;	
	int iOldEvolution = GetLocalInt(oBaseCreature, "UNDEAD_EVOLUTION");
	
//:: Creatures & NPCs only
	if ((GetObjectType(oBaseCreature) != OBJECT_TYPE_CREATURE) || (GetIsPC(oBaseCreature) == TRUE))
	{ 
		DoDebug("Not a creature");
		return;
	}	
	
//:: Undead only
	if(iBaseRace != RACIAL_TYPE_UNDEAD)
	{
		DoDebug("make_evolved: Invalid racial type for template.");
		return;
	}		
	
	if(DEBUG) DoDebug("make_evolved: Previous Evolution is: " +IntToString(iOldEvolution));
	
	iEvolution = iEvolution + iOldEvolution;
	
	if(DEBUG) DoDebug("make_evolved: Evolution is: " +IntToString(iEvolution));
	
	int nBaseHD = GetHitDice(oBaseCreature);
	int nBaseCR = FloatToInt(GetChallengeRating(oBaseCreature));
	
	location lSpawnLoc = GetLocation(oBaseCreature);
	
	json jBaseCreature = ObjectToJson(oBaseCreature, FALSE);
	json jNewCreature;
	json jFinalCreature;

//:: Get original name
	string sBaseName = GetName(oBaseCreature);
	
//:: Add Spell-like abilities	
	jNewCreature = json_AddEvolvedPowers(jBaseCreature, nBaseHD, nCasterLevel, iEvolution);
	
//:: Update stats	
 	if(bIncorporeal)
	{
		//:: Incorporeal = CHA only
		jNewCreature = json_UpdateCreatureStats(jNewCreature, oBaseCreature, 0, 0, 0, 0, 0, 2);
	}
	else
	{
		jNewCreature = json_UpdateCreatureStats(jNewCreature, oBaseCreature, 2, 0, 0, 0, 0, 2);		
	}

//:: Delete original creature.
	if (GetIsObjectValid(oBaseCreature))
	{
		AssignCommand(oBaseCreature, ClearAllActions(TRUE));

		// optional fade / vanish visuals
		effect eBlank = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlank, oBaseCreature, 6.0f);

		DestroyObject(oBaseCreature, 0.1f);
	}	
 
//:: Update CR	
	jFinalCreature = json_UpdateCR(jNewCreature, nBaseCR, 1);
	
//:: Update the creature
    oNewCreature = JsonToObject(jFinalCreature, lSpawnLoc);

//:: Apply effects
	ApplyEvolvedEffects(oNewCreature, nBaseHD, nCasterLevel, iEvolution); 

//:: Update name
	if(DEBUG) DoDebug("make_evolved: Final evolution is: " +IntToString(iEvolution));
	if (iEvolution == 1)
	{
		SetName(oNewCreature, "Evolved " + sBaseName);
	}
	else if (iEvolution == 2)
	{
		SetName(oNewCreature, "Greater " + sBaseName);
	}
	else
	{
		SetName(oNewCreature, sBaseName);
	}
//:: Update race field	
	SetSubRace(oNewCreature, "Undead (Augmented)");

//:: Update age	
	SetAge(oNewCreature, GetAge(oNewCreature) + d100(1));

//:: Freshen up	
	//DelayCommand(0.0f, PRCForceRest(oNewCreature)); 

//:: Set variables	
	SetLocalInt(oNewCreature, "UNDEAD_EVOLUTION", iEvolution);	
	SetLocalInt(oNewCreature, "TEMPLATE_EVOLVED", 1); 
} 