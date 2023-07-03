		   
#include "prc_class_const"

void main ()
{
	object oCaster = GetLastSpellCaster();
	
	int nDivine = 0;

    if(GetLevelByClass(CLASS_TYPE_ARCHIVIST, oCaster))
    {    
        if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_ARCHIVIST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_ARCHIVIST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_ARCHIVIST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDRITCH_DISCIPLE_SPELLCASTING_ARCHIVIST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
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
		
/* 		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_ARCHIVIST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster); */
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster + 1) / 2;		
			
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
			
		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_ARCHIVIST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);
			
		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_ARCHIVIST, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2			
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_ARCHIVIST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_ARCHIVIST, oCaster))		
			nDivine += GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster + 1) / 2		
			
		if(GetHasFeat(FEAT_KORD_SPELLCASTING_ARCHIVIST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_ARCHIVIST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_OLLAM, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_ARCHIVIST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster + 1) / 2
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_ARCHIVIST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster + 1) / 3;		
		
	}
//:: End Archivist Divine PrC casting calculations


    if(GetLevelByClass(CLASS_TYPE_BLACKGUARD, oCaster))
    {    
        if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_BLACKGUARD, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
/* 		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_BLACKGUARD, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster); */
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_BLACKGUARD, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDRITCH_DISCIPLE_SPELLCASTING_BLACKGUARD, oCaster))			
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
			nDivine += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster + 1) / 2;
		
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
			
/* 		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_BLACKGUARD, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster); */
			
		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_BLACKGUARD, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2			
			
/* 		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_BLACKGUARD, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_BLACKGUARD, oCaster))		
			nDivine += GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster + 1) / 2	 */	
			
/* 		if(GetHasFeat(FEAT_KORD_SPELLCASTING_BLACKGUARD, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2 */
			
/* 		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_BLACKGUARD, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_OLLAM, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2
			
/* 		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_BLACKGUARD, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster + 1) / 2
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_BLACKGUARD, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster + 1) / 3;		
		
	}
//:: End Blackguard Divine PrC casting calculations


    if(GetLevelByClass(CLASS_TYPE_BLIGHTER, oCaster))
    {    
        if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_BLIGHTER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
/* 		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_BLIGHTER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster); */
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_BLIGHTER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDRITCH_DISCIPLE_SPELLCASTING_BLIGHTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
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
		
		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster);
			
/* 		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster); */
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster + 1) / 2;
		
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
			
/* 		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_BLIGHTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster); */
			
		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_BLIGHTER, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2			
			
/* 		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_BLIGHTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_BLIGHTER, oCaster))		
			nDivine += GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster + 1) / 2		
			
		if(GetHasFeat(FEAT_KORD_SPELLCASTING_BLIGHTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_BLIGHTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_OLLAM, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2
			
/* 		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_BLIGHTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster + 1) / 2
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_BLIGHTER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster + 1) / 3;		
		
	}
//:: End Blighter Divine PrC casting calculations


    if(GetLevelByClass(CLASS_TYPE_CLERIC, oCaster))
    {    
        if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_CLERIC, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_CLERIC, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_CLERIC, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDRITCH_DISCIPLE_SPELLCASTING_CLERIC, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_CLERIC, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
		if(GetHasFeat(FEAT_FMM_SPELLCASTING_CLERIC, oCaster) && GetHasFeat(FEAT_BONUS_DOMAIN_FORCE, oCaster) || GetHasFeat(FEAT_FORCE_DOMAIN, oCaster))	//:: Not divine
			nDivine += GetLevelByClass(CLASS_TYPE_FMM, oCaster);		
		
		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster);
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_CLERIC, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster);
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster + 1) / 2;
		
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
			
		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_CLERIC, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);
			
		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_CLERIC, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2			
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_CLERIC, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster + 1) / 2;
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_CLERIC, oCaster))		
			nDivine += GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster + 1) / 2	;	
			
		if(GetHasFeat(FEAT_KORD_SPELLCASTING_CLERIC, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2;
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_CLERIC, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_OLLAM, oCaster + 1) / 2;
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2;
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster + 1) / 2;
			
		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2;
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_CLERIC, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster + 1) / 2;
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_CLERIC, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster + 1) / 3;		
		
	}
//:: End Cleric Divine PrC casting calculations


    if(GetLevelByClass(CLASS_TYPE_DRUID, oCaster))
    {    
/*         if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_DRUID, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster); */
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_DRUID, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_DRUID, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDRITCH_DISCIPLE_SPELLCASTING_DRUID, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
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
		
		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster);
			
/* 		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster); */
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster + 1) / 2;
		
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
			
/* 		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_DRUID, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster); */
			
		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
/* 		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_DRUID, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2	 */		
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_DRUID, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_DRUID, oCaster))		
			nDivine += GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster + 1) / 2		
			
/* 		if(GetHasFeat(FEAT_KORD_SPELLCASTING_DRUID, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2 */
			
/* 		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_DRUID, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_OLLAM, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_DRUID, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster + 1) / 2
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_DRUID, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster + 1) / 3;		
		
	}
//:: End Druid Divine PrC casting calculations

	   
    if(GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oCaster))
    {    
        if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_FAVOURED_SOUL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_FAVOURED_SOUL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_FAVOURED_SOUL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDRITCH_DISCIPLE_SPELLCASTING_FAVOURED_SOUL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
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
		
		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster);
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster + 1) / 2;
		
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
			
		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_FAVOURED_SOUL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);
			
		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_FAVOURED_SOUL, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2			
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_FAVOURED_SOUL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_FAVOURED_SOUL, oCaster))		
			nDivine += GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster + 1) / 2		
			
		if(GetHasFeat(FEAT_KORD_SPELLCASTING_FAVOURED_SOUL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_FAVOURED_SOUL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_OLLAM, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_FAVOURED_SOUL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster + 1) / 2
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_FAVOURED_SOUL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster + 1) / 3;		
		
	}
//:: End Favoured Soul Divine PrC casting calculations	
   

    if(GetLevelByClass(CLASS_TYPE_HEALER, oCaster))
    {    
/*         if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_HEALER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster); */
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_HEALER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_HEALER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDRITCH_DISCIPLE_SPELLCASTING_HEALER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_HEALER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster);
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_HEALER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
/* 		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster); */
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster + 1) / 2;
		
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
			
/* 		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster); */
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
/* 		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);		 */	
			
/* 		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_HEALER, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2 */			
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_HEALER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_HEALER, oCaster))		
			nDivine += GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster + 1) / 2		
			
		if(GetHasFeat(FEAT_KORD_SPELLCASTING_HEALER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_HEALER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_OLLAM, oCaster + 1) / 2
			
/* 		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster + 1) / 2
			
/* 		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_HEALER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster + 1) / 2
		
/* 		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_HEALER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster + 1) / 3;	 */	
		
	}
//:: End Healer Divine PrC casting calculations	
   


	   
    if(GetLevelByClass(CLASS_TYPE_JUSTICEWW, oCaster))
    {    
        if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_JUSTICEWW, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_JUSTICEWW, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_JUSTICEWW, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDRITCH_DISCIPLE_SPELLCASTING_JUSTICEWW, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_JUSTICEWW, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster);
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_JUSTICEWW, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster);
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster + 1) / 2;
		
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
			
		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_JUSTICEWW, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);
			
		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_JUSTICEWW, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2			
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_JUSTICEWW, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_JUSTICEWW, oCaster))		
			nDivine += GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster + 1) / 2		
			
		if(GetHasFeat(FEAT_KORD_SPELLCASTING_JUSTICEWW, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_JUSTICEWW, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_OLLAM, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_JUSTICEWW, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster + 1) / 2
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_JUSTICEWW, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster + 1) / 3;		
		
	}
//:: End Justice of Weald & Woe Divine PrC casting calculations	   
	   
	   
    if(GetLevelByClass(CLASS_TYPE_KNIGHT_CHALICE, oCaster))
    {    
/*         if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_KNIGHT_CHALICE, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster); */
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_KNIGHT_CHALICE, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_KNIGHT_CHALICE, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDRITCH_DISCIPLE_SPELLCASTING_KNIGHT_CHALICE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_KNIGHT_CHALICE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
/* 		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster); */
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_KNIGHT_CHALICE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
/* 		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster); */
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
/* 		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster + 1) / 2; */
		
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
			
/* 		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster); */
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
/* 		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_KNIGHT_CHALICE, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2	 */		
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_KNIGHT_CHALICE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_KNIGHT_CHALICE, oCaster))		
			nDivine += GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster + 1) / 2		
			
/* 		if(GetHasFeat(FEAT_KORD_SPELLCASTING_KNIGHT_CHALICE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_KNIGHT_CHALICE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_OLLAM, oCaster + 1) / 2
			
/* 		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster + 1) / 2
			
/* 		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_KNIGHT_CHALICE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster + 1) / 2
		
/* 		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_KNIGHT_CHALICE, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster + 1) / 3;	 */	
		
	}
//:: End Knight of the Chalice Divine PrC casting calculations


    if(GetLevelByClass(CLASS_TYPE_KNIGHT_MIDDLECIRCLE, oCaster))
    {    
/*         if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster); */
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDRITCH_DISCIPLE_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster);
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
/* 		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster); */
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster + 1) / 2;
		
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
			
/* 		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster); */
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
/* 		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2		 */	
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))		
			nDivine += GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster + 1) / 2		
			
/* 		if(GetHasFeat(FEAT_KORD_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_OLLAM, oCaster + 1) / 2
			
/* 		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster + 1) / 2
			
/* 		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster + 1) / 2
		
/* 		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_KNIGHT_MIDDLECIRCLE, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster + 1) / 3;		 */
		
	}
//:: End Knight of the Middle Circle Divine PrC casting calculations			   
	   
	   
    if(GetLevelByClass(CLASS_TYPE_NENTYAR_HUNTER, oCaster))
    {    
/*         if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_NENTYAR_HUNTER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster); */
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_NENTYAR_HUNTER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_NENTYAR_HUNTER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDRITCH_DISCIPLE_SPELLCASTING_NENTYAR_HUNTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
		if(GetHasFeat(FEAT_FMM_SPELLCASTING_NENTYAR_HUNTER, oCaster))	//:: Not divine
			nDivine += GetLevelByClass(CLASS_TYPE_FMM, oCaster);
		
		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_NENTYAR_HUNTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
/* 		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster); */
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_NENTYAR_HUNTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
/* 		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster); */
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster + 1) / 2;
		
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
			
		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_NENTYAR_HUNTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);
			
/* 		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster); */
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
/* 		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);	 */		
			
/* 		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_NENTYAR_HUNTER, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2	 */		
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_NENTYAR_HUNTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_NENTYAR_HUNTER, oCaster))		
			nDivine += GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster + 1) / 2		
			
		if(GetHasFeat(FEAT_KORD_SPELLCASTING_NENTYAR_HUNTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_NENTYAR_HUNTER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_OLLAM, oCaster + 1) / 2
			
/* 		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster + 1) / 2
			
/* 		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_NENTYAR_HUNTER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster + 1) / 2
		
/* 		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_NENTYAR_HUNTER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster + 1) / 3;	 */	
		
	}
//:: End Nentyar Hunter Divine PrC casting calculations	   
	   
	   
    if(GetLevelByClass(CLASS_TYPE_OCULAR, oCaster))
    {    
        if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_OCULAR, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
/* 		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_OCULAR, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_OCULAR, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster); */
		
		if(GetHasFeat(FEAT_ELDRITCH_DISCIPLE_SPELLCASTING_OCULAR, oCaster))			
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
		
		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster);
			
/* 		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster); */
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster + 1) / 2;
		
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
			
/* 		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_OCULAR, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster); */
			
		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_OCULAR, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2			
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_OCULAR, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster + 1) / 2
			
/* 		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_OCULAR, oCaster))		
			nDivine += GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster + 1) / 2	 */	
			
/* 		if(GetHasFeat(FEAT_KORD_SPELLCASTING_OCULAR, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2 */
			
/* 		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_OCULAR, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_OLLAM, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2
			
/* 		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_OCULAR, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster + 1) / 2
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_OCULAR, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster + 1) / 3;		
		
	}
//:: End Ocular Adept Divine PrC casting calculations		   
	   
	   
    if(GetLevelByClass(CLASS_TYPE_PALADIN, oCaster))
    {    
/*         if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_PALADIN, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_PALADIN, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster); */
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_PALADIN, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDRITCH_DISCIPLE_SPELLCASTING_PALADIN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
/* 		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster); */
		
		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_PALADIN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
/* 		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster); */
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_PALADIN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
/* 		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster); */
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster + 1) / 2;
		
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
			
/* 		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster); */
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
/* 		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_PALADIN, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2		 */	
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_PALADIN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_PALADIN, oCaster))		
			nDivine += GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster + 1) / 2		
			
/* 		if(GetHasFeat(FEAT_KORD_SPELLCASTING_PALADIN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_PALADIN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_OLLAM, oCaster + 1) / 2
			
/* 		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster + 1) / 2
			
/* 		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_PALADIN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster + 1) / 2
		
/* 		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_PALADIN, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster + 1) / 3; */		
		
	}
//:: End Paladin Divine PrC casting calculations	   
	   
	   
    if(GetLevelByClass(CLASS_TYPE_RANGER, oCaster))
    {    
        if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_RANGER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_RANGER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_RANGER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDRITCH_DISCIPLE_SPELLCASTING_RANGER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_RANGER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster);
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_RANGER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster);
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster + 1) / 2;
		
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
			
		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_RANGER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);
			
		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_RANGER, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2			
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_RANGER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_RANGER, oCaster))		
			nDivine += GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster + 1) / 2		
			
		if(GetHasFeat(FEAT_KORD_SPELLCASTING_RANGER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_RANGER, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_OLLAM, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_RANGER, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster + 1) / 2
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_RANGER, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster + 1) / 3;		
		
	}
//:: End Ranger Divine PrC casting calculations	   
	   
	   
    if(GetLevelByClass(CLASS_TYPE_SHAMAN, oCaster))
    {    
        if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_SHAMAN, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_SHAMAN, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_SHAMAN, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDRITCH_DISCIPLE_SPELLCASTING_SHAMAN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_SHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_SHAMAN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
		if(GetHasFeat(FEAT_FMM_SPELLCASTING_SHAMAN, oCaster) && GetHasFeat(FEAT_BONUS_DOMAIN_FORCE, oCaster) || GetHasFeat(FEAT_FORCE_DOMAIN, oCaster))	//:: Not divine
			nDivine += GetLevelByClass(CLASS_TYPE_FMM, oCaster);
		
		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_SHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster);
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_SHAMAN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_SHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_SHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster);
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_SHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_SHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster + 1) / 2;
		
		if(GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_SHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster);
			
		if(GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_SHAMAN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oCaster);
			
		if(GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_SHAMAN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
			
		if(GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_SHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SACREDPURIFIER, oCaster);
			
		if(GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_SHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oCaster);
			
		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_SHAMAN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);
			
		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_SHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_SHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_SHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_SHAMAN, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2			
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_SHAMAN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_SHAMAN, oCaster))		
			nDivine += GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster + 1) / 2		
			
		if(GetHasFeat(FEAT_KORD_SPELLCASTING_SHAMAN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_SHAMAN, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_OLLAM, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_SHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_SHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_SHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_SHAMAN, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster + 1) / 2
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_SHAMAN, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster + 1) / 3;		
		
	}
//:: End Shaman Divine PrC casting calculations	   	   
	   
	   
    if(GetLevelByClass(CLASS_TYPE_SLAYER_OF_DOMIEL, oCaster))
    {    
/*         if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_DOMIEL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_DOMIEL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster); */
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_DOMIEL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDRITCH_DISCIPLE_SPELLCASTING_DOMIEL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_DOMIEL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
/* 		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster); */
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_DOMIEL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
/* 		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster); */
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster + 1) / 2;
		
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
			
/* 		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster); */
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
/* 		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_DOMIEL, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2		 */	
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_DOMIEL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_DOMIEL, oCaster))		
			nDivine += GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster + 1) / 2		
			
/* 		if(GetHasFeat(FEAT_KORD_SPELLCASTING_DOMIEL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_DOMIEL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_OLLAM, oCaster + 1) / 2
			
/* 		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster + 1) / 2
			
/* 		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_DOMIEL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster + 1) / 2
		
/* 		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_DOMIEL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster + 1) / 3;	 */	
		
	}
//:: End Slayer of Domiel Divine PrC casting calculations		   
	   
	   
    if(GetLevelByClass(CLASS_TYPE_SOHEI, oCaster))
    {    
        if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_SOHEI, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_SOHEI, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_SOHEI, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDRITCH_DISCIPLE_SPELLCASTING_SOHEI, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_SOHEI, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
/* 		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster); */
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_SOHEI, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster);
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster + 1) / 2;
		
		if(GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster);
			
		if(GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_SOHEI, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oCaster);
			
		if(GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_SOHEI, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
			
		if(GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SACREDPURIFIER, oCaster);
			
		if(GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oCaster);
			
		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_SOHEI, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);
			
/* 		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster); */
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_SOHEI, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2			
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_SOHEI, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_SOHEI, oCaster))		
			nDivine += GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster + 1) / 2		
			
/* 		if(GetHasFeat(FEAT_KORD_SPELLCASTING_SOHEI, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_SOHEI, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_OLLAM, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster + 1) / 2
			
/* 		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_SOHEI, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster + 1) / 2
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_SOHEI, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster + 1) / 3;		
		
	}
//:: End Sohei Divine PrC casting calculations		   
	   
	   
    if(GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT, oCaster))
    {    
/*         if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_SOL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster); */
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_SOL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster);
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_SOL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDRITCH_DISCIPLE_SPELLCASTING_SOL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
/* 		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_SOL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster); */
		
/* 		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster); */
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_SOL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
/* 		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster); */
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster);
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster + 1) / 2;
		
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
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);
			
		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster); */
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
/* 		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_SOL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_SOL, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2		 */	
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_SOL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_SOL, oCaster))		
			nDivine += GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster + 1) / 2		
			
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
			nDivine += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster + 1) / 2
		
		IF(GETHASFEAT(FEAT_JUDICATOR_SPELLCASTING_SOL, OCASTER))
			NDIVINE += GETLEVELBYCLASS(CLASS_TYPE_JUDICATOR, OCASTER + 1) / 3;		
		
	}
//:: End Soldier of Light Divine PrC casting calculations		   
	   
	   
    if(GetLevelByClass(CLASS_TYPE_UR_PRIEST, oCaster))
    {    
/*         if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_UR_PRIEST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_UR_PRIEST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster); */
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_UR_PRIEST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDRITCH_DISCIPLE_SPELLCASTING_UR_PRIEST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
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
		
/* 		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster);
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster); */
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster + 1) / 2;
		
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
			
/* 		if(GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_UR_PRIEST, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER,oCaster);
			
		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster); */
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_UR_PRIEST, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2			
			
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
			
		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_UR_PRIEST, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster + 1) / 2
		
		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_UR_PRIEST, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster + 1) / 3;		
		
	}
//:: End Ur-Priest Divine PrC casting calculations	   
	   

    if(GetLevelByClass(CLASS_TYPE_VASSAL, oCaster))
    {    
/*         if(GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_VASSAL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster);
		
		if(GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_VASSAL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster); */
		
		if(GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_VASSAL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster);
		
		if(GetHasFeat(FEAT_ELDRITCH_DISCIPLE_SPELLCASTING_VASSAL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oCaster);
		
/* 		if(GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_FORESTMASTER, oCaster);
		
		if(GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_VASSAL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);
		
		if(GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster); */
		
		if(GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_VASSAL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
		
		if(GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster);
		
/* 		if(GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster);
			
		if(GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MORNINGLORD, oCaster); */
			
		if(GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);
		
		if(GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster + 1) / 2;
		
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
			
/* 		if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster); */
			
		if(GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SWIFT_WING, oCaster);
			
/* 		if(GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oCaster);			
			
		if(GetHasFeat(FEAT_BFZ_SPELLCASTING_VASSAL, oCaster))	
			nDivine += GetLevelByClass(CLASS_TYPE_BFZ, oCaster + 1) / 2	 */		
			
		if(GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_VASSAL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oCaster + 1) / 2
			
		if(GetHasFeat(FEAT_HATHRAN_SPELLCASTING_VASSAL, oCaster))		
			nDivine += GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster + 1) / 2		
			
/* 		if(GetHasFeat(FEAT_KORD_SPELLCASTING_VASSAL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_OLLAM_SPELLCASTING_VASSAL, oCaster))			
			nDivine += GetLevelByClass(CLASS_TYPE_OLLAM, oCaster + 1) / 2
			
/* 		if(GetHasFeat(FEAT_ORCUS_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_ORCUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster + 1) / 2
			
/* 		if(GetHasFeat(FEAT_TEMPUS_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster + 1) / 2 */
			
		if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_VASSAL, oCaster))				
			nDivine += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster + 1) / 2
		
/* 		if(GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_VASSAL, oCaster))
			nDivine += GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster + 1) / 3;	 */	
		
	}
//:: End Vassal of Bahamut Divine PrC casting calculations		   
	   
	   