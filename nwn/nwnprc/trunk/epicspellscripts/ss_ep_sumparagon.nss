//::////////////////////////////////////////////////////////
//::	;-.  ,-.   ,-.  ,-. 
//::	|  ) |  ) /    (   )
//::	|-'  |-<  |     ;-: 
//::	|    |  \ \    (   )
//::	'    '  '  `-'  `-' 
//::////////////////////////////////////////////////////////
//;:
//:: Epic Spell: Summon Elemental Paragon
//:: ss_ep_sumparagon.nss
//:: Author: Jaysyn
//:: Updated on: 2026-08-15 00:58:10
//::
//::////////////////////////////////////////////////////////
/*
	Summon Elemental Paragon

	Conjuration (Summoning)
	Spellcraft DC: 87

	Components: V, S
	Casting Time: 1 minute
	Range: 75 ft.
	Effect: One summoned paragon elder elemental
	Duration: 17 hours
	Saving Throw: Will negates
	Spell Resistance: Yes

	The caster summons an elder elemental of the caster's choice: 
	air, earth, fire, or water. The summoned elemental has the 
	paragon template applied to it.

	The elemental appears where the caster designates 
	and acts immediately, on the caster's turn. It attacks the 
	caster's opponents to the best of its ability. The caster 
	can direct the elemental's actions as normal for a summoned 
	creature.

	Mitigating Factor: Burn 500 XP during casting (–5 DC).

	To Develop: 783,000 gp; 16 days; 31,320 XP.
*/
//::////////////////////////////////////////////////////////
#include "prc_inc_spells"
#include "prc_inc_json"
#include "inc_epicspells"

void main()
{
    if(!X2PreSpellCastCode()) return;
	
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
	
	if(!GetCanCastSpell(oCaster, SPELL_EPIC_PARAGON)) return;
	
	int i = 1;  
	object oExisting = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, i);  
	while(GetIsObjectValid(oExisting))  
	{  
		if(GetLocalInt(oExisting, "TEMPLATE_PARAGON"))  
		{  
			FloatingTextStringOnCreature("You may only have one Paragon active at a time.", oCaster, FALSE);  
			return;  
		}  
		i++;  
		oExisting = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, i);  
	}

    float fDuration = HoursToSeconds(17);	
	
    // Target location
    location lTarget = PRCGetSpellTargetLocation();	

	int nVFX = VFX_FNF_SUMMON_MONSTER_3;
	int nRoll = d4();
	string sSummon = nRoll == 1 ? "airelder" :
			nRoll == 2 ? "earthelder" :
			nRoll == 3 ? "fireelder" : "waterelder";
			
    if (GetHasFeat(FEAT_SUMMON_ALIEN, oCaster) || GetHasSpellEffect(VESTIGE_ZCERYLL, oCaster)) sSummon = "pseudo"+sSummon;
    else     sSummon = "nw_s_"+sSummon;			
			
	json jParagon = TemplateToJson(sSummon, RESTYPE_UTC);
	
	int nBaseCR = FloatToInt(json_GetChallengeRating(jParagon));	
	int nBaseHD	=  json_GetCreatureHD(jParagon);
			
	jParagon 	= json_AddParagonPowers(jParagon);
	jParagon 	= json_UpdateParagonCR(jParagon, nBaseCR, nBaseHD);
	jParagon	= json_UpdateBaseAC(jParagon, 5);
	jParagon 	= json_UpdateTemplateStats(jParagon, 15, 15, 15, 15, 15, 15);

    MultisummonPreSummon();
	
/*     string sSummon;		// << -- For whenever the Epic spell radial bug gets fixed
    int nVFX;
    switch(GetSpellId())
	{
		case EPIC_SPELL_SUMMON_AIR_PARAGON:
            sSummon = "airelder";
            nVFX = VFX_FNF_SUMMON_MONSTER_3;
            break;
		case EPIC_SPELL_SUMMON_EARTH_PARAGON:
            sSummon = "earthelder";
            nVFX = VFX_FNF_SUMMON_MONSTER_3;
            break;
		case EPIC_SPELL_SUMMON_FIRE_PARAGON:
            sSummon = "fireelder";
            nVFX = VFX_FNF_SUMMON_MONSTER_3;
            break;
		case EPIC_SPELL_SUMMON_WATER_PARAGON:
            sSummon = "waterelder";
            nVFX = VFX_FNF_SUMMON_MONSTER_3;
            break;			
	} */


    
    if (DEBUG) DoDebug("ss_ep_sumparagon: oCaster " +GetName(oCaster)+", GetSpellId " +IntToString(GetSpellId())+", sSummon " +sSummon);
    
    //Apply the VFX impact and summon effect
    MultisummonPreSummon();
	
	object oParagon = JsonToObject(jParagon, lTarget);
	
	effect eSummon = ExtraordinaryEffect(EffectSummonCreature("", nVFX, 0.0, 0, VFX_IMP_UNSUMMON, oParagon));
	
	//:: Apply effects
	ApplyParagonEffects(oParagon, nBaseHD, nBaseCR); 	
	
//:: Adding extra 12 HP per HD as Temporary HP.
	effect eTempHP = EffectTemporaryHitpoints(nBaseHD * 12);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTempHP, oParagon);
	
//:: Update creature's name
	string sBaseName = GetName(oParagon);
	SetName(oParagon, "Paragon "+ sBaseName);
	
//:: Freshen Up
	//DelayCommand(0.0f, PRCForceRest(oParagon));

//:: Set variables	
	SetLocalInt(oParagon, "TEMPLATE_PARAGON", 1);

	SetCurrentHitPoints(oParagon, GetMaxPossibleHP(oParagon));
	
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), fDuration);

    DelayCommand(0.8, AugmentSummonedCreature(sSummon));
	
    PRCSetSchool();
}