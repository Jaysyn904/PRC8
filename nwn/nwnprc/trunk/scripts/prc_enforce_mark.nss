//:://////////////////////////////////////////////////////////////////
//::
/*
*	[prc_enforce_mark.nss] - Jaysyn 20240204
*
*	This script checks that correct amount of prestige class marker 
*	feats are taken at the correct level
*	
*/
//::
//:://////////////////////////////////////////////////////////////////

#include "prc_class_const"
#include "prc_feat_const"

//:; Enforces Abjurant Champion marker feats
int AbjurantChampionMarkerFeats();

//:; Enforces Acolyte of the Skin marker feats
int AoTSMarkerFeats();

//:; Enforces Master Alchemist marker feats
int AlchemistMarkerFeats();

//:; Enforces Alienist marker feats
int AlienistMarkerFeats();

//:; Enforces Anima Mage marker feats
int AnimaMageMarkerFeats();

//:; Enforces Archmage marker feats
int ArchmageMarkerFeats();

//:; Enforces Arcane Trickster marker feats
int ArcaneTricksterMarkerFeats();

//:; Enforces Disciple of Asmodeus marker feats
int DoAMarkerFeats();

//:; Enforces Black Flame Zealot marker feats
int BFZMarkerFeats();

//:; Enforces Blood Magus marker feats
int BloodMagusMarkerFeats();

//:; Enforces Talontar Blightlord marker feats
int BlightlordMarkerFeats();

//:; Enforces Bonded Summoner marker feats
int BondedSummonerMarkerFeats();

//:; Enforces Brimstone Speaker marker feats
int BrimstoneSpeakerMarkerFeats();

//:; Enforces Bladesinger marker feats
int BladesingerMarkerFeats();

//:: Enforces Cerebrmancer marker feats
int CerebremancerMarkerFeats();

//:: Enforce Child of Night marker feats
int CoNMarkerFeats();

//:; Enforces Combat Medic marker feats
int CombatMedicMarkerFeats();

//:; Enforces Contemplative marker feats
int ContemplativeMarkerFeats();

//:: Enforces Diamond Dragon marker feats
int DiamondDragonMarkerFeats();

//:: Enforces Dragonheart Mage marker feats
int DragonheartMarkerFeats();

//:; Enforces Diabolist marker feats
int DiabolistMarkerFeats();

//:; Enforces Dragonsong Lyrist marker feats
int DragonsongLyristMarkerFeats();

//:; Enforces Eldritch Knight marker feats
int EldritchKnightMarkerFeats();

//:; Enforces Eldritch Disciple marker feats
int EldritchDiscipleMarkerFeats();

//:; Enforces Eldritch Theurge marker feats
int EldritchTheurgeMarkerFeats();

//:; Enforces Elemental Savant marker feats
int ElementalSavantMarkerFeats();

//:; Enforces Enlightend Fist marker feats
int EnlightendFistMarkerFeats();

//:; Enforces Fist of Raziel marker feats
int FistOfRazielMarkerFeats();

//:; Enforces Force Missile Mage marker feats
int FMMMarkerFeats();

//:; Enforces Fochlucan Lyrist marker feats
int FochlucanLyristMarkerFeats();

//:; Enforces Forest Master marker feats
int ForestMasterMarkerFeats();

//:; Enforces Frost Mage marker feats
int FrostMageMarkerFeats();

//:; Enforces Thrall of Grazzt marker feats
int ToGMarkerFeats();

//:; Enforces Harper Mage marker feats
int HarperMageMarkerFeats();

//:; Enforces Hathran marker feats
int HathranMarkerFeats();

//:; Enforces Havoc Mage marker feats
int HavocMageMarkerFeats();

//:; Enforces Heartwarder marker feats
int HeartwarderMarkerFeats();

//:; Enforces Hierophant marker feats
int HierophantMarkerFeats();

//:; Enforces Hospitaler marker feats
int HospitalerMarkerFeats();

//:; Enforces Iron Mind marker feats
int IronMindMarkerFeats();

//:; Enforces Jade Phoenix Mage marker feats
int JPMMarkerFeats();

//:; Enforces Drow Judicator marker feats
int JudicatorMarkerFeats();

//:; Enforces Mighty Contender of Kord marker feats
int MCoKMarkerFeats();

//:; Enforces Maester marker feats
int MaesterMarkerFeats();

//:; Enforces Magekiller marker feats
int MagekillerMarkerFeats();

//:: Enforces Master of Shadows marker feats
int MasterShadowMarkerFeats();

//:; Enforces Master of Shrouds marker feats
int MoSMarkerFeats();

//:; Enforces Master Harper marker feats
int MasterHarperMarkerFeats();

//:; Enforces Morninglord of Lathander marker feats
int MorninglordMarkerFeats();

//:; Enforces Mystic Theurge marker feats
int MysticTheurgeMarkerFeats();

//:; Enforces Noctumancer marker feats
int NoctumancerMarkerFeats();

//:; Enforces Ollam marker feats
int OllamMarkerFeats();

//:; Enforces Oozemaster marker feats
int OozemasterMarkerFeats();

//:; Enforces Thrall of Orcus marker feats
int OrcusMarkerFeats();

//:; Enforces Pale Master marker feats
int PaleMasterMarkerFeats();

//:; Enforces Psychic Theurge marker feats
int PsychicTheurgeMarkerFeats();

//:; Enforces Rage Mage marker feats
int RageMageMarkerFeats();

//:; Enforces Red Wizard marker feats
int RedWizardMarkerFeats();

//:; Enforces Ruby Knight Vindicator marker feats
int RKVMarkerFeats();

//:; Enforces Runecaster marker feats
int RunecasterMarkerFeats();

//:; Enforces Sacred Fist marker feats
int SacredFistMarkerFeats();

//:; Enforces Sacred Purifier marker feats
int SacredPurifierMarkerFeats();

//:: Enforces Sancified Mind marker feats
int SanctifiedMindMarkerFeats();

//:; Enforces Sapphire Hierarch marker feats
int SapphireHierarchMarkerFeats();

//:; Enforces Shadow Adept marker feats
int ShadowAdeptMarkerFeats();

//:; Enforces Shadowbane Stalker marker feats
int SBStalkerMarkerFeats();

//:; Enforces Shining Blade of Heironeous marker feats
int HeironeousMarkerFeats();

//:: Enforces Shadow Mind marker feats
int ShadowMindMarkerFeats();

//:: Enforces Soulcaster marker feats
int SoulcasterMarkerFeats();

//:; Enforces Spelldancer marker feats
int SpelldancerMarkerFeats();

//:; Enforces Spellsword marker feats
int SpellswordMarkerFeats();

//:; Enforces Stormlord of Talos marker feats
int StormlordMarkerFeats();

//:: Enforces Sublime Chord marker feats
int SublimeChordMarkerFeats();

//:; Enforces Battleguard of Tempus marker feats
int BGTMarkerFeats();

//:; Enforces Tenebrous Apostate marker feats
int TenebrousMarkerFeats();

//:: Enforces Thrallherd marker feats
int ThrallherdMarkerFeats();

//:; Enforces Talon of Tiamat marker feats
int TiamatMarkerFeats();

//:; Enforces True Necromancer marker feats
int TrueNecroMarkerFeats();

//:; Enforces Ultmate Magus marker feats
int UltMagusMarkerFeats();

//:; Enforces Unseen Seer marker feats
int UnseenMarkerFeats();

//:; Enforces Warpriest marker feats
int WarpriestMarkerFeats();

//:; Enforces Wayfarer Guide marker feats
int WayfarerMarkerFeats();

//:; Enforces Wild Mage marker feats
int WildMageMarkerFeats();

//:; Enforces War Wizard of Cormyr marker feats
int WWoCMarkerFeats();


/*///////////////////////////////////////
	Begin Functions
*////////////////////////////////////////
	
//:; Enforces Abjurant Champion marker feats
int AbjurantChampionMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_ABJURANT_CHAMPION))
    {
		int nAbChamp 	= GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_ASSASSIN)
						+ GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_CELEBRANT_SHARESS)
						+ GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_CULTIST_PEAK)
						+ GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_HARPER)
						+ GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_HEXBLADE)
						+ GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_KNIGHT_WEAVE)
						+ GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_SHADOWLORD)
						+ GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_ABCHAMP_SPELLCASTING_WIZARD)
						+ GetHasFeat(FEAT_ABCHAMP_INVOKING_WARLOCK)
						+ GetHasFeat(FEAT_ABCHAMP_INVOKING_DFA)
						+ GetHasFeat(FEAT_ABCHAMP_INVOKING_DRAGON_SHAMAN);
						
		//FloatingTextStringOnCreature("nAbChamp = " + IntToString(nAbChamp), OBJECT_SELF, FALSE);

        if(nAbChamp > 1)
        {
            FloatingTextStringOnCreature("An Abjurant Champion may only advance a single arcane or invoker class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nAbChamp < 1)
        {
            FloatingTextStringOnCreature("An Abjurant Champion must pick one arcane or invoker class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}

//:; Enforces Acolyte of the Skin marker feats
int AoTSMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_ACOLYTE))
    {
		int nAcolyte 	= GetHasFeat(FEAT_AOTS_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_AOTS_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_AOTS_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_AOTS_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_AOTS_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_AOTS_SPELLCASTING_ASSASSIN)
						+ GetHasFeat(FEAT_AOTS_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_AOTS_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_AOTS_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_AOTS_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_AOTS_SPELLCASTING_HEXBLADE)
						+ GetHasFeat(FEAT_AOTS_SPELLCASTING_SHADOWLORD)
						+ GetHasFeat(FEAT_AOTS_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_AOTS_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_AOTS_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_AOTS_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_AOTS_SPELLCASTING_WIZARD)
						+ GetHasFeat(FEAT_AOTS_SPELLCASTING_CULTIST_PEAK)
						+ GetHasFeat(FEAT_AOTS_INVOKING_WARLOCK)
						+ GetHasFeat(FEAT_AOTS_INVOKING_DFA)
						+ GetHasFeat(FEAT_AOTS_MYSTERY_SHADOWCASTER)
						+ GetHasFeat(FEAT_AOTS_MYSTERY_SHADOWSMITH);

        if(nAcolyte > 1)
        {
            FloatingTextStringOnCreature("An Acolyte of the Skin may only advance a single arcane, shadowcasting or invoker class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nAcolyte < 1)
        {
            FloatingTextStringOnCreature("An Acolyte of the Skin must pick one arcane, shadowcasting or invoker class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}

//:; Enforces Master Alchemist marker feats
int AlchemistMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_MASTER_ALCHEMIST))
    {
		int nAlchemist 	= GetHasFeat(FEAT_ALCHEM_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_ALCHEM_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_ALCHEM_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_ALCHEM_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_ALCHEM_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_ALCHEM_SPELLCASTING_ASSASSIN)
						+ GetHasFeat(FEAT_ALCHEM_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_ALCHEM_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_ALCHEM_SPELLCASTING_CELEBRANT_SHARESS)
						+ GetHasFeat(FEAT_ALCHEM_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_ALCHEM_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_ALCHEM_SPELLCASTING_HEXBLADE)
						+ GetHasFeat(FEAT_ALCHEM_SPELLCASTING_KNIGHT_WEAVE)
						+ GetHasFeat(FEAT_ALCHEM_SPELLCASTING_SHADOWLORD)
						+ GetHasFeat(FEAT_ALCHEM_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_ALCHEM_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_ALCHEM_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_ALCHEM_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_ALCHEM_SPELLCASTING_WIZARD);

        if(nAlchemist > 1)
        {
            FloatingTextStringOnCreature("A Master Alchemist may only advance a single arcane or divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nAlchemist < 1)
        {
            FloatingTextStringOnCreature("A Master Alchemist must pick one arcane or divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}

//:; Enforces Alienist marker feats
int AlienistMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_ALIENIST))
    {
		int nAlienist 	= GetHasFeat(FEAT_ALIENIST_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_ALIENIST_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_ALIENIST_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_ALIENIST_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_ALIENIST_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_ALIENIST_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_ALIENIST_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_ALIENIST_SPELLCASTING_CELEBRANT_SHARESS)
						+ GetHasFeat(FEAT_ALIENIST_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_ALIENIST_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_ALIENIST_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_ALIENIST_SPELLCASTING_WIZARD)
						+ GetHasFeat(FEAT_ALIENIST_MYSTERY_SHADOWCASTER)
						+ GetHasFeat(FEAT_ALIENIST_MYSTERY_SHADOWSMITH);

        if(nAlienist > 1)
        {
            FloatingTextStringOnCreature("An Alienist may only advance a single arcane, shadowcasting or divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nAlienist < 1)
        {
            FloatingTextStringOnCreature("An Alienist must pick one arcane, shadowcasting or divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}

//:; Enforces Anima Mage marker feats
int AnimaMageMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_ANIMA_MAGE))
    {
		int nAnima 	= GetHasFeat(FEAT_ANIMA_SPELLCASTING_FEY)
					+ GetHasFeat(FEAT_ANIMA_SPELLCASTING_ABERRATION)
					+ GetHasFeat(FEAT_ANIMA_SPELLCASTING_MONSTROUS)
					+ GetHasFeat(FEAT_ANIMA_SPELLCASTING_OUTSIDER)
					+ GetHasFeat(FEAT_ANIMA_SPELLCASTING_SHAPECHANGER)
					+ GetHasFeat(FEAT_ANIMA_SPELLCASTING_ASSASSIN)
					+ GetHasFeat(FEAT_ANIMA_SPELLCASTING_BARD)
					+ GetHasFeat(FEAT_ANIMA_SPELLCASTING_BEGUILER)
					+ GetHasFeat(FEAT_ANIMA_SPELLCASTING_DNECRO)
					+ GetHasFeat(FEAT_ANIMA_SPELLCASTING_DUSKBLADE)
					+ GetHasFeat(FEAT_ANIMA_SPELLCASTING_HARPER)
					+ GetHasFeat(FEAT_ANIMA_SPELLCASTING_HEXBLADE)
					+ GetHasFeat(FEAT_ANIMA_SPELLCASTING_KNIGHT_WEAVE)
					+ GetHasFeat(FEAT_ANIMA_SPELLCASTING_SHADOWLORD)
					+ GetHasFeat(FEAT_ANIMA_SPELLCASTING_SORCERER)
					+ GetHasFeat(FEAT_ANIMA_SPELLCASTING_SUBLIME_CHORD)
					+ GetHasFeat(FEAT_ANIMA_SPELLCASTING_SUEL_ARCHANAMACH)
					+ GetHasFeat(FEAT_ANIMA_SPELLCASTING_WARMAGE)
					+ GetHasFeat(FEAT_ANIMA_SPELLCASTING_WIZARD)
					+ GetHasFeat(FEAT_ANIMA_SPELLCASTING_CULTIST_PEAK)
					+ GetHasFeat(FEAT_ANIMA_INVOKING_WARLOCK)
					+ GetHasFeat(FEAT_ANIMA_INVOKING_DFA);

        if(nAnima > 1)
        {
            FloatingTextStringOnCreature("Anima Mage may only advance a single arcane or invoker class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nAnima < 1)
        {
            FloatingTextStringOnCreature("Anima Mage must pick one arcane or invoker class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}

//:; Enforces Archmage marker feats
int ArchmageMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_ARCHMAGE))
    {
		int iArchClass 	= GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_ARCHMAGE_SPELLCASTING_WIZARD);

        if(iArchClass > 1)
        {
            FloatingTextStringOnCreature("An Archmage may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(iArchClass < 1)
        {
            FloatingTextStringOnCreature("An Archmage must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Arcane Trickster marker feats
int ArcaneTricksterMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_ARCTRICK))
    {
		int nTrickster 	= GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_ASSASSIN)
						+ GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_CELEBRANT_SHARESS)
						+ GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_CULTIST_PEAK)
						+ GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_HARPER)
						+ GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_HEXBLADE)
						+ GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_KNIGHT_WEAVE)
						+ GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_SHADOWLORD)
						+ GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_ARCTRICK_SPELLCASTING_WIZARD)
						+ GetHasFeat(FEAT_ARCTRICK_INVOKING_WARLOCK)
						+ GetHasFeat(FEAT_ARCTRICK_INVOKING_DFA);

        if(nTrickster > 1)
        {
            FloatingTextStringOnCreature("An Arcane Trickster may only advance a single arcane or invoker class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nTrickster < 1)
        {
            FloatingTextStringOnCreature("An Arcane Trickster must pick one arcane or invoker class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Disciple of Asmodeus marker feats
int DoAMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS))
    {
		int nDoA	 	= GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_ASSASSIN)
						+ GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_CULTIST_PEAK)
						+ GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_HEXBLADE)
						+ GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_SHADOWLORD)
						+ GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_WIZARD)
						+ GetHasFeat(FEAT_ASMODEUS_SPELLCASTING_NONE)
						+ GetHasFeat(FEAT_ASMODEUS_INVOKING_WARLOCK)
						+ GetHasFeat(FEAT_ASMODEUS_INVOKING_DFA)
						+ GetHasFeat(FEAT_ASMODEUS_INVOKING_DRAGON_SHAMAN)
						+ GetHasFeat(FEAT_ASMODEUS_MYSTERY_SHADOWCASTER)
						+ GetHasFeat(FEAT_ASMODEUS_MYSTERY_SHADOWSMITH);

        if(nDoA > 1)
        {
            FloatingTextStringOnCreature("A Disciple of Asmodeus may only advance a single arcane, shadowcasting or invoker class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nDoA < 1)
        {
            FloatingTextStringOnCreature("A Disciple of Asmodeus must pick one arcane, shadowcasting or invoker class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Black Flame Zealot marker feats
int BFZMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_BFZ))
    {
		int nBFZ	 	= GetHasFeat(FEAT_BFZ_SPELLCASTING_ARCHIVIST)
						+ GetHasFeat(FEAT_BFZ_SPELLCASTING_BLACKGUARD)
						+ GetHasFeat(FEAT_BFZ_SPELLCASTING_BLIGHTER)
						+ GetHasFeat(FEAT_BFZ_SPELLCASTING_CLERIC)
						+ GetHasFeat(FEAT_BFZ_SPELLCASTING_FAVOURED_SOUL)
						+ GetHasFeat(FEAT_BFZ_SPELLCASTING_JUSTICEWW)
						+ GetHasFeat(FEAT_BFZ_SPELLCASTING_OCULAR)
						+ GetHasFeat(FEAT_BFZ_SPELLCASTING_RANGER)
						+ GetHasFeat(FEAT_BFZ_SPELLCASTING_OASHAMAN)
						+ GetHasFeat(FEAT_BFZ_SPELLCASTING_SOHEI)
						+ GetHasFeat(FEAT_BFZ_SPELLCASTING_SPSHAMAN)
						+ GetHasFeat(FEAT_BFZ_SPELLCASTING_UR_PRIEST);

        if(nBFZ > 1)
        {
            FloatingTextStringOnCreature("A Black Flame Zealot may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nBFZ < 1)
        {
            FloatingTextStringOnCreature("A Black Flame Zealot must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Blood Magus marker feats
int BloodMagusMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_BLOOD_MAGUS))
    {
		int nBlood	= GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_FEY)
					+ GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_ABERRATION)
					+ GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_MONSTROUS)
					+ GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_OUTSIDER)
					+ GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_SHAPECHANGER)
					+ GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_BARD)
					+ GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_BEGUILER)
					+ GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_DNECRO)
					+ GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_DUSKBLADE)
					+ GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_KNIGHT_WEAVE)
					+ GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_SORCERER)
					+ GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_SUBLIME_CHORD)
					+ GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_ARCHANAMACH)
					+ GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_WARMAGE)
					+ GetHasFeat(FEAT_BLDMAGUS_SPELLCASTING_WIZARD)
					+ GetHasFeat(FEAT_BLDMAGUS_INVOKING_WARLOCK)
					+ GetHasFeat(FEAT_BLDMAGUS_INVOKING_DFA);

        if(nBlood > 1)
        {
            FloatingTextStringOnCreature("A Blood Magus may only advance a single arcane or invoker class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nBlood < 1)
        {
            FloatingTextStringOnCreature("A Blood Magus must pick one arcane or invoker to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Talontar Blightlord marker feats
int BlightlordMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_BLIGHTLORD))
    {
		int nBlight	= GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_ARCHIVIST)
					+ GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_BLACKGUARD)
					+ GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_BLIGHTER)
					+ GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_CLERIC)
					+ GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_DRUID)
					+ GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_FAVOURED_SOUL)
					+ GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_JUSTICEWW)
					+ GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_RANGER)
					+ GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_OASHAMAN)
					+ GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_SOHEI)
					+ GetHasFeat(FEAT_BLIGHTLORD_SPELLCASTING_SPSHAMAN);

        if(nBlight > 1)
        {
            FloatingTextStringOnCreature("A Talontar Blightlord may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nBlight < 1)
        {
            FloatingTextStringOnCreature("A Talontar Blightlord must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Bonded Summoner marker feats
int BondedSummonerMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER))
    {
		int nBonded	= GetHasFeat(FEAT_BONDED_SPELLCASTING_CELEBRANT_SHARESS)
					+ GetHasFeat(FEAT_BONDED_SPELLCASTING_HEXBLADE)
					+ GetHasFeat(FEAT_BONDED_SPELLCASTING_SORCERER)
					+ GetHasFeat(FEAT_BONDED_SPELLCASTING_WARMAGE)
					+ GetHasFeat(FEAT_BONDED_SPELLCASTING_WIZARD);

        if(nBonded > 1)
        {
            FloatingTextStringOnCreature("A Bonded Summoner may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nBonded < 1)
        {
            FloatingTextStringOnCreature("A Bonded Summoner must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Brimstone Speaker marker feats
int BrimstoneSpeakerMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER))
    {
		int nBrimstone	= GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_ARCHIVIST)
						+ GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_CLERIC)
						+ GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_DOMIEL)
						+ GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_FAVOURED_SOUL)
						+ GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_HEALER)
						+ GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_JUSTICEWW)
						+ GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_KNIGHT_CHALICE)
						+ GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_KNIGHT_MIDDLECIRCLE)
						+ GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_NENTYAR_HUNTER)
						+ GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_PALADIN)
						+ GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_RANGER)
						+ GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_OASHAMAN)
						+ GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_SOHEI)
						+ GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_SOL)
						+ GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_SPSHAMAN)
						+ GetHasFeat(FEAT_BRIMSTONE_SPEAKER_SPELLCASTING_VASSAL);

        if(nBrimstone > 1)
        {
            FloatingTextStringOnCreature("A Brimstone Speaker may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nBrimstone < 1)
        {
            FloatingTextStringOnCreature("A Brimstone Speaker must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Bladesinger marker feats
int BladesingerMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_BLADESINGER))
    {
		int nBladesinger	= GetHasFeat(FEAT_BSINGER_SPELLCASTING_FEY)
							+ GetHasFeat(FEAT_BSINGER_SPELLCASTING_ABERRATION)
							+ GetHasFeat(FEAT_BSINGER_SPELLCASTING_MONSTROUS)
							+ GetHasFeat(FEAT_BSINGER_SPELLCASTING_OUTSIDER)
							+ GetHasFeat(FEAT_BSINGER_SPELLCASTING_SHAPECHANGER)
							+ GetHasFeat(FEAT_BSINGER_SPELLCASTING_ASSASSIN)
							+ GetHasFeat(FEAT_BSINGER_SPELLCASTING_BARD)
							+ GetHasFeat(FEAT_BSINGER_SPELLCASTING_BEGUILER)
							+ GetHasFeat(FEAT_BSINGER_SPELLCASTING_CELEBRANT_SHARESS)
							+ GetHasFeat(FEAT_BSINGER_SPELLCASTING_CULTIST_PEAK)
							+ GetHasFeat(FEAT_BSINGER_SPELLCASTING_DNECRO)
							+ GetHasFeat(FEAT_BSINGER_SPELLCASTING_DUSKBLADE)
							+ GetHasFeat(FEAT_BSINGER_SPELLCASTING_HARPER)
							+ GetHasFeat(FEAT_BSINGER_SPELLCASTING_HEXBLADE)
							+ GetHasFeat(FEAT_BSINGER_SPELLCASTING_KNIGHT_WEAVE)
							+ GetHasFeat(FEAT_BSINGER_SPELLCASTING_SHADOWLORD)
							+ GetHasFeat(FEAT_BSINGER_SPELLCASTING_SORCERER)
							+ GetHasFeat(FEAT_BSINGER_SPELLCASTING_SUBLIME_CHORD)
							+ GetHasFeat(FEAT_BSINGER_SPELLCASTING_SUEL_ARCHANAMACH)
							+ GetHasFeat(FEAT_BSINGER_SPELLCASTING_WARMAGE)
							+ GetHasFeat(FEAT_BSINGER_SPELLCASTING_WIZARD);

        if(nBladesinger > 1)
        {
            FloatingTextStringOnCreature("A Bladesinger may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nBladesinger < 1)
        {
            FloatingTextStringOnCreature("A Bladesinger must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Cerebrmancer marker feats
int CerebremancerMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_CEREBREMANCER))
    {
		int nCerebArcane	= GetHasFeat(FEAT_CMANCER_SPELLCASTING_FEY)
					+ GetHasFeat(FEAT_CMANCER_SPELLCASTING_ABERRATION)
					+ GetHasFeat(FEAT_CMANCER_SPELLCASTING_MONSTROUS)
					+ GetHasFeat(FEAT_CMANCER_SPELLCASTING_OUTSIDER)
					+ GetHasFeat(FEAT_CMANCER_SPELLCASTING_SHAPECHANGER)
					+ GetHasFeat(FEAT_CMANCER_SPELLCASTING_ASSASSIN)
					+ GetHasFeat(FEAT_CMANCER_SPELLCASTING_BARD)
					+ GetHasFeat(FEAT_CMANCER_SPELLCASTING_BEGUILER)
					+ GetHasFeat(FEAT_CMANCER_SPELLCASTING_CELEBRANT_SHARESS)
					+ GetHasFeat(FEAT_CMANCER_SPELLCASTING_CULTIST_PEAK)
					+ GetHasFeat(FEAT_CMANCER_SPELLCASTING_DNECRO)
					+ GetHasFeat(FEAT_CMANCER_SPELLCASTING_DUSKBLADE)
					+ GetHasFeat(FEAT_CMANCER_SPELLCASTING_HARPER)
					+ GetHasFeat(FEAT_CMANCER_SPELLCASTING_HEXBLADE)
					+ GetHasFeat(FEAT_CMANCER_SPELLCASTING_KNIGHT_WEAVE)
					+ GetHasFeat(FEAT_CMANCER_SPELLCASTING_SHADOWLORD)
					+ GetHasFeat(FEAT_CMANCER_SPELLCASTING_SORCERER)
					+ GetHasFeat(FEAT_CMANCER_SPELLCASTING_SUBLIME_CHORD)
					+ GetHasFeat(FEAT_CMANCER_SPELLCASTING_SUEL_ARCHANAMACH)
					+ GetHasFeat(FEAT_CMANCER_SPELLCASTING_WARMAGE)
					+ GetHasFeat(FEAT_CMANCER_SPELLCASTING_WIZARD);
					
		int nCerebPsi	= GetHasFeat(FEAT_CEREBREMANCER_MANIFEST_FOZ)
					+ GetHasFeat(FEAT_CEREBREMANCER_MANIFEST_PSION)
					+ GetHasFeat(FEAT_CEREBREMANCER_MANIFEST_PSYROUGE)
					+ GetHasFeat(FEAT_CEREBREMANCER_MANIFEST_PSYWAR)
					+ GetHasFeat(FEAT_CEREBREMANCER_MANIFEST_WARMIND)
					+ GetHasFeat(FEAT_CEREBREMANCER_MANIFEST_WILDER);

        if(nCerebPsi > 1)
        {
            FloatingTextStringOnCreature("A Cerebremancer may only advance a single psionic class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nCerebPsi < 1)
        {
            FloatingTextStringOnCreature("A Cerebremancer must pick one psionic class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		if(nCerebArcane > 1)
        {
            FloatingTextStringOnCreature("A Cerebremancer may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }		
		if(nCerebArcane < 1)
        {
            FloatingTextStringOnCreature("A Cerebremancer must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:: Enforce Child of Night marker feats
int CoNMarkerFeats()
{
	if(GetLevelByClass(CLASS_TYPE_CHILD_OF_NIGHT))
	{
		int nChild	= GetHasFeat(FEAT_CHILDNIGHT_MYSTERY_SHADOWCASTER)
					+ GetHasFeat(FEAT_CHILDNIGHT_MYSTERY_SHADOWSMITH);
				
        if(nChild > 1)
        {
            FloatingTextStringOnCreature("A Child of Night may only advance a single shadowcasting class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nChild < 1)
        {
            FloatingTextStringOnCreature("A Child of Night must pick one shadowcasting class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }	
			
	}
	
	return FALSE;
}	

//:; Enforces Combat Medic marker feats
int CombatMedicMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC))
    {
		int nCombatMedic	= GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_ARCHIVIST)
							+ GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_CLERIC)
							+ GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_DRUID)
							+ GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_FAVOURED_SOUL)
							+ GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_HEALER)
							+ GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_JUSTICEWW)
							+ GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_KNIGHT_CHALICE)
							+ GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_KNIGHT_MIDDLECIRCLE)
							+ GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_NENTYAR_HUNTER)
							+ GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_RANGER)
							+ GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_OASHAMAN)
							+ GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_SOL)
							+ GetHasFeat(FEAT_COMBAT_MEDIC_SPELLCASTING_SPSHAMAN);

        if(nCombatMedic > 1)
        {
            FloatingTextStringOnCreature("A Combat Medic may only advance a single class with Cure Light Wounds in its spell list.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nCombatMedic < 1)
        {
            FloatingTextStringOnCreature("A Combat Medic must pick one class with Cure Light Wounds in its spell list to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Contemplative marker feats
int ContemplativeMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE))
    {
		int nContemplative	= GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_ARCHIVIST)
							+ GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_BLACKGUARD)
							+ GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_BLIGHTER)
							+ GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_CLERIC)
							+ GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_DOMIEL)
							+ GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_DRUID)
							+ GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_FAVOURED_SOUL)
							+ GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_HEALER)
							+ GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_JUSTICEWW)
							+ GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_KNIGHT_CHALICE)
							+ GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_KNIGHT_MIDDLECIRCLE)
							+ GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_NENTYAR_HUNTER)
							+ GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_PALADIN)
							+ GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_RANGER)
							+ GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_OASHAMAN)
							+ GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_SOHEI)
							+ GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_SOL)
							+ GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_SPSHAMAN)
							+ GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_UR_PRIEST)
							+ GetHasFeat(FEAT_CONTEMPLATIVE_SPELLCASTING_VASSAL);

        if(nContemplative > 1)
        {
            FloatingTextStringOnCreature("A Contemplative may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nContemplative < 1)
        {
            FloatingTextStringOnCreature("A Contemplative  must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:: Enforces Diamond Dragon marker feats
int DiamondDragonMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_DIAMOND_DRAGON, OBJECT_SELF) > 1)
    {
		int nDiaDrag	= GetHasFeat(FEAT_DIAMOND_DRAGON_MANIFEST_FOZ)
						+ GetHasFeat(FEAT_DIAMOND_DRAGON_MANIFEST_PSION)
						+ GetHasFeat(FEAT_DIAMOND_DRAGON_MANIFEST_PSYROUGE)
						+ GetHasFeat(FEAT_DIAMOND_DRAGON_MANIFEST_PSYWAR)
						+ GetHasFeat(FEAT_DIAMOND_DRAGON_MANIFEST_WARMIND)
						+ GetHasFeat(FEAT_DIAMOND_DRAGON_MANIFEST_WILDER);

        if(nDiaDrag > 1)
        {
            FloatingTextStringOnCreature("A Diamond Dragon may only advance a single psionic class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nDiaDrag < 1)
        {
            FloatingTextStringOnCreature("A Diamond Dragon must pick one psionic class to advance at second level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;	
}
//:; Enforces Dragonheart Mage marker feats
int DragonheartMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_DRAGONHEART_MAGE))
    {
		int nDragonheart	= GetHasFeat(FEAT_DHEART_SPELLCASTING_FEY)
							+ GetHasFeat(FEAT_DHEART_SPELLCASTING_ABERRATION)
							+ GetHasFeat(FEAT_DHEART_SPELLCASTING_MONSTROUS)
							+ GetHasFeat(FEAT_DHEART_SPELLCASTING_OUTSIDER)
							+ GetHasFeat(FEAT_DHEART_SPELLCASTING_SHAPECHANGER)
							+ GetHasFeat(FEAT_DHEART_SPELLCASTING_ASSASSIN)
							+ GetHasFeat(FEAT_DHEART_SPELLCASTING_BARD)
							+ GetHasFeat(FEAT_DHEART_SPELLCASTING_BEGUILER)
							+ GetHasFeat(FEAT_DHEART_SPELLCASTING_CELEBRANT_SHARESS)
							+ GetHasFeat(FEAT_DHEART_SPELLCASTING_DNECRO)
							+ GetHasFeat(FEAT_DHEART_SPELLCASTING_DUSKBLADE)
							+ GetHasFeat(FEAT_DHEART_SPELLCASTING_HARPER)
							+ GetHasFeat(FEAT_DHEART_SPELLCASTING_HEXBLADE)
							+ GetHasFeat(FEAT_DHEART_SPELLCASTING_KNIGHT_WEAVE)
							+ GetHasFeat(FEAT_DHEART_SPELLCASTING_SHADOWLORD)
							+ GetHasFeat(FEAT_DHEART_SPELLCASTING_SORCERER)
							+ GetHasFeat(FEAT_DHEART_SPELLCASTING_SUBLIME_CHORD)
							+ GetHasFeat(FEAT_DHEART_SPELLCASTING_SUEL_ARCHANAMACH)
							+ GetHasFeat(FEAT_DHEART_SPELLCASTING_WARMAGE);

        if(nDragonheart > 1)
        {
            FloatingTextStringOnCreature("A Dragonheart Mage may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nDragonheart < 1)
        {
            FloatingTextStringOnCreature("A Dragonheart Mage must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Diabolist marker feats
int DiabolistMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_DIABOLIST))
    {
		int nDiabolist	= GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_ASSASSIN)
						+ GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_CULTIST_PEAK)
						+ GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_HEXBLADE)
						+ GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_SHADOWLORD)
						+ GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_DIABOLIST_SPELLCASTING_WIZARD);

        if(nDiabolist > 1)
        {
            FloatingTextStringOnCreature("A Diabolist may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nDiabolist < 1)
        {
            FloatingTextStringOnCreature("A Diabolist must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Dragonsong Lyrist marker feats
int DragonsongLyristMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST))
    {
		int nDragonsong	= GetHasFeat(FEAT_DSONG_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_DSONG_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_DSONG_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_DSONG_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_DSONG_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_DSONG_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_DSONG_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_DSONG_SPELLCASTING_CELEBRANT_SHARESS)
						+ GetHasFeat(FEAT_DSONG_SPELLCASTING_CULTIST_PEAK)
						+ GetHasFeat(FEAT_DSONG_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_DSONG_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_DSONG_SPELLCASTING_HARPER)
						+ GetHasFeat(FEAT_DSONG_SPELLCASTING_HEXBLADE)
						+ GetHasFeat(FEAT_DSONG_SPELLCASTING_KNIGHT_WEAVE)
						+ GetHasFeat(FEAT_DSONG_SPELLCASTING_SHADOWLORD)
						+ GetHasFeat(FEAT_DSONG_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_DSONG_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_DSONG_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_DSONG_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_DSONG_SPELLCASTING_WIZARD)					
						+ GetHasFeat(FEAT_DSONG_MYSTERY_SHADOWCASTER)
						+ GetHasFeat(FEAT_DSONG_MYSTERY_SHADOWSMITH);
						
        if(nDragonsong > 1)
        {
            FloatingTextStringOnCreature("A Dragonsong Lyrist may only advance a single arcane or shadowcasting class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nDragonsong < 1)
        {
            FloatingTextStringOnCreature("A Dragonsong Lyrist must pick one arcane or shadowcasting class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Eldritch Knight marker feats
int EldritchKnightMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT))
    {
		int nEldKnight	= GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_ASSASSIN)
						+ GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_CELEBRANT_SHARESS)
						+ GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_CULTIST_PEAK)
						+ GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_HARPER)
						+ GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_HEXBLADE)
						+ GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_KNIGHT_WEAVE)
						+ GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_SHADOWLORD)
						+ GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_EKNIGHT_SPELLCASTING_WIZARD);
						
        if(nEldKnight > 1)
        {
            FloatingTextStringOnCreature("An Eldritch Knight may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nEldKnight < 1)
        {
            FloatingTextStringOnCreature("An Eldritch Knight must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Eldritch Disciple marker feats
int EldritchDiscipleMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE))
    {
		int nEldInvoke	= GetHasFeat(FEAT_ELDISCIPLE_INVOKING_WARLOCK)
							+ GetHasFeat(FEAT_ELDISCIPLE_INVOKING_DFA);
							
		int nEldDisciple	= GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_ARCHIVIST)
							+ GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_BLACKGUARD)
							+ GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_BLIGHTER)
							+ GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_CLERIC)
							+ GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_DOMIEL)
							+ GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_DRUID)
							+ GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_FAVOURED_SOUL)
							+ GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_HEALER)
							+ GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_JUSTICEWW)
							+ GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_KNIGHT_CHALICE)
							+ GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_KNIGHT_MIDDLECIRCLE)
							+ GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_NENTYAR_HUNTER)
							+ GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_OCULAR)
							+ GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_RANGER)
							+ GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_OASHAMAN)
							+ GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_SOHEI)
							+ GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_SOL)
							+ GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_SPSHAMAN)
							+ GetHasFeat(FEAT_ELDISCIPLE_SPELLCASTING_UR_PRIEST);
						
        if(nEldInvoke > 1)
        {
            FloatingTextStringOnCreature("An Eldritch Disciple may only advance a single invoking class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nEldInvoke < 1)
        {
            FloatingTextStringOnCreature("An Eldritch Disciple must pick one invoking class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
        if(nEldDisciple > 1)
        {
            FloatingTextStringOnCreature("An Eldritch Disciple may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nEldDisciple < 1)
        {
            FloatingTextStringOnCreature("An Eldritch Disciple must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Eldritch Theurge marker feats
int EldritchTheurgeMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_ELDRITCH_THEURGE))
    {
		int nEldTheurge	= GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_ASSASSIN)
						+ GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_CULTIST_PEAK)
						+ GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_HARPER)
						+ GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_HEXBLADE)
						+ GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_KNIGHT_WEAVE)
						+ GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_SHADOWLORD)
						+ GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_WIZARD)
						+ GetHasFeat(FEAT_ETHEURGE_SPELLCASTING_CELEBRANT_SHARESS);
						
        if(nEldTheurge > 1)
        {
            FloatingTextStringOnCreature("An Eldritch Theurge may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nEldTheurge < 1)
        {
            FloatingTextStringOnCreature("An Eldritch Theurge must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Elemental Savant marker feats
int ElementalSavantMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT))
    {
		int nElmSavant	= GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_ASSASSIN)
						+ GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_CELEBRANT_SHARESS)
						+ GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_CULTIST_PEAK)
						+ GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_HARPER)
						+ GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_HEXBLADE)
						+ GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_KNIGHT_WEAVE)
						+ GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_SHADOWLORD)
						+ GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_ELESAVANT_SPELLCASTING_WIZARD)
						+ GetHasFeat(FEAT_ELESAVANT_MYSTERY_SHADOWCASTER)
						+ GetHasFeat(FEAT_ELESAVANT_MYSTERY_SHADOWSMITH);
						
        if(nElmSavant > 1)
        {
            FloatingTextStringOnCreature("An Elemental Savant may only advance a single arcane or shadowcasting class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nElmSavant < 1)
        {
            FloatingTextStringOnCreature("An Elemental Savant must pick one arcane or shadowcasting class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	


//:; Enforces Enlightend Fist marker feats
int EnlightendFistMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST))
    {
		int nEnlightened	= GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_FEY)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_ABERRATION)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_MONSTROUS)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_OUTSIDER)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_SHAPECHANGER)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_ASSASSIN)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_BARD)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_BEGUILER)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_CELEBRANT_SHARESS)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_CULTIST_PEAK)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_DNECRO)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_DUSKBLADE)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_HARPER)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_HEXBLADE)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_KNIGHT_WEAVE)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_SHADOWLORD)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_SORCERER)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_SUBLIME_CHORD)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_SUEL_ARCHANAMACH)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_WARMAGE)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_SPELLCASTING_WIZARD)						
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_INVOKING_WARLOCK)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_INVOKING_DFA)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_INVOKING_DRAGON_SHAMAN);
						
        if(nEnlightened > 1)
        {
            FloatingTextStringOnCreature("An Enlighted Fist may only advance a single arcane or invoker class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nEnlightened < 1)
        {
            FloatingTextStringOnCreature("An Enlighted Fist must pick one arcane or invoker class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}
	
//:; Enforces Fist of Raziel marker feats
int FistOfRazielMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_FISTRAZIEL))
    {
		int nRaziel	= GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_ARCHIVIST)
					+ GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_CLERIC)
					+ GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_DOMIEL)
					+ GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_FAVOURED_SOUL)
					+ GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_KNIGHT_CHALICE)
					+ GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_KNIGHT_MIDDLECIRCLE)
					+ GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_PALADIN)
					+ GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_SOHEI)
					+ GetHasFeat(FEAT_FISTRAZIEL_SPELLCASTING_VASSAL);
						
        if(nRaziel > 1)
        {
            FloatingTextStringOnCreature("A Fist of Raziel may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nRaziel < 1)
        {
            FloatingTextStringOnCreature("A Fist of Raziel must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Force Missile Mage marker feats
int FMMMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_FMM))
    {
		int nFMM	= GetHasFeat(FEAT_FMM_SPELLCASTING_ABERRATION)
					+ GetHasFeat(FEAT_FMM_SPELLCASTING_MONSTROUS)
					+ GetHasFeat(FEAT_FMM_SPELLCASTING_OUTSIDER)
					+ GetHasFeat(FEAT_FMM_SPELLCASTING_SHAPECHANGER)
					+ GetHasFeat(FEAT_FMM_SPELLCASTING_KNIGHT_WEAVE)
					+ GetHasFeat(FEAT_FMM_SPELLCASTING_SORCERER)
					+ GetHasFeat(FEAT_FMM_SPELLCASTING_WARMAGE)
					+ GetHasFeat(FEAT_FMM_SPELLCASTING_WIZARD);
						
        if(nFMM > 1)
        {
            FloatingTextStringOnCreature("A Force Missile Mage may only advance a single class with Magic Missile in its spell list.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nFMM < 1)
        {
            FloatingTextStringOnCreature("A Force Missile Mage must pick one class with Magic Missile in its spell list to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Fochlucan Lyrist marker feats
int FochlucanLyristMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_FOCHLUCAN_LYRIST))
    {
		int nFochlucanArcane	= GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_FEY)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_ABERRATION)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_MONSTROUS)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_OUTSIDER)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_SHAPECHANGER)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_ASSASSIN)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_BARD)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_BEGUILER)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_DNECRO)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_DUSKBLADE)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_HARPER)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_HEXBLADE)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_KNIGHT_WEAVE)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_SHADOWLORD)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_SORCERER)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_SUBLIME_CHORD)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_SUEL_ARCHANAMACH)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_WARMAGE)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_WIZARD)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_CULTIST_PEAK);
							
		int nFochlucanDivine	= GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_ARCHIVIST)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_BLACKGUARD)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_BLIGHTER)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_CLERIC)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_DRUID)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_FAVOURED_SOUL)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_HEALER)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_JUSTICEWW)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_KNIGHT_CHALICE)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_KNIGHT_MIDDLECIRCLE)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_NENTYAR_HUNTER)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_OCULAR)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_RANGER)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_OASHAMAN)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_SOHEI)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_SOL)
								+ GetHasFeat(FEAT_FOCHLUCAN_LYRIST_SPELLCASTING_SPSHAMAN);
							

        if(nFochlucanArcane > 1)
        {
            FloatingTextStringOnCreature("A Fochlucan Lyrist may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nFochlucanArcane < 1)
        {
            FloatingTextStringOnCreature("A Fochlucan Lyrist must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }							
						
        if(nFochlucanDivine > 1)
        {
            FloatingTextStringOnCreature("A Fochlucan Lyrist may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nFochlucanDivine < 1)
        {
            FloatingTextStringOnCreature("A Fochlucan Lyrist must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Forest Master marker feats
int ForestMasterMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_FORESTMASTER))
    {
		int nForestMaster	= GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_ARCHIVIST)
							+ GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_CLERIC)
							+ GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_DRUID)
							+ GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_FAVOURED_SOUL)
							+ GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_NENTYAR_HUNTER)
							+ GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_RANGER)
							+ GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_OASHAMAN)
							+ GetHasFeat(FEAT_FORESTMASTER_SPELLCASTING_SPSHAMAN);
						
        if(nForestMaster > 1)
        {
            FloatingTextStringOnCreature("A Forest Master may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nForestMaster < 1)
        {
            FloatingTextStringOnCreature("A Forest Master must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Frost Mage marker feats
int FrostMageMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_FROST_MAGE))
    {
		int nFrostMage	= GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_ASSASSIN)
						+ GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_CELEBRANT_SHARESS)
						+ GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_CULTIST_PEAK)
						+ GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_HARPER)
						+ GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_HEXBLADE)
						+ GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_KNIGHT_WEAVE)
						+ GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_SHADOWLORD)
						+ GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_WIZARD);
						
        if(nFrostMage > 1)
        {
            FloatingTextStringOnCreature("A Frost Mage may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nFrostMage < 1)
        {
            FloatingTextStringOnCreature("A Frost Mage must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Thrall of Grazzt marker feats
int ToGMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A))
    {
		int nGrazzt	= GetHasFeat(FEAT_GRAZZT_SPELLCASTING_FEY)
					+ GetHasFeat(FEAT_GRAZZT_SPELLCASTING_ABERRATION)
					+ GetHasFeat(FEAT_GRAZZT_SPELLCASTING_MONSTROUS)
					+ GetHasFeat(FEAT_GRAZZT_SPELLCASTING_OUTSIDER)
					+ GetHasFeat(FEAT_GRAZZT_SPELLCASTING_SHAPECHANGER)
					+ GetHasFeat(FEAT_GRAZZT_SPELLCASTING_ASSASSIN)
					+ GetHasFeat(FEAT_GRAZZT_SPELLCASTING_BARD)
					+ GetHasFeat(FEAT_GRAZZT_SPELLCASTING_BEGUILER)
					+ GetHasFeat(FEAT_GRAZZT_SPELLCASTING_CULTIST_PEAK)
					+ GetHasFeat(FEAT_GRAZZT_SPELLCASTING_DNECRO)
					+ GetHasFeat(FEAT_GRAZZT_SPELLCASTING_DUSKBLADE)
					+ GetHasFeat(FEAT_GRAZZT_SPELLCASTING_HEXBLADE)
					+ GetHasFeat(FEAT_GRAZZT_SPELLCASTING_SHADOWLORD)
					+ GetHasFeat(FEAT_GRAZZT_SPELLCASTING_SORCERER)
					+ GetHasFeat(FEAT_GRAZZT_SPELLCASTING_SUBLIME_CHORD)
					+ GetHasFeat(FEAT_GRAZZT_SPELLCASTING_SUEL_ARCHANAMACH)
					+ GetHasFeat(FEAT_GRAZZT_SPELLCASTING_WARMAGE)
					+ GetHasFeat(FEAT_GRAZZT_SPELLCASTING_WIZARD);
						
        if(nGrazzt > 1)
        {
            FloatingTextStringOnCreature("A Thrall of Grazzt may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nGrazzt < 1)
        {
            FloatingTextStringOnCreature("A Thrall of Grazzt must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Harper Mage marker feats
int HarperMageMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_HARPERMAGE))
    {
		int nHarperMage	= GetHasFeat(FEAT_HARPERM_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_HARPERM_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_HARPERM_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_HARPERM_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_HARPERM_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_HARPERM_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_HARPERM_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_HARPERM_SPELLCASTING_CELEBRANT_SHARESS)
						+ GetHasFeat(FEAT_HARPERM_SPELLCASTING_CULTIST_PEAK)
						+ GetHasFeat(FEAT_HARPERM_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_HARPERM_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_HARPERM_SPELLCASTING_HARPER)
						+ GetHasFeat(FEAT_HARPERM_SPELLCASTING_HEXBLADE)
						+ GetHasFeat(FEAT_HARPERM_SPELLCASTING_KNIGHT_WEAVE)
						+ GetHasFeat(FEAT_HARPERM_SPELLCASTING_SHADOWLORD)
						+ GetHasFeat(FEAT_HARPERM_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_HARPERM_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_HARPERM_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_HARPERM_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_HARPERM_SPELLCASTING_WIZARD);
						
        if(nHarperMage > 1)
        {
            FloatingTextStringOnCreature("A Harper Mage may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nHarperMage < 1)
        {
            FloatingTextStringOnCreature("A Harper Mage must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Hathran marker feats
int HathranMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_HATHRAN))	
    {
		int nHathranArcane	= GetHasFeat(FEAT_HATHRAN_SPELLCASTING_FEY)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_ABERRATION)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_MONSTROUS)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_OUTSIDER)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_SHAPECHANGER)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_BARD)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_BEGUILER)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_CULTIST_PEAK)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_DNECRO)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_DUSKBLADE)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_HARPER)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_HEXBLADE)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_KNIGHT_WEAVE)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_SHADOWLORD)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_SORCERER)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_SUBLIME_CHORD)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_SUEL_ARCHANAMACH)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_WARMAGE)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_WIZARD);
							
		int nHathranDivine	= GetHasFeat(FEAT_HATHRAN_SPELLCASTING_ARCHIVIST)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_CLERIC)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_DOMIEL)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_DRUID)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_FAVOURED_SOUL)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_HEALER)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_JUSTICEWW)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_KNIGHT_CHALICE)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_KNIGHT_MIDDLECIRCLE)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_NENTYAR_HUNTER)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_PALADIN)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_RANGER)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_OASHAMAN)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_SOHEI)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_SOL)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_SPSHAMAN)
							+ GetHasFeat(FEAT_HATHRAN_SPELLCASTING_VASSAL);							
							

        if(nHathranArcane > 1)
        {
            FloatingTextStringOnCreature("A Hathran may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nHathranArcane < 1)
        {
            FloatingTextStringOnCreature("A Hathran must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }							
						
        if(nHathranDivine > 1)
        {
            FloatingTextStringOnCreature("A Hathran may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nHathranDivine < 1)
        {
            FloatingTextStringOnCreature("A Hathran must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Havoc Mage marker feats
int HavocMageMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_HAVOC_MAGE))
    {
		int nHavocMage	= GetHasFeat(FEAT_HAVOC_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_HAVOC_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_HAVOC_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_HAVOC_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_HAVOC_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_HAVOC_SPELLCASTING_ASSASSIN)
						+ GetHasFeat(FEAT_HAVOC_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_HAVOC_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_HAVOC_SPELLCASTING_CULTIST_PEAK)
						+ GetHasFeat(FEAT_HAVOC_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_HAVOC_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_HAVOC_SPELLCASTING_HARPER)
						+ GetHasFeat(FEAT_HAVOC_SPELLCASTING_HEXBLADE)
						+ GetHasFeat(FEAT_HAVOC_SPELLCASTING_KNIGHT_WEAVE)
						+ GetHasFeat(FEAT_HAVOC_SPELLCASTING_SHADOWLORD)
						+ GetHasFeat(FEAT_HAVOC_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_HAVOC_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_HAVOC_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_HAVOC_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_HAVOC_SPELLCASTING_WIZARD)
						+ GetHasFeat(FEAT_HAVOC_SPELLCASTING_CELEBRANT_SHARESS);
						
        if(nHavocMage > 1)
        {
            FloatingTextStringOnCreature("A Havoc Mage may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nHavocMage < 1)
        {
            FloatingTextStringOnCreature("A Havoc Mage must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Heartwarder marker feats
int HeartwarderMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_HEARTWARDER))
    {
		int nHeartwarder	= GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_ARCHIVIST)
							+ GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_CLERIC)
							+ GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_FAVOURED_SOUL)
							+ GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_HEALER)
							+ GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_JUSTICEWW)
							+ GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_KNIGHT_MIDDLECIRCLE)
							+ GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_RANGER)
							+ GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_OASHAMAN)
							+ GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_SPSHAMAN);
						
        if(nHeartwarder > 1)
        {
            FloatingTextStringOnCreature("A Heartwarder may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nHeartwarder < 1)
        {
            FloatingTextStringOnCreature("A Heartwarder must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Hierophant marker feats
int HierophantMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_HIEROPHANT))
    {
		int nHierophant	= GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_ARCHIVIST)
						+ GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_BLIGHTER)
						+ GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_CLERIC)
						+ GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_DRUID)
						+ GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_FAVOURED_SOUL)
						+ GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_HEALER)
						+ GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_OCULAR)
						+ GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_OASHAMAN)
						+ GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_SPSHAMAN)
						+ GetHasFeat(FEAT_HIEROPHANT_SPELLCASTING_UR_PRIEST);
						
        if(nHierophant > 1)
        {
            FloatingTextStringOnCreature("A Hierophant may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nHierophant < 1)
        {
            FloatingTextStringOnCreature("A Hierophant must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Hospitaler marker feats
int HospitalerMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_HOSPITALER))
    {
		int nHospitaler	= GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_ARCHIVIST)
						+ GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_BLIGHTER)
						+ GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_CLERIC)
						+ GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_DRUID)
						+ GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_FAVOURED_SOUL)
						+ GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_HEALER)
						+ GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_OCULAR)
						+ GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_OASHAMAN)
						+ GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_SPSHAMAN)
						+ GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_UR_PRIEST);
						
        if(nHospitaler > 1)
        {
            FloatingTextStringOnCreature("A Hospitaler may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nHospitaler < 1)
        {
            FloatingTextStringOnCreature("A Hospitaler must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}

//:; Enforces Jade Phoenix Mage marker feats
int JPMMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE))
    {
		int nJPM	= GetHasFeat(FEAT_JPM_SPELLCASTING_FEY)
					+ GetHasFeat(FEAT_JPM_SPELLCASTING_ABERRATION)
					+ GetHasFeat(FEAT_JPM_SPELLCASTING_MONSTROUS)
					+ GetHasFeat(FEAT_JPM_SPELLCASTING_OUTSIDER)
					+ GetHasFeat(FEAT_JPM_SPELLCASTING_SHAPECHANGER)
					+ GetHasFeat(FEAT_JPM_SPELLCASTING_BARD)
					+ GetHasFeat(FEAT_JPM_SPELLCASTING_BEGUILER)
					+ GetHasFeat(FEAT_JPM_SPELLCASTING_CELEBRANT_SHARESS)
					+ GetHasFeat(FEAT_JPM_SPELLCASTING_CULTIST_PEAK)
					+ GetHasFeat(FEAT_JPM_SPELLCASTING_DNECRO)
					+ GetHasFeat(FEAT_JPM_SPELLCASTING_DUSKBLADE)
					+ GetHasFeat(FEAT_JPM_SPELLCASTING_HARPER)
					+ GetHasFeat(FEAT_JPM_SPELLCASTING_HEXBLADE)
					+ GetHasFeat(FEAT_JPM_SPELLCASTING_KNIGHT_WEAVE)
					+ GetHasFeat(FEAT_JPM_SPELLCASTING_SHADOWLORD)
					+ GetHasFeat(FEAT_JPM_SPELLCASTING_SORCERER)
					+ GetHasFeat(FEAT_JPM_SPELLCASTING_SUBLIME_CHORD)
					+ GetHasFeat(FEAT_JPM_SPELLCASTING_SUEL_ARCHANAMACH)
					+ GetHasFeat(FEAT_JPM_SPELLCASTING_WARMAGE)
					+ GetHasFeat(FEAT_JPM_SPELLCASTING_WIZARD);
						
        if(nJPM > 1)
        {
            FloatingTextStringOnCreature("A Jade Phoenis Mage may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nJPM < 1)
        {
            FloatingTextStringOnCreature("A Jade Phoenis Mage must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:: Enforces Iron Mind marker feats
int IronMindMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_IRONMIND))
    {
		int nIronMind	= GetHasFeat(FEAT_IRONMIND_MANIFEST_FOZ)
						+ GetHasFeat(FEAT_IRONMIND_MANIFEST_PSION)
						+ GetHasFeat(FEAT_IRONMIND_MANIFEST_PSYROUGE)
						+ GetHasFeat(FEAT_IRONMIND_MANIFEST_PSYWAR)
						+ GetHasFeat(FEAT_IRONMIND_MANIFEST_WARMIND)
						+ GetHasFeat(FEAT_IRONMIND_MANIFEST_WILDER);

        if(nIronMind > 1)
        {
            FloatingTextStringOnCreature("An Iron Mind may only advance a single psionic class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nIronMind < 1)
        {
            FloatingTextStringOnCreature("An Iron Mind must pick one psionic class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;	
}

//:; Enforces Drow Judicator marker feats
int JudicatorMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_JUDICATOR))
    {
		int nJudicator	= GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_ASSASSIN)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_HEXBLADE)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_SHADOWLORD)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_WIZARD)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_ARCHIVIST)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_BLACKGUARD)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_BLIGHTER)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_CLERIC)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_DRUID)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_FAVOURED_SOUL)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_JUSTICEWW)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_RANGER)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_OASHAMAN)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_SOHEI)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_SPSHAMAN)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_UR_PRIEST);
						
        if(nJudicator > 1)
        {
            FloatingTextStringOnCreature("A Drow Judicator may only advance a single arcane, divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nJudicator < 1)
        {
            FloatingTextStringOnCreature("A Drow Judicator must pick one arcane or divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Mighty Contender of Kord marker feats
int MCoKMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD))
    {
		int nKord	= GetHasFeat(FEAT_KORD_SPELLCASTING_ARCHIVIST)
						+ GetHasFeat(FEAT_KORD_SPELLCASTING_CLERIC)
						+ GetHasFeat(FEAT_KORD_SPELLCASTING_FAVOURED_SOUL)
						+ GetHasFeat(FEAT_KORD_SPELLCASTING_HEALER)
						+ GetHasFeat(FEAT_KORD_SPELLCASTING_JUSTICEWW)
						+ GetHasFeat(FEAT_KORD_SPELLCASTING_KNIGHT_MIDDLECIRCLE)
						+ GetHasFeat(FEAT_KORD_SPELLCASTING_NENTYAR_HUNTER)
						+ GetHasFeat(FEAT_KORD_SPELLCASTING_RANGER)
						+ GetHasFeat(FEAT_KORD_SPELLCASTING_OASHAMAN)
						+ GetHasFeat(FEAT_KORD_SPELLCASTING_SPSHAMAN);
						
        if(nKord > 1)
        {
            FloatingTextStringOnCreature("A Mighty Contender of Kord may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nKord < 1)
        {
            FloatingTextStringOnCreature("A Mighty Contender of Kord must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Maester marker feats
int MaesterMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_MAESTER))
    {
		int nMaester	= GetHasFeat(FEAT_MAESTER_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_MAESTER_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_MAESTER_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_MAESTER_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_MAESTER_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_MAESTER_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_MAESTER_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_MAESTER_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_MAESTER_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_MAESTER_SPELLCASTING_KNIGHT_WEAVE)
						+ GetHasFeat(FEAT_MAESTER_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_MAESTER_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_MAESTER_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_MAESTER_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_MAESTER_SPELLCASTING_WIZARD)
						+ GetHasFeat(FEAT_MAESTER_INVOKING_WARLOCK)
						+ GetHasFeat(FEAT_MAESTER_INVOKING_DFA);
						
        if(nMaester > 1)
        {
            FloatingTextStringOnCreature("A Maester may only advance a single arcane or invoker class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nMaester < 1)
        {
            FloatingTextStringOnCreature("A Maester must pick one arcane or invoker class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Magekiller marker feats
int MagekillerMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_MAGEKILLER))
    {
		int nMagekiller	= GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_MAGEKILLER_SPELLCASTING_WIZARD);
						
        if(nMagekiller > 1)
        {
            FloatingTextStringOnCreature("A Mage Killer may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nMagekiller < 1)
        {
            FloatingTextStringOnCreature("A Mage Killer must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:: Enforces Master of Shadows marker feats
int MasterShadowMarkerFeats()
{
	if(GetLevelByClass(CLASS_TYPE_MASTER_OF_SHADOW))
	{
		int nShadow	= GetHasFeat(FEAT_MASTERSHADOW_MYSTERY_SHADOWCASTER)
					+ GetHasFeat(FEAT_MASTERSHADOW_MYSTERY_SHADOWSMITH);
				
        if(nShadow > 1)
        {
            FloatingTextStringOnCreature("A Master of Shadows may only advance a single shadowcasting class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nShadow < 1)
        {
            FloatingTextStringOnCreature("A Master of Shadows must pick one shadowcasting class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
	}
    return FALSE;				
}

//:; Enforces Master of Shrouds marker feats
int MoSMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS))
    {
		int nMoS	= GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_BLIGHTER)
					+ GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_CLERIC)
					+ GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_OCULAR)
					+ GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_OASHAMAN)
					+ GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_ARCHIVIST)
					+ GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_BLACKGUARD)
					+ GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_DRUID)
					+ GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_FAVOURED_SOUL)
					+ GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_JUSTICEWW)
					+ GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_RANGER)
					+ GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_SOHEI)
					+ GetHasFeat(FEAT_MASTER_OF_SHROUDS_SPELLCASTING_UR_PRIEST);
						
        if(nMoS > 1)
        {
            FloatingTextStringOnCreature("A Master of Shrouds may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nMoS < 1)
        {
            FloatingTextStringOnCreature("A Master of Shrouds must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		int iCleDom = GetHasFeat(FEAT_EVIL_DOMAIN_POWER)
                    + GetHasFeat(FEAT_DEATH_DOMAIN_POWER)
                    + GetHasFeat(FEAT_PROTECTION_DOMAIN_POWER);

        if(iCleDom < 1)
        {
            FloatingTextStringOnCreature("To become a Master of Shrouds you must possess one of the following divine domains: Evil, Death, or Protection.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }	
    }
	
    return FALSE;
}	

//:; Enforces Master Harper marker feats
int MasterHarperMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_MASTER_HARPER))
    {
		int nMasterHaper	= GetHasFeat(FEAT_MHARPER_SPELLCASTING_FEY)
							+ GetHasFeat(FEAT_MHARPER_SPELLCASTING_ABERRATION)
							+ GetHasFeat(FEAT_MHARPER_SPELLCASTING_MONSTROUS)
							+ GetHasFeat(FEAT_MHARPER_SPELLCASTING_OUTSIDER)
							+ GetHasFeat(FEAT_MHARPER_SPELLCASTING_SHAPECHANGER)
							+ GetHasFeat(FEAT_MHARPER_SPELLCASTING_BARD)
							+ GetHasFeat(FEAT_MHARPER_SPELLCASTING_BEGUILER)
							+ GetHasFeat(FEAT_MHARPER_SPELLCASTING_CELEBRANT_SHARESS)
							+ GetHasFeat(FEAT_MHARPER_SPELLCASTING_CULTIST_PEAK)
							+ GetHasFeat(FEAT_MHARPER_SPELLCASTING_DNECRO)
							+ GetHasFeat(FEAT_MHARPER_SPELLCASTING_DUSKBLADE)
							+ GetHasFeat(FEAT_MHARPER_SPELLCASTING_HARPER)
							+ GetHasFeat(FEAT_MHARPER_SPELLCASTING_HEXBLADE)
							+ GetHasFeat(FEAT_MHARPER_SPELLCASTING_KNIGHT_WEAVE)
							+ GetHasFeat(FEAT_MHARPER_SPELLCASTING_SHADOWLORD)
							+ GetHasFeat(FEAT_MHARPER_SPELLCASTING_SORCERER)
							+ GetHasFeat(FEAT_MHARPER_SPELLCASTING_SUBLIME_CHORD)
							+ GetHasFeat(FEAT_MHARPER_SPELLCASTING_WARMAGE)
							+ GetHasFeat(FEAT_MHARPER_SPELLCASTING_WIZARD)
							+ GetHasFeat(FEAT_MHARPER_SPELLCASTING_SUEL_ARCHANAMACH);
						
        if(nMasterHaper > 1)
        {
            FloatingTextStringOnCreature("A Master Harper may only advance a single arcane or divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nMasterHaper < 1)
        {
            FloatingTextStringOnCreature("A Master Harper must pick one arcane or divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Morninglord of Lathander marker feats
int MorninglordMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_MORNINGLORD))
    {
		int nMorninglord	= GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_CLERIC)
							+ GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_FAVOURED_SOUL)
							+ GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_HEALER)
							+ GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_PALADIN)
							+ GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_RANGER)
							+ GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_OASHAMAN)
							+ GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_SOHEI)
							+ GetHasFeat(FEAT_MORNINGLORD_SPELLCASTING_SOL);
						
        if(nMorninglord > 1)
        {
            FloatingTextStringOnCreature("A Morninglord of Lathander may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nMorninglord < 1)
        {
            FloatingTextStringOnCreature("A Morninglord of Lathander must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Mystic Theurge marker feats
int MysticTheurgeMarkerFeats()
{
    if (GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE))
    {
        int nMysticDivine = 0;
        int nMysticArcane = 0;
        int nMysticShadow = 0;

        // Check for divine, arcane, and shadow marker feats
        nMysticDivine = GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_ARCHIVIST)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_BLACKGUARD)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_BLIGHTER)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_CLERIC)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_DOMIEL)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_DRUID)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_FAVOURED_SOUL)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_HEALER)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_JUSTICEWW)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_KNIGHT_CHALICE)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_KNIGHT_MIDDLECIRCLE)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_NENTYAR_HUNTER)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_OCULAR)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_PALADIN)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_RANGER)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_OASHAMAN)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SOHEI)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SOL)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SPSHAMAN)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_UR_PRIEST)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_VASSAL);

        nMysticArcane = GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_ASSASSIN)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_CELEBRANT_SHARESS)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_CULTIST_PEAK)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_HARPER)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_HEXBLADE)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_KNIGHT_WEAVE)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SHADOWLORD)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_WIZARD);

        nMysticShadow = GetHasFeat(FEAT_MYSTICTHEURGE_MYSTERY_SHADOWCASTER)
						+ GetHasFeat(FEAT_MYSTICTHEURGE_MYSTERY_SHADOWSMITH);

        // Ensure no more than one feat is selected per category
        if (nMysticDivine > 1 || nMysticArcane > 1 || nMysticShadow > 1)
        {
            FloatingTextStringOnCreature("A Mystic Theurge may only advance two different types of spellcasting.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }

        int nSelectedTypes = 0;

        // Count how many different types of spellcasting the character has selected
        if (nMysticDivine > 0) nSelectedTypes++;
        if (nMysticArcane > 0) nSelectedTypes++;
        if (nMysticShadow > 0) nSelectedTypes++;

        // Check if the character has chosen a valid combination of marker feats
        if (nSelectedTypes > 2) 
		{
            FloatingTextStringOnCreature("A Mystic Theurge may only advance two different types of spellcasting.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }

        if (nSelectedTypes < 2) 
		{
            FloatingTextStringOnCreature("A Mystic Theurge must pick two spellcasting classes to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }

    return FALSE;
}

/* //:; Enforces Mystic Theurge marker feats
int MysticTheurgeMarkerFeats()
{
    if (GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE))
    {
        int nMysticDivine = -1;
        int nMysticArcane = -1;
        int nMysticShadow = -1;

        // Check for divine, arcane, and shadow marker feats
        nMysticDivine = GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_ARCHIVIST)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_BLACKGUARD)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_BLIGHTER)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_CLERIC)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_DOMIEL)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_DRUID)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_FAVOURED_SOUL)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_HEALER)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_JUSTICEWW)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_KNIGHT_CHALICE)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_KNIGHT_MIDDLECIRCLE)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_NENTYAR_HUNTER)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_OCULAR)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_PALADIN)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_RANGER)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_OASHAMAN)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SOHEI)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SOL)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SPSHAMAN)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_UR_PRIEST)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_VASSAL);

        nMysticArcane = GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_ASSASSIN)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_CELEBRANT_SHARESS)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_CULTIST_PEAK)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_HARPER)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_HEXBLADE)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_KNIGHT_WEAVE)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SHADOWLORD)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_MYSTIC_THEURGE_SPELLCASTING_WIZARD);

        nMysticShadow = GetHasFeat(FEAT_MYSTICTHEURGE_MYSTERY_SHADOWCASTER)
						+ GetHasFeat(FEAT_MYSTICTHEURGE_MYSTERY_SHADOWSMITH);

        int totalMarkerFeats = nMysticDivine + nMysticArcane + nMysticShadow;

        // Check if the character has chosen a valid combination of marker feats
        if ((totalMarkerFeats > 2) || (nMysticDivine > 1) || (nMysticArcane > 1) || (nMysticShadow > 1)) 
		{
            FloatingTextStringOnCreature("A Mystic Theurge may only advance two different types of spellcasting.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }

        if (totalMarkerFeats < 2) 
		{
            FloatingTextStringOnCreature("A Mystic Theurge must pick two spellcasting classes to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }

    return FALSE;
} */

//:; Enforces Noctumancer marker feats
int NoctumancerMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_NOCTUMANCER))
    {
		int nNoctArcane		= GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_FEY)
							+ GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_ABERRATION)
							+ GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_MONSTROUS)
							+ GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_OUTSIDER)
							+ GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_SHAPECHANGER)
							+ GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_BARD)
							+ GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_BEGUILER)
							+ GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_DNECRO)
							+ GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_DUSKBLADE)
							+ GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_KNIGHT_WEAVE)
							+ GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_SORCERER)
							+ GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_SUBLIME_CHORD)
							+ GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_SUEL_ARCHANAMACH)
							+ GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_WARMAGE)
							+ GetHasFeat(FEAT_NOCTUMANCER_SPELLCASTING_WIZARD);

		int nNoctShadow		= GetHasFeat(FEAT_NOCTUMANCER_MYSTERY_SHADOWCASTER)
							+ GetHasFeat(FEAT_NOCTUMANCER_MYSTERY_SHADOWSMITH);
						
        if(nNoctArcane > 1)
        {
            FloatingTextStringOnCreature("A Noctumancer may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nNoctArcane < 1)
        {
            FloatingTextStringOnCreature("A Noctumancer must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
        if(nNoctShadow > 1)
        {
            FloatingTextStringOnCreature("A Noctumancer may only advance a single shadowcasting class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nNoctShadow < 1)
        {
            FloatingTextStringOnCreature("A Noctumancer must pick one shadowcasting class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }		
    }
	
    return FALSE;
}	

//:; Enforces Ollam marker feats
int OllamMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_OLLAM))
    {
		int nOllam	= GetHasFeat(FEAT_OLLAM_SPELLCASTING_ARCHIVIST)
					+ GetHasFeat(FEAT_OLLAM_SPELLCASTING_CLERIC)
					+ GetHasFeat(FEAT_OLLAM_SPELLCASTING_DOMIEL)
					+ GetHasFeat(FEAT_OLLAM_SPELLCASTING_FAVOURED_SOUL)
					+ GetHasFeat(FEAT_OLLAM_SPELLCASTING_HEALER)
					+ GetHasFeat(FEAT_OLLAM_SPELLCASTING_JUSTICEWW)
					+ GetHasFeat(FEAT_OLLAM_SPELLCASTING_KNIGHT_CHALICE)
					+ GetHasFeat(FEAT_OLLAM_SPELLCASTING_KNIGHT_MIDDLECIRCLE)
					+ GetHasFeat(FEAT_OLLAM_SPELLCASTING_NENTYAR_HUNTER)
					+ GetHasFeat(FEAT_OLLAM_SPELLCASTING_PALADIN)
					+ GetHasFeat(FEAT_OLLAM_SPELLCASTING_RANGER)
					+ GetHasFeat(FEAT_OLLAM_SPELLCASTING_OASHAMAN)
					+ GetHasFeat(FEAT_OLLAM_SPELLCASTING_SOHEI)
					+ GetHasFeat(FEAT_OLLAM_SPELLCASTING_SPSHAMAN)
					+ GetHasFeat(FEAT_OLLAM_SPELLCASTING_VASSAL)
					+ GetHasFeat(FEAT_OLLAM_SPELLCASTING_NONE)
					+ GetHasFeat(FEAT_OLLAM_MYSTERY_SHADOWCASTER)
					+ GetHasFeat(FEAT_OLLAM_MYSTERY_SHADOWSMITH);				
						
        if(nOllam > 1)
        {
            FloatingTextStringOnCreature("A Ollam may only advance a single arcane or shadowcasting class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nOllam < 1)
        {
            FloatingTextStringOnCreature("A Ollam must pick one arcane or shadowcasting class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Oozemaster marker feats
int OozemasterMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_OOZEMASTER))
    {
		int nOozemaster	= GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_ASSASSIN)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_CELEBRANT_SHARESS)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_CULTIST_PEAK)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_HARPER)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_HEXBLADE)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_KNIGHT_WEAVE)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_SHADOWLORD)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_WIZARD)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_ARCHIVIST)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_BLACKGUARD)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_BLIGHTER)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_CLERIC)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_DOMIEL)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_DRUID)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_FAVOURED_SOUL)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_HEALER)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_JUSTICEWW)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_KNIGHT_MIDDLECIRCLE)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_NENTYAR_HUNTER)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_OCULAR)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_PALADIN)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_RANGER)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_OASHAMAN)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_SOHEI)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_SOL)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_UR_PRIEST)
						+ GetHasFeat(FEAT_OOZEMASTER_SPELLCASTING_VASSAL);
						
        if(nOozemaster > 1)
        {
            FloatingTextStringOnCreature("An Oozemaster may only advance a single arcane or divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nOozemaster < 1)
        {
            FloatingTextStringOnCreature("An Oozemaster must pick one arcane or divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Thrall of Orcus marker feats
int OrcusMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_ORCUS))
    {
		int nOrcus	= GetHasFeat(FEAT_ORCUS_SPELLCASTING_ARCHIVIST)
					+ GetHasFeat(FEAT_ORCUS_SPELLCASTING_BLACKGUARD)
					+ GetHasFeat(FEAT_ORCUS_SPELLCASTING_BLIGHTER)
					+ GetHasFeat(FEAT_ORCUS_SPELLCASTING_CLERIC)
					+ GetHasFeat(FEAT_ORCUS_SPELLCASTING_FAVOURED_SOUL)
					+ GetHasFeat(FEAT_ORCUS_SPELLCASTING_JUSTICEWW)
					+ GetHasFeat(FEAT_ORCUS_SPELLCASTING_RANGER)
					+ GetHasFeat(FEAT_ORCUS_SPELLCASTING_OASHAMAN)
					+ GetHasFeat(FEAT_ORCUS_SPELLCASTING_SOHEI)
					+ GetHasFeat(FEAT_ORCUS_SPELLCASTING_SPSHAMAN)
					+ GetHasFeat(FEAT_ORCUS_MYSTERY_SHADOWCASTER)
					+ GetHasFeat(FEAT_ORCUS_MYSTERY_SHADOWSMITH);
						
        if(nOrcus > 1)
        {
            FloatingTextStringOnCreature("A Thrall of Orcus may only advance a single shadowcasting or divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nOrcus < 1)
        {
            FloatingTextStringOnCreature("A Thrall of Orcus must pick one shadowcasting or divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Pale Master marker feats
int PaleMasterMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_PALEMASTER) || GetLevelByClass(CLASS_TYPE_PALE_MASTER))
    {
		int nPaleMaster	= GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_ASSASSIN)
						+ GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_CULTIST_PEAK)
						+ GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_HARPER)
						+ GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_HEXBLADE)
						+ GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_KNIGHT_WEAVE)
						+ GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_SHADOWLORD)
						+ GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_PALEMASTER_SPELLCASTING_WIZARD);
						
        if(nPaleMaster > 1)
        {
            FloatingTextStringOnCreature("A Pale Master may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nPaleMaster < 1)
        {
            FloatingTextStringOnCreature("A Pale Master must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Psychic Theurge marker feats
int PsychicTheurgeMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE))
    {
		int nPsyTheurgePsi	= GetHasFeat(FEAT_PSYCHIC_THEURGE_MANIFEST_FOZ)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_MANIFEST_PSION)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_MANIFEST_PSYROUGE)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_MANIFEST_PSYWAR)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_MANIFEST_WARMIND)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_MANIFEST_WILDER);
								
		int nPsyTheurgeDivine	= GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_ARCHIVIST)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_BLACKGUARD)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_BLIGHTER)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_CLERIC)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_DOMIEL)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_DRUID)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_FAVOURED_SOUL)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_HEALER)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_JUSTICEWW)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_KNIGHT_CHALICE)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_KNIGHT_MIDDLECIRCLE)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_NENTYAR_HUNTER)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_OCULAR)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_PALADIN)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_RANGER)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_OASHAMAN)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_SOHEI)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_SOL)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_SPSHAMAN)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_UR_PRIEST)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_SPELLCASTING_VASSAL);
						
        if(nPsyTheurgeDivine > 1)
        {
            FloatingTextStringOnCreature("A Psychic Theurge may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nPsyTheurgeDivine < 1)
        {
            FloatingTextStringOnCreature("A Psychic Theurge must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
        if(nPsyTheurgePsi > 1)
        {
            FloatingTextStringOnCreature("A Psychic Theurge may only advance a single psionic class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nPsyTheurgePsi < 1)
        {
            FloatingTextStringOnCreature("A Psychic Theurge must pick one psionic class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Rage Mage marker feats
int RageMageMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_RAGE_MAGE))
    {
		int nRageMage	= GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_ASSASSIN)
						+ GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_CULTIST_PEAK)
						+ GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_HARPER)
						+ GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_HEXBLADE)
						+ GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_KNIGHT_WEAVE)
						+ GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_SHADOWLORD)
						+ GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_WIZARD)
						+ GetHasFeat(FEAT_RAGEMAGE_SPELLCASTING_CELEBRANT_SHARESS);
						
        if(nRageMage > 1)
        {
            FloatingTextStringOnCreature("A Rage Mage may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nRageMage < 1)
        {
            FloatingTextStringOnCreature("A Rage Mage must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Red Wizard marker feats
int RedWizardMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_RED_WIZARD))
    {
		int nRedWizard	= GetHasFeat(FEAT_REDWIZ_SPELLCASTING_WIZARD);
						
        if(nRedWizard > 1)
        {
            FloatingTextStringOnCreature("A Red Wizard may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nRedWizard < 1)
        {
            FloatingTextStringOnCreature("A Red Wizard must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Ruby Knight Vindicator marker feats
int RKVMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR))
    {
		int nRKV	= GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_ARCHIVIST)
					+ GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_BLACKGUARD)
					+ GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_BLIGHTER)
					+ GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_CLERIC)
					+ GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_FAVOURED_SOUL)
					+ GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_PALADIN)
					+ GetHasFeat(FEAT_RUBY_VINDICATOR_SPELLCASTING_OASHAMAN);
						
        if(nRKV > 1)
        {
            FloatingTextStringOnCreature("A Ruby Knight Vindicator may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nRKV < 1)
        {
            FloatingTextStringOnCreature("A Ruby Knight Vindicator must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Runecaster marker feats
int RunecasterMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_RUNECASTER))
    {
		int nRunecaster	= GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_ARCHIVIST)
						+ GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_BLACKGUARD)
						+ GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_BLIGHTER)
						+ GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_CLERIC)
						+ GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_DOMIEL)
						+ GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_DRUID)
						+ GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_FAVOURED_SOUL)
						+ GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_HEALER)
						+ GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_JUSTICEWW)
						+ GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_KNIGHT_CHALICE)
						+ GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_KNIGHT_MIDDLECIRCLE)
						+ GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_NENTYAR_HUNTER)
						+ GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_OCULAR)
						+ GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_PALADIN)
						+ GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_RANGER)
						+ GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_OASHAMAN)
						+ GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_SOHEI)
						+ GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_SOL)
						+ GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_SPSHAMAN)
						+ GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_UR_PRIEST)
						+ GetHasFeat(FEAT_RUNECASTER_SPELLCASTING_VASSAL);
						
        if(nRunecaster > 1)
        {
            FloatingTextStringOnCreature("A Runecaster may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nRunecaster < 1)
        {
            FloatingTextStringOnCreature("A Runecaster must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Sacred Fist marker feats
int SacredFistMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_SACREDFIST))
    {
		int nSacredFist	= GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_ARCHIVIST)
						+ GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_BLACKGUARD)
						+ GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_BLIGHTER)
						+ GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_CLERIC)
						+ GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_DOMIEL)
						+ GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_DRUID)
						+ GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_FAVOURED_SOUL)
						+ GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_HEALER)
						+ GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_JUSTICEWW)
						+ GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_KNIGHT_CHALICE)
						+ GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_KNIGHT_MIDDLECIRCLE)
						+ GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_NENTYAR_HUNTER)
						+ GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_OCULAR)
						+ GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_PALADIN)
						+ GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_RANGER)
						+ GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_OASHAMAN)
						+ GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_SOHEI)
						+ GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_SOL)
						+ GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_SPSHAMAN)
						+ GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_UR_PRIEST)
						+ GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_VASSAL);
						
        if(nSacredFist > 1)
        {
            FloatingTextStringOnCreature("A Sacred Fist may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nSacredFist < 1)
        {
            FloatingTextStringOnCreature("A Sacred Fist must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Sacred Purifier marker feats
int SacredPurifierMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_SACREDPURIFIER))
    {
		int nSacredPurifier	= GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_ARCHIVIST)
							+ GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_CLERIC)
							+ GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_DOMIEL)
							+ GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_DRUID)
							+ GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_FAVOURED_SOUL)
							+ GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_HEALER)
							+ GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_JUSTICEWW)
							+ GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_KNIGHT_CHALICE)
							+ GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_KNIGHT_MIDDLECIRCLE)
							+ GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_NENTYAR_HUNTER)
							+ GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_PALADIN)
							+ GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_RANGER)
							+ GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_OASHAMAN)
							+ GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_SOHEI)
							+ GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_SOL)
							+ GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_SPSHAMAN)
							+ GetHasFeat(FEAT_SACREDPURIFIER_SPELLCASTING_VASSAL);
						
        if(nSacredPurifier > 1)
        {
            FloatingTextStringOnCreature("A Sacred Purifier may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nSacredPurifier < 1)
        {
            FloatingTextStringOnCreature("A Sacred Purifier must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:: Enforces Sancified Mind marker feats
int SanctifiedMindMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_SANCTIFIED_MIND))
    {
		int nSanctMind	= GetHasFeat(FEAT_SANCTIFIED_MIND_MANIFEST_FOZ)
						+ GetHasFeat(FEAT_SANCTIFIED_MIND_MANIFEST_PSION)
						+ GetHasFeat(FEAT_SANCTIFIED_MIND_MANIFEST_PSYROUGE)
						+ GetHasFeat(FEAT_SANCTIFIED_MIND_MANIFEST_PSYWAR)
						+ GetHasFeat(FEAT_SANCTIFIED_MIND_MANIFEST_WARMIND)
						+ GetHasFeat(FEAT_SANCTIFIED_MIND_MANIFEST_WILDER)
						+ GetHasFeat(FEAT_SANCTIFIED_MIND_MANIFEST_NONE);

        if(nSanctMind > 1)
        {
            FloatingTextStringOnCreature("A Sancified Mind may only advance a single psionic class or their highest divine spellcasting class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nSanctMind < 1)
        {
            FloatingTextStringOnCreature("A Sancified Mind must pick a psionic class or divine spellcasting to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;	
}

//:; Enforces Sapphire Hierarch marker feats
int SapphireHierarchMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH))
    {
		int nSapphireHierarch	= GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_ARCHIVIST)
								+ GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_BLACKGUARD)
								+ GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_BLIGHTER)
								+ GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_CLERIC)
								+ GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_DOMIEL)
								+ GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_DRUID)
								+ GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_FAVOURED_SOUL)
								+ GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_HEALER)
								+ GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_JUSTICEWW)
								+ GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_KNIGHT_CHALICE)
								+ GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_KNIGHT_MIDDLECIRCLE)
								+ GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_NENTYAR_HUNTER)
								+ GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_PALADIN)
								+ GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_RANGER)
								+ GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_OASHAMAN)
								+ GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_SOHEI)
								+ GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_SPSHAMAN)
								+ GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_UR_PRIEST)
								+ GetHasFeat(FEAT_SAPPHIRE_HIERARCH_SPELLCASTING_VASSAL);
						
        if(nSapphireHierarch > 1)
        {
            FloatingTextStringOnCreature("A Sapphire Hierarch may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nSapphireHierarch < 1)
        {
            FloatingTextStringOnCreature("A Sapphire Hierarch must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Shadow Adept marker feats
int ShadowAdeptMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT))
    {
		int nShadowAdept	= GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_FEY)
							+ GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_ABERRATION)
							+ GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_MONSTROUS)
							+ GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_OUTSIDER)
							+ GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_SHAPECHANGER)
							+ GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_ASSASSIN)
							+ GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_BARD)
							+ GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_BEGUILER)
							+ GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_CELEBRANT_SHARESS)
							+ GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_CULTIST_PEAK)
							+ GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_DNECRO)
							+ GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_DUSKBLADE)
							+ GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_HARPER)
							+ GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_HEXBLADE)
							+ GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_KNIGHT_WEAVE)
							+ GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_SHADOWLORD)
							+ GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_SORCERER)
							+ GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_SUBLIME_CHORD)
							+ GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_SUEL_ARCHANAMACH)
							+ GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_WARMAGE)
							+ GetHasFeat(FEAT_SHADOWADEPT_SPELLCASTING_WIZARD);
						
        if(nShadowAdept > 1)
        {
            FloatingTextStringOnCreature("A Shadow Adept may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nShadowAdept < 1)
        {
            FloatingTextStringOnCreature("A Shadow Adept must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Shadowbane Stalker marker feats
int SBStalkerMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER))
    {
		int nSBStalker	= GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_ARCHIVIST)
						+ GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_CLERIC)
						+ GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_DOMIEL)
						+ GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_FAVOURED_SOUL)
						+ GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_HEALER)
						+ GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_JUSTICEWW)
						+ GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_KNIGHT_CHALICE)
						+ GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_KNIGHT_MIDDLECIRCLE)
						+ GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_NENTYAR_HUNTER)
						+ GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_PALADIN)
						+ GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_RANGER)
						+ GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_OASHAMAN)
						+ GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_SPSHAMAN)
						+ GetHasFeat(FEAT_SHADOWBANE_STALKER_SPELLCASTING_VASSAL);
						
        if(nSBStalker > 1)
        {
            FloatingTextStringOnCreature("A Shadowbane Stalker may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nSBStalker < 1)
        {
            FloatingTextStringOnCreature("A Shadowbane Stalker must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:: Enforces Shadow Mind marker feats
int ShadowMindMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_SHADOWMIND))
    {
		int nShadowMind	= GetHasFeat(FEAT_SHADOWMIND_MANIFEST_FOZ)
						+ GetHasFeat(FEAT_SHADOWMIND_MANIFEST_PSION)
						+ GetHasFeat(FEAT_SHADOWMIND_MANIFEST_PSYROUGE)
						+ GetHasFeat(FEAT_SHADOWMIND_MANIFEST_PSYWAR)
						+ GetHasFeat(FEAT_SHADOWMIND_MANIFEST_WARMIND)
						+ GetHasFeat(FEAT_SHADOWMIND_MANIFEST_WILDER);

        if(nShadowMind > 1)
        {
            FloatingTextStringOnCreature("A Shadow Mind may only advance a single psionic class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nShadowMind < 1)
        {
            FloatingTextStringOnCreature("A Shadow Mind must pick a psionic class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;	
}

//:; Enforces Shining Blade of Heironeous marker feats
int HeironeousMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_SHINING_BLADE))
    {
		int nSBHeironeous	= GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_ARCHIVIST)
							+ GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_CLERIC)
							+ GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_DOMIEL)
							+ GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_FAVOURED_SOUL)
							+ GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_HEALER)
							+ GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_JUSTICEWW)
							+ GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_KNIGHT_CHALICE)
							+ GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_KNIGHT_MIDDLECIRCLE)
							+ GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_NENTYAR_HUNTER)
							+ GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_PALADIN)
							+ GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_RANGER)
							+ GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_OASHAMAN)
							+ GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_SOHEI)
							+ GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_SPSHAMAN)
							+ GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_VASSAL);
						
        if(nSBHeironeous > 1)
        {
            FloatingTextStringOnCreature("A Shining Blade of Heironeous may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nSBHeironeous < 1)
        {
            FloatingTextStringOnCreature("A Shining Blade of Heironeous must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:: Enforces Soulcaster marker feats
int SoulcasterMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_SOULCASTER))
    {
		int nSoulcaster	= GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_ASSASSIN)
						+ GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_CELEBRANT_SHARESS)
						+ GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_CULTIST_PEAK)
						+ GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_HARPER)
						+ GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_HEXBLADE)
						+ GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_KNIGHT_WEAVE)
						+ GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_SHADOWLORD)
						+ GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_SOULCASTER_SPELLCASTING_WIZARD)
						+ GetHasFeat(FEAT_SOULCASTER_MANIFEST_FOZ)
						+ GetHasFeat(FEAT_SOULCASTER_MANIFEST_PSION)
						+ GetHasFeat(FEAT_SOULCASTER_MANIFEST_PSYROUGE)
						+ GetHasFeat(FEAT_SOULCASTER_MANIFEST_PSYWAR)
						+ GetHasFeat(FEAT_SOULCASTER_MANIFEST_WARMIND)
						+ GetHasFeat(FEAT_SOULCASTER_MANIFEST_WILDER)
						+ GetHasFeat(FEAT_SOULCASTER_MANIFEST_NONE);

        if(nSoulcaster > 1)
        {
            FloatingTextStringOnCreature("A Soulcaster may only advance a single psionic or arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nSoulcaster < 1)
        {
            FloatingTextStringOnCreature("A Soulcaster must pick a single psionic or arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;	
}

//:; Enforces Spelldancer marker feats
int SpelldancerMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_SPELLDANCER))
    {
		int nSpelldancer	= GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_FEY)
							+ GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_ABERRATION)
							+ GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_MONSTROUS)
							+ GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_OUTSIDER)
							+ GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_SHAPECHANGER)
							+ GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_ASSASSIN)
							+ GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_BARD)
							+ GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_BEGUILER)
							+ GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_CELEBRANT_SHARESS)
							+ GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_CULTIST_PEAK)
							+ GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_DNECRO)
							+ GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_DUSKBLADE)
							+ GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_HARPER)
							+ GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_HEXBLADE)
							+ GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_KNIGHT_WEAVE)
							+ GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_SHADOWLORD)
							+ GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_SORCERER)
							+ GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_SUBLIME_CHORD)
							+ GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_SUEL_ARCHANAMACH)
							+ GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_WARMAGE)
							+ GetHasFeat(FEAT_SPELLDANCER_SPELLCASTING_WIZARD);
						
        if(nSpelldancer > 1)
        {
            FloatingTextStringOnCreature("A Spelldancer may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nSpelldancer < 1)
        {
            FloatingTextStringOnCreature("A Spelldancer must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Spellsword marker feats
int SpellswordMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_SPELLSWORD))
    {
		int nSpellsword	= GetHasFeat(FEAT_SSWORD_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_SSWORD_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_SSWORD_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_SSWORD_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_SSWORD_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_SSWORD_SPELLCASTING_ASSASSIN)
						+ GetHasFeat(FEAT_SSWORD_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_SSWORD_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_SSWORD_SPELLCASTING_CULTIST_PEAK)
						+ GetHasFeat(FEAT_SSWORD_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_SSWORD_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_SSWORD_SPELLCASTING_HARPER)
						+ GetHasFeat(FEAT_SSWORD_SPELLCASTING_HEXBLADE)
						+ GetHasFeat(FEAT_SSWORD_SPELLCASTING_KNIGHT_WEAVE)
						+ GetHasFeat(FEAT_SSWORD_SPELLCASTING_SHADOWLORD)
						+ GetHasFeat(FEAT_SSWORD_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_SSWORD_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_SSWORD_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_SSWORD_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_SSWORD_SPELLCASTING_WIZARD)
						+ GetHasFeat(FEAT_SSWORD_SPELLCASTING_CELEBRANT_SHARESS);
						
        if(nSpellsword > 1)
        {
            FloatingTextStringOnCreature("A Spellsword may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nSpellsword < 1)
        {
            FloatingTextStringOnCreature("A Spellsword must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Stormlord of Talos marker feats
int StormlordMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_STORMLORD))
    {
		int nStormlord	= GetHasFeat(FEAT_STORMLORD_SPELLCASTING_ARCHIVIST)
						+ GetHasFeat(FEAT_STORMLORD_SPELLCASTING_BLACKGUARD)
						+ GetHasFeat(FEAT_STORMLORD_SPELLCASTING_BLIGHTER)
						+ GetHasFeat(FEAT_STORMLORD_SPELLCASTING_CLERIC)
						+ GetHasFeat(FEAT_STORMLORD_SPELLCASTING_DRUID)
						+ GetHasFeat(FEAT_STORMLORD_SPELLCASTING_FAVOURED_SOUL)
						+ GetHasFeat(FEAT_STORMLORD_SPELLCASTING_JUSTICEWW)
						+ GetHasFeat(FEAT_STORMLORD_SPELLCASTING_RANGER)
						+ GetHasFeat(FEAT_STORMLORD_SPELLCASTING_OASHAMAN)
						+ GetHasFeat(FEAT_STORMLORD_SPELLCASTING_SPSHAMAN);
						
        if(nStormlord > 1)
        {
            FloatingTextStringOnCreature("A Stormlord of Talos may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nStormlord < 1)
        {
            FloatingTextStringOnCreature("A Stormlord of Talos must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Sublime Chord marker feats
int SublimeChordMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_SUBLIME_CHORD))
    {
		int nSublimeChord	= GetHasFeat(FEAT_SUBLIME_CHORD_SPELLCASTING_FEY)
							+ GetHasFeat(FEAT_SUBLIME_CHORD_SPELLCASTING_ABERRATION)
							+ GetHasFeat(FEAT_SUBLIME_CHORD_SPELLCASTING_MONSTROUS)
							+ GetHasFeat(FEAT_SUBLIME_CHORD_SPELLCASTING_OUTSIDER)
							+ GetHasFeat(FEAT_SUBLIME_CHORD_SPELLCASTING_SHAPECHANGER)
							+ GetHasFeat(FEAT_SUBLIME_CHORD_SPELLCASTING_BARD)
							+ GetHasFeat(FEAT_SUBLIME_CHORD_SPELLCASTING_BEGUILER)
							+ GetHasFeat(FEAT_SUBLIME_CHORD_SPELLCASTING_DUSKBLADE)
							+ GetHasFeat(FEAT_SUBLIME_CHORD_SPELLCASTING_SORCERER)
							+ GetHasFeat(FEAT_SUBLIME_CHORD_SPELLCASTING_WARMAGE)
							+ GetHasFeat(FEAT_SUBLIME_CHORD_SPELLCASTING_WIZARD);
						
        if(nSublimeChord > 1)
        {
            FloatingTextStringOnCreature("A Sublime Chord may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nSublimeChord < 1)
        {
            FloatingTextStringOnCreature("A Sublime Chord must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Swift Wing marker feats
int SwiftWingMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_SWIFT_WING))
    {
		int nSwiftWing	= GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_ARCHIVIST)
						+ GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_BLACKGUARD)
						+ GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_BLIGHTER)
						+ GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_CLERIC)
						+ GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_DOMIEL)
						+ GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_DRUID)
						+ GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_FAVOURED_SOUL)
						+ GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_HEALER)
						+ GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_JUSTICEWW)
						+ GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_KNIGHT_CHALICE)
						+ GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_KNIGHT_MIDDLECIRCLE)
						+ GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_NENTYAR_HUNTER)
						+ GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_PALADIN)
						+ GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_RANGER)
						+ GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_OASHAMAN)
						+ GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_SOHEI)
						+ GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_SOL)
						+ GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_SPSHAMAN)
						+ GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_UR_PRIEST)
						+ GetHasFeat(FEAT_SWIFT_WING_SPELLCASTING_VASSAL);
						
        if(nSwiftWing > 1)
        {
            FloatingTextStringOnCreature("A Swift Wing may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nSwiftWing < 1)
        {
            FloatingTextStringOnCreature("A Swift Wing must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Battleguard of Tempus marker feats
int BGTMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_TEMPUS))
    {
		int nBGT	= GetHasFeat(FEAT_TEMPUS_SPELLCASTING_ARCHIVIST)
					+ GetHasFeat(FEAT_TEMPUS_SPELLCASTING_BLACKGUARD)
					+ GetHasFeat(FEAT_TEMPUS_SPELLCASTING_CLERIC)
					+ GetHasFeat(FEAT_TEMPUS_SPELLCASTING_FAVOURED_SOUL)
					+ GetHasFeat(FEAT_TEMPUS_SPELLCASTING_JUSTICEWW)
					+ GetHasFeat(FEAT_TEMPUS_SPELLCASTING_RANGER)
					+ GetHasFeat(FEAT_TEMPUS_SPELLCASTING_OASHAMAN)
					+ GetHasFeat(FEAT_TEMPUS_SPELLCASTING_SPSHAMAN);
						
        if(nBGT > 1)
        {
            FloatingTextStringOnCreature("A Battleguard of Tempus may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nBGT < 1)
        {
            FloatingTextStringOnCreature("A Battleguard of Tempus must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Tenebrous Apostate marker feats
int TenebrousMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE))
    {
		int nTenebrous 	= GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_ARCHIVIST)
						+ GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_BLACKGUARD)
						+ GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_BLIGHTER)
						+ GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_CLERIC)
						+ GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_FAVOURED_SOUL)
						+ GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_JUSTICEWW)
						+ GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_RANGER)
						+ GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_OASHAMAN)
						+ GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_SOHEI)
						+ GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_SPSHAMAN)
						+ GetHasFeat(FEAT_TENEBROUS_APOSTATE_SPELLCASTING_UR_PRIEST);
						
        if(nTenebrous > 1)
        {
            FloatingTextStringOnCreature("A Tenebrous Apostate may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nTenebrous < 1)
        {
            FloatingTextStringOnCreature("A Tenebrous Apostate must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:: Enforces Thrallherd marker feats
int ThrallherdMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_THRALLHERD))
    {
		int nThrall	= GetHasFeat(FEAT_THRALLHERD_MANIFEST_PSION);

        if(nThrall > 1)
        {
            FloatingTextStringOnCreature("A Thrallherd may only advance a single psionic class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nThrall < 1)
        {
            FloatingTextStringOnCreature("A Thrallherd must pick a psionic class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;	
}
//:; Enforces Talon of Tiamat marker feats
int TiamatMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT))
    {
		int nTiamat	= GetHasFeat(FEAT_TIAMAT_SPELLCASTING_FEY)
					+ GetHasFeat(FEAT_TIAMAT_SPELLCASTING_ABERRATION)
					+ GetHasFeat(FEAT_TIAMAT_SPELLCASTING_MONSTROUS)
					+ GetHasFeat(FEAT_TIAMAT_SPELLCASTING_OUTSIDER)
					+ GetHasFeat(FEAT_TIAMAT_SPELLCASTING_SHAPECHANGER)
					+ GetHasFeat(FEAT_TIAMAT_SPELLCASTING_ASSASSIN)
					+ GetHasFeat(FEAT_TIAMAT_SPELLCASTING_BARD)
					+ GetHasFeat(FEAT_TIAMAT_SPELLCASTING_BEGUILER)
					+ GetHasFeat(FEAT_TIAMAT_SPELLCASTING_CULTIST_PEAK)
					+ GetHasFeat(FEAT_TIAMAT_SPELLCASTING_DNECRO)
					+ GetHasFeat(FEAT_TIAMAT_SPELLCASTING_DUSKBLADE)
					+ GetHasFeat(FEAT_TIAMAT_SPELLCASTING_HEXBLADE)
					+ GetHasFeat(FEAT_TIAMAT_SPELLCASTING_SHADOWLORD)
					+ GetHasFeat(FEAT_TIAMAT_SPELLCASTING_SORCERER)
					+ GetHasFeat(FEAT_TIAMAT_SPELLCASTING_SUBLIME_CHORD)
					+ GetHasFeat(FEAT_TIAMAT_SPELLCASTING_SUEL_ARCHANAMACH)
					+ GetHasFeat(FEAT_TIAMAT_SPELLCASTING_WARMAGE)
					+ GetHasFeat(FEAT_TIAMAT_SPELLCASTING_WIZARD)
					+ GetHasFeat(FEAT_TIAMAT_SPELLCASTING_NONE)					
					+ GetHasFeat(FEAT_TIAMAT_INVOKING_WARLOCK)
					+ GetHasFeat(FEAT_TIAMAT_INVOKING_DFA)
					+ GetHasFeat(FEAT_TIAMAT_INVOKING_DRAGON_SHAMAN)
					+ GetHasFeat(FEAT_TIAMAT_MYSTERY_SHADOWCASTER)
					+ GetHasFeat(FEAT_TIAMAT_MYSTERY_SHADOWSMITH);					;
						
        if(nTiamat > 1)
        {
            FloatingTextStringOnCreature("A Talon of Tiamat may only advance a single arcane, shadowcasting or invoker class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nTiamat < 1)
        {
            FloatingTextStringOnCreature("A Talon of Tiamat must pick one arcane, shadowcasting or invoker class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces True Necromancer marker feats
int TrueNecroMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_TRUENECRO))
    {
		int nTrueNecroArc	= GetHasFeat(FEAT_TNECRO_SPELLCASTING_ABERRATION)
							+ GetHasFeat(FEAT_TNECRO_SPELLCASTING_MONSTROUS)
							+ GetHasFeat(FEAT_TNECRO_SPELLCASTING_OUTSIDER)
							+ GetHasFeat(FEAT_TNECRO_SPELLCASTING_SHAPECHANGER)
							+ GetHasFeat(FEAT_TNECRO_SPELLCASTING_DNECRO)
							+ GetHasFeat(FEAT_TNECRO_SPELLCASTING_SORCERER)
							+ GetHasFeat(FEAT_TNECRO_SPELLCASTING_WIZARD)
							+ GetHasFeat(FEAT_TNECRO_SPELLCASTING_SUBLIME_CHORD);
							
/* 		int nTrueNecroDiv	= GetHasFeat(FEAT_TNECRO_SPELLCASTING_ARCHIVIST)
							+ GetHasFeat(FEAT_TNECRO_SPELLCASTING_BLIGHTER)
							+ GetHasFeat(FEAT_TNECRO_SPELLCASTING_CLERIC)
							+ GetHasFeat(FEAT_TNECRO_SPELLCASTING_FAVOURED_SOUL)
							+ GetHasFeat(FEAT_TNECRO_SPELLCASTING_OCULAR)
							+ GetHasFeat(FEAT_TNECRO_SPELLCASTING_OASHAMAN)
							+ GetHasFeat(FEAT_TNECRO_SPELLCASTING_UR_PRIEST); */							
						
        if(nTrueNecroArc > 1)
        {
            FloatingTextStringOnCreature("A True Necromancer may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nTrueNecroArc < 1)
        {
            FloatingTextStringOnCreature("A True Necromancer must pick one arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
/*         if(nTrueNecroDiv > 1)
        {
            FloatingTextStringOnCreature("A True Necromancer may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nTrueNecroDiv < 1)
        {
            FloatingTextStringOnCreature("A True Necromancer must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }	 */	
    }
	
    return FALSE;
}	

//:; Enforces Ultmate Magus marker feats
int UltMagusMarkerFeats()
{
    if(GetLevelByClass(188))  //:: Ultimate Magus
    {
		int nUltMagus	= GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_ASSASSIN)
						+ GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_CELEBRANT_SHARESS)
						+ GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_CULTIST_PEAK)
						+ GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_HARPER)
						+ GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_HEXBLADE)
						+ GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_KNIGHT_WEAVE)
						+ GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_SHADOWLORD)
						+ GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_ULTMAGUS_SPELLCASTING_WARMAGE);
						
        if(nUltMagus > 1)
        {
            FloatingTextStringOnCreature("An Ultmate Magus may only advance a single spontaneous arcane class alongside their Wizard progression.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nUltMagus < 1)
        {
            FloatingTextStringOnCreature("An Ultmate Magus must pick one spontaneous arcane class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Unseen Seer marker feats
int UnseenMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_UNSEEN_SEER))
    {
		int nUnseen	= GetHasFeat(FEAT_UNSEEN_SPELLCASTING_FEY)
					+ GetHasFeat(FEAT_UNSEEN_SPELLCASTING_ABERRATION)
					+ GetHasFeat(FEAT_UNSEEN_SPELLCASTING_MONSTROUS)
					+ GetHasFeat(FEAT_UNSEEN_SPELLCASTING_OUTSIDER)
					+ GetHasFeat(FEAT_UNSEEN_SPELLCASTING_SHAPECHANGER)
					+ GetHasFeat(FEAT_UNSEEN_SPELLCASTING_ASSASSIN)
					+ GetHasFeat(FEAT_UNSEEN_SPELLCASTING_BARD)
					+ GetHasFeat(FEAT_UNSEEN_SPELLCASTING_BEGUILER)
					+ GetHasFeat(FEAT_UNSEEN_SPELLCASTING_CELEBRANT_SHARESS)
					+ GetHasFeat(FEAT_UNSEEN_SPELLCASTING_CULTIST_PEAK)
					+ GetHasFeat(FEAT_UNSEEN_SPELLCASTING_DNECRO)
					+ GetHasFeat(FEAT_UNSEEN_SPELLCASTING_DUSKBLADE)
					+ GetHasFeat(FEAT_UNSEEN_SPELLCASTING_HARPER)
					+ GetHasFeat(FEAT_UNSEEN_SPELLCASTING_HEXBLADE)
					+ GetHasFeat(FEAT_UNSEEN_SPELLCASTING_KNIGHT_WEAVE)
					+ GetHasFeat(FEAT_UNSEEN_SPELLCASTING_SHADOWLORD)
					+ GetHasFeat(FEAT_UNSEEN_SPELLCASTING_SORCERER)
					+ GetHasFeat(FEAT_UNSEEN_SPELLCASTING_SUBLIME_CHORD)
					+ GetHasFeat(FEAT_UNSEEN_SPELLCASTING_SUEL_ARCHANAMACH)
					+ GetHasFeat(FEAT_UNSEEN_SPELLCASTING_WARMAGE)
					+ GetHasFeat(FEAT_UNSEEN_SPELLCASTING_WIZARD)
					+ GetHasFeat(FEAT_UNSEEN_INVOKING_WARLOCK)
					+ GetHasFeat(FEAT_UNSEEN_INVOKING_DFA)
					+ GetHasFeat(FEAT_UNSEEN_INVOKING_DRAGON_SHAMAN);
						
        if(nUnseen > 1)
        {
            FloatingTextStringOnCreature("An Unseen Seer may only advance a single arcane or invoker class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nUnseen < 1)
        {
            FloatingTextStringOnCreature("An Unseen Seer must pick one arcane or invoker class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Virtuoso marker feats
int VirtuosoMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_VIRTUOSO))
    {
		int nVirtuoso	= GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_VIRTUOSO_SPELLCASTING_WIZARD)
						+ GetHasFeat(FEAT_VIRTUOSO_INVOKING_WARLOCK)
						+ GetHasFeat(FEAT_VIRTUOSO_INVOKING_DFA)
						+ GetHasFeat(FEAT_VIRTUOSO_INVOKING_DRAGON_SHAMAN);
						
        if(nVirtuoso > 1)
        {
            FloatingTextStringOnCreature("A Virtuoso may only advance a single arcane or invoker class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nVirtuoso < 1)
        {
            FloatingTextStringOnCreature("A Virtuoso must pick one arcane or invoker class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Warpriest marker feats
int WarpriestMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_WARPRIEST))
    {
		int nWarpriest	= GetHasFeat(FEAT_TEMPUS_SPELLCASTING_ARCHIVIST)
						+ GetHasFeat(FEAT_TEMPUS_SPELLCASTING_BLACKGUARD)
						+ GetHasFeat(FEAT_TEMPUS_SPELLCASTING_CLERIC)
						+ GetHasFeat(FEAT_TEMPUS_SPELLCASTING_FAVOURED_SOUL)
						+ GetHasFeat(FEAT_TEMPUS_SPELLCASTING_JUSTICEWW)
						+ GetHasFeat(FEAT_TEMPUS_SPELLCASTING_RANGER)
						+ GetHasFeat(FEAT_TEMPUS_SPELLCASTING_OASHAMAN)
						+ GetHasFeat(FEAT_TEMPUS_SPELLCASTING_SPSHAMAN);
						
        if(nWarpriest > 1)
        {
            FloatingTextStringOnCreature("A Warpriest may only advance a single divine class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nWarpriest < 1)
        {
            FloatingTextStringOnCreature("A Warpriest must pick one divine class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Wayfarer Guide marker feats
int WayfarerMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_WAYFARER_GUIDE))
    {
		int nWayfarer	= GetHasFeat(FEAT_WAYFARER_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_WAYFARER_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_WAYFARER_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_WAYFARER_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_WAYFARER_SPELLCASTING_KNIGHT_WEAVE)
						+ GetHasFeat(FEAT_WAYFARER_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_WAYFARER_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_WAYFARER_SPELLCASTING_WIZARD);
						
        if(nWayfarer > 1)
        {
            FloatingTextStringOnCreature("A Wayfarer Guide may only advance a single class with teleport on its spell list.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nWayfarer < 1)
        {
            FloatingTextStringOnCreature("A Wayfarer Guide must pick one class with teleport in its list to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces Wild Mage marker feats
int WildMageMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_WILD_MAGE))
    {
		int nWildMage	= GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_FEY)
						+ GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_ABERRATION)
						+ GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_MONSTROUS)
						+ GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_OUTSIDER)
						+ GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_SHAPECHANGER)
						+ GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_ASSASSIN)
						+ GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_BARD)
						+ GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_BEGUILER)
						+ GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_CELEBRANT_SHARESS)
						+ GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_CULTIST_PEAK)
						+ GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_DNECRO)
						+ GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_DUSKBLADE)
						+ GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_HARPER)
						+ GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_HEXBLADE)
						+ GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_KNIGHT_WEAVE)
						+ GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_SHADOWLORD)
						+ GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_SORCERER)
						+ GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_SUBLIME_CHORD)
						+ GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_SUEL_ARCHANAMACH)
						+ GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_WARMAGE)
						+ GetHasFeat(FEAT_WILDMAGE_SPELLCASTING_WIZARD)
						+ GetHasFeat(FEAT_WILDMAGE_INVOKING_WARLOCK)
						+ GetHasFeat(FEAT_WILDMAGE_INVOKING_DFA)
						+ GetHasFeat(FEAT_WILDMAGE_INVOKING_DRAGON_SHAMAN);
						
        if(nWildMage > 1)
        {
            FloatingTextStringOnCreature("A Wild Mage may only advance a single arcane or invoker class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nWildMage < 1)
        {
            FloatingTextStringOnCreature("A Wild Mage must pick one arcane or invoker class at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	

//:; Enforces War Wizard of Cormyr marker feats
int WWoCMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR))
    {
		int nWWoC	= GetHasFeat(FEAT_WWOC_SPELLCASTING_FEY)
					+ GetHasFeat(FEAT_WWOC_SPELLCASTING_ABERRATION)
					+ GetHasFeat(FEAT_WWOC_SPELLCASTING_MONSTROUS)
					+ GetHasFeat(FEAT_WWOC_SPELLCASTING_OUTSIDER)
					+ GetHasFeat(FEAT_WWOC_SPELLCASTING_SHAPECHANGER)
					+ GetHasFeat(FEAT_WWOC_SPELLCASTING_BARD)
					+ GetHasFeat(FEAT_WWOC_SPELLCASTING_BEGUILER)
					+ GetHasFeat(FEAT_WWOC_SPELLCASTING_CELEBRANT_SHARESS)
					+ GetHasFeat(FEAT_WWOC_SPELLCASTING_CULTIST_PEAK)
					+ GetHasFeat(FEAT_WWOC_SPELLCASTING_DNECRO)
					+ GetHasFeat(FEAT_WWOC_SPELLCASTING_DUSKBLADE)
					+ GetHasFeat(FEAT_WWOC_SPELLCASTING_HEXBLADE)
					+ GetHasFeat(FEAT_WWOC_SPELLCASTING_KNIGHT_WEAVE)
					+ GetHasFeat(FEAT_WWOC_SPELLCASTING_SHADOWLORD)
					+ GetHasFeat(FEAT_WWOC_SPELLCASTING_SORCERER)
					+ GetHasFeat(FEAT_WWOC_SPELLCASTING_SUBLIME_CHORD)
					+ GetHasFeat(FEAT_WWOC_SPELLCASTING_SUEL_ARCHANAMACH)
					+ GetHasFeat(FEAT_WWOC_SPELLCASTING_WARMAGE)
					+ GetHasFeat(FEAT_WWOC_SPELLCASTING_WIZARD);
						
        if(nWWoC > 1)
        {
            FloatingTextStringOnCreature("A War Wizard of Cormyr may only advance a single arcane class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nWWoC < 1)
        {
            FloatingTextStringOnCreature("A War Wizard of Cormyr must pick one arcane class at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	


void main()
{
//:: If any of these conditions are true, relevel the character.	
    if(AbjurantChampionMarkerFeats()
    || AoTSMarkerFeats()
	|| AlchemistMarkerFeats()
    || AlienistMarkerFeats()
	|| AnimaMageMarkerFeats()
    || ArchmageMarkerFeats()
	|| ArcaneTricksterMarkerFeats()
	|| DoAMarkerFeats()
	|| BFZMarkerFeats()
	|| BloodMagusMarkerFeats()
	|| BlightlordMarkerFeats()
	|| BondedSummonerMarkerFeats()
	|| BrimstoneSpeakerMarkerFeats()
	|| BladesingerMarkerFeats()
	|| CerebremancerMarkerFeats()
	|| CoNMarkerFeats()
	|| DiamondDragonMarkerFeats()
	|| CombatMedicMarkerFeats()
	|| ContemplativeMarkerFeats()
	|| DragonheartMarkerFeats()
	|| DiabolistMarkerFeats()
	|| DragonsongLyristMarkerFeats()
	|| EldritchKnightMarkerFeats()
	|| EldritchDiscipleMarkerFeats()
	|| EldritchTheurgeMarkerFeats()
	|| ElementalSavantMarkerFeats()
	|| EnlightendFistMarkerFeats()
	|| FistOfRazielMarkerFeats()
	|| FMMMarkerFeats()
	|| FochlucanLyristMarkerFeats()
	|| ForestMasterMarkerFeats()
	|| FrostMageMarkerFeats()
	|| ToGMarkerFeats()
	|| HarperMageMarkerFeats()
	|| HathranMarkerFeats()
	|| HavocMageMarkerFeats()
	|| HeartwarderMarkerFeats()
	|| HierophantMarkerFeats()
	|| HospitalerMarkerFeats()
	|| IronMindMarkerFeats()
	|| JPMMarkerFeats()
	|| JudicatorMarkerFeats()
	|| MCoKMarkerFeats()
	|| MaesterMarkerFeats()
	|| MagekillerMarkerFeats()
	|| MasterShadowMarkerFeats()
	|| MoSMarkerFeats()
	|| MasterHarperMarkerFeats()
	|| MorninglordMarkerFeats()
	|| MysticTheurgeMarkerFeats()
	|| NoctumancerMarkerFeats()
	|| OllamMarkerFeats()
	|| OozemasterMarkerFeats()
	|| OrcusMarkerFeats()
	|| PaleMasterMarkerFeats()
	|| PsychicTheurgeMarkerFeats()
	|| RageMageMarkerFeats()
	// || RedWizardMarkerFeats()
	|| RKVMarkerFeats()
	|| RunecasterMarkerFeats()
	|| SacredFistMarkerFeats()
	|| SacredPurifierMarkerFeats()
	|| SanctifiedMindMarkerFeats()
	|| ShadowMindMarkerFeats()
	|| SapphireHierarchMarkerFeats()
	|| ShadowAdeptMarkerFeats()
	|| SBStalkerMarkerFeats()
	|| HeironeousMarkerFeats()
	|| SoulcasterMarkerFeats()
	|| SpelldancerMarkerFeats()
	|| SpellswordMarkerFeats()
	|| StormlordMarkerFeats()
	|| SublimeChordMarkerFeats()
	|| SwiftWingMarkerFeats()
	|| BGTMarkerFeats()
	|| TenebrousMarkerFeats()
	|| ThrallherdMarkerFeats()
	|| TiamatMarkerFeats()
	|| TrueNecroMarkerFeats()
	|| UltMagusMarkerFeats()
	|| UnseenMarkerFeats()
	|| VirtuosoMarkerFeats()
	|| WarpriestMarkerFeats()
	|| WayfarerMarkerFeats()
	|| WildMageMarkerFeats()
	|| WWoCMarkerFeats())
    {
       int nHD = GetHitDice(OBJECT_SELF);
       int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
       int nOldXP = GetXP(OBJECT_SELF);
       int nNewXP = nMinXPForLevel - 1000;
       SetXP(OBJECT_SELF, nNewXP);
       DelayCommand(0.2, SetXP(OBJECT_SELF, nOldXP));
       SetLocalInt(OBJECT_SELF, "RelevelXP", nOldXP);
    }
}