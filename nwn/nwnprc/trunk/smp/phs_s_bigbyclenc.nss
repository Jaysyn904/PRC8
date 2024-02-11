/*:://////////////////////////////////////////////
//:: Spell Name Bigby's Clenched Fist
//:: Spell FileName PHS_S_BigbyClenched
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Force]
    Level: Sor/Wiz 8, Strength 8
    Components: V, S, F/DF
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: Large hand
    Duration: 1 round/level (D)
    Saving Throw: None
    Spell Resistance: Yes

    This spell functions like interposing hand, except that the hand can
    interpose itself, push, or strike one opponent that you select.

    The hand attacks once per round, and its attack bonus equals your caster
    level + your Intelligence, Wisdom, or Charisma modifier (for a wizard,
    cleric, or sorcerer, respectively), +11 for the hand’s Strength score (33),
    -1 for being Large. The hand deals 1d8+11 points of damage on each attack,
    and any creature struck must make a Fortitude save (against this spell’s
    save DC) or be stunned for 1 round.

    The clenched fist can also interpose itself as interposing hand does, or it
    can bull rush an opponent as forceful hand does, but at a +17 bonus on the
    Strength check (+11 for Strength 33, +4 for being Large, and a +2 bonus for
    charging, which it always gets).

    Clerics who cast this spell name it for their deities.

    Arcane Focus: A leather glove.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    The attack is using the attack function, if it hits, it may stun for 6
    seconds.

    Cannot be redirected, too hard, like the others.
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
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nSpellId = GetSpellId();

    // Duration - 1 round/level
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Do interposing hand
    if(nSpellId == PHS_SPELL_BIGBYS_CLENCHED_FIST_INTERPOSING)
    {
        ApplyInterposingHand(oTarget, nSpellId, fDuration, oCaster);
    }
    // Do forceful hand
    else if(nSpellId == PHS_SPELL_BIGBYS_CLENCHED_FIST_FORCEFUL)
    {
        // +18 bonus to the forceful hand pushback.
        ApplyForcefulHand(oTarget, 18, nSpellId, fDuration, oCaster);
    }
    // Do Clenched Fist
    else if(nSpellId == PHS_SPELL_BIGBYS_CLENCHED_FIST_CLENCHED)
    {
        // Clenched fist, Attack bonus of Caster Level + Ability Bonus +
        // 11 (STR) - 1 (large).
        int nBonus = nCasterLevel + PHS_GetAppropriateAbilityBonus() + 10 - 1;
        ApplyClenchedFist(oTarget, nBonus, nSpellSaveDC, nSpellId, fDuration, oCaster);
    }
}
