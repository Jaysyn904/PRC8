////////////////////////////////////////////////////////
// Alchemical Sleep Gas
// sp_alcslpgas.nss
/////////////////////////////////////////////////////////

/*
Alchemical Sleep Gas: This liquid evaporates quickly when
exposed to air, creating a temporary, mildly toxic cloud that puts
living creatures to sleep. You can throw a flask of sleep gas as a
grenadelike weapon. On a direct hit a living target must succeed
on a Fortitude save (DC 15) or fall asleep for 1 minute. After 1 minute,
the target must make another Fortitude save (DC 15) or sleep 1d4 additional
minutes. The sleep gas does not affect creatures that are immune to poison.
*/

#include "prc_inc_sp_tch"

void SleepSave(object oTarget)
{
        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, 15, SAVING_THROW_TYPE_POISON))
        {
                int nTurns = d4(1);
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSleep(), oTarget, TurnsToSeconds(nTurns));
        }
}

void main()
{
        object oTarget = PRCGetSpellTargetObject();
        int nTarget = GetObjectType(oTarget);
        int nTouch = PRCDoRangedTouchAttack(oTarget);

        if(nTouch)
        {
                if(nTarget == OBJECT_TYPE_CREATURE)
                {
                        if(!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))
                        {
                                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, 15, SAVING_THROW_TYPE_POISON))
                                {
                                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSleep(), oTarget, TurnsToSeconds(1));
                                        DelayCommand(TurnsToSeconds(1), SleepSave(oTarget));
                                }
                        }
                }
        }
}