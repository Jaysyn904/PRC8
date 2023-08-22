/*:://////////////////////////////////////////////
//:: Spell Name Dispel Alignment [Dispel Good, Evil, Lawful, Chaos]
//:: Spell FileName PHS_S_DispelAlgn
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Example from Dispel Evil. The others are the same (except the type changes,
    and the stuff dispelled/removed does too).

    Dispel Evil
    Abjuration [Good]
    Level: Clr 5, Good 5, Pal 4
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Touch
    Target: You, and touched evil creature from another plane; or an evil spell
            on a touched creature
    Duration: 1 round/level or until discharged, whichever comes first
    Saving Throw: See text
    Spell Resistance: See text

    Shimmering, white, holy energy surrounds you. This power has three possible
    effects.

    If you mage a successful melee touch attack against an evil creature you
    targeted from another plane, you try to drive that creature back to its home
    plane. The creature can negate the effects with a successful Will save (spell
    resistance applies).

    Else, if you touch someone with an evil spell's effects upon them, you
    automatically dispel any one enchantment spell cast by an evil creature or
    any one evil spell. Exception: Spells that can’t be dispelled by dispel magic
    also can’t be dispelled by dispel evil. Saving throws and spell resistance
    do not apply to this effect.

    If you do neither of the above (no presence of an evil spell), you gain a +4
    deflection bonus to AC against attacks by evil creatures.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Ok, dispels a cirtain alignment.

    Visuals:
    Dispel Evil: Shimmering, white, holy energy surrounds you.
    Dispel Good: you are surrounded by dark, wavering, unholy energy,
    Dispel Chaos: you are surrounded by constant, blue, lawful energy,
    Dispel Law: except that you are surrounded by flickering, yellow, chaotic energy

    It first tries to make the outsider creature of the alignment specfied go.

    Then, it will attempt to dispel an evil spell.

    Failing that (no evil spells present) it will apply the effects.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Get what spell is being cast
    int nSpellId = GetSpellId();
    int nAlignment, bGoodEvil, nVFX, nSaveType;

    if(nSpellId == PHS_SPELL_DISPEL_CHAOS)
    {
        nAlignment = ALIGNMENT_CHAOTIC;
        bGoodEvil = FALSE;
        nVFX = PHS_VFX_DUR_DISPEL_CHAOS;
        nSaveType = SAVING_THROW_TYPE_CHAOS;
    }
    else if(nSpellId == PHS_SPELL_DISPEL_EVIL)
    {
        nAlignment = ALIGNMENT_EVIL;
        bGoodEvil = TRUE;
        nVFX = PHS_VFX_DUR_DISPEL_EVIL;
        nSaveType = SAVING_THROW_TYPE_EVIL;
    }
    else if(nSpellId == PHS_SPELL_DISPEL_GOOD)
    {
        nAlignment = ALIGNMENT_GOOD;
        bGoodEvil = TRUE;
        nVFX = PHS_VFX_DUR_DISPEL_GOOD;
        nSaveType = SAVING_THROW_TYPE_GOOD;
    }
    else if(nSpellId == PHS_SPELL_DISPEL_LAW)
    {
        nAlignment = ALIGNMENT_LAWFUL;
        bGoodEvil = FALSE;
        nVFX = PHS_VFX_DUR_DISPEL_LAW;
        nSaveType = SAVING_THROW_TYPE_LAW;
    }
    else
    {
        return;
    }

    // Spell Hook Check.
    if(!PHS_SpellHookCheck(nSpellId)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration in rounds
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Delcare effects
    effect eUnsummonVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
    effect eDispelVis = EffectVisualEffect(VFX_IMP_DISPEL);
    effect eAC = EffectACIncrease(4, AC_DEFLECTION_BONUS);
    effect eDur = EffectVisualEffect(nVFX);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eAC, eDur);
    eLink = EffectLinkEffects(eAC, eCessate);

    // VS what alignment to make eLink?
    if(bGoodEvil == TRUE)
    {
        eLink = VersusAlignmentEffect(eLink, ALIGNMENT_ALL, nAlignment);
    }
    else
    {
        eLink = VersusAlignmentEffect(eLink, nAlignment, ALIGNMENT_ALL);
    }

    // Signal Spell cast at the target
    PHS_SignalSpellCastAt(oTarget, nSpellId);

    // Check if they are an outsider of the specfified alignment
    if(GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER)
    {
        // We always try and "unsummon" even if they are not the correct alignment,
        // as we don't want our paladin going up to a reformed demon, trying to
        // dispel evil and actually dispelling an spell effect from them.

        if(bGoodEvil == TRUE)
        {
            if(GetAlignmentGoodEvil(oTarget) != nAlignment) return;
        }
        else
        {
            if(GetAlignmentLawChaos(oTarget) != nAlignment) return;
        }

        // No special visual

        // PvP Check and touch result
        // Touch attack required
        if(!GetIsReactionTypeFriendly(oTarget) && PHS_SpellTouchAttack(PHS_TOUCH_MELEE, oTarget, TRUE))
        {
            // Spell Resistance + Immunity check
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Saving throw check vs. will.
                if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, nSaveType))
                {
                    // Um, go
                }
            }
        }
    }
    else
    {
        // Attempt to dispel evil naughty spells or those cast by evil casters
        int bResult = FALSE;
        if(bGoodEvil == TRUE)
        {
            bResult = PHS_DispelBestSpellFromGoodEvilAlignment(oTarget, nCasterLevel, nAlignment);
        }
        else
        {
            bResult = PHS_DispelBestSpellFromLawChaosAlignment(oTarget, nCasterLevel, nAlignment);
        }
        if(bResult == TRUE)
        {
            // Dispel VFX and thats it
            PHS_ApplyVFX(oTarget, eDispelVis);
            return;
        }
        else if(bResult == 2)
        {
            // Failed to dispel
            return;
        }
        else
        {
            // We'll else apply the AC as normal
            PHS_ApplyDuration(oTarget, eDur, fDuration);
        }
    }
}
