//::///////////////////////////////////////////////
//:: Name      Charm
//:: FileName  inv_dra_charm.nss
//::///////////////////////////////////////////////
/*

Lesser Invocation
4th Level Spell

You can beguile a creature within 60'. They must
make a Will save or regard you as an ally. The
charm lasts for 1 day per caster level, but you can
only have one creature charmed in this way at any
time. If you charm another creature, the first
charm will be canceled.

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
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    int nDuration = CasterLvl;
    int nPenetr = CasterLvl + SPGetPenetr();
    int nRacial = MyPRCGetRacialType(oTarget);
	int nDC = GetInvocationSaveDC(oTarget, oCaster);
	
	if (GetHasFeat(FEAT_ABFOC_CHARM, oCaster)) nDC += 2;
	
    effect eVis = EffectVisualEffect(VFX_IMP_CHARM);
    effect eCharm = EffectDominated();  //EffectDominated is limited to 1 creature at a time
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    eCharm = PRCGetScaledEffect(eCharm, oTarget);
    nDuration = PRCGetScaledDuration(nDuration, oTarget);

    //Link effects
    effect eLink = EffectLinkEffects(eMind, eCharm);
           eLink = EffectLinkEffects(eLink, eDur);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_CHARM, FALSE));
        // Make SR Check
        if (!PRCDoResistSpell(oCaster, oTarget, nPenetr))
        {
            // Make Will save vs Mind-Affecting
            if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
            {
                //Apply impact and linked effect
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration * 24), TRUE, -1, CasterLvl);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
}
