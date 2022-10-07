/*:://////////////////////////////////////////////
//:: Spell Name Contingency
//:: Spell FileName PHS_S_Contingenc
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation
    Level: Sor/Wiz 6
    Components: V, S, M, F
    Casting Time: At least 10 minutes; see text
    Range: Personal
    Target: You
    Duration: One day/level (D) or until discharged

    You can place another spell upon your person so that it comes into effect
    under some condition you dictate when casting contingency. The contingency
    spell and the companion spell are cast at the same time. The 10-minute
    casting time is the minimum total for both castings; if the companion spell
    has a casting time longer than 10 minutes, use that instead.

    --- Longer description
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Contingency placeholder.

    Um, not sure...

    Ok, some ideas:

    xxxxxxxxxxxxxxxxxxxxxxxxxx
    SCRAPPED FOR NOW
    1. To get any spell to be cast correctly, at the right level, we can
       use a placeholder "spell", or ability, called something like "Contingency
       Release" (which as a nice side effect, can be made to say "Contingency
       Released" not "Contingency Casts Contingency Release").
    2. This has a 40M range, can target anything (just in case), and has a special
       script to fire.
    3. The contingency (using, for example, a 6 second heartbeat) will check the
       conditions of the spell all the time, and will move to the caster if the
       conditions are not met, else, it will cast the "Continceny Release"
    4.
    xxxxxxxxxxxxxxxxxxxxxxxxxx

    Different idea (from my AI):

    1. Create the contingency monster. Has High AI, follows the caster (with
       plot status, invsible, ETC).
    2. This monster will have all wizard spells. It will have them dispite its
       level (the lowest level for contingency) and will level up in sorceror
       to be the same level as the PC.
    3. Adds the feats (Save DC bonuses, Spell Penetrations) to its own hide.
    4. Using fast-casting, it will cast the spells, when required, at the
       correct targets. As it should always be on the PC's location, this will
       mean it will always be in range ETC.
    5. Then destroys itself.

    Quite elegant, really, and full-proof (given how ResistSpell works, and
    so on). Of course, we could have oCaster made as the actual caster of this,
    but thats quite complciated, and no need!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{

}
