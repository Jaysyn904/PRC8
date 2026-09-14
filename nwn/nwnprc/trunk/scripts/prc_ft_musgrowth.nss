//::////////////////////////////////////////////////////////  
//:: Music of Growth  
//:: prc_ft_musgrowth.nss  
//::////////////////////////////////////////////////////////  
/*  
    Music of Growth
	( Eberron Campaign Setting, p. 57)

	[General]

	Your music can enhance the power of animals and plant 
	creatures.
	
	Prerequisite
	Perform 12 ranks, Bardic music class feature,
	
	Benefit
	By singing or playing music, you grant a +4 enhancement 
	bonus to the Strength and Constitution scores of every 
	creature of the animal or plant type within 30 feet of 
	you. This bonus lasts only as long as you continue 
	performing.

	Special
	Using this ability counts as one of your daily uses of 
	bardic music.
  
*/  
//::////////////////////////////////////////////////////////
//::
//:: Created By: Jaysyn
//:: Created on: 2026-09-14 10:07:35
//::
//::////////////////////////////////////////////////////////  
#include "prc_inc_spells"  
#include "prc_inc_clsfunc"  
  
void main()  
{  
    object oCaster = OBJECT_SELF;  
	
	//FloatingTextStringOnCreature("Firing Music of Growth.", oCaster, FALSE); 
  
    if (PRCGetHasEffect(EFFECT_TYPE_SILENCE, oCaster))  
    {  
        FloatingTextStrRefOnCreature(85764, oCaster);  
        return;  
    }  
    else if (GetSkillRank(SKILL_PERFORM, oCaster) < 12)  
    {  
        FloatingTextStringOnCreature("You need 12 or more ranks in Perform.", oCaster, FALSE);  
        return;  
    }  
    else if (!GetHasFeat(FEAT_BARD_SONGS, oCaster))  
    {  
        FloatingTextStringOnCreature("No Bard Song uses!", oCaster, FALSE);  
        return;  
    }  
  
    DecrementRemainingFeatUses(oCaster, FEAT_BARD_SONGS);  
  
    int nDuration = 10;  
    if (GetHasFeat(FEAT_LINGERING_SONG, oCaster)) nDuration += 5;  
    if (GetHasFeat(FEAT_EPIC_LASTING_INSPIRATION, oCaster)) nDuration *= 10;  
	
	int nSongheart = GetHasFeat(FEAT_SONG_OF_THE_HEART, oCaster);
	int nSTR = 4;
	int nCON = 4;
	
	if(nSongheart) 
	{
		nSTR = 6;
		nCON = 6;
	}	

	effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_SONIC);  
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nSTR);  
    effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, nCON);  
    effect eVis = EffectVisualEffect(VFX_DUR_BARD_SONG);  
    effect eLink = EffectLinkEffects(eStr, eCon);  
    eLink = EffectLinkEffects(eLink, eVis);
	eLink = EffectLinkEffects(eLink, eImpact);	
    eLink = ExtraordinaryEffect(eLink);  
	
	effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(oCaster));
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oCaster, RoundsToSeconds(nDuration)); 
	
  
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oCaster));  
    while (GetIsObjectValid(oTarget))  
    {  
        if (!PRCGetHasEffect(EFFECT_TYPE_SILENCE, oTarget) && !PRCGetHasEffect(EFFECT_TYPE_DEAF, oTarget))  
        {  
            int nRace = MyPRCGetRacialType(oTarget);  
            if (nRace == RACIAL_TYPE_ANIMAL || nRace == RACIAL_TYPE_PLANT)  
            {  
                RemoveSongEffects(GetSpellId(), oCaster, oTarget);  
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));  
            }  
        }  
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oCaster));  
    }  
}