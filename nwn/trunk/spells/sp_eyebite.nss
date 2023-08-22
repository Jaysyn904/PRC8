/*:://////////////////////////////////////////////
//:: Spell Name Eyebite
//:: Spell FileName PHS_S_Eyebite
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Target: One living creature Duration: 1 round per three levels; see text
    Saving Throw: Fortitude negates Spell Resistance: Yes

    Each round, you may target a single living creature, striking it with waves
    of evil power. Depending on the target’s HD, this attack has as many as three
    effects.

    HD          Effect
    10 or more  Sickened
    5-9         Panicked, sickened
    4 or less   Comatose, panicked, sickened

    The effects are cumulative and concurrent.

    Sickened: Sudden pain and fever sweeps over the subject’s body. A sickened
    creature takes a -2 penalty on attack rolls, weapon damage rolls, saving
    throws, and skills. A creature affected by this spell remains sickened for
    10 minutes per caster level. The effects cannot be negated by a remove
    disease or heal spell, but a remove curse is effective.

    Panicked: The subject becomes panicked for for 10 minutes per caster level.
    This is a fear effect.

    Comatose: The subject falls into a catatonic standing coma for 10 minutes per
    caster level. During this time, it cannot be awakened by any means short of
    dispelling the effect. This is not a sleep effect, and thus elves are not
    immune to it.

    The spell lasts for 1 round per three caster levels. You can target a new
    target until this duration expires using the Class Item you have.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Should be as spell effect, BUT camatose is a special function with animations
    to make them "sleep"
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Converted to PRC: Stratovarius
//::////////////////////////////////////////////*/

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    // Spell hook check.
    if(!X2PreSpellCastCode()) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nPenetr = nCasterLvl + SPGetPenetr();
    int nDC = PRCGetSaveDC(oTarget, oCaster);
    int nSpellID = PRCGetSpellId();
    int nHD, bCommandable;
    
    // Duration is 10 minutes/caster level
    float fDuration = nCasterLvl * 600.0;
    if (nMetaMagic & METAMAGIC_EXTEND)
    {
    	fDuration = (fDuration * 2);
    }
    // Panicked: The subject becomes panicked for for 10 minutes per caster level.
    // This is a fear effect.
    effect ePanicked = EffectFrightened();
    effect ePanickedDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);

    effect ePanickedLink = EffectLinkEffects(ePanicked, ePanickedDur);

    // Comatose: The subject falls into a catatonic standing coma for 10 minutes per
    // caster level. During this time, it cannot be awakened by any means short of
    // dispelling the effect. This is not a sleep effect, and thus elves are not
    // immune to it.
    effect eComatosePara = EffectCutsceneParalyze();
    effect eComatoseDur = EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION);
    effect eComatoseVis = EffectVisualEffect(VFX_IMP_SLEEP);

    effect eComatoseLink = EffectLinkEffects(eComatosePara, eComatoseDur);

    // Check PvP settings
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster) && PRCGetIsAliveCreature(oTarget))
    {
        // Signal event
        PRCSignalSpellEvent(oTarget);

        // Check spell resistance
        if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
        {
            // Check fortitude save (Evil save)
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
            {
                nHD = GetHitDice(oTarget);
                // If they fail, do effects based on hit dice

                // We always apply the sickening effect
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSickened(), oTarget, fDuration, TRUE, nSpellID, nCasterLvl);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISEASE_S), oTarget);

                // Anything at 9 or under is feared
                if(nHD <= 9)
                {
                    // Apply sickening effect
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePanickedLink, oTarget, RoundsToSeconds(d4()), TRUE, nSpellID, nCasterLvl);
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectShaken(), oTarget, fDuration, TRUE, nSpellID, nCasterLvl);

                    // Anything at 4 or under is camatosed.
                    if(nHD <= 4)
                    {
                        // camatosed means, basically, a
                        // "PlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 10.0)"
                        // and then instantly apply effects to stay looping dead.
                        bCommandable = GetCommandable(oTarget);
                        if(!bCommandable) SetCommandable(TRUE, oTarget);

                        // Make them go down
                        AssignCommand(oTarget, ClearAllActions());
                        AssignCommand(oTarget, PlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 10.0));
                        // Apply duration after 1 second
                        DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eComatoseLink, oTarget, fDuration, TRUE, nSpellID, nCasterLvl));
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eComatoseVis, oTarget);
                        // Reset commandable flag
                        SetCommandable(bCommandable, oTarget);
                    }
                }
            }
        }
    }
}
