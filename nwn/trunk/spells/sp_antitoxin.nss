/////////////////////////////////////////////
// Antitoxin
// sp_antitoxin.nss
////////////////////////////////////////////
// +5 to Fortitude vs poison for 1 hour

#include "prc_inc_nwscript"

void main()
{
        object oTarget = PRCGetSpellTargetObject();
        effect eBoost = EffectSavingThrowIncrease(SAVING_THROW_FORT, 5, SAVING_THROW_TYPE_POISON);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBoost, oTarget, HoursToSeconds(1));
}