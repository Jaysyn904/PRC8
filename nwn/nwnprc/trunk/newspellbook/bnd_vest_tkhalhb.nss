/*
Heartbeat script for Tkhaluuljin's Aura of Madness (bnd_vest_tkhalhb)
*/
#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = GetAreaOfEffectCreator();
    if (!GetIsObjectValid(oBinder) ||
        !GetHasSpellEffect(VESTIGE_TKHALUULJIN, oBinder) ||
        !GetLocalInt(oBinder, "TkhalMadnessAuraActive"))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_TKHALUULJIN);
    int nRounds = PRCMax(1, nBinderLevel / 5);
    string sImmVar = "TkhalMadnessImmune_" + ObjectToString(oBinder);

    object oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        if (oTarget != oBinder &&
            PRCGetIsAliveCreature(oTarget) &&
            spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oBinder) &&
            !GetLocalInt(oTarget, sImmVar))
        {
            int bAlreadyConfused = FALSE;
            effect eEff = GetFirstEffect(oTarget);
            while (GetIsEffectValid(eEff))
            {
                if (GetEffectType(eEff) == EFFECT_TYPE_CONFUSED)
                {
                    bAlreadyConfused = TRUE;
                    break;
                }
                eEff = GetNextEffect(oTarget);
            }

            if (!bAlreadyConfused)
            {
                int nDC = GetBinderDC(oBinder, VESTIGE_TKHALUULJIN, oTarget);
                SignalEvent(oTarget, EventSpellCastAt(oBinder, VESTIGE_TKHAL_MADNESS_SPELL));
                if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, oBinder))
                {
                    effect eRawConf = PRCEffectConfused(oTarget);
                    if (GetIsEffectValid(eRawConf) && !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oBinder) &&
                        !GetIsImmune(oTarget, IMMUNITY_TYPE_CONFUSED, oBinder))
                    {
                        effect eConf = EffectLinkEffects(eRawConf, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED));
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eConf), oTarget, RoundsToSeconds(nRounds));
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_CONFUSION_S), oTarget);
                    }
                }
                else
                {
                    SetLocalInt(oTarget, sImmVar, TRUE);
                    AssignCommand(oTarget, DelayCommand(HoursToSeconds(24), DeleteLocalInt(oTarget, sImmVar)));
                }
            }
        }
        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    }
}
