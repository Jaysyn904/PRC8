/*:://////////////////////////////////////////////
//:: Spell Name Bless
//:: Spell FileName SMP_S_Bless
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Compulsion) [Mind-Affecting]
    Level: Clr 1, Pal 1
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: 10M. (30-ft.)
    Area: The caster and all allies within a 10M. burst (30-ft.), centered
          on the caster
    Duration: 1 min./level
    Saving Throw: None
    Spell Resistance: Yes (harmless)

    Bless fills your allies with courage. Each ally gains a +1 morale bonus on
    attack rolls and on saving throws against fear effects.

    Bless counters and dispels bane.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Dispels bane, or adds +1 to attack rolls and feat effects.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(SMP_SpellHookCheck()) return;

    // Define ourselves.
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lSelf = GetLocation(oCaster);
    int nCasterLevel = SMP_GetCasterLevel();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    float fDelay;
    // Duration in minutes
    float fDuration = SMP_GetDuration(SMP_MINUTES, nCasterLevel, nMetaMagic);

    // Effect - attack +1, effect +1 save vs. fear.
    effect eAttack = EffectAttackIncrease(1);
    effect eMorale = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eAttack, eMorale);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eVis);

    // This is the dispell effect used when they have bane.
    effect eDispel = EffectVisualEffect(VFX_IMP_HEAD_HOLY);

    // AOE visual applied.
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
    SMP_ApplyLocationVFX(lSelf, eImpact);

    // Loop allies - and apply the effects. AOE is 30ft, 10M
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_30, lSelf);
    while(GetIsObjectValid(oTarget))
    {
        // Only affects friends
        if((GetIsFriend(oTarget) || GetFactionEqual(oTarget) || oTarget == oCaster) &&
        // Make sure they are not immune to spells
           !SMP_TotalSpellImmunity(oTarget))
        {
            //Fire cast spell at event for the specified target
            SMP_SignalSpellCastAt(oTarget, SMP_SPELL_BLESS, FALSE);

            // Delay for visuals and effects.
            fDelay = GetDistanceBetween(oCaster, oTarget)/20;

            // Remove bane - dispells it.
            if(SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_BANE, oTarget, fDelay))
            {
                // Apply effect if we remove any.
                DelayCommand(fDelay, SMP_ApplyVFX(oTarget, eDispel));
            }
            else
            {
                // Apply the VFX impact and effects
                DelayCommand(fDelay, SMP_ApplyVFX(oTarget, eVis));
                SMP_ApplyDuration(oTarget, eLink, fDuration);
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_30, lSelf);
    }
}
