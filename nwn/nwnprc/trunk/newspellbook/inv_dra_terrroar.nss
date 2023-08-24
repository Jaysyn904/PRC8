//::///////////////////////////////////////////////
//:: Name      Terrifying Roar
//:: FileName  inv_dra_terrroar.nss
//::///////////////////////////////////////////////
/*

Greater Invocation
5th Level Spell

You utter a powerful roar that fills a 30' cone.
All creatures whose hit dice are equal to or less
than your caster level become panicked for 1 round.
If they succeed on a Will save they are shaken for
one round. This is a mind-affecting fear effect.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if(!PreInvocationCastCode()) return;

// shaken   -2 attack,weapon dmg,save.
// panicked -2 save + flee away ,50 % drop object holding

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    int CasterLvl = GetInvokerLevel(oCaster, GetInvokingClass());
    int nPenetr = CasterLvl + SPGetPenetr();
    float fDuration = RoundsToSeconds(CasterLvl);
    float fRange = FeetToMeters(30.0);
    float fDelay;
    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eFear = EffectFrightened();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eSaveD = EffectSavingThrowDecrease(SAVING_THROW_ALL,2);
    effect eShaken = EffectShaken();

    //Link the panicked effects
    effect eLink = EffectLinkEffects(eFear, eMind);
           eLink = EffectLinkEffects(eLink, eSaveD);
           eLink = EffectLinkEffects(eLink, eDur);
    //Link the shaken effects
    effect eLink2 = EffectLinkEffects(eShaken, eDur);

    //Get first target in the spell cone
    object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, fRange, lTarget, TRUE, OBJECT_TYPE_CREATURE, GetPosition(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)
            && !(GetHitDice(oTarget) > CasterLvl))
        {
            fDelay = GetDistanceBetween(oCaster, oTarget)/20;
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_TERRIFYING_ROAR));
            //Make SR Check
            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr, fDelay))
            {
                //Make a will save - if failed, panicked
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetInvocationSaveDC(oTarget, oCaster), SAVING_THROW_TYPE_FEAR, oCaster, fDelay))
                {
                    //Apply the linked effects and the VFX impact
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0, TRUE, -1, CasterLvl));
                }
                //otherwise shaken
                else
                {
                    //Apply the linked effects and the VFX impact
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, 6.0, TRUE, -1, CasterLvl));
                }
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }
        //Get next target in the spell cone
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, fRange, lTarget, TRUE, OBJECT_TYPE_CREATURE, GetPosition(oCaster));
    }
}