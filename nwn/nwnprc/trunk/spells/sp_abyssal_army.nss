//::////////////////////////////////////////////////////////
//::
/*
	Abyssal Army	(sp_abysal_army.nss)
	Conjuration (Summoning) [Chaotic, Evil]
	Level: 				Cleric 9, Sorcerer 9, Wizard 9,
	Components: 		V, S,
	Casting Time: 		10 minutes
	Range: 				Medium (100 ft. + 10 ft./level)
	Effect: 			Two or more summoned creatures, no 
						two of which are more than 30 ft. 
						apart
	Duration: 			10 minutes/level (D)
	Saving Throw: 		None
	Spell Resistance: 	No
*/
//::
//::////////////////////////////////////////////////////////
//::
/*
	This spell summons a pack of demons from the Infinite 
	Layers of the Abyss to serve you.

	When the spell is complete, 2d4 dretches (MM 42) appear. 
	Ten minutes later, 1d4 babau demons (MM 40) appear. Ten 
	minutes after that, one vrock demon (MM 48) appears. Each 
	creature has maximum hit points per Hit Die. Once these 
	creatures appear, they serve you for
	the duration of the spell.

	The demons obey you explicitly and never attack you, even 
	if someone else manages to gain control over them. You do 
	not need to concentrate to maintain control over the 
	demons. You can dismiss them singly or in groups at any 
	time.

*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Jaysyn
//:: Date: 2026-09-15
//::
//:://////////////////////////////////////////////////////// 
#include "prc_alterations"  
#include "prc_inc_spells"  
  
void DoBabauStage(object oPC, int nCasterLvl, location lLoc);  
void DoVrockStage(object oPC, int nCasterLvl, location lLoc);  
  
void main()  
{  
    if(!X2PreSpellCastCode()) return;  
  
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);  
  
    object oPC = OBJECT_SELF;  
    int nCasterLvl = PRCGetCasterLevel(oPC);  
    location lLoc = PRCGetSpellTargetLocation();  
  
    // Stage 1: 2d4 dretches, immediately  
    MultisummonPreSummon();  
    effect eDretch = SupernaturalEffect(EffectSummonCreature("prc_sum_dretch"));  
    int i; int nCount = d4(2);  
    for(i = 0; i < nCount; i++)  
    {  
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eDretch, lLoc, RoundsToSeconds(nCasterLvl) * 10.0f);  
    }  
    DelayCommand(0.5f, AugmentSummonedCreature("prc_sum_dretch"));  
  
    // Stage 2: 1d4 babaus, 10 minutes later  
    DelayCommand(600.0f, DoBabauStage(oPC, nCasterLvl, lLoc));  
  
    // Stage 3: 1 vrock, 10 minutes after that  
    DelayCommand(1200.0f, DoVrockStage(oPC, nCasterLvl, lLoc));  
  
    PRCSetSchool();  
}  
  
void DoBabauStage(object oPC, int nCasterLvl, location lLoc)  
{  
    MultisummonPreSummon();  
    effect eBabau = SupernaturalEffect(EffectSummonCreature("prc_sum_babau"));  
    int i; int nCount = d4(1);  
    for(i = 0; i < nCount; i++)  
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eBabau, lLoc, (RoundsToSeconds(nCasterLvl) * 10.0f) - 600.0f);  
    DelayCommand(0.5f, AugmentSummonedCreature("prc_sum_babau"));  
}  
  
void DoVrockStage(object oPC, int nCasterLvl, location lLoc)  
{  
    MultisummonPreSummon();  
    effect eVrock = SupernaturalEffect(EffectSummonCreature("prc_sum_vrock"));  
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVrock, lLoc, (RoundsToSeconds(nCasterLvl) * 10.0f) - 1200.0f);  
    DelayCommand(0.5f, AugmentSummonedCreature("prc_sum_vrock"));  
}