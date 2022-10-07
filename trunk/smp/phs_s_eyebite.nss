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
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_EYEBITE)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nHD, bCommandable;

    // Duration is 10 minutes/caster level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Declare effects

    // Sickened: Sudden pain and fever sweeps over the subject’s body. A sickened
    // creature takes a -2 penalty on attack rolls, weapon damage rolls, saving
    // throws, and skills. A creature affected by this spell remains sickened for
    // 10 minutes per caster level. The effects cannot be negated by a remove
    // disease or heal spell, but a remove curse is effective.
    effect eSickenedAttack = EffectAttackDecrease(2);
    effect eSickenedDamage = EffectDamageDecrease(2, DAMAGE_TYPE_NEGATIVE);
    effect eSickenedSaves = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
    effect eSickenedSkills = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
    effect eSickenedVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eSickenedCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eSickenedLink = EffectLinkEffects(eSickenedAttack, eSickenedDamage);
    eSickenedLink = EffectLinkEffects(eSickenedLink, eSickenedSaves);
    eSickenedLink = EffectLinkEffects(eSickenedLink, eSickenedSkills);
    eSickenedLink = EffectLinkEffects(eSickenedLink, eSickenedCessate);

    eSickenedLink = SupernaturalEffect(eSickenedLink);

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
    if(!GetIsReactionTypeFriendly(oTarget) &&
    // Make sure they are not immune to spells
       !PHS_TotalSpellImmunity(oTarget))
    {
        // Signal event
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_EYEBITE);

        // Check spell resistance
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Check fortitude save (Evil save)
            if(!PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_EVIL))
            {
                nHD = GetHitDice(oTarget);
                // If they fail, do effects based on hit dice

                // We always apply the sickening effect
                PHS_ApplyDurationAndVFX(oTarget, eSickenedVis, eSickenedLink, fDuration);

                // Anything at 9 or under is feared
                if(nHD <= 9)
                {
                    // Apply sickening effect
                    PHS_ApplyDuration(oTarget, ePanickedLink, fDuration);

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
                        DelayCommand(1.0, PHS_ApplyDurationAndVFX(oTarget, eComatoseVis, eComatoseLink, fDuration - 1.0));
                        // Reset commandable flag
                        SetCommandable(bCommandable, oTarget);
                    }
                }
            }
        }
    }
}
