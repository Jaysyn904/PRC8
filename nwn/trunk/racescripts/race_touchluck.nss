/* Glimmerskin Halfling's "Touch of Luck"
   +2 to the saving throw of an ally within 30'*/

#include "prc_sp_func"


void main()
{
    object oTarget = PRCGetSpellTargetObject();

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2), oTarget, 6.0);
}