/*:://////////////////////////////////////////////
//:: Spell Name Bigby's Crushing Hand
//:: Spell FileName PHS_S_BigbysCrus
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Force]
    Level: Sor/Wiz 9, Strength 9
    Components: V, S, M, F/DF
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: Large hand
    Duration: 1 round/level (D)
    Saving Throw: None
    Spell Resistance: Yes

    This spell functions like interposing hand, except that the hand can interpose
    itself, push, or crush one opponent that you select.

    The crushing hand can grapple an opponent like grasping hand does. Its grapple
    bonus equals your caster level + your Intelligence, Wisdom, or Charisma
    modifier (for a wizard, cleric, or sorcerer, respectively), +12 for the
    hand’s Strength score (35), +4 for being Large. The hand deals 2d6+12 points
    of damage on each successful grapple check against an opponent.

    The crushing hand can also interpose itself as interposing hand does, or it
    can bull rush an opponent as forceful hand does, but at a +18 bonus on the
    Strength check (+12 for Strength 35, +4 for being Large, and a +2 bonus for
    charging, which it always gets).

    Clerics who cast this spell name it for their deities.

    Arcane Material Component: The shell of an egg.

    Arcane Focus: A glove of snakeskin.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Similar to Grasping Hand, as in the grapple checks and stuff (attack bonuses
    etc).

    And does damage in addition to holding.
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
    if(nSpellId == PHS_SPELL_BIGBYS_CRUSHING_HAND_INTERPOSING)
    {
        ApplyInterposingHand(oTarget, nSpellId, fDuration, oCaster);
    }
    // Do forceful hand
    else if(nSpellId == PHS_SPELL_BIGBYS_CRUSHING_HAND_FORCEFUL)
    {
        // +16 bonus to the forceful hand pushback.
        ApplyForcefulHand(oTarget, 16, nSpellId, fDuration, oCaster);
    }
    // Do grasping hand
    else if(nSpellId == PHS_SPELL_BIGBYS_CRUSHING_HAND_CRUSHING)
    {
        // Do the crushing hand.
        // Attack bonus: Caster Level + Ability Bonus + 12 (STR) - 1 (Large).
        // Grapple bonus: Caster Level + Ability Bonus + 12 (STR) + 4 (Large, grapple).
        int nBonus = nCasterLevel + PHS_GetAppropriateAbilityBonus() + 12;
        // We add 4 for grapple, -1 for attack.
        ApplyCrushingHand(oTarget, nBonus - 1, nBonus + 4, nSpellId, fDuration, oCaster);
    }
}
