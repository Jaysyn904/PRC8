int GetArcanePRCLevels(object oCaster, int nCastingClass = CLASS_TYPE_INVALID)
{
	int nArcane;
	int nOozeMLevel  	= GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);
	int nUM          	= GetLevelByClass(CLASS_TYPE_ULTIMATE_MAGUS, oCaster);
	
	int nFirstClass  	= GetClassByPosition(1, oCaster);
	int nSecondClass 	= GetClassByPosition(2, oCaster);
	int nThirdClass  	= GetClassByPosition(3, oCaster);
	int nFourthClass  	= GetClassByPosition(4, oCaster);  
	int nFifthClass  	= GetClassByPosition(5, oCaster);
	int nSixthClass  	= GetClassByPosition(6, oCaster);
	int nSeventhClass  	= GetClassByPosition(7, oCaster);
	int nEighthClass  	= GetClassByPosition(8, oCaster);
   
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
           +  (GetLevelByClass(CLASS_TYPE_JUDICATOR, 		  oCaster) + 1) / 3;
           
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
   if (nOozeMLevel) //:: [PRC .35]  This needs marker feats.
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

	int nFirstClass  	= GetClassByPosition(1, oCaster);
	int nSecondClass 	= GetClassByPosition(2, oCaster);
	int nThirdClass  	= GetClassByPosition(3, oCaster);
	int nFourthClass  	= GetClassByPosition(4, oCaster);  
	int nFifthClass  	= GetClassByPosition(5, oCaster);
	int nSixthClass  	= GetClassByPosition(6, oCaster);
	int nSeventhClass  	= GetClassByPosition(7, oCaster);
	int nEighthClass  	= GetClassByPosition(8, oCaster);

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

   if (nOozeMLevel)  //:: [PRC .35]  This needs marker feats.
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
