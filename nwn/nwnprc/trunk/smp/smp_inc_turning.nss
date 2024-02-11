/*:://////////////////////////////////////////////
//:: Name Spell Turning Include
//:: FileName SMP_INC_TURNING
//:://////////////////////////////////////////////
    This includes the functions to let spells turn back from the target
    to the caster!

    From 3.5 rules:

    Spell Turning
    Abjuration
    Level: Luck 7, Magic 7, Sor/Wiz 7
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: Until expended or 10 min./level

    Spells and spell-like effects targeted on you are turned back upon the
    original caster. The abjuration turns only spells that have you as a target.
    Effect and area spells are not affected. Spell turning also fails to stop
    touch range spells.

    From seven to ten (1d4+6) spell levels are affected by the turning. The
    exact number is rolled secretly.

    When you are targeted by a spell of higher level than the amount of spell
    turning you have left, that spell is partially turned. The subtract the
    amount of spell turning left from the spell level of the incoming spell,
    then divide the result by the spell level of the incoming spell to see what
    fraction of the effect gets through. For damaging spells, you and the caster
    each take a fraction of the damage. For nondamaging spells, each of you has
    a proportional chance to be affected.

    If you and a spellcasting attacker are both warded by spell turning effects
    in operation, a resonating field is created.

    Roll randomly to determine the result.

    d%          Effect
    01-70       Spell drains away without effect.
    71-80       Spell affects both of you equally at full effect.
    81-97       Both turning effects are rendered nonfunctional for 1d4 minutes.
    98-100      Both of you go through a rift into another plane.

    Arcane Material Component: A small silver mirror.

//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: October
//::////////////////////////////////////////////*/

// Note: Need to complete

const string SMP_SPELL_TURNING_TEMP_OFF = "SMP_SPELL_TURNING_TEMP_OFF";
const string SMP_SPELL_TURNING_AMOUNT   = "SMP_SPELL_TURNING_AMOUNT";
const string SMP_SPELL_TURNING_FRACTION = "SMP_SPELL_TURNING_FRACTION";
const string SMP_RIFT_TARGET            = "SMP_RIFT_TARGET";

#include "SMP_INC_CONSTANT"

// SMP_INC_TURNING. This checks for the spell "Spell Turning" and does a check
// based on it. Each spell has to be done on a case-by-case basis.
// It will return:
// 0 = No effect - (EG: Not present), should affect target normally.
// 1 = Spell drains away without effect.
//     (Can be: Both turning effects are rendered nonfunctional for 1d4 minutes.)
//     (Can be: Both of you go through a rift into another plane.)
// 2 = Affect the caster only, full power.
// 3 = Affects the caster OR the target, a % type thing. Set on local that can be
//     retrieved. If damaging, part damage each. If not, % chance to affect either.
// 4 = Spell affects both people equally at full effect.
// * The remaing power is automatically decreased.
int SMP_SpellTurningCheck(object oCaster, object oTarget, int nSpellLevel, float fDelay = 0.0);

// SMP_INC_TURNING. Remove all effects from SMP_SPELL_SPELL_TURNING
void SMP_SpellTurningRemoveSpellTurning(object oTarget);

// SMP_INC_TURNING. Sends both players to the rift, IF THERE IS ONE.
// * TRUE if they are moved to the rift.
int SMP_SpellTurningMoveToRift(object oCaster, object oTarget);

// SMP_INC_TURNING. Renders both non-functional for the time
void SMP_SpellTurningRenderTurningUnfunctonal(object oCaster, object oTarget);

// SMP_INC_TURNING. Decreases the stored integer by 1
// * Deletes if it would be 0.
void SMP_SpellTurningReduceInteger(object oTarget, string sStored);

// This checks for the spell "Spell Turning" and does a check
// based on it. Each spell has to be done on a case-by-case basis.
// It will return:
// 0 = No effect - (EG: Not present), should affect target normally.
// 1 = Spell drains away without effect.
//     (Can be: Both turning effects are rendered nonfunctional for 1d4 minutes.)
//     (Can be: Both of you go through a rift into another plane.)
// 2 = Affect the caster only, full power.
// 3 = Affects the caster OR the target, a % type thing. Set on local that can be
//     retrieved. If damaging, part damage each. If not, % chance to affect either.
// 4 = Spell affects both people equally at full effect.
// * The remaing power is automatically decreased.
int SMP_SpellTurningCheck(object oCaster, object oTarget, int nSpellLevel, float fDelay = 0.0)
{
    // Does the target have the effects
    if(GetHasSpellEffect(SMP_SPELL_SPELL_TURNING, oTarget) &&
      !GetLocalInt(oTarget, SMP_SPELL_TURNING_TEMP_OFF))
    {
        // We first check if they already have spell turning too (and it is
        // activated) If so, will maybe do one of 4 random things!
        if(GetHasSpellEffect(SMP_SPELL_SPELL_TURNING, oCaster) &&
          !GetLocalInt(oCaster, SMP_SPELL_TURNING_TEMP_OFF))
        {
/*
    d%          Effect
    01-70       Spell drains away without effect.
    71-80       Spell affects both of you equally at full effect.
    81-97       Both turning effects are rendered nonfunctional for 1d4 minutes.
    98-100      Both of you go through a rift into another plane.
*/
            // Roll dice
            int nDice = d100();

            // "Spell drains away without effect." - return 1
            if(nDice <= 70)
            {
                return 1;
            }
            // "Spell affects both of you equally at full effect." - return 4
            else if(nDice <= 80)
            {
                return 4;
            }
            // "Both turning effects are rendered nonfunctional for 1d4 minutes." - return 1
            else if(nDice <= 97)
            {
                // We set an integer for a cirain amount of time
                SMP_SpellTurningRenderTurningUnfunctonal(oCaster, oTarget);
                return 1;
            }
            // "Both of you go through a rift into another plane." - return 1
            else //if(nDice <= 100)
            {
                // Use function
                SMP_SpellTurningMoveToRift(oCaster, oTarget);
                return 1;
            }
        }
        // Must be, of course, not a cantrip
        else if(nSpellLevel > 0)
        {
            // Normal spell turning!
            int nTurnPower = GetLocalInt(oTarget, SMP_SPELL_TURNING_AMOUNT);

            // Get new power - this minus spell level
            int nNewPower = nTurnPower - nSpellLevel;

            // Remove now, if <= 0
            if(nNewPower <= 0)
            {
                // Remove it
                SMP_SpellTurningRemoveSpellTurning(oTarget);
            }

            // We check the spell power
            if(nNewPower >= 0)
            {
                // If we have any normal left, we "rebound" normally...
                // return 2 - Affect the caster only, full power.
                return 2;
            }
            else //if(nNewPower < 0)
            {
/*              Must be a fraction.
    When you are targeted by a spell of higher level than the amount of spell
    turning you have left, that spell is partially turned. The subtract the
    amount of spell turning left from the spell level of the incoming spell,
    then divide the result by the spell level of the incoming spell to see what
    fraction of the effect gets through. For damaging spells, you and the caster
    each take a fraction of the damage. For nondamaging spells, each of you has
    a proportional chance to be affected.
*/
                // Divide by spell level
                float fFraction = IntToFloat(nNewPower) / IntToFloat(nSpellLevel);

                // Set it
                SetLocalFloat(oCaster, SMP_SPELL_TURNING_FRACTION, fFraction);

// 3 = Affects the caster OR the target, a % type thing. Set on local that can be
//     retrieved. If damaging, part damage each. If not, % chance to affect either.
                return 3;
            }
        }
        else
        {
            // Can trip, always stop
            // return 2 - Affect the caster only, full power.
            return 2;
        }
    }
    // Return nothing - error
    return FALSE;
}

// Remove all effects from SMP_SPELL_SPELL_TURNING
void SMP_SpellTurningRemoveSpellTurning(object oTarget)
{
    //Declare major variables
    effect eCheck = GetFirstEffect(oTarget);;
    //Search through the valid effects on the target.
    while(GetIsEffectValid(eCheck))
    {
        //If the effect was created by the spell then remove it
        if(GetEffectSpellId(eCheck) == SMP_SPELL_SPELL_TURNING)
        {
            RemoveEffect(oTarget, eCheck);
        }
        //Get next effect on the target
        eCheck = GetNextEffect(oTarget);
    }
}

// Sends both players to the rift, IF THERE IS ONE.
// * TRUE if they are moved to the rift.
int SMP_SpellTurningMoveToRift(object oCaster, object oTarget)
{
    object oWP = GetObjectByTag(SMP_RIFT_TARGET);
    if(GetIsObjectValid(oWP))
    {
        location lWP = GetLocation(oWP);
        // Move the caster
        AssignCommand(oCaster, ClearAllActions());
        AssignCommand(oCaster, JumpToLocation(lWP));
        // Move the target
        AssignCommand(oTarget, ClearAllActions());
        AssignCommand(oTarget, JumpToLocation(lWP));
        return TRUE;
    }
    return FALSE;
}


// Renders both non-functional for the time
void SMP_SpellTurningRenderTurningUnfunctonal(object oCaster, object oTarget)
{
    // 1d4 minutes - same for both
    float fMinutes = TurnsToSeconds(d4());

    // We increase the stored integer by 1 for caster
    int nStored = GetLocalInt(oCaster, SMP_SPELL_TURNING_TEMP_OFF) + 1;
    SetLocalInt(oCaster, SMP_SPELL_TURNING_TEMP_OFF, nStored);

    // We increase the stored integer by 1 for target
    nStored = GetLocalInt(oTarget, SMP_SPELL_TURNING_TEMP_OFF) + 1;
    SetLocalInt(oTarget, SMP_SPELL_TURNING_TEMP_OFF, nStored);

    // Delay the reduction.
    DelayCommand(fMinutes, SMP_SpellTurningReduceInteger(oCaster, SMP_SPELL_TURNING_TEMP_OFF));
    DelayCommand(fMinutes, SMP_SpellTurningReduceInteger(oTarget, SMP_SPELL_TURNING_TEMP_OFF));
}

// Decreases the stored integer by 1
// * Deletes if it would be 0.
void SMP_SpellTurningReduceInteger(object oTarget, string sStored)
{
    int nInteger = GetLocalInt(oTarget, SMP_SPELL_TURNING_TEMP_OFF) - 1;
    if(nInteger <= 0)
    {
        DeleteLocalInt(oTarget, SMP_SPELL_TURNING_TEMP_OFF);
    }
    else
    {
        SetLocalInt(oTarget, SMP_SPELL_TURNING_TEMP_OFF, nInteger);
    }
}

// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
