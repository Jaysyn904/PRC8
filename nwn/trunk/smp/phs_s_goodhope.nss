/*:://////////////////////////////////////////////
//:: Spell Name Good Hope
//:: Spell FileName phs_s_goodhope
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    1 living ally/level. 5M radius. 1 min/level. 20M range.

    The spell affects the nearest to the target location first. This spell
    instills powerful hope in the subjects. Each affected creature gains
    a +2 morale bonus on saving throws, attack rolls, skill checks, and weapon
    damage rolls.
    Good hope counters and dispels crushing despair.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Like bless really, but song!

    We apply song visual effect to the bard too, for a few seconds that is, and
    a few seconds to those affected.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_GOOD_HOPE)) return;

    // Delcare Major Variables.
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    object oTarget;
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();
    int nCnt, nTotalAffected;
    float fDelay;

    // Duration in turns
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Delcare Effects
    // "+2 morale bonus on saving throws, attack rolls, skill
    //  checks, and weapon damage rolls"
    effect eSkills = EffectSkillIncrease(SKILL_ALL_SKILLS, 2);
    effect eAttack = EffectAttackIncrease(2);
    effect eDamage = EffectDamageIncrease(2, DAMAGE_TYPE_SONIC);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // This is applied as a short visual effect.
    effect eSong = EffectVisualEffect(VFX_DUR_BARD_SONG);

    // This is the dispel effect used when they have crushing dispare.
    effect eDispel = EffectVisualEffect(VFX_IMP_HEAD_SONIC);

    effect eLink = EffectLinkEffects(eSkills, eAttack);
    eLink = EffectLinkEffects(eLink, eDamage);
    eLink = EffectLinkEffects(eLink, eSave);
    eLink = EffectLinkEffects(eLink, eDur);

    // Apply song to caster always
    PHS_ApplyDuration(oTarget, eSong, 6.0);

    // Loop targets
    nCnt = 1;
    // Get all nearest allies up to nCasterLevel.
    // - We use nearest, as GetFirst/Next object in shape may get allies we
    //   didn't want to target (although unlikely)
    oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lTarget, nCnt);
    // Loop targets - 5M radius
    while(GetIsObjectValid(oTarget) && nTotalAffected < nCasterLevel &&
          GetDistanceBetweenLocations(lTarget, GetLocation(oTarget)) <= RADIUS_SIZE_LARGE)
    {
        // Faction check
        if(GetFactionEqual(oTarget) || GetIsFriend(oTarget) || oTarget == oCaster)
        {
            // Add one to those affected
            nTotalAffected++;

            //Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_GOOD_HOPE, FALSE);

            // Delay for visuals and effects.
            fDelay = GetDistanceBetween(oCaster, oTarget)/20;

            // If we can dispel Crushing Dispare, do so
            if(PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_CRUSHING_DISPARE, oTarget, fDelay))
            {
                // Apply effect if we remove any.
                DelayCommand(fDelay, PHS_ApplyVFX(oTarget, eDispel));
            }
            else
            {
                // Remove previous castings
                PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_GOOD_HOPE, oTarget);

                // Apply the VFX impact and effects
                if(oTarget != oCaster)
                {
                    DelayCommand(fDelay, PHS_ApplyDuration(oTarget, eSong, 6.0));
                }
                // Apply link instantly
                PHS_ApplyDuration(oTarget, eLink, fDuration);
            }
        }
        // Loop targets
        nCnt++;
        // Get all nearest allies up to nCasterLevel.
        oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lTarget, nCnt);
    }
}
