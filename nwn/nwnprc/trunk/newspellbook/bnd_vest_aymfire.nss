/*
03/02/21 by Stratovarius

Aym, Queen Avarice
  
Halo of Fire: At will, you can shroud yourself in a wreath of flame. Any opponent that strikes you in melee takes 
1d6 points of fire damage. You can also deal 1d6 points of fire damage with each melee touch attack you make.
*/

#include "prc_inc_sp_tch"

void main()
{
	object oBinder = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
    int nAttack = PRCDoMeleeTouchAttack(oTarget);

    // PvP check.
    if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oBinder))
    {    
    	if (nAttack > 0)
    	{
            int nDamage = d6();
           	ApplyTouchAttackDamage(oBinder, oTarget, nAttack, nDamage, DAMAGE_TYPE_FIRE);
           	SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_S), oTarget);
        }
    }
}