/*:://////////////////////////////////////////////
//:: Spell Name Detect Magic
//:: Spell FileName PHS_S_DetectMagi
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Range 60ft, (20M). A cone-shaped burst.

    for 3 rounds, you can check what stength of aura's the magic has there:

    1st Round: Presence or absence of magical auras.
    2nd Round: Number of different magical auras and the power of the most potent aura.
    3rd Round: The strength and location of each aura. If the items or creatures
               bearing the auras are in line of sight, you can make Spellcraft
               skill checks to determine the school of magic involved in each.
               (Make one check per aura; DC 15 + spell level, or 15 + half caster
               level for a nonspell effect.)

    For NwN, it detects spell effects on creatures, and magical items they hold.
    It also will check for AOE's.

    2nd round oviously tells you the power registering as the most potent, and no. of aura's.
        - Weaker aura's can be excluded randomly if near a large one!
    3rd round Then can check the strength and locaton, and spellcraft checks
              for checking which school of magic it was that cast it.


//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This will be simple if kept simple. Can only concentrate one one area, must
    stand still basically.

    The cone is done in all rounds, so things moving away may, next time, not
    appear and locations will not be revealed.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{

}

