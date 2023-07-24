		   
#include "prc_class_const"
#include "prc_feat_const"
#include "prc_inc_spells"

void main ()
{
	object oCaster = GetLastSpellCaster();
	
	int nCastingClass = PRCGetLastSpellCastClass();
	
	int nDivine = 0;

	if (nCastingClass == CLASS_TYPE_ARCHIVIST)
    {
		if (!GetHasFeat(FEAT_SF_CODE, oCaster) && GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_ARCHIVIST, oCaster))
		{
			nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
		}
		
		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_ARCHIVIST, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_ARCHIVIST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);
		
		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_ARCHIVIST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster);		
		
		if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_ARCHIVIST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_ARCHIVIST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_ARCHIVIST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_ARCHIVIST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);			

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_ARCHIVIST, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;		
		
		if(GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_ARCHIVIST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_ARCHIVIST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);		
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_ARCHIVIST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
		if(GetHasFeat(FEAT_FMM_SPELLCASTING_ARCHIVIST, oCaster))	//:: Not divine
			nDivine += GetLevelByClass(CLASS_TYPE_FMM, oCaster);
		
		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster);
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_ARCHIVIST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);		

		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);			
		
/* 		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_ARCHIVIST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster); */
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster) + 1) / 2;		
			
		if(GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster);
			
		if(GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_ARCHIVIST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oCaster);
			
		if(GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_ARCHIVIST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
			
		if(GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SACREDPURIFIER, oCaster);
			
		if(GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oCaster);
		
		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_ARCHIVIST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);		
			
		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_ARCHIVIST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_ARCHIVIST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);		
			
		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_ARCHIVIST, oCaster))	
			nDivine += (GetLevelByClass(CLASS_TYPE_BFZ, oCaster) + 1) / 2;			
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_ARCHIVIST, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_ARCHIVIST, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;		
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_ARCHIVIST, oCaster))		
			nDivine += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;		
			
		if(GetHasFeat(FEAT_KORD_SPELLCASTING_ARCHIVIST, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_ARCHIVIST, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_ARCHIVIST, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;	
			
		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_WAYFARER_SPELLCASTING_ARCHIVIST, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_WAYFARER_GUIDE, oCaster) + 1) / 2;		
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_ARCHIVIST, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;		
		
	}
//:: End Archivist Divine PrC casting calculations


	if (nCastingClass == CLASS_TYPE_BLACKGUARD)
    {    
		if (!GetHasFeat(FEAT_SF_CODE, oCaster) && GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_BLACKGUARD, oCaster))
		{
			nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
		}
		
		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_BLACKGUARD, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_BLACKGUARD, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);		
		
		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_BLACKGUARD, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster);			
		
		if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_BLACKGUARD, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
/* 		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_BLACKGUARD, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster); */
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_BLACKGUARD, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_BLACKGUARD, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);	

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_BLACKGUARD, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;			
		
		if(GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_BLACKGUARD, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
/* 		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_BLACKGUARD, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster);
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_BLACKGUARD, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster); */
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster);
		
/* 		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster); */
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster);
			
		if(GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_BLACKGUARD, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oCaster);
			
		if(GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_BLACKGUARD, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
			
/* 		if(GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SACREDPURIFIER, oCaster); */
			
		if(GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oCaster);
		
		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_BLACKGUARD, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);		
			
/* 		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_BLACKGUARD, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster); */
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_BLACKGUARD, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);			
			
		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_BLACKGUARD, oCaster))	
			nDivine += (GetLevelByClass(CLASS_TYPE_BFZ, oCaster) + 1) / 2;			
			
/* 		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_BLACKGUARD, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster) + 1) / 2; */
		
/*		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_BLACKGUARD, oCaster))		
			nDivine += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;	 */	
			
/* 		if(GetHasFeat(FEAT_KORD_SPELLCASTING_BLACKGUARD, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster) + 1) / 2; */
			
/* 		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_BLACKGUARD, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) / 2; */
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2;
			
/* 		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster) + 1) / 2; */
		
		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_BLACKGUARD, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;		
			
		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_BLACKGUARD, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;		
		
	}
//:: End Blackguard Divine PrC casting calculations


	if (nCastingClass == CLASS_TYPE_BLIGHTER)
    {    
		if (!GetHasFeat(FEAT_SF_CODE, oCaster) && GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_BLIGHTER, oCaster))
		{
			nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
		}
		
		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_BLIGHTER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);	
		
		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_BLIGHTER, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_BLIGHTER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
/* 		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_BLIGHTER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster); */
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_BLIGHTER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_BLIGHTER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_BLIGHTER, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;		
		
		if(GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_BLIGHTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_BLIGHTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);		
		
/* 		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster); */
		
/* 		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_BLIGHTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster); */
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_BLIGHTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);

		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster);
			
/* 		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster); */
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster);
			
		if(GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_BLIGHTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oCaster);
			
		if(GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_BLIGHTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
			
/* 		if(GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SACREDPURIFIER, oCaster); */
			
		if(GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oCaster);
		
		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_BLIGHTER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);		
			
/* 		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_BLIGHTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster); */
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_BLIGHTER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);		
			
		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_BLIGHTER, oCaster))	
			nDivine += (GetLevelByClass(CLASS_TYPE_BFZ, oCaster) + 1) / 2;		
			
/* 		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_BLIGHTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_BLIGHTER, oCaster))		
			nDivine += GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster + 1) / 2		
			
		if(GetHasFeat(FEAT_KORD_SPELLCASTING_BLIGHTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_BLIGHTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_OLLAM, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2;
			
/* 		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster + 1) / 2 */
		
		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_BLIGHTER, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;			
			
/*		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_BLIGHTER, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;	
		
	}
//:: End Blighter Divine PrC casting calculations


	if (nCastingClass == CLASS_TYPE_CLERIC)
    {   

		if (!GetHasFeat(FEAT_SF_CODE, oCaster) && GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_CLERIC, oCaster))
		{
			nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
		}
		
		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_CLERIC, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);
		
		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_CLERIC, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_CLERIC, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster);		
        
		if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_CLERIC, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_CLERIC, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_CLERIC, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_CLERIC, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_CLERIC, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;			
		
		if(GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_CLERIC, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_CLERIC, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);		
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_CLERIC, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
		if(GetHasFeat(FEAT_FMM_SPELLCASTING_CLERIC, oCaster) && GetHasFeat(FEAT_BONUS_DOMAIN_FORCE, oCaster) || GetHasFeat(FEAT_DOMAIN_POWER_FORCE, oCaster))	//:: Not divine
			nDivine += GetLevelByClass(CLASS_TYPE_FMM, oCaster);		
		
		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster);
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_CLERIC, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);

		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);			
		
		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster);
		
		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);		
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_CLERIC, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster);
			
		if(GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_CLERIC, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oCaster);
			
		if(GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_CLERIC, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
			
		if(GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SACREDPURIFIER, oCaster);
			
		if(GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oCaster);
		
		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_CLERIC, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);		

		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_CLERIC, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);			
			
		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_CLERIC, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);
			
		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_CLERIC, oCaster))	
			nDivine += (GetLevelByClass(CLASS_TYPE_BFZ, oCaster) + 1) / 2;			
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_CLERIC, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_CLERIC, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;		
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_CLERIC, oCaster))		
			nDivine += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_KORD_SPELLCASTING_CLERIC, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_CLERIC, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_CLERIC, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_CLERIC, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_CLERIC, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;		
			
		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_CLERIC, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_CLERIC, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_WAYFARER_SPELLCASTING_CLERIC, oCaster) && GetHasFeat(FEAT_BONUS_DOMAIN_TRAVEL, oCaster) || GetHasFeat(FEAT_TRAVEL_DOMAIN_POWER, oCaster))	//:: Not divine
			nDivine += (GetLevelByClass(CLASS_TYPE_WAYFARER_GUIDE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_CLERIC, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;		
		
	}
//:: End Cleric Divine PrC casting calculations


	if (nCastingClass == CLASS_TYPE_DRUID)
    {
		if (!GetHasFeat(FEAT_SF_CODE, oCaster) && GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_DRUID, oCaster))
		{
			nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
		}
		
		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_DRUID, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_DRUID, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);		

		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_DRUID, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster);		

	/*	if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_DRUID, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster); */
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_DRUID, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_DRUID, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_DRUID, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_DRUID, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;		
		
		if(GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_DRUID, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_DRUID, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);			
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
/* 		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_DRUID, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster); */
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_DRUID, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);				
		
		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster);
		
		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);		
			
/* 		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster); */
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_DRUID, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster);
			
/* 		if(GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_DRUID, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oCaster); */
			
		if(GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_DRUID, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
			
		if(GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SACREDPURIFIER, oCaster);
			
		if(GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oCaster);
		
		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_DRUID, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);		
			
/* 		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_DRUID, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster); */
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_DRUID, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);		
			
		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
		
		if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);		
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
/* 		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_DRUID, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2	 */		
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_DRUID, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_DRUID, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_DRUID, oCaster))		
			nDivine += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;		
			
/* 		if(GetHasFeat(FEAT_KORD_SPELLCASTING_DRUID, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2 */
			
/* 		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_DRUID, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_DRUID, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_DRUID, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster) + 1) / 2; */
		
		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_DRUID, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;			
			
/*		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_DRUID, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster) + 1) / 2; */
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_DRUID, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_DRUID, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;		
		
	}
//:: End Druid Divine PrC casting calculations

	   
 	if (nCastingClass == CLASS_TYPE_FAVOURED_SOUL)
    {
		if (!GetHasFeat(FEAT_SF_CODE, oCaster) && GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_FAVOURED_SOUL, oCaster))
		{
			nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
		}
		
		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_FAVOURED_SOUL, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_FAVOURED_SOUL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);		
		
		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_FAVOURED_SOUL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster);		
		
		if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_FAVOURED_SOUL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_FAVOURED_SOUL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_FAVOURED_SOUL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_FAVOURED_SOUL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);	

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_FAVOURED_SOUL, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;

		if(GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_FAVOURED_SOUL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_FAVOURED_SOUL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);		
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_FAVOURED_SOUL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster);
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_FAVOURED_SOUL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);				
		
		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster);
		
		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);			
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster);
			
		if(GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_FAVOURED_SOUL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oCaster);
			
		if(GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_FAVOURED_SOUL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
			
		if(GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SACREDPURIFIER, oCaster);
			
		if(GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oCaster);
		
		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_FAVOURED_SOUL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);			
			
		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_FAVOURED_SOUL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_FAVOURED_SOUL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);		
			
		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_FAVOURED_SOUL, oCaster))	
			nDivine += (GetLevelByClass(CLASS_TYPE_BFZ, oCaster) + 1) / 2;			
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_FAVOURED_SOUL, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_FAVOURED_SOUL, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;			
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_FAVOURED_SOUL, oCaster))		
			nDivine += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;			
			
		if(GetHasFeat(FEAT_KORD_SPELLCASTING_FAVOURED_SOUL, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster) + 1) / 2;	
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_FAVOURED_SOUL, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) / 2;	
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2;	
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_FAVOURED_SOUL, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;			
			
		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster) + 1) / 2;	
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_FAVOURED_SOUL, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;			
		
	}
//:: End Favoured Soul Divine PrC casting calculations	
   

 	if (nCastingClass == CLASS_TYPE_HEALER)
    {
		if (!GetHasFeat(FEAT_SF_CODE, oCaster) && GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_HEALER, oCaster))
		{
			nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
		}		
		
		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_HEALER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);
		
/*		if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_HEALER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster); */
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_HEALER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_HEALER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_HEALER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
/* 		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_HEALER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster); */
		
		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster);
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_HEALER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
/* 		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster); */
		
		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);		
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_HEALER, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster);
			
		if(GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_HEALER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oCaster);
			
		if(GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_HEALER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
			
		if(GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SACREDPURIFIER, oCaster);
			
		if(GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oCaster);
			
		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_HEALER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_HEALER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);			
			
/* 		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster); */
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
/* 		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);		 */	
			
/* 		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_HEALER, oCaster))	
			nDivine += (GetLevelByClass(CLASS_TYPE_BFZ, oCaster) + 1) / 2; */			
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_HEALER, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster) + 1) / 2;		

		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_HEALER, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;				
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_HEALER, oCaster))		
			nDivine += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;			
			
		if(GetHasFeat(FEAT_KORD_SPELLCASTING_HEALER, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster) + 1) / 2;	
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_HEALER, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) / 2;	
			
/* 		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_HEALER, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2; */
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_HEALER, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster) + 1) / 2;	
			
/* 		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_HEALER, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster) + 1) / 2; */
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_HEALER, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2;	
		
/* 		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_HEALER, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;	 */	
		
	}
//:: End Healer Divine PrC casting calculations	
   
	   
 	if (nCastingClass == CLASS_TYPE_JUSTICEWW)
    {
		if (!GetHasFeat(FEAT_SF_CODE, oCaster) && GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_JUSTICEWW, oCaster))
		{
			nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
		}
		
		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_JUSTICEWW, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_JUSTICEWW, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);		
		
		if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_JUSTICEWW, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_JUSTICEWW, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_JUSTICEWW, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_JUSTICEWW, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);	

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_JUSTICEWW, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;			
		
		if(GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_JUSTICEWW, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
/* 		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_JUSTICEWW, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster); */
		
		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster);
		
/* 		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_JUSTICEWW, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster); */
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster);
		
		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);				
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster);
			
		if(GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_JUSTICEWW, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oCaster);
			
		if(GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_JUSTICEWW, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
			
		if(GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SACREDPURIFIER, oCaster);
			
		if(GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oCaster);
		
		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_JUSTICEWW, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);				
			
		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_JUSTICEWW, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_JUSTICEWW, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);		
			
		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_JUSTICEWW, oCaster))	
			nDivine += (GetLevelByClass(CLASS_TYPE_BFZ, oCaster) + 1) / 2;				
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_JUSTICEWW, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_JUSTICEWW, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;			
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_JUSTICEWW, oCaster))		
			nDivine += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;			
			
		if(GetHasFeat(FEAT_KORD_SPELLCASTING_JUSTICEWW, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster) + 1) / 2;	
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_JUSTICEWW, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) / 2;	
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2;	
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_JUSTICEWW, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;			
			
		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster) + 1) / 2;	
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_JUSTICEWW, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;			
		
	}
//:: End Justice of Weald & Woe Divine PrC casting calculations	   
	   
	   
 	if (nCastingClass == CLASS_TYPE_KNIGHT_CHALICE)
    {
		if (!GetHasFeat(FEAT_SF_CODE, oCaster) && GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_KNIGHT_CHALICE, oCaster))
		{
			nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
		}
		
		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_KNIGHT_CHALICE, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);
		
		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_KNIGHT_CHALICE, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster);
		
/*         if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_KNIGHT_CHALICE, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster); */
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_KNIGHT_CHALICE, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_KNIGHT_CHALICE, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_KNIGHT_CHALICE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_KNIGHT_CHALICE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
/* 		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster); */
		
/* 		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_KNIGHT_CHALICE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster); */
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
/* 		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster); */
		
		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);			
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
/* 		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster) + 1) / 2; */
		
		if(GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster);
			
		if(GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_KNIGHT_CHALICE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oCaster);
			
		if(GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_KNIGHT_CHALICE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
			
		if(GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SACREDPURIFIER, oCaster);
			
		if(GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oCaster);
			
		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_KNIGHT_CHALICE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_KNIGHT_CHALICE, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);		
			
/* 		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster); */
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
/* 		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_KNIGHT_CHALICE, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2	 */		
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_KNIGHT_CHALICE, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_KNIGHT_CHALICE, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;				
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_KNIGHT_CHALICE, oCaster))		
			nDivine += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;			
			
/* 		if(GetHasFeat(FEAT_KORD_SPELLCASTING_KNIGHT_CHALICE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_KNIGHT_CHALICE, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) / 2;	
			
/* 		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster) + 1) / 2;	
			
/* 		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2;	;
		
/* 		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_KNIGHT_CHALICE, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;	 */	
		
	}
//:: End Knight of the Chalice Divine PrC casting calculations


 	if (nCastingClass == CLASS_TYPE_KNIGHT_MIDDLECIRCLE)
    {
		if (!GetHasFeat(FEAT_SF_CODE, oCaster) && GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))
		{
			nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
		}
		
/*         if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster); */
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster);
		
/* 		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster); */
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
/* 		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster); */
		
		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);		
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster);
			
		if(GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oCaster);
			
		if(GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
			
		if(GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SACREDPURIFIER, oCaster);
			
		if(GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oCaster);
			
		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);		
			
/* 		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster); */
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
/* 		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2		 */	
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;			
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))		
			nDivine += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;			
			
/* 		if(GetHasFeat(FEAT_KORD_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) / 2;	
			
/* 		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster) + 1) / 2;	
			
/* 		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2;	
		
/* 		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;		 */
		
	}
//:: End Knight of the Middle Circle Divine PrC casting calculations			   
	   
	   
 	if (nCastingClass == CLASS_TYPE_NENTYAR_HUNTER)
    {
		if (!GetHasFeat(FEAT_SF_CODE, oCaster) && GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_NENTYAR_HUNTER, oCaster))
		{
			nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
		}
		
		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_NENTYAR_HUNTER, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) / 2;	

		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_NENTYAR_HUNTER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);		
		
/*		if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_NENTYAR_HUNTER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster); */
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_NENTYAR_HUNTER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_NENTYAR_HUNTER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_NENTYAR_HUNTER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);

		if(GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_NENTYAR_HUNTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_NENTYAR_HUNTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);		
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
		if(GetHasFeat(FEAT_FMM_SPELLCASTING_NENTYAR_HUNTER, oCaster))	//:: Not divine
			nDivine += GetLevelByClass(CLASS_TYPE_FMM, oCaster);
		
/* 		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_NENTYAR_HUNTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster); */
		
/* 		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster); */
		
/* 		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_NENTYAR_HUNTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster); */
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);		
		
/* 		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster); */
		
		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);			
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster);
			
		if(GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_NENTYAR_HUNTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oCaster);
			
		if(GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_NENTYAR_HUNTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
			
		if(GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SACREDPURIFIER, oCaster);
			
		if(GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oCaster);
		
		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_NENTYAR_HUNTER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);		
			
		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_NENTYAR_HUNTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_NENTYAR_HUNTER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);		
			
/* 		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster); */
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
/* 		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);	 */		
			
/* 		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_NENTYAR_HUNTER, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2	 */		
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_NENTYAR_HUNTER, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_NENTYAR_HUNTER, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;			
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_NENTYAR_HUNTER, oCaster))		
			nDivine += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;			
			
		if(GetHasFeat(FEAT_KORD_SPELLCASTING_NENTYAR_HUNTER, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster) + 1) / 2;	
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_NENTYAR_HUNTER, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) / 2;	
			
/* 		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster) + 1) / 2;	
			
/* 		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2;	
		
/* 		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_NENTYAR_HUNTER, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;	 */	
		
	}
//:: End Nentyar Hunter Divine PrC casting calculations	   
	   
	   
 	if (nCastingClass == CLASS_TYPE_OCULAR)
    {
		if (!GetHasFeat(FEAT_SF_CODE, oCaster) && GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_OCULAR, oCaster))
		{
			nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
		}
		
		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_OCULAR, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_OCULAR, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);			
		
		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_OCULAR, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster);		
		
        if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_OCULAR, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
/* 		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_OCULAR, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_OCULAR, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster); */
		
		if(GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_OCULAR, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);
		
		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_OCULAR, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;		

		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_OCULAR, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);		
		
		if(GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_OCULAR, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
/* 		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_OCULAR, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster); */
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_OCULAR, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);				
		
		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster);
			
/* 		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster); */
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_OCULAR, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster) + 1) / 2;	
		
		if(GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster);
			
		if(GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_OCULAR, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oCaster);
			
		if(GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_OCULAR, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
			
/* 		if(GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SACREDPURIFIER, oCaster); */
			
		if(GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oCaster);
		
		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_OCULAR, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);		
			
/* 		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_OCULAR, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster); */
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_OCULAR, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);		
			
		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_OCULAR, oCaster))	
			nDivine += (GetLevelByClass(CLASS_TYPE_BFZ, oCaster) + 1) / 2;			
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_OCULAR, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster) + 1) / 2;
			
/* 		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_OCULAR, oCaster))		
			nDivine += GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster + 1) / 2	 */	
			
/* 		if(GetHasFeat(FEAT_KORD_SPELLCASTING_OCULAR, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2 */
			
/* 		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_OCULAR, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_OLLAM, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_OCULAR, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2;
			
/* 		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster + 1) / 2 */
		
		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_OCULAR, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;		
			
		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_OCULAR, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_OCULAR, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_OCULAR, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;		
		
	}
//:: End Ocular Adept Divine PrC casting calculations		   
	   
	   
 	if (nCastingClass == CLASS_TYPE_PALADIN)
    {
		if (!GetHasFeat(FEAT_SF_CODE, oCaster) && GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_PALADIN, oCaster))
		{
			nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
		}

		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_PALADIN, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);
		
/*         if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_PALADIN, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_PALADIN, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster); */
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_PALADIN, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_PALADIN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
/* 		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster); */
		
		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_PALADIN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
/* 		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster); */
		
/* 		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_PALADIN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster); */
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
/* 		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster); */
		
		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);			
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_PALADIN, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster);
			
		if(GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_PALADIN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oCaster);
			
		if(GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_PALADIN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
			
		if(GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SACREDPURIFIER, oCaster);
			
		if(GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oCaster);
			
		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_PALADIN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_PALADIN, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);		
			
/* 		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster); */
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
/* 		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_PALADIN, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2		 */	
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_PALADIN, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_PALADIN, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;		
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_PALADIN, oCaster))		
			nDivine += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;		
			
/* 		if(GetHasFeat(FEAT_KORD_SPELLCASTING_PALADIN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_PALADIN, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) / 2;
			
/* 		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_PALADIN, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster) + 1) / 2;
			
/* 		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_PALADIN, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2;
		
/* 		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_PALADIN, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3; */		
		
	}
//:: End Paladin Divine PrC casting calculations	   
	   
	   
 	if (nCastingClass == CLASS_TYPE_RANGER)
    {
		if (!GetHasFeat(FEAT_SF_CODE, oCaster) && GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_RANGER, oCaster))
		{
			nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
		}		

		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_RANGER, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_RANGER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);		
		
		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_RANGER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster);			
		
        if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_RANGER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_RANGER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_RANGER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_RANGER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_RANGER, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;		
		
		if(GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_RANGER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
/* 		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_RANGER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster); */
		
		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster);
		
/* 		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_RANGER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster); */
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster);
		
		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);			
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_RANGER, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster);
			
		if(GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_RANGER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oCaster);
			
		if(GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_RANGER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
			
		if(GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SACREDPURIFIER, oCaster);
			
		if(GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oCaster);
		
		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_RANGER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);		
			
		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_RANGER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_RANGER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);		
			
		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_RANGER, oCaster))	
			nDivine += (GetLevelByClass(CLASS_TYPE_BFZ, oCaster) + 1) / 2;			
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_RANGER, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_RANGER, oCaster))		
			nDivine += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;		
			
		if(GetHasFeat(FEAT_KORD_SPELLCASTING_RANGER, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_RANGER, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_RANGER, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_RANGER, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_RANGER, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;		
			
		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_RANGER, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_RANGER, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_RANGER, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;		
		
	}
//:: End Ranger Divine PrC casting calculations	   
	   
	   
 	if (nCastingClass == CLASS_TYPE_SHAMAN)
    {
		if (!GetHasFeat(FEAT_SF_CODE, oCaster) && GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_OASHAMAN, oCaster))
		{
			nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
		}
		
		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_OASHAMAN, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_OASHAMAN, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);		
		
		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_OASHAMAN, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster);		
		
		if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_OASHAMAN, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_OASHAMAN, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_OASHAMAN, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_OASHAMAN, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_OASHAMAN, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;			
		
		if(GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_OASHAMAN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_OASHAMAN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);		
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_OASHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
/* 		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_OASHAMAN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster); */
		
		if(GetHasFeat(FEAT_FMM_SPELLCASTING_OASHAMAN, oCaster) && GetHasFeat(FEAT_BONUS_DOMAIN_FORCE, oCaster) || GetHasFeat(FEAT_DOMAIN_POWER_FORCE, oCaster))	//:: Not divine
			nDivine += GetLevelByClass(CLASS_TYPE_FMM, oCaster);
		
		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_OASHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster);
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_OASHAMAN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_OASHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_OASHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);				
		
		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_OASHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster);
		
		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_OASHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);		
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_OASHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_OASHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_OASHAMAN, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_OASHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster);
			
		if(GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_OASHAMAN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oCaster);
			
		if(GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_OASHAMAN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
			
		if(GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_OASHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SACREDPURIFIER, oCaster);
			
		if(GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_OASHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oCaster);
		
		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_OASHAMAN, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);			
			
		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_OASHAMAN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_OASHAMAN, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);		
			
		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_OASHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_OASHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_OASHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_OASHAMAN, oCaster))	
			nDivine += (GetLevelByClass(CLASS_TYPE_BFZ, oCaster) + 1) / 2;			
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_OASHAMAN, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_OASHAMAN, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;			
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_OASHAMAN, oCaster))		
			nDivine += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;		
			
		if(GetHasFeat(FEAT_KORD_SPELLCASTING_OASHAMAN, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_OASHAMAN, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_OASHAMAN, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_OASHAMAN, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_OASHAMAN, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;			
			
		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_OASHAMAN, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_WAYFARER_SPELLCASTING_OASHAMAN, oCaster) && GetHasFeat(FEAT_BONUS_DOMAIN_TRAVEL, oCaster) || GetHasFeat(FEAT_TRAVEL_DOMAIN_POWER, oCaster))	//:: Not divine
			nDivine += (GetLevelByClass(CLASS_TYPE_WAYFARER_GUIDE, oCaster) + 1) / 2;			
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_OASHAMAN, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_OASHAMAN, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;		
		
	}
//:: End Shaman Divine PrC casting calculations	   	   
	   
	   
 	if (nCastingClass == CLASS_TYPE_SLAYER_OF_DOMIEL)
    {
		if (!GetHasFeat(FEAT_SF_CODE, oCaster) && GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_DOMIEL, oCaster))
		{
			nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
		}		
		
/*         if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_DOMIEL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_DOMIEL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster); */
		
		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_DOMIEL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);			
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_DOMIEL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_DOMIEL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_DOMIEL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
/* 		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster); */
		
/* 		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_DOMIEL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster); */
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
/* 		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster); */
		
		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);			
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster);
			
		if(GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_DOMIEL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oCaster);
			
		if(GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_DOMIEL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
			
		if(GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SACREDPURIFIER, oCaster);
			
		if(GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oCaster);
			
		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_DOMIEL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_DOMIEL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);		
			
/* 		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster); */
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
/* 		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_DOMIEL, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2		 */	
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_DOMIEL, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_DOMIEL, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;			
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_DOMIEL, oCaster))		
			nDivine += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;		
			
/* 		if(GetHasFeat(FEAT_KORD_SPELLCASTING_DOMIEL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_DOMIEL, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) / 2;
			
/* 		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster) + 1) / 2;
			
/* 		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2;
		
/* 		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_DOMIEL, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;	 */	
		
	}
//:: End Slayer of Domiel Divine PrC casting calculations		   
	   
	   
 	if (nCastingClass == CLASS_TYPE_SOHEI)
    {
		if (!GetHasFeat(FEAT_SF_CODE, oCaster) && GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_SOHEI, oCaster))
		{
			nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
		}
		
		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_SOHEI, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_SOHEI, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);		

/* 		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_SOHEI, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster); */				
		
		if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_SOHEI, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
/* 		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_SOHEI, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster); */
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_SOHEI, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_SOHEI, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_SOHEI, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;		
		
		if(GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_SOHEI, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_SOHEI, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
/* 		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster); */
		
/* 		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_SOHEI, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster); */
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster);
		
		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);			
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_SOHEI, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster);
			
/* 		if(GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_SOHEI, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oCaster); */
			
		if(GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_SOHEI, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
			
		if(GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SACREDPURIFIER, oCaster);
			
		if(GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oCaster);
		
		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_SOHEI, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);			
			
/* 		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_SOHEI, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster); */
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_SOHEI, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);		
			
/* 		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster); */
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_SOHEI, oCaster))	
			nDivine += (GetLevelByClass(CLASS_TYPE_BFZ, oCaster) + 1) / 2;			
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_SOHEI, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_SOHEI, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;		
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_SOHEI, oCaster))		
			nDivine += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;		
			
/* 		if(GetHasFeat(FEAT_KORD_SPELLCASTING_SOHEI, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_SOHEI, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_SOHEI, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2;
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_SOHEI, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_SOHEI, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;		
			
/* 		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_SOHEI, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_SOHEI, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;		
		
	}
//:: End Sohei Divine PrC casting calculations		   
	   
	   
 	if (nCastingClass == CLASS_TYPE_SOLDIER_OF_LIGHT)
    {
		if (!GetHasFeat(FEAT_SF_CODE, oCaster) && GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_SOL, oCaster))
		{
			nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
		}
		
/*         if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_SOL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster); */
		
		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_SOL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);		
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_SOL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_SOL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_SOL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
/* 		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_SOL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster); */
		
/* 		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster); */
		
/* 		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_SOL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster); */
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
/* 		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster); */
		
		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);	
		
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_SOL, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster);
			
		if(GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_SOL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oCaster);
			
		if(GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_SOL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
			
		if(GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SACREDPURIFIER, oCaster);
			
/* 		if(GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oCaster); */
			
/* 		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_SOL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);*/
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_SOL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);		
			
		/*if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster); */
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
/* 		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_SOL, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2		 */	
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_SOL, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_SOL, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;			
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_SOL, oCaster))		
			nDivine += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;		
			
/* 		if(GetHasFeat(FEAT_KORD_SPELLCASTING_SOL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_SOL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_OLLAM, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_SOL, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2;
		
/* 		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_SOL, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;	 */	
		
	}
//:: End Soldier of Light Divine PrC casting calculations		   
	   
	   
 	if (nCastingClass == CLASS_TYPE_UR_PRIEST)
    { 
		if (!GetHasFeat(FEAT_SF_CODE, oCaster) && GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_UR_PRIEST, oCaster))
		{
			nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
		}
		
		if(GetHasFeat(FEAT_ACOLYTE_SPELLCASTING_UR_PRIEST, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) / 2; 
		
		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_UR_PRIEST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);		

		if(GetHasFeat(FEAT_ALIENIST_SPELLCASTING_UR_PRIEST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_ALIENIST, oCaster);		
		
/*         if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_UR_PRIEST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_UR_PRIEST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster); */
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_UR_PRIEST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_UR_PRIEST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);

		if(GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_UR_PRIEST, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2;		
		
		if(GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_UR_PRIEST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_UR_PRIEST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT, oCaster);		
		
/* 		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster); */
		
/* 		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_UR_PRIEST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster); */
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_UR_PRIEST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
		if(GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);			
		
/* 		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster);
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster); */
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster);
			
		if(GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_UR_PRIEST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oCaster);
			
		if(GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_UR_PRIEST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
			
/* 		if(GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SACREDPURIFIER, oCaster); */
			
		if(GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oCaster);
		
		if(GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_UR_PRIEST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);			
			
/* 		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_UR_PRIEST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster); */
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_UR_PRIEST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);		
			
/*		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster); */
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_UR_PRIEST, oCaster))	
			nDivine += (GetLevelByClass(CLASS_TYPE_BFZ, oCaster) + 1) / 2;			
			
/* 		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_UR_PRIEST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_UR_PRIEST, oCaster))		
			nDivine += GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster + 1) / 2		
			
		if(GetHasFeat(FEAT_KORD_SPELLCASTING_UR_PRIEST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_UR_PRIEST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_OLLAM, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster + 1) / 2
		
		if(GetHasFeat(FEAT_TIAMAT_SPELLCASTING_UR_PRIEST, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oCaster) + 1) / 2;		
			
/*		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_UR_PRIEST, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;		
		
	}
//:: End Ur-Priest Divine PrC casting calculations	   
	   

 	if (nCastingClass == CLASS_TYPE_VASSAL)
    {
		if (!GetHasFeat(FEAT_SF_CODE, oCaster) && GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_VASSAL, oCaster))
		{
			nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
		}
		
/*         if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_VASSAL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_VASSAL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster); */
		
		if(GetHasFeat(FEAT_ALCHEM_SPELLCASTING_VASSAL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST, oCaster);				
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_VASSAL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_VASSAL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
/* 		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster); */
		
		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_VASSAL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
/* 		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster);
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_VASSAL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster); */
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
/* 		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster); */
		
		if(GetHasFeat(FEAT_MHARPER_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster);			
			
/*		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster); */
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_VASSAL, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster);
			
		if(GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_VASSAL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oCaster);
			
		if(GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_VASSAL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
			
		if(GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SACREDPURIFIER, oCaster);
			
		if(GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oCaster);
			
		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_VASSAL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);
		
		if(GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_VASSAL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_SPELLDANCER, oCaster);		
			
/* 		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster); */
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
/* 		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_VASSAL, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2	 */		
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_VASSAL, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster) + 1) / 2;
		
		if(GetHasFeat(FEAT_DSONG_SPELLCASTING_VASSAL, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST, oCaster) + 1) / 2;		
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_VASSAL, oCaster))		
			nDivine += (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2;		
			
/* 		if(GetHasFeat(FEAT_KORD_SPELLCASTING_VASSAL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_VASSAL, oCaster))			
			nDivine += (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) / 2;
			
/* 		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_VASSAL, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster) + 1) / 2;
			
/* 		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2 */
		
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_VASSAL, oCaster))				
			nDivine += (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2;
		
/* 		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_VASSAL, oCaster))
			nDivine += (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;	 */	
		
	}
//:: End Vassal of Bahamut Divine PrC casting calculations
}