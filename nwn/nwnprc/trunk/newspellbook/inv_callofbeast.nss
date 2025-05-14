//::///////////////////////////////////////////////
//:: Name      Call of the Beast
//:: FileName  inv_callofbeast.nss
//::///////////////////////////////////////////////
/*

Least Invocation
2nd Level Spell

You gain a rapport with the beasts of the world,
and can charm a single animal for 2 rounds plus one
round for every 3 levels.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if(!PreInvocationCastCode()) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int CasterLvl = GetInvokerLevel(oCaster, GetInvokingClass());
    int nDuration = 2  + CasterLvl/3;
    nDuration = PRCGetScaledDuration(nDuration, oTarget);
    int nRacial = MyPRCGetRacialType(oTarget);
    int nPenetr = CasterLvl + SPGetPenetr();
	int nDC = GetInvocationSaveDC(oTarget, oCaster);
	
	if (GetHasFeat(FEAT_ABFOC_CALL_OF_THE_BEAST, OBJECT_SELF)) nDC += 2;
	
    effect eVis = EffectVisualEffect(VFX_IMP_CHARM);
    effect eCharm = PRCGetScaledEffect(EffectCharmed(), oTarget);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    //Link the charm and duration visual effects
    effect eLink = EffectLinkEffects(eMind, eCharm);
           eLink = EffectLinkEffects(eLink, eDur);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire spell cast at event to fire on the target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_CALL_OF_THE_BEAST, FALSE));
        //Make SR Check
        if (!PRCDoResistSpell(oCaster, oTarget, nPenetr))
        {
            //Make sure the racial type of the target is applicable
            if(nRacial == RACIAL_TYPE_ANIMAL)
            {
                //Make Will Save
                if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //Apply impact effects and linked duration and charm effect
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration), TRUE, -1, CasterLvl);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        }
    }
}
