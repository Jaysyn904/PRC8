//Hellfire Blast by Sir Attilla

//Fixed some run-time errors that caused spell to do nothing
//Aaon Graywolf - Jan 9, 2004
#include "prc_inc_sp_tch"
void main()
{
    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    int nDamage = d6(4);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
   //Main Spell Body
   int iHit = PRCDoMeleeTouchAttack(oTarget);;
   if (iHit > 0)
   {
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
   }

}
