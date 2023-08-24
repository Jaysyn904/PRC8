//::///////////////////////////////////////////////
//:: Epic Spell: Godsmite
//:: Author: Boneshank (Don Armstrong)

#include "prc_alterations"
//#include "x2_inc_spellhook"
#include "inc_epicspells"
#include "x0_i0_position"

void main()
{
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    object oCaster = OBJECT_SELF;
    if(GetCanCastSpell(oCaster, SPELL_EPIC_GODSMIT))
    {
        //Declare major variables
        object oTarget = PRCGetSpellTargetObject();
        int nSpellPower = GetTotalCastingLevel(oCaster);

        int nDam, iCAling, iTAling;
        object oArea = GetArea(oTarget);
        location lTarget;

        // if this option has been enabled, the caster will take backlash damage
        if(GetPRCSwitch(PRC_EPIC_BACKLASH_DAMAGE))
        {
            effect eCast = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
            int nDamage = d4(nSpellPower);
            effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
            DelayCommand(3.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eCast, oCaster));
            DelayCommand(3.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oCaster));
        }

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, PRCGetSpellId()));
        //Roll damage

        iCAling = GetAlignmentGoodEvil(oCaster);
        iTAling = GetAlignmentGoodEvil(oTarget);

        if(iCAling == iTAling)
            nDam = d4(nSpellPower);
        else if(iCAling == ALIGNMENT_NEUTRAL || iTAling == ALIGNMENT_NEUTRAL)
            nDam = d6(nSpellPower);
        else
            nDam = d8(nSpellPower);

        iCAling = GetAlignmentLawChaos(oCaster);
        iTAling = GetAlignmentLawChaos(oTarget);

        if(iCAling == iTAling)
            nDam += d4(nSpellPower);
        else if(iCAling == ALIGNMENT_NEUTRAL || iTAling == ALIGNMENT_NEUTRAL)
            nDam += d6(nSpellPower);
        else
            nDam += d8(nSpellPower);

        //Set damage effect

        if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, GetEpicSpellSaveDC(oCaster, oTarget), SAVING_THROW_TYPE_SPELL, oCaster))
        {
            nDam /=2;
            // This script does nothing if it has Mettle, bail
            if(GetHasMettle(oTarget, SAVING_THROW_FORT))
                nDam = 0;
        }

        effect eDam = EffectDamage(nDam, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_PLUS_TWENTY);
        lTarget = GetRandomLocation(oArea, oTarget, 4.0);
        DelayCommand(0.4, ApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
        lTarget = GetRandomLocation(oArea, oTarget, 3.5);
        DelayCommand(0.8, ApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
        lTarget = GetRandomLocation(oArea, oTarget, 3.0);
        DelayCommand(1.2, ApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
        lTarget = GetRandomLocation(oArea, oTarget, 2.5);
        DelayCommand(1.6, ApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
        lTarget = GetRandomLocation(oArea, oTarget, 2.0);
        DelayCommand(2.0, ApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
        lTarget = GetRandomLocation(oArea, oTarget, 1.5);
        DelayCommand(2.4, ApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
        lTarget = GetRandomLocation(oArea, oTarget, 1.0);
        DelayCommand(2.7, ApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
        lTarget = GetRandomLocation(oArea, oTarget, 0.5);
        DelayCommand(3.0, ApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
        ApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), GetLocation(oTarget));
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BIGBYS_INTERPOSING_HAND), oTarget, 0.75, TRUE, -1, nSpellPower);
        DelayCommand(0.75, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BIGBYS_GRASPING_HAND), oTarget, 1.0, TRUE, -1, nSpellPower));
        DelayCommand(1.75, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BIGBYS_CLENCHED_FIST), oTarget, 0.75, TRUE, -1, nSpellPower));
        DelayCommand(2.5, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BIGBYS_CRUSHING_HAND), oTarget, 1.0, TRUE, -1, nSpellPower));
        DelayCommand(3.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_HIT_DIVINE), oTarget));
        DelayCommand(3.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_STONE_MEDIUM), oTarget));
        DelayCommand(3.1, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
    }
    PRCSetSchool();
}
