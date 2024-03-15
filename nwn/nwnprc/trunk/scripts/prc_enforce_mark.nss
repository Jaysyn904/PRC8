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

//:; Enforces Alienist marker feats
int AlienistMarkerFeats();

//:; Enforces Anima Mage marker feats
int AnimaMageMarkerFeats();

//:; Enforces Arcane Trickster marker feats
int ArcaneTricksterMarkerFeats();

//:; Enforces Disciple of Asmodeus marker feats
int DoAMarkerFeats();

//:; Enforces Blood Magus marker feats
int BloodMagusMarkerFeats();

//:: Enforces Cerebrmancer marker feats
int CerebremancerMarkerFeats();

//:: Enforces Diamond Dragon marker feats
int DiamondDragonMarkerFeats();

//:; Enforces Dragonsong Lyrist marker feats
int DragonsongLyristMarkerFeats();

//:; Enforces Eldritch Disciple marker feats
int EldritchDiscipleMarkerFeats();

//:; Enforces Elemental Savant marker feats
int ElementalSavantMarkerFeats();

//:; Enforces Enlightend Fist marker feats
int EnlightendFistMarkerFeats();

//:; Enforces Iron Mind marker feats
int IronMindMarkerFeats();

//:; Enforces Maester marker feats
int MaesterMarkerFeats();

//:: Enforces Master of Shadows marker feats
int MasterShadowMarkerFeats();

//:; Enforces Mystic Theurge marker feats
int MysticTheurgeMarkerFeats();

//:; Enforces Noctumancer marker feats
int NoctumancerMarkerFeats();

//:; Enforces Ollam marker feats
int OllamMarkerFeats();

/* //:; Enforces Oozemaster marker feats
int OozemasterMarkerFeats(); */

//:; Enforces Thrall of Orcus marker feats
int OrcusMarkerFeats();

//:; Enforces Psychic Theurge marker feats
int PsychicTheurgeMarkerFeats();

//:: Enforces Sancified Mind marker feats
int SanctifiedMindMarkerFeats();

//:: Enforces Shadow Mind marker feats
int ShadowMindMarkerFeats();

//:: Enforces Soulcaster marker feats
int SoulcasterMarkerFeats();

//:: Enforces Thrallherd marker feats
int ThrallherdMarkerFeats();

//:; Enforces Talon of Tiamat marker feats
int TiamatMarkerFeats();

//:; Enforces Unseen Seer marker feats
int UnseenMarkerFeats();

//:; Enforces Wild Mage marker feats
int WildMageMarkerFeats();

/*///////////////////////////////////////
	Begin Functions
*////////////////////////////////////////
	
//:; Enforces Abjurant Champion marker feats
int AbjurantChampionMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_ABJURANT_CHAMPION))
    {
		int nAbChamp;
		
		nAbChamp 	=+ GetHasFeat(FEAT_ABCHAMP_INVOKING_WARLOCK);
		nAbChamp	=+ GetHasFeat(FEAT_ABCHAMP_INVOKING_DFA);
		nAbChamp	=+ GetHasFeat(FEAT_ABCHAMP_INVOKING_DRAGON_SHAMAN);
		nAbChamp	=+ GetHasFeat(FEAT_ABCHAMP_NONE);
						
		//FloatingTextStringOnCreature("nAbChamp = " + IntToString(nAbChamp), OBJECT_SELF, FALSE);

        if(nAbChamp > 1)
        {
            FloatingTextStringOnCreature("An Abjurant Champion may only advance a single invoker class, or N/A for arcane spellcasting.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nAbChamp < 1)
        {
            FloatingTextStringOnCreature("A Abjurant Champion must pick an invoker class to advance at first level, or pick N/A for an arcane spellcaster.", OBJECT_SELF, FALSE);
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
		int nAcolyte 	= GetHasFeat(FEAT_AOTS_INVOKING_WARLOCK)
						+ GetHasFeat(FEAT_AOTS_INVOKING_DFA)
						+ GetHasFeat(FEAT_AOTS_MYSTERY_SHADOWCASTER)
						+ GetHasFeat(FEAT_AOTS_MYSTERY_SHADOWSMITH)
						+ GetHasFeat(FEAT_AOTS_NONE);

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

//:; Enforces Alienist marker feats
int AlienistMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_ALIENIST))
    {
		int nAlienist 	= GetHasFeat(FEAT_ALIENIST_MYSTERY_SHADOWCASTER)
						+ GetHasFeat(FEAT_ALIENIST_MYSTERY_SHADOWSMITH)
						+ GetHasFeat(FEAT_ALIENIST_NONE);

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
		int nAnima 	= GetHasFeat(FEAT_ANIMA_INVOKING_WARLOCK)
					+ GetHasFeat(FEAT_ANIMA_INVOKING_DFA)
					+ GetHasFeat(FEAT_ANIMA_NONE);

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

//:; Enforces Arcane Trickster marker feats
int ArcaneTricksterMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_ARCTRICK))
    {
		int nTrickster 	= GetHasFeat(FEAT_ARCTRICK_INVOKING_WARLOCK)
						+ GetHasFeat(FEAT_ARCTRICK_INVOKING_DFA)
						+ GetHasFeat(FEAT_ARCTRICK_NONE);

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
		int nDoA	 	= GetHasFeat(FEAT_ASMODEUS_NONE)
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

//:; Enforces Blood Magus marker feats
int BloodMagusMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_BLOOD_MAGUS))
    {
		int nBlood	= GetHasFeat(FEAT_BLDMAGUS_INVOKING_WARLOCK)
					+ GetHasFeat(FEAT_BLDMAGUS_INVOKING_DFA)
					+ GetHasFeat(FEAT_BLDMAGUS_NONE);

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

//:; Enforces Cerebrmancer marker feats
int CerebremancerMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_CEREBREMANCER))
    {
		int nCereb	= GetHasFeat(FEAT_CEREBREMANCER_MANIFEST_FOZ)
					+ GetHasFeat(FEAT_CEREBREMANCER_MANIFEST_PSION)
					+ GetHasFeat(FEAT_CEREBREMANCER_MANIFEST_PSYROUGE)
					+ GetHasFeat(FEAT_CEREBREMANCER_MANIFEST_PSYWAR)
					+ GetHasFeat(FEAT_CEREBREMANCER_MANIFEST_WARMIND)
					+ GetHasFeat(FEAT_CEREBREMANCER_MANIFEST_WILDER);

        if(nCereb > 1)
        {
            FloatingTextStringOnCreature("A Cerebremancer may only advance a single psionic class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nCereb < 1)
        {
            FloatingTextStringOnCreature("A Cerebremancer must pick one psionic class to advance at first level.", OBJECT_SELF, FALSE);
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

//:; Enforces Dragonsong Lyrist marker feats
int DragonsongLyristMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST))
    {
		int nDragonsong	= GetHasFeat(FEAT_DRAGONSONG_NONE)						
						+ GetHasFeat(FEAT_DRAGONSONG_MYSTERY_SHADOWCASTER)
						+ GetHasFeat(FEAT_DRAGONSONG_MYSTERY_SHADOWSMITH);
						
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

//:; Enforces Eldritch Disciple marker feats
int EldritchDiscipleMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE))
    {
		int nEldDisciple	= GetHasFeat(FEAT_ELDISCIPLE_INVOKING_WARLOCK)
							+ GetHasFeat(FEAT_ELDISCIPLE_INVOKING_DFA);
						
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

//:; Enforces Elemental Savant marker feats
int ElementalSavantMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_ELEMENTAL_SAVANT))
    {
		int nElmSavant	= GetHasFeat(FEAT_ESAVANT_MYSTERY_SHADOWCASTER)
						+ GetHasFeat(FEAT_ESAVANT_MYSTERY_SHADOWSMITH)
						+ GetHasFeat(FEAT_ESAVANT_NONE);
						
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
		int nEnlightened	= GetHasFeat(FEAT_ENLIGHTENEDFIST_INVOKING_WARLOCK)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_INVOKING_DFA)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_INVOKING_DRAGON_SHAMAN)
							+ GetHasFeat(FEAT_ENLIGHTENEDFIST_NONE);
						
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

/* //:; Enforces Drow Judicator marker feats
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
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_OCULAR)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_RANGER)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_OASHAMAN)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_SOHEI)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_SPSHAMAN)
						+ GetHasFeat(FEAT_JUDICATOR_SPELLCASTING_UR_PRIEST);
						
        if(nJudicator > 1)
        {
            FloatingTextStringOnCreature("A Drow Judicator may only advance a single arcane, divine or invoker class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nJudicator < 1)
        {
            FloatingTextStringOnCreature("A Drow Judicator must pick one arcane, divine or invoker class to advance at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
	
    return FALSE;
}	
 */

//:; Enforces Maester marker feats
int MaesterMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_MAESTER))
    {
		int nMaester	= GetHasFeat(FEAT_MAESTER_INVOKING_WARLOCK)
						+ GetHasFeat(FEAT_MAESTER_INVOKING_DFA)
						+ GetHasFeat(FEAT_MAESTER_NONE);
						
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

//:; Enforces Mystic Theurge marker feats
int MysticTheurgeMarkerFeats()
{
    if (GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE))
    {
        int nMysticShadow	= GetHasFeat(FEAT_MYSTICTHEURGE_MYSTERY_SHADOWCASTER)
							+ GetHasFeat(FEAT_MYSTICTHEURGE_MYSTERY_SHADOWSMITH)
							+ GetHasFeat(FEAT_MYSTICTHEURGE_NONE);


        // Check if the character has chosen a valid combination of marker feats
        if (nMysticShadow > 1) 
		{
            FloatingTextStringOnCreature("A Mystic Theurge must choose or exclude shadowcasting at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }

        if (nMysticShadow < 1) 
		{
            FloatingTextStringOnCreature("A Mystic Theurge must choose or exclude shadowcasting at first level.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }

    return FALSE;
}

//:; Enforces Noctumancer marker feats
int NoctumancerMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_NOCTUMANCER))
    {
		int nNoctShadow		= GetHasFeat(FEAT_NOCTUMANCER_MYSTERY_SHADOWCASTER)
							+ GetHasFeat(FEAT_NOCTUMANCER_MYSTERY_SHADOWSMITH);
						
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
		int nOllam	= GetHasFeat(FEAT_OLLAM_NONE)
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

/* //:; Enforces Oozemaster marker feats
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
 */


//:; Enforces Thrall of Orcus marker feats
int OrcusMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_ORCUS))
    {
		int nOrcus	= GetHasFeat(FEAT_ORCUS_MYSTERY_SHADOWCASTER)
					+ GetHasFeat(FEAT_ORCUS_MYSTERY_SHADOWSMITH)
					+ GetHasFeat(FEAT_ORCUS_NONE);
					
        if(nOrcus > 1)
        {
            FloatingTextStringOnCreature("A Thrall of Orcus may only advance a single divine or shadowcasting class.", OBJECT_SELF, FALSE);
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

//:; Enforces Psychic Theurge marker feats
int PsychicTheurgeMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE))
    {
		int nPsyTheurgeDivine	= GetHasFeat(FEAT_PSYCHIC_THEURGE_MANIFEST_FOZ)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_MANIFEST_PSION)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_MANIFEST_PSYROUGE)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_MANIFEST_PSYWAR)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_MANIFEST_WARMIND)
								+ GetHasFeat(FEAT_PSYCHIC_THEURGE_MANIFEST_WILDER);
						
        if(nPsyTheurgeDivine > 1)
        {
            FloatingTextStringOnCreature("A Psychic Theurge may only advance a single psionic class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nPsyTheurgeDivine < 1)
        {
            FloatingTextStringOnCreature("A Psychic Theurge must pick one psionic class to advance at first level.", OBJECT_SELF, FALSE);
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

//:: Enforces Soulcaster marker feats
int SoulcasterMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_SOULCASTER))
    {
		int nSoulcast	= GetHasFeat(FEAT_SOULCASTER_MANIFEST_FOZ)
						+ GetHasFeat(FEAT_SOULCASTER_MANIFEST_PSION)
						+ GetHasFeat(FEAT_SOULCASTER_MANIFEST_PSYROUGE)
						+ GetHasFeat(FEAT_SOULCASTER_MANIFEST_PSYWAR)
						+ GetHasFeat(FEAT_SOULCASTER_MANIFEST_WARMIND)
						+ GetHasFeat(FEAT_SOULCASTER_MANIFEST_WILDER)
						+ GetHasFeat(FEAT_SOULCASTER_MANIFEST_NONE);

        if(nSoulcast > 1)
        {
            FloatingTextStringOnCreature("A Soulcaster may only advance a single psionic class or their highest arcane spellcasting class.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
		
		if(nSoulcast < 1)
        {
            FloatingTextStringOnCreature("A Soulcaster must pick a psionic class or arcane spellcasting to advance at first level.", OBJECT_SELF, FALSE);
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
		int nTiamat	= GetHasFeat(FEAT_TIAMAT_NONE)					
					+ GetHasFeat(FEAT_TIAMAT_INVOKING_WARLOCK)
					+ GetHasFeat(FEAT_TIAMAT_INVOKING_DFA)
					+ GetHasFeat(FEAT_TIAMAT_INVOKING_DRAGON_SHAMAN)
					+ GetHasFeat(FEAT_TIAMAT_MYSTERY_SHADOWCASTER)
					+ GetHasFeat(FEAT_TIAMAT_MYSTERY_SHADOWSMITH);
						
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

//:; Enforces Unseen Seer marker feats
int UnseenMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_UNSEEN_SEER))
    {
		int nUnseen	= GetHasFeat(FEAT_UNSEEN_NONE)
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
		int nVirtuoso	= GetHasFeat(FEAT_VIRTUOSO_NONE)
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

//:; Enforces Wild Mage marker feats
int WildMageMarkerFeats()
{
    if(GetLevelByClass(CLASS_TYPE_WILD_MAGE))
    {
		int nWildMage	= GetHasFeat(FEAT_WILDMAGE_NONE)
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

/* 
CLASS_TYPE_THRALLHERD
 */


void main()
{
//:: If any of these conditions are true, relevel the character.	
    if(AbjurantChampionMarkerFeats()
    || AoTSMarkerFeats()
    || AlienistMarkerFeats()
	|| AnimaMageMarkerFeats()
	|| ArcaneTricksterMarkerFeats()
	|| DoAMarkerFeats()
	|| BloodMagusMarkerFeats()
 	|| CerebremancerMarkerFeats()
	|| CoNMarkerFeats()
	|| DiamondDragonMarkerFeats()
	|| DragonsongLyristMarkerFeats()
	|| EldritchDiscipleMarkerFeats()
	|| ElementalSavantMarkerFeats()
	|| EnlightendFistMarkerFeats()	
	|| IronMindMarkerFeats()
//	|| JudicatorMarkerFeats()
	|| MaesterMarkerFeats()
	|| MasterShadowMarkerFeats()
	|| MysticTheurgeMarkerFeats()
	|| NoctumancerMarkerFeats()
	|| OllamMarkerFeats()
//	|| OozemasterMarkerFeats()
	|| OrcusMarkerFeats()
	|| PsychicTheurgeMarkerFeats()
	|| SanctifiedMindMarkerFeats()
	|| ShadowMindMarkerFeats()
	|| SoulcasterMarkerFeats()
	|| ThrallherdMarkerFeats()
	|| TiamatMarkerFeats()
	|| UnseenMarkerFeats()
	|| VirtuosoMarkerFeats()
	|| WildMageMarkerFeats())
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