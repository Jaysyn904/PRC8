/*
12/03/21 by Stratovarius

Otiax, the Key to the Gate
  
The alien Otiax gives its summoners the power to open what is closed, to walk among the clouds, and to strike foes with fog that lands like a hammer.

Vestige Level: 5th
Binding DC: 25
Special Requirement: No

Influence: Otiax’s motives remain a mystery, but its influence is clear. When confronted with unopened doors or gates, you become agitated and nervous. This emotional 
state lasts until the door or gate is opened, or until you can no longer see it. Furthermore, Otiax cannot abide a lock remaining secured. Thus, whenever you see a 
key, Otiax requires that you use it to open the corresponding lock.

Granted Abilities: 
Otiax opens doors for you, lets you batter opponents with wind, and cloaks you in a protective fog that can actually lash out at foes.

Air Blast: You can focus the air around you into a concentrated blast that batters opponents. You can use your air blast as a melee touch attack against an adjacent 
opponent or one that is up to 10 feet away. This attack deals 2d6 points of bludgeoning damage, but you do not add your Strength bonus to the damage roll. If your 
base attack bonus is high enough, you might be entitled to additional air blast attacks each round when you make a full attack.
*/

#include "bnd_inc_bndfunc"
#include "prc_inc_sp_tch"

void OtiaxAirBlast(object oTarget, object oBinder)
{
	int nAttack = PRCDoMeleeTouchAttack(oTarget);
    if (nAttack > 0)
    {
        int nDamage = d6();
       	ApplyTouchAttackDamage(oBinder, oTarget, nAttack, d6(2), DAMAGE_TYPE_BLUDGEONING);
       	SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_WIND), oTarget);
    }
}

void main()
{
  	object oBinder = OBJECT_SELF;
  	object oTarget = PRCGetSpellTargetObject();
	int nBAB = GetBaseAttackBonus(oBinder);
	
	OtiaxAirBlast(oTarget, oBinder);
	if (nBAB >= 16) DelayCommand(3.0, OtiaxAirBlast(oTarget, oBinder));
	if (nBAB >= 11) DelayCommand(2.0, OtiaxAirBlast(oTarget, oBinder));
	if (nBAB >= 6) DelayCommand(1.0, OtiaxAirBlast(oTarget, oBinder));
}