//::///////////////////////////////////////////////
//:: Name      Frightful Presence
//:: FileName  inv_dra_frtpres.nss
//::///////////////////////////////////////////////
/*

Lesser Invocation
3rd Level Spell

You can cast this invocation as a swift action. Any
enemies who are within 30' and fail a Will save are
shaken for 10 minutes. This is a mind-affecting
effect.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if(!PreInvocationCastCode()) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    int CasterLvl = GetInvokerLevel(oCaster, GetInvokingClass());
    int nPenetr = CasterLvl + SPGetPenetr();
    int nDamage;
    float fDuration = RoundsToSeconds(CasterLvl);
    float fRange = FeetToMeters(30.0);
    float fDelay;

    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eShaken = EffectShaken();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    //Link the shaken effects
    effect eLink = EffectLinkEffects(eShaken, eDur);

    //Get first target in the spell cone
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRange, lTarget, TRUE, OBJECT_TYPE_CREATURE, GetPosition(oCaster));
	
    while(GetIsObjectValid(oTarget))
    {
		int nDC = GetInvocationSaveDC(oTarget, oCaster);
		if (GetHasFeat(FEAT_ABFOC_FRIGHTFUL_PRESENCE, OBJECT_SELF)) nDC += 2;
	
        if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF)
            && MyPRCGetRacialType(oTarget)!= RACIAL_TYPE_DRAGON)
        {
            fDelay = GetDistanceBetween(oCaster, oTarget)/20;
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_FRIGHTFUL_PRESENCE));
            //Make SR Check
            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr, fDelay))
            {
                //Make a will save - if failed, shaken for 10 minutes
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR, oCaster, fDelay))
                {
                    //Apply the linked effects and the VFX impact
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(10), TRUE, -1, CasterLvl));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
        //Get next target in the spell cone
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRange, lTarget, TRUE, OBJECT_TYPE_CREATURE, GetPosition(oCaster));
    }
}