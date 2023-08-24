/*:://////////////////////////////////////////////
//:: Spell Name Miracle
//:: Spell FileName PHS_S_Miracle
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation
    Level: Clr 9, Luck 9
    Components: V, S, XP; see text
    Casting Time: 1 standard action
    Range: See text
    Target, Effect, or Area: See text
    Duration: See text
    Saving Throw: See text
    Spell Resistance: Yes

    You don’t so much cast a miracle as request one. You state what you would
    like to have happen and request that your deity (or the power you pray to
    for spells) intercede.

    A miracle can do any of the following things.

    More description.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    See limited wish + wish. Leave for now.

    Placeholder script.

    Ideas (and can be incorporated into the others):

    • Duplicate any cleric spell of 8th level or lower (including spells to which
    you have access because of your domains).
    - Can check with, normally, GetHasFeat() for domains, and alignment as normal.
      Add a few class list arrays in maybe...
      Anyway, some kind of spoken thing would be easy enough

    • Duplicate any other spell of 7th level or lower.
    - Note: Alignment restrictions still, but pretty easy to cheat-cast a spell
      like this.

    Wording maybe listened for:
    "I want to cast Mage Armor on Tom" will assign a cheat-casting of mage armor
    at Tom, noting to make the level of the caster the same as this spells caster
    level.

    • Undo the harmful effects of certain spells, such as feeblemind or insanity.
    - Worded as normal, it'd act as a simple loop of effects on a person.
    "I want to rid feeblemind from Tom" will rid that from tom, noting that asking
    for 2 or more will only go for the first.

    • Have any effect whose power level is in line with the above effects.
    - Worded as well.

    Ideas:
    - Free someone from a curse (Undoing harmful effects) as remove curse, but
    no check on the DC.


    If the miracle has any of the above effects, casting it has no experience
    point cost.

    - Ok, lower powered effects basically, like spells, removal of bad effects.

    Alternatively, a cleric can make a very powerful request. Casting such a
    miracle costs the cleric 5,000 XP because of the powerful divine energies
    involved. Examples of especially powerful miracles of this sort could
    include the following.

    • Swinging the tide of a battle in your favor by raising fallen allies to
    continue fighting.
    - "Mass ressurection" basically. Easy to do for a loop of party (and friendly)
    members in the area. Good use for 5000XP too.

    • Moving you and your allies, with all your and their gear, from one plane
    to another through planar barriers to a specific locale with no chance of error.
    - Moving out of maze/prismatic plane/imprisonment (if another person I guess), and
    any allies in the area, with you.

    • Protecting a city from an earthquake, volcanic eruption, flood, or other
    major natural disaster.
    - Remove this from the description, maybe add a DM only version.

    Other ideas for 5000XP:
    - Free someone from imprisonment.
    - Destroy/Command all undead in area (in a burst effect, you instantly
      destroy undead you'd otherwise turn, or command if you don't destroy).
    - Unsummon all summoned creatures within an area (no check, and doesn't do
      anything about outsiders maybe?)
    -

//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{

}
