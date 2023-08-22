/*

Unstoppable
prc_lgdr_unstop
+20 attack bonus for 1 Round
Unless I can make it 1 Attack

*/
/*
void main()
{
    //Old Spell Code
    //Declare major variables
    object oTarget;
    oTarget = OBJECT_SELF;

    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
    effect eAttack = EffectAttackIncrease(20);

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = eAttack;
    eLink = EffectLinkEffects(eLink, eDur);

    //Apply VFX impact and bonus effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 9.0);

}
*/
#include "prc_inc_combat"
void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    effect eInvalid;
    PerformAttackRound(oTarget, oPC, eInvalid, 0.0, 20, 0, 0, FALSE, 
        "*Unstoppable Attack Hit*", "*Unstoppable Attack Missed");
}
