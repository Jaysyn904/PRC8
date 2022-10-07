/*:://////////////////////////////////////////////
//:: Spell Name Holy Smite
//:: Spell FileName PHS_S_HolySmite
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Good]
    Level: Good 4
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (20M)
    Area: 6.67-M.-radius burst
    Duration: Instantaneous (1 round); see text
    Saving Throw: Will partial; see text
    Spell Resistance: Yes

    You draw down holy power to smite your enemies. Only evil and neutral
    creatures are harmed by the spell; good creatures are unaffected.

    The spell deals 1d8 points of damage per two caster levels (maximum 5d8) to
    each evil creature in the area (or 1d6 points of damage per caster level,
    maximum 10d6, to an evil outsider) and causes it to become blinded for 1
    round. A successful Will saving throw reduces damage to half and negates the
    blinded effect.

    The spell deals only half damage to creatures who are neither good nor evil,
    and they are not blinded. Such a creature can reduce that damage by half
    (down to one-quarter of the roll) with a successful Will save.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Good = No damage
    Neutral = Half damage, can quarter on a will save. Never blinded.
    Evil = Full damage, can half on a will save. Blinded on fail.

    Hits non-good people.

    Hits for up to 5d6 damage, or 10d6 VS outsiders.

    Neutrals take /2 damage.

    This is taken from Chaos Hammer's script, but replaces slow with 1 round
    blindness and changes alignemnts
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_CHAOS_HAMMER)) return;

    // Delcare major variables.
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = GetCasterLevel(oCaster);
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nAlignment, nDam;
    int nSpellSaveDC = GetSpellSaveDC();
    float fDelay;

    // Duration of blindness is 1 round
    float fDuration = PHS_GetDuration(PHS_ROUNDS, 1, nMetaMagic);

    // Delcare Effects
    effect eVis = EffectVisualEffect(VFX_COM_HIT_DIVINE);
    effect eVisBlind = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    effect eBlind = EffectBlindness();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eBlind, eDur);
    eLink = EffectLinkEffects(eLink, eVisBlind);

    // how much damage dice?
    // 1d8 damage/2 caster levels. We do 1d6/caster level to outsiders
    int nOutsiderDice = PHS_LimitInteger(nCasterLevel, 10);

    // Normal dice will be nOutsiderDice/2, or 1 per 2 caster levels.
    int nNormalDice = PHS_LimitInteger(nOutsiderDice/2);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(PHS_VFX_FNF_HOLY_SMITE);
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Loop all targets in the area.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 6.67, lTarget, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        // Alignment check and PvP check
        nAlignment = GetAlignmentGoodEvil(oTarget);
        if(nAlignment != ALIGNMENT_GOOD &&
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
            if(PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_GOOD))
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

                // If not alignment neutral, we apply blindess as they failed the save.
                if(nAlignment != ALIGNMENT_NEUTRAL)
                {
                    // Apply blindness for fDuration, and instantly!
                    PHS_ApplyDuration(oTarget, eLink, fDuration);
                }
            }
        }
        // Get next target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 6.67, lTarget, TRUE);
    }
}
