/*:://////////////////////////////////////////////
//:: Spell Name Bigby's Interposing Hand
//:: Spell FileName PHS_S_BigbyInter
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Force]
    Level: Sor/Wiz 5
    Components: V, S, F
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: Large hand
    Duration: 1 round/level (D)
    Saving Throw: None
    Spell Resistance: Yes

    Interposing hand creates a Large magic hand that appears at the position of
    one opponent. This floating, disembodied hand then moves to block that
    enemies attacks against other creatures, regardless of how the opponent
    tries to get around it, which has the effect of reducing the targets attack
    rolls by 4.

    Disintegrate or a successful dispel magic destroys the hand.

    Any creature weighing 2,000 pounds or less that tries to moves is slowed to
    half its normal speed. The hand cannot reduce the speed of a creature
    weighing more than 2,000 pounds, but it still affects the creature’s attacks.

    Focus: A soft glove.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Ok, interposing hand:

    -4 Attack (And possibly 50% movement speed decrease depending on weight
      of the target)
    Is destroyed by Dintegrate damage on the target

    Currently, however, it cannot be redirected. Might add this in, of course...

    Oh, and no save, but SR applies as normal (and nothing else, not even a
    touch attack, is required).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_BIGBY"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck()) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration - 1 round/level
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // PvP check
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Spell resistance check
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Use function
            ApplyInterposingHand(oTarget, PHS_SPELL_BIGBYS_INTERPOSING_HAND, fDuration, oCaster);
        }
    }
}
