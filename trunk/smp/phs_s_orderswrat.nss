/*:://////////////////////////////////////////////
//:: Spell Name Order’s Wrath
//:: Spell FileName PHS_S_OrdersWrat
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Casting Time: 1 standard action
    Range: Medium (20M)
    Area: Nonlawful creatures within a burst that fills a 10M. cube
    Duration: Instantaneous (1 round); see text
    Saving Throw: Will partial; see text
    Spell Resistance: Yes

    You channel lawful power to smite enemies. The power takes the form of a
    three-dimensional grid of energy. Only chaotic and neutral (not lawful)
    creatures are harmed by the spell.

    The spell deals 1d8 points of damage per two caster levels (maximum 5d8) to
    chaotic creatures (or 1d6 points of damage per caster level, maximum 10d6,
    to chaotic outsiders) and causes them to be dazed for 1 round. A successful
    Will save reduces the damage to half and negates the daze effect.

    The spell deals only half damage to creatures who are neither chaotic nor
    lawful, and they are not dazed. They can reduce the damage in half again
    (down to one-quarter of the roll) with a successful Will save.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Lawful = No damage
    Neutral = Half damage, can quarter on a will save. Never Dazed.
    Chaotic = Full damage, can half on a will save. Dazed on fail.

    Divine damage.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_ORDERS_WRATH)) return;

    // Delcare major variables.
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = GetCasterLevel(oCaster);
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nAlignment, nDam;
    int nSpellSaveDC = GetSpellSaveDC();
    float fDelay;

    // fDuration is 1 round for daze
    float fDuration = PHS_GetDuration(PHS_ROUNDS, 1, nMetaMagic);

    // Delcare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eVisDaze = EffectVisualEffect(VFX_IMP_DAZED_S);
    effect eDaze = EffectSlow();
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eLink = EffectLinkEffects(eDaze, eDur);
    eLink = EffectLinkEffects(eLink, eVisDaze);

    // how much damage dice?
    // 1d8 damage/2 caster levels. We do 1d6/caster level to outsiders
    int nOutsiderDice = PHS_LimitInteger(nCasterLevel, 10);

    // Normal dice will be nOutsiderDice/2, or 1 per 2 caster levels.
    int nNormalDice = PHS_LimitInteger(nOutsiderDice/2);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(PHS_VFX_FNF_ORDERS_WRATH);
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Loop all targets in the cube - 10x10M, put 5.0M in
    oTarget = GetFirstObjectInShape(SHAPE_CUBE, 5.0, lTarget, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        // Alignment check and PvP check
        nAlignment = GetAlignmentLawChaos(oTarget);
        if(nAlignment != ALIGNMENT_LAWFUL && !GetIsReactionTypeFriendly(oTarget))
        {
            // Signal spell cast at
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_ORDERS_WRATH);

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
            // - Lawful Saving throw.
            // If we SAVE it does half damage - no slow
            if(PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_LAW))
            {
                // No slow - half damage
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

                // If not alignment neutral, we apply daze as they failed the save.
                if(nAlignment != ALIGNMENT_NEUTRAL)
                {
                    // Apply daze for fDuration, and instantly!
                    PHS_ApplyDuration(oTarget, eLink, fDuration);
                }
            }
        }
        // Get next target
        oTarget = GetNextObjectInShape(SHAPE_CUBE, 5.0, lTarget, TRUE);
    }
}
