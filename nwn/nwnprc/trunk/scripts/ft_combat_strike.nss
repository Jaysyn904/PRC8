//:://////////////////////////////////////////////////////////////////
//::	;-.  ,-.   ,-.  ,-. 
//::	|  ) |  ) /    (   )
//::	|-'  |-<  |     ;-: 
//::	|    |  \ \    (   )
//::	'    '  '  `-'  `-' 
//:://////////////////////////////////////////////////////////////////
//::
/* 	
	Combat Strike

	Your intense, focused state allows you to see the one critical 
	moment in a battle when you hang suspended between victory and 
	defeat. By pouring the energy required to maintain your focus 
	into your assault, you batter through your foe's defenses.

	Prerequisite: Combat Focus, WIS 13, any two other combat form 
	feats, base attack bonus +15
	
	Specifics: If you choose to end your combat focus as a swift 
	action, you gain a bonus on attack rolls and damage rolls equal 
	to your total number of combat form feats for the rest of your 
	current turn. You immediately lose all BENEFITS of combat form 
	feats that affect you only while you are maintaining your combat 
	focus.
	
	Use: Selected.
		
	Special: A fighter can select Combat Focus as one of his fighter 
	bonus feats. 
*/
//::
//:://////////////////////////////////////////////////////////////////
//::	Script:     ft_combat_strike.nss
//::	Author:     Jaysyn
//::	Created:    2026-02-22 12:29:37
//:://////////////////////////////////////////////////////////////////
#include "prc_inc_spells" 
#include "prc_inc_cmbtform"  
#include "prc_x2_itemprop"
  
void main()  
{  
    object oPC = OBJECT_SELF;  
    if (!GetHasFeat(FEAT_COMBAT_STRIKE, oPC)) return;  
  
    if (!GetLocalInt(oPC, COMBAT_FOCUS_VAR))  
    {  
        FloatingTextStringOnCreature("Combat Strike requires active Combat Focus.", oPC, FALSE);  
        return;  
    }  
  
    if (CountCombatFormFeats(oPC) < 2)  
    {  
        FloatingTextStringOnCreature("Combat Strike requires two other Combat Form feats.", oPC, FALSE);  
        return;  
    }  
  
    // End Combat Focus immediately  
    DeleteLocalInt(oPC, COMBAT_FOCUS_VAR);  
    DeleteLocalInt(oPC, COMBAT_FOCUS_END);  
  
    // Remove all Combat Form effects by tag immediately  
    RemoveCombatFocusWillBonus(oPC);  
    RemoveCombatAwarenessBlindsight(oPC);  
    RemoveCombatDefenseAC(oPC);  
    RemoveCombatStabilityBonus(oPC);  
    RemoveCombatVigorFastHeal(oPC);  
  
    // Apply temporary attack/damage bonus for the current turn  
    int nBonus = CountCombatFormFeats(oPC) + 1;
	effect eImpact = EffectVisualEffect(VFX_IMP_PDK_WRATH);	
    effect eAtk = EffectAttackIncrease(nBonus);  
    effect eDam = EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(nBonus), DAMAGE_TYPE_BASE_WEAPON);  
    effect eLink = EffectLinkEffects(eAtk, eDam);  
    eLink = TagEffect(eLink, "CombatStrike_Bonus");  
    eLink = SupernaturalEffect(eLink);
	
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oPC);	
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 7.0f);  
  
    FloatingTextStringOnCreature("*Combat Strike Activated*", oPC, FALSE);  
}