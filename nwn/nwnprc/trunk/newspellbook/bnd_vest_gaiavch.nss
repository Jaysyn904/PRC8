/*
Heartbeat script for Gaia's Earth's Voice Aura (bnd_vest_gaiavch)
*/
#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = GetAreaOfEffectCreator();
    if (!GetIsObjectValid(oBinder) ||
        !GetHasSpellEffect(VESTIGE_GAIA, oBinder) ||
        !GetLocalInt(oBinder, "GaiaVoiceAuraActive"))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_GAIA);

    object oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        if (oTarget != oBinder && !GetIsFriend(oTarget, oBinder) && !GetPlotFlag(oTarget))
        {
            if (PRCGetIsAliveCreature(oTarget) && !PRCGetHasEffect(EFFECT_TYPE_DEAF, oTarget))
            {
                int bCharmed = FALSE;
                effect eEff = GetFirstEffect(oTarget);
                while (GetIsEffectValid(eEff))
                {
                    if (GetEffectType(eEff) == EFFECT_TYPE_CHARMED || GetEffectTag(eEff) == "GaiaVoiceCharm")
                    {
                        bCharmed = TRUE;
                        break;
                    }
                    eEff = GetNextEffect(oTarget);
                }
                if (!bCharmed)
                {
                    int nDC = GetBinderDC(oBinder, VESTIGE_GAIA, oTarget);
                    SignalEvent(oTarget, EventSpellCastAt(oBinder, VESTIGE_GAIA_VOICE_SPELL, FALSE));
                    if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, oBinder))
                    {
                        effect eCharm = PRCGetScaledEffect(EffectCharmed(), oTarget);
                        eCharm = TagEffect(SupernaturalEffect(eCharm), "GaiaVoiceCharm");
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharm, oTarget, RoundsToSeconds(nBinderLevel));
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_CHARM), oTarget);
                    }
                }
            }
        }
        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    }
}
