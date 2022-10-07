/*:://////////////////////////////////////////////
//:: Spell Name Bigby's Forceful Hand
//:: Spell FileName PHS_S_BigbyForce
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Force]
    Level: Sor/Wiz 6
    Components: V, S, F
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: Large hand
    Duration: 1 round/level (D)
    Saving Throw: None
    Spell Resistance: Yes

    This spell functions like interposing hand, except that the forceful hand
    pushes away the opponent that you designate. Treat this attack as a bull
    rush with a +14 bonus on the Strength check (+8 for Strength 27, +4 for
    being Large, and a +2 bonus for charging, which it always gets). The
    opponent and you roll a d20, you add the +14 bonus, and the target adds
    thier own strength and size bonuses, +4 if they are steady. The hand always
    moves with the opponent to push that target back the full distance allowed.
    that is 2M per round, until they are 20M away.

    Each new round, another bull rush is attempted. If the hand is sucessful,
    it pushes the target back yet futher, if not, then the target can move
    normally.

    Focus: A sturdy glove made of leather or heavy cloth.
//:://////////////////////////////////////////////
//:: 3E Bull rush description
//:://////////////////////////////////////////////
    BULL RUSH
    You can make a bull rush as a standard action (an attack) or as part of a
    charge (see Charge, below). When you make a bull rush, you attempt to push
    an opponent straight back instead of damaging him. You can only bull rush
    an opponent who is one size category larger than you, the same size, or
    smaller.

    Initiating a Bull Rush: First, you move into the defender’s space. Doing
    this provokes an attack of opportunity from each opponent that threatens
    you, including the defender. (If you have the Improved Bull Rush feat, you
    don’t provoke an attack of opportunity from the defender.) Any attack of
    opportunity made by anyone other than the defender against you during a bull
    rush has a 25% chance of accidentally targeting the defender instead, and
    any attack of opportunity by anyone other than you against the defender
    likewise has a 25% chance of accidentally targeting you. (When someone
    makes an attack of opportunity, make the attack roll and then roll to see
    whether the attack went astray.)

    Second, you and the defender make opposed Strength checks. You each add a
    +4 bonus for each size category you are larger than Medium or a -4 penalty
    for each size category you are smaller than Medium. You get a +2 bonus if
    you are charging. The defender gets a +4 bonus if he has more than two legs
    or is otherwise exceptionally stable.

    Bull Rush Results: If you beat the defender’s Strength check result, you
    push him back 5 feet. If you wish to move with the defender, you can push
    him back an additional 5 feet for each 5 points by which your check result
    is greater than the defender’s check result. You can’t, however, exceed your
    normal movement limit. (Note: The defender provokes attacks of opportunity
    if he is moved. So do you, if you move with him. The two of you do not
    provoke attacks of opportunity from each other, however.)

    If you fail to beat the defender’s Strength check result, you move 5 feet
    straight back to where you were before you moved into his space. If that
    space is occupied, you fall prone in that space.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    We will attempt a move back

    Bull rush is simple, and there is wrappers for:

    - Bull rush check
    - Size modifier
    - Steady or not

    Forceful hand only can force them back OR interpose, not both.
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
    if(nSpellId == PHS_SPELL_BIGBYS_FORCEFUL_HAND_INTERPOSING)
    {
        ApplyInterposingHand(oTarget, nSpellId, fDuration, oCaster);
    }
    // Do forceful hand
    else if(nSpellId == PHS_SPELL_BIGBYS_FORCEFUL_HAND_FORCEFUL)
    {
        // +14 bonus to the forceful hand pushback.
        ApplyForcefulHand(oTarget, 14, nSpellId, fDuration, oCaster);
    }
}
