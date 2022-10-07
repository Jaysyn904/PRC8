/*
25/03/21 by Stratovarius

Halphax, the Angel in the Angle
    
Gnomes rarely earn a reputation for their military might, but Halphax is one of the few exceptions to that rule. He grants his summoners the ability to defend a fortress and imprison foes, as well as the hardness of stone.
  
Vestige Level: 8th
Binding DC: 32
Special Requirement: Halphax’s sign must be drawn inside a building.
  
Influence: In his time as a vestige, Halphax seems to have lost all memory of his life as well as any feeling of guilt or shame for his actions. Thus, when you are under his influence, 
you lose any normal sense of shame or embarrassment. However, if someone threatens a hostage you care about—be it a creature or an item—Halphax requires that you accede to the hostage taker’s demands.
  
Granted Abilities: 
Halphax grants you great knowledge of mechanical arts as well as the power to imprison foes, build defenses, and gird your body with the hardness of stone.

Imprison: As a standard action, you can make a melee touch attack to imprison your target. If you hit, the target must make a Fortitude saving throw or be imprisoned. 
This ability functions like the imprisonment spell, except that the imprisonment lasts for a number of rounds equal to your effective binder level. If a target makes 
its save, you must wait 1d4 rounds before using the ability again. You cannot imprison a creature while you already have another imprisoned from the use of this ability.
*/

#include "bnd_inc_bndfunc"
#include "prc_inc_sp_tch"

void main()
{
  	object oBinder = OBJECT_SELF;
  	if(GetLocalInt(oBinder, "HalphaxDelay")) return;
  	object oTarget = PRCGetSpellTargetObject();
  	int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_HALPHAX);
  	int nDC = GetBinderDC(oBinder, VESTIGE_HALPHAX);
  	
  	if (PRCDoMeleeTouchAttack(oTarget))
  	{
    	if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
    	{
        	effect eLink      =                          EffectCutsceneParalyze();
        	       eLink      = EffectLinkEffects(eLink, EffectCutsceneGhost());
        	       eLink      = EffectLinkEffects(eLink, EffectEthereal());
        	       eLink      = EffectLinkEffects(eLink, EffectSpellImmunity(SPELL_ALL_SPELLS));
        	       eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID,        100));
        	       eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 100));
        	       eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD,        100));
        	       eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE,      100));
        	       eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL,  100));
        	       eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE,        100));
        	       eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL,     100));
        	       eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE,    100));
        	       eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING,    100));
        	       eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE,    100));
        	       eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING,    100));
        	       eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC,       100));
      		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oTarget, RoundsToSeconds(nBinderLevel));
    		SetLocalInt(oBinder, "HalphaxDelay", TRUE);
    		DelayCommand(RoundsToSeconds(nBinderLevel), DeleteLocalInt(oBinder, "HalphaxDelay"));      		
    		DelayCommand(RoundsToSeconds(nBinderLevel), FloatingTextStringOnCreature("You can use Halphax's Imprison ability again", oBinder, FALSE));
    	}
    	else
    	{
    		SetLocalInt(oBinder, "HalphaxDelay", TRUE);
    		int nDelay = d4();
    		DelayCommand(RoundsToSeconds(nDelay), DeleteLocalInt(oBinder, "HalphaxDelay"));
    		DelayCommand(RoundsToSeconds(nDelay), FloatingTextStringOnCreature("You can use Halphax's Imprison ability again", oBinder, FALSE));
    	}	
  	}
}