/*:://////////////////////////////////////////////
//:: Spell Name Battlecalm
//:: Spell FileName XXX_S_Battlecalm
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment [Mind-Affecting]
    Level: Clr 3
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: 6.67M (20ft.)
    Area: Caster and all allies with in a 6.67M. burst (20ft.) centered on the caster
    Duration: 1 min./level
    Saving Throw: None
    Spell Resistance: Yes (Harmless)
    Source: Various (cwslyclgh)

    Battlecalm instills a sense of serenity and calm in the face of danger to
    your allies. For  the duration of the spell all characters affected by
    battlecalm are immune to fear (magical or otherwise). This includes all
    supernatural fear effects, spells with the [Fear]  descriptor, extraordinary
    abilities that inspire fear, and so forth.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As above, this is various - might be too powerful.

    It was originally more complicated, this was the final versoin, but a suggestion
    to make it 1 min/level was included, as 1 round/level is too short for
    such a level spell.

    Otherwise, it is simply Immunity: Fear.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(SMP_SpellHookCheck(SMP_SPELL_BATTLECALM)) return;

    // Define ourselves.
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lSelf = GetLocation(oCaster);
    int nCasterLevel = SMP_GetCasterLevel();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    float fDelay;

    // Duration in minutes
    float fDuration = SMP_GetDuration(SMP_MINUTES, nCasterLevel, nMetaMagic);

    // Effect - Immunity: Fear
    effect eFear = EffectImmunity(IMMUNITY_TYPE_FEAR);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);

    // Link effects
    effect eLink = EffectLinkEffects(eFear, eDur);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_20);
    SMP_ApplyLocationVFX(lSelf, eImpact);

    // Loop allies - and apply the effects.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_20, lSelf);
    while(GetIsObjectValid(oTarget))
    {
        // Only affects friends, but all of them.
        if((GetIsFriend(oTarget) || GetFactionEqual(oTarget) || oTarget == oCaster) &&
        // Make sure they are not immune to spells
           !SMP_TotalSpellImmunity(oTarget))
        {
            // Fire cast spell at event for the specified target
            SMP_SignalSpellCastAt(oTarget, SMP_SPELL_BATTLECALM, FALSE);

            // Delay for visuals and effects.
            fDelay = GetDistanceBetween(oCaster, oTarget)/20;

            // Delay application of effects
            DelayCommand(fDelay, SMP_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration));
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_20, lSelf);
    }
}
