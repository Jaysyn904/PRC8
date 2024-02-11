/* Resistance racial ability for Elans
   Grants a save bonus for 1 round.*/

#include "psi_inc_psifunc"
#include "prc_sp_func"


void main()
{
    object oTarget     = PRCGetSpellTargetObject();

    if(GetCurrentPowerPoints(OBJECT_SELF) > 0)
    {
        effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4);

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        //Apply the VFX impact and effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSave, oTarget, 6.0, TRUE, -1, 0);

        //pay the PP cost
        LosePowerPoints(OBJECT_SELF, 1);
    }
}