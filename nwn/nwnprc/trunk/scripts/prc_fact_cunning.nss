//:://////////////////////////////////////////////
//:: Factotum Cunning X abilities
//:: prc_fact_cunning
//:://////////////////////////////////////////////
/*
    @author Stratovarius - 2019.12.21
*/

#include "prc_inc_factotum"
#include "inc_dynconv"

void main()
{
    object oPC = OBJECT_SELF;
    int nSpellID = PRCGetSpellId();
    int nBonus = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
    int nClass = GetLevelByClass(CLASS_TYPE_FACTOTUM, oPC);
    
    if(GetHasSpellEffect(nSpellID, oPC))
    {
    	FloatingTextStringOnCreature("You are already under the effect of this ability!", oPC, FALSE);
    	return;
    }	
    
    if (nSpellID == SPELL_CUNNING_INSIGHT_ATTACK && ExpendInspiration(oPC, 1))
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(nBonus), oPC, 6.0);
    else if (nSpellID == SPELL_CUNNING_INSIGHT_DAMAGE && ExpendInspiration(oPC, 1))
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(nBonus), DAMAGE_TYPE_BASE_WEAPON), oPC, 6.0);
    else if (nSpellID == SPELL_CUNNING_INSIGHT_SAVES && ExpendInspiration(oPC, 1))
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus), oPC, 6.0);  
    else if (nSpellID == SPELL_CUNNING_DEFENSE && 16 > nClass) //Once you get Improved Cunning Defense, you can't use this
    {
    	if (ExpendInspiration(oPC, 1)) 
    		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACIncrease(nBonus, AC_DODGE_BONUS), oPC, 6.0); 
    }		
    else if (nSpellID == SPELL_CUNNING_STRIKE && ExpendInspiration(oPC, 1))
    {
    	SetLocalInt(oPC, "CunningStrike", TRUE);
    	ExecuteScript("prc_sneak_att", oPC);
    	DelayCommand(5.9, DeleteLocalInt(oPC, "CunningStrike"));
    	DelayCommand(6.0, ExecuteScript("prc_sneak_att", oPC));
    }
    else if (nSpellID == SPELL_CUNNING_SURGE && ExpendInspiration(oPC, 3))
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectHaste(), oPC, 6.0);  
    else if (nSpellID == SPELL_CUNNING_BREACH && ExpendInspiration(oPC, 2))
    {
    	SetLocalInt(oPC, "CunningBreach", TRUE);
    	DelayCommand(5.9, DeleteLocalInt(oPC, "CunningBreach"));
    }  
    else if (nSpellID == SPELL_CUNNING_DODGE && ExpendInspiration(oPC, 4))
    {
    	SetImmortal(oPC, TRUE);
    	DelayCommand(5.9, SetImmortal(oPC, FALSE));
    }
    else if (nSpellID == SPELL_OPPORTUNISTIC_PIETY_HEAL)
    {
    	if (ExpendInspiration(oPC, 1))
    	{
    		object oTarget = PRCGetSpellTargetObject();
    		if (PRCGetIsAliveCreature(oTarget))
    			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nBonus + (nClass*2)), oTarget); 
    		else if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nBonus + (nClass*2)), oTarget);
    		
    		DecrementRemainingFeatUses(oPC, FEAT_OPPORTUNISTIC_PIETY_TURN);
    	}
    	else
    		IncrementRemainingFeatUses(oPC, FEAT_OPPORTUNISTIC_PIETY_HEAL);   		
    }	
    else if (nSpellID == SPELL_CUNNING_KNOWLEDGE && ExpendInspiration(oPC, 1))
    {
        AssignCommand(oPC, ClearAllActions(TRUE));
        StartDynamicConversation("prc_fact_sklconv", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);
    }    
}