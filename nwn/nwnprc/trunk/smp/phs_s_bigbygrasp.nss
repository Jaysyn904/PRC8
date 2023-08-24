/*:://////////////////////////////////////////////
//:: Spell Name Bigby's Grasping Hand
//:: Spell FileName PHS_S_BigbyGrasp
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Force]
    Level: Sor/Wiz 7, Strength 7
    Components: V, S, F/DF
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: Large hand
    Duration: 1 round/level (D)
    Saving Throw: None
    Spell Resistance: Yes

    This spell functions like interposing hand, except the hand can also grapple
    one opponent that you select. The grasping hand gets one grapple attack per
    round.

    Its attack bonus to make contact equals your caster level + your
    Intelligence, Wisdom, or Charisma modifier (for wizards, clerics, and
    sorcerers, respectively), +10 for the hand’s Strength score (31), -1 for
    being Large. Its grapple bonus is this same figure, except with a +4
    modifier for being Large instead of -1. The hand holds but does not harm
    creatures it grapples.

    The grasping hand can also bull rush an opponent as forceful hand does, but
    at a +16 bonus on the Strength check (+10 for Strength 31, +4 for being
    Large, and a +2 bonus for charging, which it always gets), or interpose
    itself as interposing hand does.

    Clerics who cast this spell name it for their deities.

    Arcane Focus: A leather glove.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Grapple:

    Use grapple function, need to attack if we didn't sucessfully hit and grapple
    last time.

    And we will stop them moving using Entangle, for now.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_BIGBY"

void main()
{
    // Spell Hook Check
    if(!PHS_SpellHookCheck()) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nSpellId = GetSpellId();

    // Duration - 1 round/level
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Do interposing hand
    if(nSpellId == PHS_SPELL_BIGBYS_GRASPING_HAND_INTERPOSING)
    {
        ApplyInterposingHand(oTarget, nSpellId, fDuration, oCaster);
    }
    // Do forceful hand
    else if(nSpellId == PHS_SPELL_BIGBYS_GRASPING_HAND_FORCEFUL)
    {
        // +16 bonus to the forceful hand pushback.
        ApplyForcefulHand(oTarget, 16, nSpellId, fDuration, oCaster);
    }
    // Do grasping hand
    else if(nSpellId == PHS_SPELL_BIGBYS_GRASPING_HAND_GRASPING)
    {
        // Do the grasping hand.
        // Attack bonus: Caster Level + Ability Bonus + 10 (STR) - 1 (Large).
        // Grapple bonus: Caster Level + Ability Bonus + 10 (STR) + 4 (Large, grapple).
        int nBonus = nCasterLevel + PHS_GetAppropriateAbilityBonus() + 10;
        // We add 4 for grapple, -1 for attack.
        ApplyGraspingHand(oTarget, nBonus - 1, nBonus + 4, nSpellId, fDuration, oCaster);
    }
}
