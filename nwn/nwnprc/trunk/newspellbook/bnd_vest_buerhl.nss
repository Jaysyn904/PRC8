/*
03/03/21 by Stratovarius

Buer, Grandmother Huntress
  
Buer grants binders superior healing as well as powers against poisons and diseases.

Vestige Level: 4th
Binding DC: 20
Special Requirement: Buer requires that her seal be drawn outdoors.

Influence: Under Buer’s influence, you are plagued by momentary memory lapses. For an instant, you might forget even a piece of information as familiar as the 
name of a friend or family member. Furthermore, since Buer abhors the needless death of living creatures other than animals and vermin, the first melee 
attack you make against such a foe must be for nonlethal damage. In addition, Buer requires that you not make any coup de grace attacks.

Granted Abilities: 
Buer grants you healing powers, the ability to ignore toxins and ailments, and skills that help you navigate the natural world.

Healing Gift: As a standard action, you can cure 1d8 points of damage +1 point per effective binder level (maximum 1d8+10 points). You cannot use your healing gift
again for 5 rounds. Both uses of the ability channel positive energy and deal a corresponding amount of damage to undead.
*/

#include "bnd_inc_bndfunc"
#include "prc_inc_sp_tch"

void main()
{
  	object oBinder = OBJECT_SELF;
  	if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_BUER)) return;
  	object oTarget = PRCGetSpellTargetObject();
  	int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_BUER);
  	int nHeal = d8() + min(nBinderLevel, 10);
  	
  	if(PRCGetIsAliveCreature(oTarget))
  	{
  		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oTarget);
  		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_L_MAG), oTarget);
  	}
  	else if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
  	{
  		int iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
    	if (iAttackRoll > 0)
    	{
      		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));

      		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DOOM), oTarget);
      		ApplyTouchAttackDamage(oBinder, oTarget, iAttackRoll, nHeal, DAMAGE_TYPE_DIVINE);
    	}
  	}
}