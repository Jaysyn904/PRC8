/*
08/03/21 by Stratovarius

Acererak, the Devourer
  
Acererak, a half-human lich, grasped at godlike power only to lose his grip on reality. As a vestige, he grants abilities that are similar to a lich’s powers.

Vestige Level: 5th
Binding DC: 25
Special Requirement: None

Influence: As a vestige, Acererak possesses the immortality he desired but none of the power that should accompany it. If you fall under his influence, 
you evince a strong hunger for influence and primacy. If you are presented with an opportunity to fill a void in power over a group of creatures, Acererak 
requires that you attempt to seize that power. You might impersonate a missing city offi cial, take command of a leaderless unit of soldiers, or even grab the reins of runaway horses to establish your supremacy.

Granted Abilities: 
While bound to Acererak, you gain powers that the great lich held in his legendary unlife.

Paralyzing Touch: As a standard action, you can make a touch attack to paralyze a living foe. The touched creature must succeed on a Fortitude save or be 
paralyzed for a number of rounds equal to one-half your effective binder level. Each round on its turn, the paralyzed creature can attempt a new saving 
throw as a full-round action, with success ending the effect immediately. Once you have used this ability, you cannot do so again for 5 rounds.
*/

#include "bnd_inc_bndfunc"
#include "prc_inc_sp_tch"

void RecurringSave(object oTarget, int nSpell, int nDC, object oBinder);

void RecurringSave(object oTarget, int nSpell, int nDC, object oBinder)
{
	if (GetHasSpellEffect(nSpell, oTarget))
	{
		if (PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
		{
			PRCRemoveSpellEffects(nSpell, oBinder, oTarget);
			GZPRCRemoveSpellEffects(nSpell, oTarget, FALSE);		
		}
		DelayCommand(6.0, RecurringSave(oTarget, nSpell, nDC, oBinder));
	}
}

void main()
{
  	object oBinder = OBJECT_SELF;
  	if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_ACERERAK)) return;
  	object oTarget = PRCGetSpellTargetObject();
  	int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_ACERERAK);
  	int nDC = GetBinderDC(oBinder, VESTIGE_ACERERAK);
  	
  	if (PRCGetIsAliveCreature(oTarget))
  	{
    	if (PRCDoMeleeTouchAttack(oTarget) && !PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
    	{
      		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
			effect eHold = EffectLinkEffects(EffectParalyze(), EffectVisualEffect(VFX_DUR_STONEHOLD));
      		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eHold), oTarget, RoundsToSeconds(nBinderLevel/2));
      		DelayCommand(6.0, RecurringSave(oTarget, GetSpellId(), nDC, oBinder));
    	}
  	}
}