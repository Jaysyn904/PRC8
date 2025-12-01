#include "prc_class_const"
#include "prc_feat_const"
#include "prc_inc_spells"

void main ()
{
	object oCaster = GetLastSpellCaster();
	
	int nCastingClass = PRCGetLastSpellCastClass();
	
	int nClass;
	int nArcane 	= 0;
	int nRace 		= GetRacialType(oCaster);

    if (nCastingClass == CLASS_TYPE_BARD && GetLevelByClass(CLASS_TYPE_BARD))
    {    
	//:: Includes RHD as bard.  If they started with bard levels, then it
	//:: counts as a prestige class, otherwise RHD is used instead of bard levels.		
		if(nRace == RACIAL_TYPE_GLOURA)
			nArcane += GetLevelByClass(CLASS_TYPE_FEY, oCaster);
			
		if(GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ABJURANT_CHAMPION, oCaster);
		
		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster);
		
		if(GetHasFeat(FEAT_ANIMA_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCTRICK, oCaster);		
		
		if(GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_BLOOD_MAGUS, oCaster);		

		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);

		if(GetHasFeat(FEAT_CMANCER_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_CEREBREMANCER, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);		
		
		if(GetHasFeat(FEAT_DIABO_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);
		
		if(GetHasFeat(FEAT_DHEART_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONHEART_MAGE, oCaster);	

		if(GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster);

		if(GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_THEURGE, oCaster);		

		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);
		
		if(GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST, oCaster);	

/* 		if(GetHasFeat(FEAT_FMM_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FMM, oCaster); */

		if(GetHasFeat(FEAT_FOCHULAN_LYRIST_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FOCHULAN_LYRIST, oCaster);		

		if(GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FROST_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_HARPERM_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster);

		if(GetHasFeat(FEAT_JPM_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_MAESTER_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAESTER, oCaster);		

		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);

		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);
		
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);	

		if(GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_NOCTUMANCER, oCaster);

		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);		
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);	

/* 		if(GetHasFeat(FEAT_SHADOWLORD_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOWLORD, oCaster); */
		
		if(GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SOULCASTER, oCaster);

/* 		if(GetHasFeat(FEAT_TNECRO_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster); */	
		
/* 		if(GetHasFeat(FEAT_REDWIZ_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster);	 */

		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);	

/* 		if(GetHasFeat(FEAT_SUBCHORD_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SUBLIME_CHORD, oCaster); */

		if(GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ULTIMATE_MAGUS, oCaster);			
		
		if(GetHasFeat(FEAT_UNSEEN_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_UNSEEN_SEER, oCaster);	

		if(GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_VIRTUOSO, oCaster);	
		
		if(GetHasFeat(FEAT_WWOC_SPELLCASTING_BARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oCaster);

		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_BARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_BARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_BSINGER_SPELLCASTING_BARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BLADESINGER, oCaster) + 1) / 2;
		
/* 		if(GetHasFeat(FEAT_BONDED_SPELLCASTING_BARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster) + 1) /2;	 */
		
		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_BARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;		

		if(GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_BARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_BARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_HAVOC_SPELLCASTING_BARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HAVOC_MAGE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_SSWORD_SPELLCASTING_BARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) + 1) /2;	

		if(GetHasFeat(FEAT_GRAZZT_SPELLCASTING_BARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_BARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2;		

		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_BARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_BARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_RAGE_MAGE, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_BARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;
        
		nClass = GetLevelByClass(CLASS_TYPE_WILD_MAGE, oCaster);   
		if(GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_BARD, oCaster))
		{	
			if (nClass) 
			{
				nArcane += nClass - 3 + d6();
			}
		}
	}
//:: End Bard Arcane PrC casting calculations
 
	if(nCastingClass == CLASS_TYPE_BARD && nRace == RACIAL_TYPE_GLOURA && !GetLevelByClass(CLASS_TYPE_BARD))
	{    
		if(GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ABJURANT_CHAMPION, oCaster);
		
		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster);
		
		if(GetHasFeat(FEAT_ANIMA_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCTRICK, oCaster);		
		
		if(GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_BLOOD_MAGUS, oCaster);		

		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);

		if(GetHasFeat(FEAT_CMANCER_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_CEREBREMANCER, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);		
		
		if(GetHasFeat(FEAT_DIABO_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);
		
		if(GetHasFeat(FEAT_DHEART_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONHEART_MAGE, oCaster);	

		if(GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster);

		if(GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_THEURGE, oCaster);		

		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);
		
		if(GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST, oCaster);	

/* 		if(GetHasFeat(FEAT_FMM_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FMM, oCaster); */

		if(GetHasFeat(FEAT_FOCHULAN_LYRIST_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FOCHULAN_LYRIST, oCaster);		

		if(GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FROST_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_HARPERM_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster);

		if(GetHasFeat(FEAT_JPM_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oCaster);
		
/* 		if(GetHasFeat(FEAT_MAESTER_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAESTER, oCaster); */		

		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);

		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);
		
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);	

		if(GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_NOCTUMANCER, oCaster);

		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);		
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);	

/* 		if(GetHasFeat(FEAT_SHADOWLORD_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOWLORD, oCaster); */
		
		if(GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SOULCASTER, oCaster);

/* 		if(GetHasFeat(FEAT_TNECRO_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster); */	
		
/* 		if(GetHasFeat(FEAT_REDWIZ_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster);	 */

		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);	

/* 		if(GetHasFeat(FEAT_SUBCHORD_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SUBLIME_CHORD, oCaster); */

		if(GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ULTIMATE_MAGUS, oCaster);			
		
		if(GetHasFeat(FEAT_UNSEEN_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_UNSEEN_SEER, oCaster);	

		if(GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_VIRTUOSO, oCaster);	
		
		if(GetHasFeat(FEAT_WWOC_SPELLCASTING_FEY, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oCaster);

		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_FEY, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_FEY, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_BSINGER_SPELLCASTING_FEY, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BLADESINGER, oCaster) + 1) / 2;
		
/* 		if(GetHasFeat(FEAT_BONDED_SPELLCASTING_FEY, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster) + 1) /2;	 */
		
		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_FEY, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;		

		if(GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_FEY, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_FEY, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_HAVOC_SPELLCASTING_FEY, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HAVOC_MAGE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_SSWORD_SPELLCASTING_FEY, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) + 1) /2;	

		if(GetHasFeat(FEAT_GRAZZT_SPELLCASTING_FEY, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_FEY, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2;		

		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_FEY, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_FEY, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_RAGE_MAGE, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_FEY, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;        
		
		if(GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_FEY, oCaster))
		{	
			nClass = GetLevelByClass(CLASS_TYPE_WILD_MAGE, oCaster);	
			if (nClass) { nArcane += nClass - 3 + d6(); }		
		}
	}
//:: End Fey Arcane PrC casting calculations

    if (nCastingClass == CLASS_TYPE_ASSASSIN)
    {    
         if(GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_ASSASSIN, oCaster))  //:: Requires Assassin 4
			nArcane += GetLevelByClass(CLASS_TYPE_ABJURANT_CHAMPION, oCaster);
		
/* 		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster); */
		
		if(GetHasFeat(FEAT_ANIMA_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oCaster);
		
/* 		if(GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCHMAGE, oCaster); */
		
		if(GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCTRICK, oCaster);		

/* 		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster); */

		if(GetHasFeat(FEAT_CMANCER_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_CEREBREMANCER, oCaster);
		
		if(GetHasFeat(FEAT_DIABO_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);
		
		if(GetHasFeat(FEAT_DHEART_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONHEART_MAGE, oCaster);		

		if(GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster);

		if(GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_THEURGE, oCaster);		

		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);
		
		if(GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST, oCaster );		

/*  	if(GetHasFeat(FEAT_FMM_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FMM, oCaster); */

		if(GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FROST_MAGE, oCaster);
		
/* 		if(GetHasFeat(FEAT_HARPERM_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster); */

/* 		if(GetHasFeat(FEAT_JPM_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oCaster); */
		
/* 		if(GetHasFeat(FEAT_MAESTER_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAESTER, oCaster); */		

/* 		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster); */

		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);
		
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);	

		if(GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_NOCTUMANCER, oCaster);	
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);	
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);	

/* 		if(GetHasFeat(FEAT_TNECRO_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster); */	
		
/* 		if(GetHasFeat(FEAT_REDWIZ_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster); */	

		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);

/* 		if(GetHasFeat(FEAT_SHADOWLORD_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOWLORD, oCaster); */

		if(GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SOULCASTER, oCaster);		

/* 		if(GetHasFeat(FEAT_SUBCHORD_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SUBLIME_CHORD, oCaster); */

		if(GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ULTIMATE_MAGUS, oCaster);		
		
		if(GetHasFeat(FEAT_UNSEEN_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_UNSEEN_SEER, oCaster);	

/* 		if(GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_VIRTUOSO, oCaster); */	
		
/* 		if(GetHasFeat(FEAT_WWOC_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oCaster); */

		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) /2;

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;		

		if(GetHasFeat(FEAT_BSINGER_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BLADESINGER, oCaster) + 1) / 2;
		
/* 		if(GetHasFeat(FEAT_BONDED_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster) + 1) /2; */

		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) + 1) / 2;	
		
/* 		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2; */	

		if(GetHasFeat(FEAT_HAVOC_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HAVOC_MAGE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_SSWORD_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) + 1) /2;	

		if(GetHasFeat(FEAT_GRAZZT_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_RAGE_MAGE, oCaster) + 1) / 2;	

/* 		if(GetHasFeat(FEAT_WAYFARER_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_WAYFARER_GUIDE, oCaster) + 1) /2;	 */
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_ASSASSIN, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;

		if(GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_ASSASSIN, oCaster))
		{	
			nClass = GetLevelByClass(CLASS_TYPE_WILD_MAGE, oCaster);
			if (nClass) 
				nArcane += nClass - 3 + d6(); 
		}				
	}
//:: End Assassin Arcane PrC casting calculations
	
    if (nCastingClass == CLASS_TYPE_BEGUILER)
    {    
        if(GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ABJURANT_CHAMPION, oCaster);
		
		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster);
		
		if(GetHasFeat(FEAT_ANIMA_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCHMAGE, oCaster);
		
		if(GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCTRICK, oCaster);

		if(GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_BLOOD_MAGUS, oCaster);			

		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);

		if(GetHasFeat(FEAT_CMANCER_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_CEREBREMANCER, oCaster);
		
		if(GetHasFeat(FEAT_DIABO_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);
		
		if(GetHasFeat(FEAT_DHEART_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONHEART_MAGE, oCaster);

		if(GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster);

		if(GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_THEURGE, oCaster);		

		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);
		
		if(GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST, oCaster);
				
/* 		if(GetHasFeat(FEAT_FMM_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FMM, oCaster); */	

		if(GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FROST_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_FOCHULAN_LYRIST_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FOCHULAN_LYRIST, oCaster);
		
		if(GetHasFeat(FEAT_HARPERM_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster);

		if(GetHasFeat(FEAT_JPM_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_MAESTER_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAESTER, oCaster);		

		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);

		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);
		
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);	

		if(GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_NOCTUMANCER, oCaster);

		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);	

		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);	
		
/* 		if(GetHasFeat(FEAT_SHADOWLORD_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOWLORD, oCaster);	 */		

/* 		if(GetHasFeat(FEAT_TNECRO_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster); */	
		
/* 		if(GetHasFeat(FEAT_REDWIZ_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster);	 */

		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);	
		
		if(GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SOULCASTER, oCaster);			

/* 		if(GetHasFeat(FEAT_SUBCHORD_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SUBLIME_CHORD, oCaster); */

		if(GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ULTIMATE_MAGUS, oCaster);		
		
		if(GetHasFeat(FEAT_UNSEEN_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_UNSEEN_SEER, oCaster);	

		if(GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_VIRTUOSO, oCaster);	
		
		if(GetHasFeat(FEAT_WWOC_SPELLCASTING_BEGUILER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oCaster);

		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_BEGUILER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) /2;
		
		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_BEGUILER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;		

		if(GetHasFeat(FEAT_BSINGER_SPELLCASTING_BEGUILER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BLADESINGER, oCaster) + 1) / 2;
		
/* 		if(GetHasFeat(FEAT_BONDED_SPELLCASTING_BEGUILER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster) + 1) /2; */	
		
		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_BEGUILER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_BEGUILER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_BEGUILER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_HAVOC_SPELLCASTING_BEGUILER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HAVOC_MAGE, oCaster) + 1) /2;
		
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_BEGUILER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) /2;		

		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_BEGUILER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) /2;
		
		if(GetHasFeat(FEAT_SSWORD_SPELLCASTING_BEGUILER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) + 1) /2;	

		if(GetHasFeat(FEAT_GRAZZT_SPELLCASTING_BEGUILER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_BEGUILER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_BEGUILER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_RAGE_MAGE, oCaster) + 1) / 2;	

/* 		if(GetHasFeat(FEAT_WAYFARER_SPELLCASTING_BEGUILER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_WAYFARER_GUIDE, oCaster) + 1) /2;	 */
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_BEGUILER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;

		if(GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_BEGUILER, oCaster))
		{	nClass = GetLevelByClass(CLASS_TYPE_WILD_MAGE, oCaster); 
			if (nClass) { nArcane += nClass - 3 + d6(); }				
		}
	}
//:: End Beguiler Arcane PrC casting calculations

    if (nCastingClass == CLASS_TYPE_CELEBRANT_SHARESS)
    {    
         if(GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ABJURANT_CHAMPION, oCaster);
		
		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster);
		
 		if(GetHasFeat(FEAT_BONDED_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster); 
		
/* 		if(GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCHMAGE, oCaster); */
		
		if(GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCTRICK, oCaster);		

		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);

		if(GetHasFeat(FEAT_CMANCER_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_CEREBREMANCER, oCaster);
		
/* 		if(GetHasFeat(FEAT_DIABO_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster); */
		
		if(GetHasFeat(FEAT_DHEART_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONHEART_MAGE, oCaster);

		if(GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster);

		if(GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_THEURGE, oCaster);		

		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);
		
		if(GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST, oCaster);		

/*  		if(GetHasFeat(FEAT_FMM_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FMM, oCaster); */

		if(GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FROST_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_HARPERM_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster);

		if(GetHasFeat(FEAT_JPM_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oCaster);
		
/* 		if(GetHasFeat(FEAT_MAESTER_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAESTER, oCaster); */		

/* 		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster); */

		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);
		
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);	

		if(GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_NOCTUMANCER, oCaster);

		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);				
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);	

/* 		if(GetHasFeat(FEAT_TNECRO_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster); */	
		
/* 		if(GetHasFeat(FEAT_REDWIZ_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster); */	

		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);	
		
		if(GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SOULCASTER, oCaster);	

/* 		if(GetHasFeat(FEAT_SUBCHORD_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SUBLIME_CHORD, oCaster); */	
		
		if(GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ULTIMATE_MAGUS, oCaster);			
		
		if(GetHasFeat(FEAT_UNSEEN_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_UNSEEN_SEER, oCaster);	

/* 		if(GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_VIRTUOSO, oCaster);	
		
		if(GetHasFeat(FEAT_WWOC_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oCaster); */		

		if(GetHasFeat(FEAT_BSINGER_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BLADESINGER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_BONDED_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster) + 1) /2;

		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;

/* 		if(GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) + 1) / 2; */	
		
/* 		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2; */	

		if(GetHasFeat(FEAT_HAVOC_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HAVOC_MAGE, oCaster) + 1) /2;

/* 		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) /2; */		
		
		if(GetHasFeat(FEAT_SSWORD_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) + 1) /2;	

/* 		if(GetHasFeat(FEAT_GRAZZT_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oCaster) + 1) / 2; */

/* 		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2; */	
		
		if(GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_RAGE_MAGE, oCaster) + 1) / 2;	

/* 		if(GetHasFeat(FEAT_WAYFARER_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_WAYFARER_GUIDE, oCaster) + 1) /2; */	
		
/* 		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3; */

		if(GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_CELEBRANT_SHARESS, oCaster))
		{	
			nClass = GetLevelByClass(CLASS_TYPE_WILD_MAGE, oCaster);
			if (nClass) { nArcane += nClass - 3 + d6(); }	
		}
	}
//:: End Celebrant of Sharess Arcane PrC casting calculations 

    if (nCastingClass == CLASS_TYPE_CULTIST_SHATTERED_PEAK)
    {    
         if(GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ABJURANT_CHAMPION, oCaster);
		
/* 		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster); */
		
		if(GetHasFeat(FEAT_ANIMA_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oCaster);
		
/* 		if(GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCHMAGE, oCaster); */
		
		if(GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCTRICK, oCaster);		

		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);

		if(GetHasFeat(FEAT_CMANCER_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_CEREBREMANCER, oCaster);
		
		if(GetHasFeat(FEAT_DIABO_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);
		
/* 		if(GetHasFeat(FEAT_DHEART_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONHEART_MAGE, oCaster); */

		if(GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster);

		if(GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_THEURGE, oCaster);		

		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);
		
		if(GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST, oCaster);		

/*  		if(GetHasFeat(FEAT_FMM_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FMM, oCaster); */
		
		if(GetHasFeat(FEAT_FOCHULAN_LYRIST_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FOCHULAN_LYRIST, oCaster);		

		if(GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FROST_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_HARPERM_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster);

		if(GetHasFeat(FEAT_JPM_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oCaster);
		
/* 		if(GetHasFeat(FEAT_MAESTER_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAESTER, oCaster); */		

/* 		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);

		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster); */
		
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);	

		if(GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_NOCTUMANCER, oCaster);

		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);			
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);

/* 		if(GetHasFeat(FEAT_SHADOWLORD_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOWLORD, oCaster);	 */		

/* 		if(GetHasFeat(FEAT_TNECRO_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster); */	
		
/* 		if(GetHasFeat(FEAT_REDWIZ_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster); */	

		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);

		if(GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SOULCASTER, oCaster);			

/* 		if(GetHasFeat(FEAT_SUBCHORD_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SUBLIME_CHORD, oCaster); */

		if(GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ULTIMATE_MAGUS, oCaster);			
		
		if(GetHasFeat(FEAT_UNSEEN_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_UNSEEN_SEER, oCaster);	

/* 		if(GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_VIRTUOSO, oCaster);	
		
		if(GetHasFeat(FEAT_WWOC_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oCaster);	 */	

		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) /2;

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_BSINGER_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BLADESINGER, oCaster) + 1) / 2;
		
/* 		if(GetHasFeat(FEAT_BONDED_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster) + 1) /2; */			

		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;				

		if(GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_HAVOC_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HAVOC_MAGE, oCaster) + 1) /2;

		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) /2;		
		
		if(GetHasFeat(FEAT_SSWORD_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) + 1) /2;	

		if(GetHasFeat(FEAT_GRAZZT_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_RAGE_MAGE, oCaster) + 1) / 2;	

/* 		if(GetHasFeat(FEAT_WAYFARER_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_WAYFARER_GUIDE, oCaster) + 1) /2; */	
		
/* 		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_CULTIST_PEAK, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3; */

		if(GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_CULTIST_PEAK, oCaster))
		{	
			nClass = GetLevelByClass(CLASS_TYPE_WILD_MAGE, oCaster);
			if (nClass) { nArcane += nClass - 3 + d6();} 
		}	
	}
//:: End Cultist of the Shattered Peaks Arcane PrC casting calculations  

    if (nCastingClass == CLASS_TYPE_DREAD_NECROMANCER)
    {    
/*         if(GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ABJURANT_CHAMPION); */
		
		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster);
		
		if(GetHasFeat(FEAT_ANIMA_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCHMAGE, oCaster);
		
		if(GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCTRICK, oCaster);

		if(GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_BLOOD_MAGUS, oCaster);	

 		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);

		if(GetHasFeat(FEAT_CMANCER_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_CEREBREMANCER, oCaster);
		
		if(GetHasFeat(FEAT_DIABO_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);
		
		if(GetHasFeat(FEAT_DHEART_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONHEART_MAGE, oCaster);	

		if(GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster);

		if(GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_THEURGE, oCaster);		

		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);
		
		if(GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST, oCaster);			

/* 		if(GetHasFeat(FEAT_FMM_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FMM, oCaster); */

		if(GetHasFeat(FEAT_FOCHULAN_LYRIST_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FOCHULAN_LYRIST, oCaster);		

		if(GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FROST_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_HARPERM_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster);

		if(GetHasFeat(FEAT_JPM_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_MAESTER_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAESTER, oCaster);		

		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);

		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);
		
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);	

		if(GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_NOCTUMANCER, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);			
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);

/* 		if(GetHasFeat(FEAT_SHADOWLORD_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOWLORD, oCaster); */			

		if(GetHasFeat(FEAT_TNECRO_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster);	
		
/* 		if(GetHasFeat(FEAT_REDWIZ_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster); */	

		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);

		if(GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SOULCASTER, oCaster);			

/* 		if(GetHasFeat(FEAT_SUBCHORD_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SUBLIME_CHORD, oCaster); */	
		
		if(GetHasFeat(FEAT_UNSEEN_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_UNSEEN_SEER, oCaster);	

/* 		if(GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_VIRTUOSO, oCaster);	 */
		
		if(GetHasFeat(FEAT_WWOC_SPELLCASTING_DNECRO, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oCaster);	

		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_DNECRO, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) /2;	

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_DNECRO, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;		

		if(GetHasFeat(FEAT_BSINGER_SPELLCASTING_DNECRO, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BLADESINGER, oCaster) + 1) / 2;
		
/* 		if(GetHasFeat(FEAT_BONDED_SPELLCASTING_DNECRO, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster) + 1) /2;	 */
		
		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_DNECRO, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_DNECRO, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_DNECRO, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_HAVOC_SPELLCASTING_DNECRO, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HAVOC_MAGE, oCaster) + 1) /2;
		
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_DNECRO, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_SSWORD_SPELLCASTING_DNECRO, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) + 1) /2;	

		if(GetHasFeat(FEAT_GRAZZT_SPELLCASTING_DNECRO, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_DNECRO, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_DNECRO, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_RAGE_MAGE, oCaster) + 1) / 2;	

/* 		if(GetHasFeat(FEAT_WAYFARER_SPELLCASTING_DNECRO, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_WAYFARER_GUIDE, oCaster) + 1) /2;	 */
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_DNECRO, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;

		if(GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_DNECRO, oCaster))
		{	nClass = GetLevelByClass(CLASS_TYPE_WILD_MAGE, oCaster);
			if (nClass) { nArcane += nClass - 3 + d6(); }
		}
	}
//:: End Dread Necromancer Arcane PrC casting calculations 

    if (nCastingClass == CLASS_TYPE_DUSKBLADE)
    {    
        if(GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ABJURANT_CHAMPION, oCaster);
		
/* 		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster); */
		
		if(GetHasFeat(FEAT_ANIMA_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oCaster);
		
/* 		if(GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCHMAGE, oCaster); */
		
		if(GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCTRICK, oCaster);

		if(GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_BLOOD_MAGUS, oCaster);

		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);

		if(GetHasFeat(FEAT_CMANCER_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_CEREBREMANCER, oCaster);
		
		if(GetHasFeat(FEAT_DIABO_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);
		
 		if(GetHasFeat(FEAT_DHEART_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONHEART_MAGE, oCaster);

		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster);			

		if(GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster);

		if(GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_THEURGE, oCaster);		

		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);
		
		if(GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST, oCaster);			

/* 		if(GetHasFeat(FEAT_FMM_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FMM, oCaster); */	

		if(GetHasFeat(FEAT_FOCHULAN_LYRIST_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FOCHULAN_LYRIST, oCaster);		

		if(GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FROST_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_HARPERM_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster);

		if(GetHasFeat(FEAT_JPM_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_MAESTER_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAESTER, oCaster);		

		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);

		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);
		
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);	

		if(GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_NOCTUMANCER, oCaster);	
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);			
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);

/* 		if(GetHasFeat(FEAT_SHADOWLORD_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOWLORD, oCaster);		 */	

/* 		if(GetHasFeat(FEAT_TNECRO_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster);	
		
		if(GetHasFeat(FEAT_REDWIZ_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster);	 */

		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);

		if(GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SOULCASTER, oCaster);			

/* 		if(GetHasFeat(FEAT_SUBCHORD_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SUBLIME_CHORD, oCaster); */

		if(GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ULTIMATE_MAGUS, oCaster);			
		
		if(GetHasFeat(FEAT_UNSEEN_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_UNSEEN_SEER, oCaster);	

		if(GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_VIRTUOSO, oCaster);	
		
		if(GetHasFeat(FEAT_WWOC_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oCaster);

		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) /2;

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;		

		if(GetHasFeat(FEAT_BSINGER_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BLADESINGER, oCaster) + 1) / 2;
		
/* 		if(GetHasFeat(FEAT_BONDED_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster) + 1) /2;	 */
		
		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) /2;		
		
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2;			

		if(GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_HAVOC_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HAVOC_MAGE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_SSWORD_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) + 1) /2;	

		if(GetHasFeat(FEAT_GRAZZT_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_RAGE_MAGE, oCaster) + 1) / 2;	

/* 		if(GetHasFeat(FEAT_WAYFARER_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_WAYFARER_GUIDE, oCaster) + 1) /2; */	
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_DUSKBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;

		if(GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_DUSKBLADE, oCaster))
		{	
			nClass = GetLevelByClass(CLASS_TYPE_WILD_MAGE, oCaster);
			if (nClass) { nArcane += nClass - 3 + d6();} 			
		}
	}
//:: End Duskblade Arcane PrC casting calculations

    if (nCastingClass == CLASS_TYPE_HARPER)
    {    
         if(GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_HARPER, oCaster))  //:: enter after 5th Harper Scout lvl
			nArcane += GetLevelByClass(CLASS_TYPE_ABJURANT_CHAMPION, oCaster);
		
/* 		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster); */
		
		if(GetHasFeat(FEAT_ANIMA_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oCaster);
		
/* 		if(GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCHMAGE, oCaster); */
		
		if(GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCTRICK, oCaster);		

		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);

		if(GetHasFeat(FEAT_CMANCER_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_CEREBREMANCER, oCaster);
		
/* 		if(GetHasFeat(FEAT_DIABO_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster); */
		
		if(GetHasFeat(FEAT_DHEART_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONHEART_MAGE, oCaster);	

		if(GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_HARPER, oCaster)) //:: enter after 5th Harper Scout lvl
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster);

		if(GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_THEURGE, oCaster);		

		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);
		
		if(GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST, oCaster);		

/*  		if(GetHasFeat(FEAT_FMM_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FMM, oCaster); */

		if(GetHasFeat(FEAT_FOCHULAN_LYRIST_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FOCHULAN_LYRIST, oCaster);		

		if(GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FROST_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_HARPERM_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster);

		if(GetHasFeat(FEAT_JPM_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oCaster);
		
/* 		if(GetHasFeat(FEAT_MAESTER_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAESTER, oCaster); */		

/* 		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);

		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster); */
		
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);	

		if(GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_NOCTUMANCER, oCaster);

		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);				
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);	

/* 		if(GetHasFeat(FEAT_TNECRO_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster); */	
		
/* 		if(GetHasFeat(FEAT_REDWIZ_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster); */	

		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);

		if(GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SOULCASTER, oCaster);		

/* 		if(GetHasFeat(FEAT_SUBCHORD_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SUBLIME_CHORD, oCaster); */

		if(GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ULTIMATE_MAGUS, oCaster);			
		
		if(GetHasFeat(FEAT_UNSEEN_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_UNSEEN_SEER, oCaster);	

/* 		if(GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_VIRTUOSO, oCaster); */	
		
/* 		if(GetHasFeat(FEAT_WWOC_SPELLCASTING_HARPER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oCaster); */		

		if(GetHasFeat(FEAT_BSINGER_SPELLCASTING_HARPER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BLADESINGER, oCaster) + 1) / 2;
		
/* 		if(GetHasFeat(FEAT_BONDED_SPELLCASTING_HARPER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster) + 1) /2;	 */
		
		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_HARPER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_HARPER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) /2;		

		if(GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_HARPER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_HARPER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_HAVOC_SPELLCASTING_HARPER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HAVOC_MAGE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_SSWORD_SPELLCASTING_HARPER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) + 1) /2;	

/* 		if(GetHasFeat(FEAT_GRAZZT_SPELLCASTING_HARPER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oCaster) + 1) / 2; */

/* 		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_HARPER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2; */	
		
		if(GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_HARPER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_RAGE_MAGE, oCaster) + 1) / 2;	

/* 		if(GetHasFeat(FEAT_WAYFARER_SPELLCASTING_HARPER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_WAYFARER_GUIDE, oCaster) + 1) /2;	
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_HARPER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3; */
	
		if(GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_HARPER, oCaster))
		{	 
			nClass = GetLevelByClass(CLASS_TYPE_WILD_MAGE, oCaster);
			if (nClass) { nArcane += nClass - 3 + d6();}
		}
	}
//:: End Harper Scout Arcane PrC casting calculations 

    if (nCastingClass == CLASS_TYPE_HEXBLADE)
    {    
        if(GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ABJURANT_CHAMPION, oCaster);
		
/* 		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster); */
		
		if(GetHasFeat(FEAT_ANIMA_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oCaster);
		
/* 		if(GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCHMAGE, oCaster); */
		
		if(GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCTRICK, oCaster);		

		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);

		if(GetHasFeat(FEAT_CMANCER_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_CEREBREMANCER, oCaster);
		
		if(GetHasFeat(FEAT_DIABO_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);
		
 		if(GetHasFeat(FEAT_DHEART_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONHEART_MAGE, oCaster);		

		if(GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster);

		if(GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_THEURGE, oCaster);		

		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);
		
		if(GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST, oCaster);		

/* 		if(GetHasFeat(FEAT_FMM_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FMM, oCaster); */	

		if(GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FROST_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_FOCHULAN_LYRIST_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FOCHULAN_LYRIST, oCaster);			
		
		if(GetHasFeat(FEAT_HARPERM_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster);

		if(GetHasFeat(FEAT_JPM_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oCaster);
		
/* 		if(GetHasFeat(FEAT_MAESTER_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAESTER, oCaster);		

		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster); */

		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);
		
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);	

		if(GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_NOCTUMANCER, oCaster);

		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);		
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);

/* 		if(GetHasFeat(FEAT_SHADOWLORD_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOWLORD, oCaster); */

		if(GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SOULCASTER, oCaster);			

/* 		if(GetHasFeat(FEAT_TNECRO_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster); */	
		
/* 		if(GetHasFeat(FEAT_REDWIZ_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster);	 */

		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);	

/* 		if(GetHasFeat(FEAT_SUBCHORD_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SUBLIME_CHORD, oCaster); */

		if(GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ULTIMATE_MAGUS, oCaster);		
		
		if(GetHasFeat(FEAT_UNSEEN_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_UNSEEN_SEER, oCaster);	

/* 		if(GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_VIRTUOSO, oCaster); */	
		
		if(GetHasFeat(FEAT_WWOC_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oCaster);	

		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) /2;	

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_BSINGER_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BLADESINGER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_BONDED_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster) + 1) /2;

		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;				

		if(GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_HAVOC_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HAVOC_MAGE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2;		
		
		if(GetHasFeat(FEAT_SSWORD_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) + 1) /2;	

		if(GetHasFeat(FEAT_GRAZZT_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_RAGE_MAGE, oCaster) + 1) / 2;	

/* 		if(GetHasFeat(FEAT_WAYFARER_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_WAYFARER_GUIDE, oCaster) + 1) /2; */	
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_HEXBLADE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;
		
		if(GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_HEXBLADE, oCaster))
		{	
			nClass = GetLevelByClass(CLASS_TYPE_WILD_MAGE, oCaster);
			if (nClass) { nArcane += nClass - 3 + d6(); }
		}
	}
//:: End Hexblade Arcane PrC casting calculations

    if (nCastingClass == CLASS_TYPE_KNIGHT_WEAVE)
    {    
         if(GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ABJURANT_CHAMPION, oCaster);
		
/* 		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster); */
		
		if(GetHasFeat(FEAT_ANIMA_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oCaster);
		
/* 		if(GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCHMAGE, oCaster); */
		
		if(GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCTRICK, oCaster);	

		if(GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_BLOOD_MAGUS, oCaster);		

		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);

		if(GetHasFeat(FEAT_CMANCER_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_CEREBREMANCER, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);		
		
/* 		if(GetHasFeat(FEAT_DIABO_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster); */
		
		if(GetHasFeat(FEAT_DHEART_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONHEART_MAGE, oCaster);		

		if(GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster);

		if(GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_THEURGE, oCaster);		

		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);
		
		if(GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST, oCaster);	
		
 		if(GetHasFeat(FEAT_FMM_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FMM, oCaster);
		
		if(GetHasFeat(FEAT_FOCHULAN_LYRIST_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FOCHULAN_LYRIST, oCaster);

		if(GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FROST_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_HARPERM_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster);

		if(GetHasFeat(FEAT_JPM_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_MAESTER_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAESTER, oCaster);		

/* 		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster); */

		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);
		
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);	

		if(GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_NOCTUMANCER, oCaster);	
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);		
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);

/* 		if(GetHasFeat(FEAT_SHADOWLORD_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOWLORD, oCaster);	 */	

		if(GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SOULCASTER, oCaster);			

/* 		if(GetHasFeat(FEAT_TNECRO_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster); */	
		
/* 		if(GetHasFeat(FEAT_REDWIZ_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster); */	

		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);	

/* 		if(GetHasFeat(FEAT_SUBCHORD_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SUBLIME_CHORD, oCaster); */

		if(GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ULTIMATE_MAGUS, oCaster);			
		
		if(GetHasFeat(FEAT_UNSEEN_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_UNSEEN_SEER, oCaster);	

/* 		if(GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_VIRTUOSO, oCaster); */	
		
		if(GetHasFeat(FEAT_WWOC_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oCaster);		

		if(GetHasFeat(FEAT_BSINGER_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BLADESINGER, oCaster) + 1) / 2;
		
/* 		if(GetHasFeat(FEAT_BONDED_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster) + 1) /2; */

		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) /2;		

		if(GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_HAVOC_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HAVOC_MAGE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_SSWORD_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) + 1) /2;	

/* 		if(GetHasFeat(FEAT_GRAZZT_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oCaster) + 1) / 2; */

/* 		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;	 */
		
		if(GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_RAGE_MAGE, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_WAYFARER_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_WAYFARER_GUIDE, oCaster) + 1) /2;	
		
/* 		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_KNIGHT_WEAVE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3; */

		if(GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_KNIGHT_WEAVE, oCaster))
		{	nClass = GetLevelByClass(CLASS_TYPE_WILD_MAGE, oCaster); }
			if (nClass) { nArcane += nClass - 3 + d6(); }	
	}
//:: End Knight of the Weave Arcane PrC casting calculations 

    if (nCastingClass == CLASS_TYPE_SORCERER && GetLevelByClass(CLASS_TYPE_SORCERER))
    {
//:: Includes RHD as sorcerer.  If they already have sorcerer levels, then it
//:: counts as a prestige class, otherwise RHD is used instead of sorc levels.		
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
  		
         if(GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ABJURANT_CHAMPION, oCaster);
		
		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster);
		
		if(GetHasFeat(FEAT_ANIMA_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCHMAGE, oCaster);
		
		if(GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCTRICK, oCaster);

		if(GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_BLOOD_MAGUS, oCaster);		

		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);

		if(GetHasFeat(FEAT_CMANCER_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_CEREBREMANCER, oCaster);
		
		if(GetHasFeat(FEAT_DIABO_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);
		
		if(GetHasFeat(FEAT_DHEART_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONHEART_MAGE, oCaster);

		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster);			

		if(GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster);

		if(GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_THEURGE, oCaster);		

		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);
		
		if(GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST, oCaster);			

 		if(GetHasFeat(FEAT_FMM_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FMM, oCaster);
		
		if(GetHasFeat(FEAT_FOCHULAN_LYRIST_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FOCHULAN_LYRIST, oCaster);		

		if(GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FROST_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_HARPERM_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster);

		if(GetHasFeat(FEAT_JPM_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_MAESTER_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAESTER, oCaster);		

		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);

		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);
		
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);	

		if(GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_NOCTUMANCER, oCaster);	
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);			
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);

/* 		if(GetHasFeat(FEAT_SHADOWLORD_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOWLORD, oCaster); */

		if(GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SOULCASTER, oCaster);			

		if(GetHasFeat(FEAT_TNECRO_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster);	
		
/* 		if(GetHasFeat(FEAT_REDWIZ_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster); */	

		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);	

/* 		if(GetHasFeat(FEAT_SUBCHORD_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SUBLIME_CHORD, oCaster); */

		if(GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ULTIMATE_MAGUS, oCaster);			
		
		if(GetHasFeat(FEAT_UNSEEN_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_UNSEEN_SEER, oCaster);	

		if(GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_VIRTUOSO, oCaster);	
		
		if(GetHasFeat(FEAT_WWOC_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oCaster);

		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_SORCERER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) /2;	

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_SORCERER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;		

		if(GetHasFeat(FEAT_BSINGER_SPELLCASTING_SORCERER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BLADESINGER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_BONDED_SPELLCASTING_SORCERER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster) + 1) /2;
		
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_SORCERER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) /2;		

		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_SORCERER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2;			

		if(GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_SORCERER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_SORCERER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_HAVOC_SPELLCASTING_SORCERER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HAVOC_MAGE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_SSWORD_SPELLCASTING_SORCERER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) + 1) /2;	

		if(GetHasFeat(FEAT_GRAZZT_SPELLCASTING_SORCERER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_SORCERER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_SORCERER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_RAGE_MAGE, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_WAYFARER_SPELLCASTING_SORCERER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_WAYFARER_GUIDE, oCaster) + 1) /2;	
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_SORCERER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;

		if(GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_SORCERER, oCaster))
		{	int nClass = GetLevelByClass(CLASS_TYPE_WILD_MAGE, oCaster); }
			if (nClass) { nArcane += nClass - 3 + d6(); }	
	}
//:: End Sorcerer Arcane PrC casting calculations 


    if(nCastingClass == CLASS_TYPE_SORCERER && nRace == RACIAL_TYPE_DRIDER 
											|| nRace == RACIAL_TYPE_ARKAMOI 
											|| nRace == RACIAL_TYPE_MARRUTACT 
											|| nRace == RACIAL_TYPE_REDSPAWN_ARCANISS 
											|| nRace == RACIAL_TYPE_RAKSHASA 
											|| nRace == RACIAL_TYPE_ARANEA 
											&& !GetLevelByClass(CLASS_TYPE_SORCERER))
    {
//:: Adding PrC caster levels to the racial caster level.		
		if(GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ABJURANT_CHAMPION, oCaster);
		
		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_ALIENIST_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_ALIENIST_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_ALIENIST_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster);

		if(GetHasFeat(FEAT_ANIMA_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_ANIMA_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_ANIMA_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_ANIMA_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oCaster);

		if(GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCHMAGE, oCaster);

		if(GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_SHAPECHANGER, oCaster))		
			nArcane += GetLevelByClass(CLASS_TYPE_ARCTRICK, oCaster);

		if(GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_BLOOD_MAGUS, oCaster);		

		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_MHARPER_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_MHARPER_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_MHARPER_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);

		if(GetHasFeat(FEAT_CMANCER_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_CMANCER_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_CMANCER_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_CMANCER_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_CEREBREMANCER, oCaster);

		if(GetHasFeat(FEAT_DIABO_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_DIABO_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_DIABO_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_DIABO_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);

		if(GetHasFeat(FEAT_DHEART_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_DHEART_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_DHEART_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_DHEART_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONHEART_MAGE, oCaster);

		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_DSONG_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_DSONG_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_DSONG_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster);

		if(GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster);

		if(GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_THEURGE, oCaster);	

		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);
			
		if(GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST, oCaster);	

		if(GetHasFeat(FEAT_FMM_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_FMM_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_FMM_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_FMM_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FMM, oCaster);
			
		if(GetHasFeat(FEAT_FOCHULAN_LYRIST_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_FOCHULAN_LYRIST_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_FOCHULAN_LYRIST_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_FOCHULAN_LYRIST_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FOCHULAN_LYRIST, oCaster);

		if(GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FROST_MAGE, oCaster);
			
		if(GetHasFeat(FEAT_HARPERM_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_HARPERM_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_HARPERM_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_HARPERM_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster);
			
		if(GetHasFeat(FEAT_JPM_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_JPM_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_JPM_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_JPM_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oCaster);
			
		if(GetHasFeat(FEAT_MAESTER_SPELLCASTING_MONSTROUS, oCaster)   //:: Shouldn't be possible
		|| GetHasFeat(FEAT_MAESTER_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_MAESTER_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_MAESTER_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAESTER, oCaster);

		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);
			
		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_ALCHEM_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_ALCHEM_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_ALCHEM_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);

		if(GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_NOCTUMANCER, oCaster);

		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);	

		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);

		if(GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SOULCASTER, oCaster);	

		if(GetHasFeat(FEAT_TNECRO_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_TNECRO_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_TNECRO_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_TNECRO_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster);	
		
/* 		if(GetHasFeat(FEAT_REDWIZ_SPELLCASTING_SORCERER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster); */	
		
		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);

		if(GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ULTIMATE_MAGUS, oCaster);	

		if(GetHasFeat(FEAT_UNSEEN_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_UNSEEN_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_UNSEEN_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_UNSEEN_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_UNSEEN_SEER, oCaster);

		if(GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_VIRTUOSO, oCaster);	

		if(GetHasFeat(FEAT_WWOC_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_WWOC_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_WWOC_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_WWOC_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oCaster);
			
		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) /2;

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_BSINGER_SPELLCASTING_MONSTROUS, oCaster)		//:: Shouldn't be possible 
		|| GetHasFeat(FEAT_BSINGER_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_BSINGER_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_BSINGER_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BLADESINGER, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_BONDED_SPELLCASTING_MONSTROUS, oCaster)		//:: Shouldn't be possible 
		|| GetHasFeat(FEAT_BONDED_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_BONDED_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_BONDED_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster) + 1) /2;
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_MONSTROUS, oCaster)		//:: Shouldn't be possible 
		|| GetHasFeat(FEAT_OLLAM_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_OLLAM_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_OLLAM_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) /2;	

		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_ORCUS_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_ORCUS_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_ORCUS_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_MONSTROUS, oCaster)		//:: Shouldn't be possible 
		|| GetHasFeat(FEAT_HATHRAN_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_HATHRAN_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_HATHRAN_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_HAVOC_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_HAVOC_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_HAVOC_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_HAVOC_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HAVOC_MAGE, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_SSWORD_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_SSWORD_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_SSWORD_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_SSWORD_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) + 1) /2;	
			
		if(GetHasFeat(FEAT_GRAZZT_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_GRAZZT_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_GRAZZT_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_GRAZZT_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_TIAMAT_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_TIAMAT_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_TIAMAT_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_RAGE_MAGE, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_WAYFARER_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_WAYFARER_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_WAYFARER_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_WAYFARER_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_WAYFARER_GUIDE, oCaster) + 1) /2;

		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_MONSTROUS, oCaster)	//:: Shouldn't be possible 
		|| GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_SHAPECHANGER, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;
			
		if(GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_MONSTROUS, oCaster) 
		|| GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_ABERRATION, oCaster) 
		|| GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_OUTSIDER, oCaster) 
		|| GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_SHAPECHANGER, oCaster))
		{	nClass = GetLevelByClass(CLASS_TYPE_WILD_MAGE, oCaster); }
			if (nClass) { nArcane += nClass - 3 + d6(); }	
	}
//:: End Aberration / Monstrous / Outsider / Shapechanger Arcane PrC casting calculations 


    if (nCastingClass == CLASS_TYPE_SUBLIME_CHORD)
    {    
         if(GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ABJURANT_CHAMPION, oCaster);
		
		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster);
		
		if(GetHasFeat(FEAT_ANIMA_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCHMAGE, oCaster);
		
		if(GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCTRICK, oCaster);		

		if(GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_BLOOD_MAGUS, oCaster);
		
		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);

		if(GetHasFeat(FEAT_CMANCER_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_CEREBREMANCER, oCaster);
		
		if(GetHasFeat(FEAT_DIABO_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);
		
		if(GetHasFeat(FEAT_DHEART_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONHEART_MAGE, oCaster);	

		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster);			

		if(GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster);

		if(GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_THEURGE, oCaster);		

		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);
		
		if(GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST, oCaster);			

/*  		if(GetHasFeat(FEAT_FMM_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FMM, oCaster); */
		
		if(GetHasFeat(FEAT_FOCHULAN_LYRIST_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FOCHULAN_LYRIST, oCaster);		

		if(GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FROST_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_HARPERM_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster);

		if(GetHasFeat(FEAT_JPM_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_MAESTER_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAESTER, oCaster);		

		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);

		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);
		
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);	

		if(GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_NOCTUMANCER, oCaster);	
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);			
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);

/* 		if(GetHasFeat(FEAT_SHADOWLORD_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOWLORD, oCaster); */

		if(GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SOULCASTER, oCaster);			

		if(GetHasFeat(FEAT_TNECRO_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster);	
		
/* 		if(GetHasFeat(FEAT_REDWIZ_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster); */	

		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);	

		if(GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ULTIMATE_MAGUS, oCaster);		
		
		if(GetHasFeat(FEAT_UNSEEN_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_UNSEEN_SEER, oCaster);	

/* 		if(GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_SUBLIME_CHORD, oCaster))  // no cantrips!
			nArcane += GetLevelByClass(CLASS_TYPE_VIRTUOSO, oCaster); */	
		
		if(GetHasFeat(FEAT_WWOC_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oCaster);

		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) /2;	

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;		

		if(GetHasFeat(FEAT_BSINGER_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BLADESINGER, oCaster) + 1) / 2;
		
/* 		if(GetHasFeat(FEAT_BONDED_SPELLCASTING_SUBLIME_CHORD, oCaster))  //: No familiar!
			nArcane += (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster) + 1) /2;	 */
		
		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;		

		if(GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_HAVOC_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HAVOC_MAGE, oCaster) + 1) /2;
		
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) /2;		

		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2;		
		
		if(GetHasFeat(FEAT_SSWORD_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) + 1) /2;	

		if(GetHasFeat(FEAT_GRAZZT_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_RAGE_MAGE, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_WAYFARER_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_WAYFARER_GUIDE, oCaster) + 1) /2;	
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_SUBLIME_CHORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;

		if(GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_SUBLIME_CHORD, oCaster))
		{	nClass = GetLevelByClass(CLASS_TYPE_WILD_MAGE, oCaster); }
			if (nClass) { nArcane += nClass - 3 + d6(); }	
	}
//:: End SUBLIME_CHORD Arcane PrC casting calculations 

	if (nCastingClass == CLASS_TYPE_SUEL_ARCHANAMACH)
    {    
         if(GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ABJURANT_CHAMPION, oCaster);
		
/* 		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster); */
		
		if(GetHasFeat(FEAT_ANIMA_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oCaster);
		
/* 		if(GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCHMAGE, oCaster); */
		
		if(GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCTRICK, oCaster);	

		if(GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_BLOOD_MAGUS, oCaster);		

		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);

		if(GetHasFeat(FEAT_CMANCER_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_CEREBREMANCER, oCaster);
		
		if(GetHasFeat(FEAT_DIABO_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);
		
		if(GetHasFeat(FEAT_DHEART_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONHEART_MAGE, oCaster);

		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster);			

		if(GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster);

		if(GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_THEURGE, oCaster);		

		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);
		
		if(GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST, oCaster);		

/*  	if(GetHasFeat(FEAT_FMM_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FMM, oCaster); */
		
		if(GetHasFeat(FEAT_FOCHULAN_LYRIST_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FOCHULAN_LYRIST, oCaster);		

		if(GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FROST_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_HARPERM_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster);

		if(GetHasFeat(FEAT_JPM_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_MAESTER_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAESTER, oCaster);		

		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);

		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);
		
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);	

		if(GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_NOCTUMANCER, oCaster);	
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);			
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);

/* 		if(GetHasFeat(FEAT_SHADOWLORD_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOWLORD, oCaster);	 */			

/* 		if(GetHasFeat(FEAT_TNECRO_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster);	 */
		
/* 		if(GetHasFeat(FEAT_REDWIZ_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster); */	

		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);

		if(GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SOULCASTER, oCaster);			

/* 		if(GetHasFeat(FEAT_SUBCHORD_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SUBLIME_CHORD, oCaster); */

		if(GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ULTIMATE_MAGUS, oCaster);			
		
		if(GetHasFeat(FEAT_UNSEEN_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_UNSEEN_SEER, oCaster);	

/* 		if(GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_VIRTUOSO, oCaster);	 */
		
		if(GetHasFeat(FEAT_WWOC_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oCaster);
		
		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) /2;		

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;			

		if(GetHasFeat(FEAT_BSINGER_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BLADESINGER, oCaster) + 1) / 2;
		
/* 		if(GetHasFeat(FEAT_BONDED_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster) + 1) /2; */

		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) /2;		

		if(GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_HAVOC_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HAVOC_MAGE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_SSWORD_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) + 1) /2;	

		if(GetHasFeat(FEAT_GRAZZT_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_RAGE_MAGE, oCaster) + 1) / 2;	

/* 		if(GetHasFeat(FEAT_WAYFARER_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_WAYFARER_GUIDE, oCaster) + 1) /2;	 */
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;

		if(GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_SUEL_ARCHANAMACH, oCaster))
		{	nClass = GetLevelByClass(CLASS_TYPE_WILD_MAGE, oCaster); }
			if (nClass) { nArcane += nClass - 3 + d6(); }
	}
//:: End Suel Archanamach Arcane PrC casting calculations 

	if (nCastingClass == CLASS_TYPE_SHADOWLORD)
    {    
         if(GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_SHADOWLORD, oCaster))  //:: Enter after 4th lvl
			nArcane += GetLevelByClass(CLASS_TYPE_ABJURANT_CHAMPION, oCaster);
		
/* 		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster); */
		
		if(GetHasFeat(FEAT_ANIMA_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oCaster);
		
/* 		if(GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCHMAGE, oCaster); */
		
		if(GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCTRICK, oCaster);		

		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);

		if(GetHasFeat(FEAT_CMANCER_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_CEREBREMANCER, oCaster);
		
		if(GetHasFeat(FEAT_DIABO_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);
		
		if(GetHasFeat(FEAT_DHEART_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONHEART_MAGE, oCaster);	

		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster);			

		if(GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster);

		if(GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_THEURGE, oCaster);		

		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);
		
		if(GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST, oCaster);		

/*		if(GetHasFeat(FEAT_FMM_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FMM, oCaster); */
		
		if(GetHasFeat(FEAT_FOCHULAN_LYRIST_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FOCHULAN_LYRIST, oCaster);		

		if(GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FROST_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_HARPERM_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster);

		if(GetHasFeat(FEAT_JPM_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oCaster);
		
/* 		if(GetHasFeat(FEAT_MAESTER_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAESTER, oCaster); */		

/* 		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);

		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster); */
		
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);	

		if(GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_NOCTUMANCER, oCaster);	
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);			
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);

/* 		if(GetHasFeat(FEAT_TNECRO_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster);	 */
		
/* 		if(GetHasFeat(FEAT_REDWIZ_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster); */	

		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);

		if(GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SOULCASTER, oCaster);			

/* 		if(GetHasFeat(FEAT_SUBCHORD_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SUBLIME_CHORD, oCaster); */

		if(GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ULTIMATE_MAGUS, oCaster);		
		
		if(GetHasFeat(FEAT_UNSEEN_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_UNSEEN_SEER, oCaster);	

/* 		if(GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_VIRTUOSO, oCaster);	
		
		if(GetHasFeat(FEAT_WWOC_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oCaster); */

		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) /2;		
		
		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;			

		if(GetHasFeat(FEAT_BSINGER_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BLADESINGER, oCaster) + 1) / 2;
		
/* 		if(GetHasFeat(FEAT_BONDED_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster) + 1) /2; */

		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;			

		if(GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_HAVOC_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HAVOC_MAGE, oCaster) + 1) /2;

/* 		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) /2; */			
		
		if(GetHasFeat(FEAT_SSWORD_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) + 1) /2;	

		if(GetHasFeat(FEAT_GRAZZT_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_RAGE_MAGE, oCaster) + 1) / 2;	

/* 		if(GetHasFeat(FEAT_WAYFARER_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_WAYFARER_GUIDE, oCaster) + 1) /2; */	
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_SHADOWLORD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;

		if(GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_SHADOWLORD, oCaster))
		{
			nClass = GetLevelByClass(CLASS_TYPE_WILD_MAGE, oCaster);
			if (nClass) { nArcane += nClass - 3 + d6();} 
		}		
	}
//:: End Telflammar Shadowlord Arcane PrC casting calculations 

 	if (nCastingClass == CLASS_TYPE_WARMAGE)
    {    
/*      if(GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ABJURANT_CHAMPION, oCaster); */
		
/* 		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster); */
		
		if(GetHasFeat(FEAT_ANIMA_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCHMAGE, oCaster);
		
		if(GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCTRICK, oCaster);		

		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);
		
		if(GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_BLOOD_MAGUS, oCaster);
		
		if(GetHasFeat(FEAT_CMANCER_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_CEREBREMANCER, oCaster);
		
		if(GetHasFeat(FEAT_DIABO_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);
		
		if(GetHasFeat(FEAT_DHEART_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONHEART_MAGE, oCaster);

		if(GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster);

		if(GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_THEURGE, oCaster);		

		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);
		
		if(GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST, oCaster);		

 		if(GetHasFeat(FEAT_FMM_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FMM, oCaster);
		
		if(GetHasFeat(FEAT_FOCHULAN_LYRIST_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FOCHULAN_LYRIST, oCaster);
		
		if(GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FROST_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_HARPERM_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster);

		if(GetHasFeat(FEAT_JPM_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_MAESTER_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAESTER, oCaster);		

		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);

		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);
		
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);	

		if(GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_NOCTUMANCER, oCaster);

		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);			
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);

/* 		if(GetHasFeat(FEAT_SHADOWLORD_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOWLORD, oCaster); */

		if(GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SOULCASTER, oCaster);			

/* 		if(GetHasFeat(FEAT_TNECRO_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster); */	
		
/* 		if(GetHasFeat(FEAT_REDWIZ_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster); */	

		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);	

/* 		if(GetHasFeat(FEAT_SUBCHORD_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SUBLIME_CHORD, oCaster); */

		if(GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ULTIMATE_MAGUS, oCaster);			
		
		if(GetHasFeat(FEAT_UNSEEN_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_UNSEEN_SEER, oCaster);	

		if(GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_VIRTUOSO, oCaster);	
		
		if(GetHasFeat(FEAT_WWOC_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oCaster);

		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_WARMAGE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) /2;		

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_WARMAGE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;			

		if(GetHasFeat(FEAT_BSINGER_SPELLCASTING_WARMAGE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BLADESINGER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_BONDED_SPELLCASTING_WARMAGE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster) + 1) /2;

		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_WARMAGE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;		

		if(GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_WARMAGE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_WARMAGE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_HAVOC_SPELLCASTING_WARMAGE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HAVOC_MAGE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_WARMAGE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) /2;		
		
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_WARMAGE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2;		
		
		if(GetHasFeat(FEAT_SSWORD_SPELLCASTING_WARMAGE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) + 1) /2;	

		if(GetHasFeat(FEAT_GRAZZT_SPELLCASTING_WARMAGE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_WARMAGE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_WARMAGE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_RAGE_MAGE, oCaster) + 1) / 2;	

/* 		if(GetHasFeat(FEAT_WAYFARER_SPELLCASTING_WARMAGE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_WAYFARER_GUIDE, oCaster) + 1) /2; */	
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_WARMAGE, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;

		if(GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_WARMAGE, oCaster))
		{	nClass = GetLevelByClass(CLASS_TYPE_WILD_MAGE, oCaster); }
			if (nClass) { nArcane += nClass - 3 + d6(); }
	}
//:: End Warmage Arcane PrC casting calculations 

 	if (nCastingClass == CLASS_TYPE_WIZARD)
    {    
        if(GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ABJURANT_CHAMPION);
		
		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster);
		
		if(GetHasFeat(FEAT_ANIMA_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCHMAGE, oCaster);
		
		if(GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ARCTRICK, oCaster);		

		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);
		
		if(GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_BLOOD_MAGUS, oCaster);		

		if(GetHasFeat(FEAT_CMANCER_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_CEREBREMANCER, oCaster);
		
		if(GetHasFeat(FEAT_DIABO_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);
		
/* 		if(GetHasFeat(FEAT_DHEART_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_DRAGONHEART_MAGE, oCaster); */		

		if(GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster);

		if(GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELDRITCH_THEURGE, oCaster);		

		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);
		
		if(GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST, oCaster);		

		if(GetHasFeat(FEAT_FMM_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FMM, oCaster);

		if(GetHasFeat(FEAT_FOCHULAN_LYRIST_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FOCHULAN_LYRIST, oCaster);		

		if(GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_FROST_MAGE, oCaster);
		
		if(GetHasFeat(FEAT_HARPERM_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster);

		if(GetHasFeat(FEAT_JPM_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oCaster);

		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);
		
		if(GetHasFeat(FEAT_MAESTER_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MAESTER, oCaster);		

		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);
		
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);	

		if(GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_NOCTUMANCER, oCaster);

		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);				
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);

		if(GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_WARMAGE, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SOULCASTER, oCaster);			

		if(GetHasFeat(FEAT_TNECRO_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster);	
		
		if(GetHasFeat(FEAT_REDWIZ_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster);	

		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);

/* 		if(GetHasFeat(FEAT_SHADOWLORD_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SHADOWLORD, oCaster); */		

/* 		if(GetHasFeat(FEAT_SUBCHORD_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_SUBLIME_CHORD, oCaster); */

		if(GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_ULTIMATE_MAGUS, oCaster);			
		
		if(GetHasFeat(FEAT_UNSEEN_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_UNSEEN_SEER, oCaster);	

		if(GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_VIRTUOSO, oCaster);	
		
		if(GetHasFeat(FEAT_WWOC_SPELLCASTING_WIZARD, oCaster))
			nArcane += GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oCaster);

		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_WIZARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) /2;

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_WIZARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;		

		if(GetHasFeat(FEAT_BSINGER_SPELLCASTING_WIZARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BLADESINGER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_BONDED_SPELLCASTING_WIZARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster) + 1) /2;
		
		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_WIZARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_WIZARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) /2;			
		
/* 		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_WIZARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) /2; */	

		if(GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_WIZARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_WIZARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_HAVOC_SPELLCASTING_WIZARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_HAVOC_MAGE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_SSWORD_SPELLCASTING_WIZARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) + 1) /2;	

		if(GetHasFeat(FEAT_GRAZZT_SPELLCASTING_WIZARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_WIZARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_WIZARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_RAGE_MAGE, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_WAYFARER_SPELLCASTING_WIZARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_WAYFARER_GUIDE, oCaster) + 1) /2;	
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_WIZARD, oCaster))
			nArcane += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;

		if(GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_WIZARD, oCaster))
		{	nClass = GetLevelByClass(CLASS_TYPE_WILD_MAGE, oCaster);}
			if (nClass) { nArcane += nClass - 3 + d6(); }		
	}
//:: End Wizard Arcane PrC casting calculations         
}