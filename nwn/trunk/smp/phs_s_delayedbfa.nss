/*:://////////////////////////////////////////////
//:: Spell Name Delayed Blast Fireball: On Enter
//:: Spell FileName PHS_S_DelayedBFA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Uses the Bioware AOE.

    This, if moved nearby to, will auto-explode.

    The caster can of course choose the duration - be it 1 heartbeat (or instant)
    to 5 heartbeats (or 5 rounds).

    The heartbeat script and OnEnter scripts do the stuff.

    OnEnter: Sets a local variable to activate the blast next hearbeat.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE status
    if(!PHS_CheckAOECreator()) return;

    // If we haven't set "We've been entered" set it if the target is not
    // in PvP lands.
    if(!GetLocalInt(OBJECT_SELF, "PHS_DELAYED_BLAST_FIREBALL_ENTERED"))
    {
        // Declare major variables
        object oTarget = GetEnteringObject();
        object oCreator = GetAreaOfEffectCreator();

        if(!GetIsReactionTypeFriendly(oTarget, oCreator))
        {
            SetLocalInt(OBJECT_SELF, "PHS_DELAYED_BLAST_FIREBALL_ENTERED", TRUE);
        }
    }
}
