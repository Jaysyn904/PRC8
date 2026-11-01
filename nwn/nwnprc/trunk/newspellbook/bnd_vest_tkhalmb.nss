/*
Mind Blast for Tkhaluuljin
120-ft cone: Will save or stunned for 12 rounds. 5-round cooldown.
*/
#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    if (!BindAbilCooldown(oBinder, PRCGetSpellId(), VESTIGE_TKHALUULJIN)) return;

    location lTarget = PRCGetSpellTargetLocation();
    float fRange = FeetToMeters(120.0);

    object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, fRange, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        if (oTarget != oBinder && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oBinder))
        {
            int nDC = GetBinderDC(oBinder, VESTIGE_TKHALUULJIN, oTarget);
            SignalEvent(oTarget, EventSpellCastAt(oBinder, VESTIGE_TKHAL_MINDBLAST_SPELL));
            if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, oBinder))
            {
                effect eStun = EffectLinkEffects(EffectStunned(), EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eStun), oTarget, RoundsToSeconds(12));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SONIC), oTarget);
            }
        }
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, fRange, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}
