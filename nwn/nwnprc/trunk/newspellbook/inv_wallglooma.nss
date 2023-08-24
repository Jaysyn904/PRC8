

#include "prc_alterations"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    SetAllAoEInts(INVOKE_VFX_PER_WALL_OF_GLOOM,OBJECT_SELF, GetSpellSaveDC());

    //Declare major variables
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
    int nCasterLvl = GetInvokerLevel(oCaster, CLASS_TYPE_WARLOCK);
    int nDC = GetInvocationSaveDC(oTarget, oCaster, INVOKE_WALL_OF_GLOOM);
    effect eConceal = EffectConcealment(50);
    effect eHalt = EffectMovementSpeedDecrease(99);

    //Fire cast spell at event for the target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_WALL_OF_GLOOM));
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConceal, oTarget, RoundsToSeconds(nCasterLvl));

    if(oTarget != oCaster)
    {
        if(!PRCDoResistSpell(oCaster, oTarget, SPGetPenetrAOE(GetAreaOfEffectCreator(), nCasterLvl))
           && GetHitDice(oTarget) < 6)
    	{
    		//save
    		if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
    		{
                // Maximum time possible. If its less, its simply cleaned up when the utterance ends.
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHalt, oTarget, RoundsToSeconds(nCasterLvl));
            }
        }
    }
    
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConceal, oTarget, RoundsToSeconds(nCasterLvl));
}
