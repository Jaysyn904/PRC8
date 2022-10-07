//::///////////////////////////////////////////////
//:: Name      Extract Drug
//:: FileName  sp_extract_drug.nss
//:://////////////////////////////////////////////
/**@file Extract Drug 
Conjuration (Creation)
Level: Brd 1, Clr 1, Drd 1, Sor/Wiz 1 
Components: V S, F 
Casting Time: 1 minute
Range: Touch
Effect: One dose of a drug 
Duration: Permanent

The caster infuses a substance with energy and 
creates a magical version of a drug. The magical
version manifests as greenish fumes that rise from 
the chosen focus. The fumes must then be inhaled 
as a standard action within 1 round to get the 
drug's effects.

The type of drug extracted depends on the substance 
used.
               Drug Extracted        Effect on Focus  

Material                           

  Metal       Baccaran            Metal's hardness drops by l. 
  Stone       Vodare              Stone's hardness drops by 1. 
  Water       Sannish             Water becomes brackish and foul. 
  Air         Mordayn             Foul odor fills the vapor area 
  Wood        Mushroom powder     Wood takes on a permanent foul odor

 

There may be other drugs that can be extracted with 
rarer substances, at the DM's discretion.

Focus: 15 lb. or 1 cubic foot of the material in question.


Author:    Tenjac
Created:   7/3/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_CONJURATION);
	
	object oPC = OBJECT_SELF;
	int nSpell = GetSpellId();
	int nMetaMagic = PRCGetMetaMagicFeat();
	
	if(nSpell == SPELL_EXTRACT_BACCARAN)
	{
		ActionCastSpellAtObject(SPELL_BACCARAN, oPC, nMetaMagic, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
	}
	
	if(nSpell == SPELL_EXTRACT_VODARE)
	{
			ActionCastSpellAtObject(SPELL_VODARE, oPC, nMetaMagic, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
	}
	
	if(nSpell == SPELL_EXTRACT_SANNISH)
	{
			ActionCastSpellAtObject(SPELL_SANNISH, oPC, nMetaMagic, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
	}
	
	if(nSpell == SPELL_EXTRACT_MUSHROOM_POWDER)
	{
			ActionCastSpellAtObject(SPELL_MUSHROOM_POWDER, oPC, nMetaMagic, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
	}
	
	PRCSetSchool();
}
	
	