//::///////////////////////////////////////////////
//:: Name      Agony  
//:: FileName  sp_agony.nss 
//:://////////////////////////////////////////////
/** Script for the drug Agony

Author:    Tenjac
Created:   5/18/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_inc_drugfunc"

void main()
{
	object oPC = OBJECT_SELF;
	effect eStun = EffectStunned();
	effect eDaze = EffectDazed();
	float fDur = RoundsToSeconds(d4(1) + 1);
	float fDaze = ((d6(1) + 1) * 60.0f);
	
	//Handle resetting addiction DC
	SetPersistantLocalInt(oPC, "PRC_Addiction_Agony_DC", 25);
	
	//Handle satiation
	SetPersistantLocalInt(oPC, "PRC_AgonySatiation", 1);	
	
	//Make addiction check
	if(!GetHasSpellEffect(SPELL_DRUG_RESISTANCE, oPC))
	{
		if(!PRCMySavingThrow(SAVING_THROW_FORT, oPC, 25, SAVING_THROW_TYPE_DISEASE))
		{
			effect eAddict = EffectDisease(DISEASE_AGONY_ADDICTION);
			SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eAddict, oPC);
			FloatingTextStringOnCreature("You have become addicted to Agony.", oPC, FALSE);
		}
	}
	
	//primary
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,eStun,oPC, fDur);	
	DelayCommand(fDur, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oPC, fDaze));	
		
	//secondary
	int nBonus = d4(1) + 1;
	float fDur2 = 300.0f + (d10(1) * 60.0f);
	effect eCha = EffectAbilityIncrease(ABILITY_CHARISMA, nBonus);
	
	DelayCommand(60.0f, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCha, oPC, fDur2));
		
	//overdose
	if(GetOverdoseCounter(oPC, "PRC_AgonyOD"))
	{
		if(!PRCMySavingThrow(SAVING_THROW_FORT, oPC, 18, SAVING_THROW_TYPE_POISON))
		{
			float fDur3 = HoursToSeconds(d4(1));
			effect eBlind = EffectBlindness();
			effect eDeaf = EffectDeaf();
			effect eLink = EffectLinkEffects(eBlind, eDeaf);	
			
			//Blind/deaf
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, (fDur3 - 1.0f));
				
			//Clear all actions
			AssignCommand(oPC, ClearAllActions());
			
			//Animation		
			PlayAnimation(ANIMATION_LOOPING_DEAD_BACK, fDur3);
					
			//Make them sit and wait.  That's what you get.  JUST SAY NO!
			DelayCommand(0.2,SetCommandable(FALSE, oPC));
			
			//Restore Control
			DelayCommand((fDur - 0.2), SetCommandable(TRUE, oPC));
		}
	}
	//OD increment
	IncrementOverdoseTracker(oPC, "PRC_AgonyOD", HoursToSeconds(24));
}