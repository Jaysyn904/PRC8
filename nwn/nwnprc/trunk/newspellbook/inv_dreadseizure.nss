//::///////////////////////////////////////////////
//:: Name      Dread Seizure
//:: FileName  inv_dreadseizure.nss
//::///////////////////////////////////////////////
/*

Lesser Invocation
4th Level Spell

You speak a word that sends wracking pain through
the limbs of a creature within 60'. The creature
can only move at half speed, and takes a -5 on
attack rolls. This effect lasts for 3 rounds, or is
negated by a fortitude save.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if (!PreInvocationCastCode()) return;

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = GetInvokerLevel(oPC, GetInvokingClass());
    int nDC = GetInvocationSaveDC(oTarget, oPC);
	
	if (GetHasFeat(FEAT_ABFOC_DREAD_SEIZURE, oPC)) nDC += 2;	

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        PRCSignalSpellEvent(oTarget, TRUE, INVOKE_DREAD_SEIZURE, oPC);

        //SR
        if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
        {
            //save
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
            {
                effect eSlow = EffectMovementSpeedDecrease(50);
                effect eAttack = EffectAttackDecrease(5);
                effect eLink = EffectLinkEffects(eSlow, eAttack);
                effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(3), TRUE, -1, nCasterLvl);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
}