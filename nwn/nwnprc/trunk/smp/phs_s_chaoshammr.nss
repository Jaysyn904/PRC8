/*:://////////////////////////////////////////////
//:: Spell Name Chaos Hammer
//:: Spell FileName PHS_S_ChaosHammr
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Chaotic]
    Level: Chaos 4
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (20M)
    Area: 6.67M.-radius burst
    Duration: Instantaneous (1d6 rounds); see text
    Saving Throw: Will partial; see text
    Spell Resistance: Yes

    You unleash chaotic power to smite your enemies. The power takes the form of
    a multicolored explosion of leaping, ricocheting energy. Only lawful and
    neutral (not chaotic) creatures are harmed by the spell.

    The spell deals 1d8 points of damage per two caster levels (maximum 5d8) to
    lawful creatures (or 1d6 points of damage per caster level, maximum 10d6, to
    lawful outsiders) and slows them for 1d6 rounds (see the slow spell). A
    successful Will save reduces the damage by half and negates the slow effect.

    The spell deals only half damage against creatures who are neither lawful nor
    chaotic, and they are not slowed. Such a creature can reduce the damage by
    half again (down to one-quarter) with a successful Will save.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Chaotic = No damage
    Neutral = Half damage, can quarter on a will save. Never slowed.
    Lawful = Full damage, can half on a will save. Slowed on fail.

    Hits non-chatoic people.

    Hits for up to 5d6 damage, or 10d6 VS outsiders.

    Neutrals take /2 damage.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck()) return;

    // Delcare major variables.
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = GetCasterLevel(oCaster);
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nAlignment, nDam;
    int nSpellSaveDC = GetSpellSaveDC();
    float fDuration, fDelay;

    // Delcare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eVisSlow = EffectVisualEffect(VFX_IMP_SLOW);
    effect eSlow = EffectSlow();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eSlow, eDur);
    eLink = EffectLinkEffects(eLink, eVisSlow);

    // how much damage dice?
    // 1d8 damage/2 caster levels. We do 1d6/caster level to outsiders
    int nOutsiderDice = PHS_LimitInteger(nCasterLevel, 10);

    // Normal dice will be nOutsiderDice/2, or 1 per 2 caster levels.
    int nNormalDice = PHS_LimitInteger(nOutsiderDice/2);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(PHS_VFX_FNF_CHAOS_HAMMER);
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Loop all targets in the area.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_20, lTarget, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        // Alignment check and PvP check
        nAlignment = GetAlignmentLawChaos(oTarget);
        if(nAlignment != ALIGNMENT_CHAOTIC &&
          !GetIsReactionTypeFriendly(oTarget) &&
        // Make sure they are not immune to spells
           !PHS_TotalSpellImmunity(oTarget))
        {
            // Signal spell cast at
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_CHAOS_HAMMER);

            // Delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            // Get random damage
            if(GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER)
            {
                nDam = PHS_MaximizeOrEmpower(6, nOutsiderDice, nMetaMagic);
            }
            else
            {
                nDam = PHS_MaximizeOrEmpower(8, nNormalDice, nMetaMagic);
            }
            // Half damage if only neutral
            if(nAlignment == ALIGNMENT_NEUTRAL)
            {
                // Divide by 2.
                nDam /= 2;
            }
            // Will saving throw for half damage, and no slow.
            // - Chaos Saving throw.
            // If we SAVE it does half damage - no slow
            if(PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_CHAOS))
            {
                // No slow - hald damage
                nDam /= 2;
                if(nDam > 0)
                {
                    // Do damage and VFX
                    DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_DIVINE));
                }
            }
            else
            {
                // Else, full damage. If not neutral, slow for 1d6 rounds

                // Do damage and VFX
                DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_DIVINE));

                // If not alignment neutral, we apply slow as they failed the save.
                if(nAlignment != ALIGNMENT_NEUTRAL)
                {
                    // Apply slow instantly.
                    fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 6, 1, nMetaMagic);

                    // Apply slow for fDuration, and instantly!
                    PHS_ApplyDuration(oTarget, eLink, fDuration);
                }
            }
        }
        // Get next target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_20, lTarget, TRUE);
    }
}
