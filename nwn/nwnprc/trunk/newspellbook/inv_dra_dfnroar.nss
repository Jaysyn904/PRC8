//::///////////////////////////////////////////////
//:: Name      Deafening Roar
//:: FileName  inv_dra_dfnroar.nss
//::///////////////////////////////////////////////
/*

Least Invocation
2nd Level Spell

You utter a loud roar within a 30' cone. Those
within must make a Fortitude save or be deafened
for 1 hour.

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
    float fDelay;
    effect eDeaf = EffectDeaf();
    effect eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    //Link the deafened effects
    effect eLink = EffectLinkEffects(eDeaf, eDur);

    //Get first target in the spell cone
    object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE, GetPosition(oCaster));
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != oCaster && !GetIsReactionTypeFriendly(oTarget))
        {
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, INVOKE_DEAFENING_ROAR));
            //Make SR Check
            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr, fDelay))
            {
                //Make a fort save
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (GetInvocationSaveDC(oTarget, oCaster)), SAVING_THROW_TYPE_SONIC, oCaster, fDelay))
                {
                    //Apply the linked effects and the VFX impact
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0,TRUE,-1,CasterLvl));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
        //Get next target in the spell cone
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE, GetPosition(oCaster));
    }
}

