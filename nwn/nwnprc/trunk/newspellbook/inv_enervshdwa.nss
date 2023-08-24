

#include "prc_inc_spells"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    
    //Declare major variables
    object oTarget = GetEnteringObject();
    int CasterLvl = GetInvokerLevel(GetAreaOfEffectCreator(), CLASS_TYPE_WARLOCK);
    int nDC = GetInvocationSaveDC(oTarget, GetAreaOfEffectCreator(),INVOKE_ENERVATING_SHADOW);
    effect eConceal = EffectConcealment(20);
    effect eStrength = EffectAbilityDecrease(ABILITY_STRENGTH, 4);
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

    if(oTarget == GetAreaOfEffectCreator())
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConceal, oTarget, RoundsToSeconds(5),TRUE,-1,CasterLvl);

    else if(!GetLocalInt(oTarget, "EnervatingShadowLock") && PRCGetIsAliveCreature(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), INVOKE_ENERVATING_SHADOW, FALSE));
        
        //SR
    	if(!PRCDoResistSpell(GetAreaOfEffectCreator(), oTarget, SPGetPenetrAOE(GetAreaOfEffectCreator(), CasterLvl)))
    	{
    		//save
    		if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
    		{
                //Apply VFX impact and effects
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStrength, oTarget, RoundsToSeconds(5),TRUE,-1,CasterLvl);
                SetLocalInt(oTarget, "EnervatingShadowLock", TRUE);
                DelayCommand(HoursToSeconds(24), DeleteLocalInt(oTarget, "EnervatingShadowLock"));
            }
        }
    }
}
