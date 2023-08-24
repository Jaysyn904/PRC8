/*:://////////////////////////////////////////////
//:: Spell Name Shield Other
//:: Spell FileName PHS_S_ShieldOth
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Range: Close (8M)
    Target: One creature
    Duration: 1 hour/level (D)

    This spell wards the subject and creates a mystic connection between you and
    the subject so that some of its wounds are transferred to you. The subject
    gains a +1 deflection bonus to AC and a +1 resistance bonus on saves.
    Additionally, the subject takes only half damage from all magical damaging
    attacks that deal hit point damage. The amount of damage not taken by the
    warded creature is taken by you. Forms of harm that do not involve hit points,
    such as charm effects, temporary ability damage, level draining, and death
    effects, are not affected. If the subject suffers a reduction of hit points
    from a lowered Constitution score, the reduction is not split with you
    because it is not hit point damage. When the spell ends, subsequent damage
    is no longer divided between the subject and you, but damage already split
    is not reassigned to the subject.

    If you and the subject of the spell move out of range of each other, the
    spell ends.

    Focus: A pair of platinum rings (worth at least 50 gp each) worn by both you
    and the warded creature.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Changed somewhat:

    - Only divides up direct magical damage
    - No monster spells affected

    No phisical damage is split either. Its still quite powerful (and, there is
    always the AC bonuses!)

    Needs a new AOE for the caster, and a VFX for the target. The AOE is actually
    totally invisible, and is just 8M diameter. If the person with the shield
    other effects moves out of the spells range, ie, out of the AOE, it gets
    instantly removed.

    Only one shield other can ever be applied to any target. It'll remove the
    effects from the target, and the creator of the targets spell effects too.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SHIELD_OTHER)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    object oRemoveCreator = PHS_FirstCasterOfSpellEffect(PHS_SPELL_SHIELD_OTHER, oTarget);
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Cannot target self
    if(oTarget == oCaster) return;

    // 1 Hour/level
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel, nMetaMagic);

    // Delcare effects
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
    effect eAC = EffectACIncrease(1, AC_DEFLECTION_BONUS);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_ALL);
    effect eDur = EffectVisualEffect(PHS_VFX_DUR_SHIELD_OTHER);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eAOE = EffectAreaOfEffect(PHS_AOE_MOB_SHIELD_OTHER);

    // Link effects for target
    effect eLink = EffectLinkEffects(eAC, eDur);
    eLink = EffectLinkEffects(eLink, eSave);
    eLink = EffectLinkEffects(eLink, eCessate);

    // remove previous castings from the creator of the spell on the target
    if(GetIsObjectValid(oRemoveCreator))
    {
        // Remove previous castings
        PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_SHIELD_OF_FAITH, oRemoveCreator);
    }
    // Remove previous castings
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_SHIELD_OF_FAITH, oTarget);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SHIELD_OF_FAITH, FALSE);
    PHS_SignalSpellCastAt(oCaster, PHS_SPELL_SHIELD_OF_FAITH, FALSE);

    // Apply effects
    PHS_ApplyDurationAndVFX(oCaster, eVis, eAOE, fDuration);
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
