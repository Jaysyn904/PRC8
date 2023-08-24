/*:://////////////////////////////////////////////
//:: Spell Name Bestow Curse
//:: Spell FileName SMP_S_BestowCurs
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy
    Level: Clr 3, Sor/Wiz 4
    Components: V, S
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: Permanent
    Saving Throw: Will negates
    Spell Resistance: Yes

    You place a curse on the subject, if they were not already cursed. Choose
    one of the following three effects.

    • -6 decrease to an ability score (minimum 3).
    • -4 penalty on attack rolls, saves, and skill checks.
    • Each turn, the target has a 50% chance to act normally; otherwise, it takes
      no action.

    The curse bestowed by this spell cannot be dispelled, but it can be removed
    with a break enchantment, limited wish, miracle, remove curse, or wish
    spell.

    Bestow curse counters remove curse.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As above. The 3rd effect is taken as a delayed effect (and a visual makes
    sure it is kept going) via. DelayCommand and a function here.

    Set the ability type in the spell menu (defaults to strength)

    Note:
    - The first one can be setup in the spells menu.
    - The 3 options are 3 subdial choices.

//:://////////////////////////////////////////////
//:: Spell Turning Notes
//:://////////////////////////////////////////////
    This is like Baleful polymorph. Some parts of the final effects are moved
    into a function and so on.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

const int SMP_BESTOW_CURSE_ABILITY = 0;
const int SMP_BESTOW_CURSE_ROLLS   = 1;
const int SMP_BESTOW_CURSE_RANDOM  = 2;

// This is executed after 6 seconds, or 60 seconds. It will 50% of the time make
// the creature immobile via. Uncommandable.
// - When uncommandable, they have a pesudo-heartbeat run on them which will
//   remove the uncommandableness if they get the curse removed
void DoRandomCurseBehaviour(object oTarget, int nCastTimes);
// Spellturning implimented effects
void DoEffects(object oTarget, effect eDur, effect eVis, int nSpellId, int nSpellSaveDC, object oCaster = OBJECT_SELF);

void main()
{
    // Spell hook check.
    if(!SMP_SpellHookCheck()) return;

    // Declare major variables.
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nSpellId = GetSpellId();

    // Make sure they are not immune to spells
    if(SMP_TotalSpellImmunity(oTarget)) return;

    // We link cirtain effects and apply eLink
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eCurse;

    // -4 penalty on attack rolls, saves, ability checks, and skill checks.
    if(nSpellId == SMP_SPELL_BESTOW_CURSE_ROLLS)
    {
        effect eRollsSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 4);
        effect eRollsSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, 4);
        effect eRollsAttack = EffectAttackDecrease(4);
        // Link them - No visual
        eCurse = EffectLinkEffects(eRollsSkill, eRollsSave);
        eCurse = EffectLinkEffects(eCurse, eRollsAttack);
    }
    // Each turn, the target has a 50% chance to act normally; otherwise, it
    // takes no action.
    else if(nSpellId == SMP_SPELL_BESTOW_CURSE_CHANCE_NO_ACTION)
    {
        // Only a visual
        eCurse = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    }
    // Default to ability
    else// if(nSpellId == SMP_SPELL_BESTOW_CURSE_ABILITY)
    {
        // Ability decrease in a stored constant, else strength.
        int nAbility = SMP_GetLocalConstant(oCaster, "SMP_BESTOW_CURSE_ABIlITY_TYPE");

        // Apply effects
        // - The function defaults to strength
        eCurse = SMP_SpecificAbilityCurse(nAbility, 6);
    }

    // Make it supernatural
    eCurse = SupernaturalEffect(eCurse);

    // Check PvP
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Signal spell cast at event
        SMP_SignalSpellCastAt(oTarget, SMP_SPELL_BESTOW_CURSE);

        // Check spell resistance
        if(!SMP_SpellResistanceCheck(oCaster, oTarget))
        {
            // Check spell turning
            int nSpellTurning = SMP_SpellTurningCheck(oCaster, oTarget, SMP_ArrayGetSpellLevel(SMP_SPELL_BALEFUL_POLYMORPH, GetLastSpellCastClass()));

            // 1 = No effect
            if(nSpellTurning == 1)
            {
                // Stop
                return;
            }
            else if(nSpellTurning == 2)
            {
                // Affect the caster only, full power.
                DoEffects(oCaster, eCurse, eVis, nSpellId, nSpellSaveDC);
            }
            else if(nSpellTurning == 3)
            {
// Affects the caster OR the target, a % type thing. Set on local that can be
// retrieved. If damaging, part damage each. If not, % chance to affect either.
                // Get the %. This one it is a chance of affecting us...
                int nFraction = FloatToInt(GetLocalFloat(oCaster, SMP_SPELL_TURNING_FRACTION) * 100);

                // Check
                // - If the d100 is LESS then nFaction, it is GOOD for the target -
                //   thus we affect the caster. Else, affect the target normally.
                if(d100() <= nFraction)
                {
                    DoEffects(oCaster, eCurse, eVis, nSpellId, nSpellSaveDC);
                }
                else
                {
                    DoEffects(oTarget, eCurse, eVis, nSpellId, nSpellSaveDC);
                }
            }
            else //if(nSpellTurning == 4)
            {
                // 4 = Spell affects both people equally at full effect.
                DoEffects(oTarget, eCurse, eVis, nSpellId, nSpellSaveDC);
                DoEffects(oCaster, eCurse, eVis, nSpellId, nSpellSaveDC);
            }
        }
    }
}

// This is executed after 6 seconds, or 60 seconds. It will 50% of the time make
// the creature immobile via. Uncommandable.
// - When uncommandable, they have a pesudo-heartbeat run on them which will
//   remove the uncommandableness if they get the curse removed
void DoRandomCurseBehaviour(object oTarget, int nCastTimes)
{
    // Check if they have the spells effects + is valid
    if(GetHasSpellEffect(SMP_SPELL_BESTOW_CURSE_CHANCE_NO_ACTION, oTarget) &&
      !GetIsDead(oTarget) && GetIsObjectValid(oTarget) &&
       GetLocalInt(oTarget, "SMP_BESTOW_CURSE_TIMES_CAST_ON") == nCastTimes)
    {
        // 50% chance of no moving this turn
        if(d100() <= 50)
        {
            // Fail!
            FloatingTextStringOnCreature("The curse causes you to take no action this turn!", oTarget, FALSE);

            // Apply a tempoary undispellable stais effect
            effect eStop = EffectCutsceneImmobilize();
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStop, oTarget, 5.9);
        }
        else
        {
            // Pass!
            FloatingTextStringOnCreature("The curse lets you take a normal action this turn.", oTarget, FALSE);
        }
        // Another check 6 seconds from now.
        DelayCommand(6.0, DoRandomCurseBehaviour(oTarget, nCastTimes));
    }
    else
    {
        SMP_SetCommandableOnSafe(oTarget, SMP_SPELL_BESTOW_CURSE);
    }
}

// Spellturning implimented effects
void DoEffects(object oTarget, effect eDur, effect eVis, int nSpellId, int nSpellSaveDC, object oCaster = OBJECT_SELF)
{
    int bContinue = TRUE;
    if(oTarget == oCaster)
    {
        bContinue = SMP_SpellResistanceCheck(oCaster, oTarget);
    }
    if(bContinue)
    {
        // Times we have cast this spell stops the pesudo-turn checking running
        // more then at once on a target
        int nTimesCast = SMP_IncreaseStoredInteger(oTarget, "SMP_BESTOW_CURSE_TIMES_CAST_ON");

        // Duration is permament (supernatural effect too)

        // Check if they have the effects already.
        if(GetHasSpellEffect(SMP_SPELL_BESTOW_CURSE, oTarget) ||
           GetHasSpellEffect(SMP_SPELL_BESTOW_CURSE_ROLLS, oTarget) ||
           GetHasSpellEffect(SMP_SPELL_BESTOW_CURSE_ABILITY, oTarget) ||
           GetHasSpellEffect(SMP_SPELL_BESTOW_CURSE_CHANCE_NO_ACTION, oTarget) ||
           SMP_GetHasEffect(EFFECT_TYPE_CURSE, oTarget))
        {
            return;
        }

        // Check immunity
        if(!SMP_ImmunityCheck(oTarget, IMMUNITY_TYPE_CURSED))
        {
            // Check will save
            if(!SMP_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC))
            {
                // Apply effects
                SMP_ApplyPermanentAndVFX(oTarget, eVis, eDur);

                // If it was the "Random" one, we start the check after 6
                // seconds.
                if(nSpellId == SMP_SPELL_BESTOW_CURSE_CHANCE_NO_ACTION)
                {
                    DelayCommand(6.0, DoRandomCurseBehaviour(oTarget, nTimesCast));
                }
            }
        }
    }
}

