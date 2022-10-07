#include "prc_inc_smite"
#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();  
    float fDur = RoundsToSeconds(GetAbilityModifier(ABILITY_CHARISMA, oMeldshaper) + 3);
    
    if(!GetOpposition(oMeldshaper, oTarget)) 
    {
		if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_LAWFUL && GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_GOOD)
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_FEAR), oTarget, fDur);
		if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_CHAOTIC && GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_GOOD)
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_PARALYSIS), oTarget, fDur);
		if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_LAWFUL && GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_EVIL)	
		{
        	SetLocalInt(oTarget, "IncarnumDefenseLE", TRUE);
        	DelayCommand(fDur, DeleteLocalInt(oTarget, "IncarnumDefenseLE"));
        }
		if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_CHAOTIC && GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_EVIL)
		{
        	SetLocalInt(oTarget, "IncarnumDefenseCE", TRUE);
        	DelayCommand(fDur, DeleteLocalInt(oTarget, "IncarnumDefenseCE"));
        }	
    }    	
}