/*:://////////////////////////////////////////////
//:: Spell Name Find the Path
//:: Spell FileName phs_s_findthpth
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    3 round casting time. 10 min/level duration. Range: Personal.

    The recipient of this spell can find the shortest, most direct physical
    route to a specified destination, one set before hand on the ground on the
    same plane.

    It creates a small light source which will move the quickest way to the
    point pre-set. The light only moves if the caster is within 10M of it.
    The light source lasts for the duration of the spell, even if it cannot find
    a path or gets stuck.

    The spell also allows the caster, and any other party members, in a Maze
    spell, find thier way out as soon as the spell is cast.

    Focus: A set of divination counters of the sort you favor.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Creates a henchmen (should work fine with Hordes anyway) which will move
    with ActionMoveToObject and using an object a PC will set for location to
    move to.

    The object is set via. the spell conversation (however that is done) if they
    have the spell memorised.

    Note: 3 rounds to cast

    Need to add "henchmen" scripts and new creature. Make the creature eathreal,
    maybe, or just ignore.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_FIND_THE_PATH)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject(); // Should be object self.
    location lTarget = GetLocation(oCaster);
    object oLocationMoveTo, oLight;
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // We set number of turns in integer form to the light source
    if(nMetaMagic == METAMAGIC_EXTEND)
    {
        nCasterLevel *= 2;// +100%
    }
    // Make it rounds, not turns, so 10 rounds  = 1 turn
    nCasterLevel *= 10; // In rounds, x10

    // Check if in a maze area...
    if(PHS_IsInMazeArea(oTarget))
    {
        // If we are not a PC, and no PC master, just jump us out.
        if(!GetIsPC(oTarget) && !GetIsPC(GetMaster(oTarget)))
        {
            // Signal spell cast at the target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FIND_THE_PATH, FALSE);
            // Jump them out of maze
            ExecuteScript("phs_s_mazed", oTarget);
        }
        else
        {
            // We jump all people in the maze area out.
            oTarget = GetFirstFactionMember(oCaster, TRUE);
            while(GetIsObjectValid(oTarget))
            {
                if(PHS_IsInMazeArea(oTarget))
                {
                    // Signal spell cast at the target
                    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FIND_THE_PATH, FALSE);
                    // Jump them out of maze
                    ExecuteScript("phs_s_mazed", oTarget);
                }
                oTarget = GetNextFactionMember(oCaster, TRUE);
            }
            // All NPC's now, familiars and the like.
            // We jump all people in the maze area out.
            oTarget = GetFirstFactionMember(oCaster, FALSE);
            while(GetIsObjectValid(oTarget))
            {
                if(PHS_IsInMazeArea(oTarget))
                {
                    // Signal spell cast at the target
                    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FIND_THE_PATH, FALSE);
                    // Jump them out of maze
                    ExecuteScript("phs_s_mazed", oTarget);
                }
                oTarget = GetNextFactionMember(oCaster, FALSE);
            }
        }
    }
    else
    {
        // Else, it is basically a light source moving to a location.

        // Make sure we have not got it cast already...
        oLight = GetLocalObject(oCaster, "PHS_SPELL_FIND_THE_PATH_LIGHT");
        if(!GetIsObjectValid(oLight) || GetIsDead(oLight))
        {
            // Signal spell cast at self
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FIND_THE_PATH, FALSE);

            // Get object to move to
            oLocationMoveTo = GetLocalObject(oCaster, "PHS_SPELL_FIND_THE_PATH_LIGHT");

            // Object valid
            if(GetIsObjectValid(oLocationMoveTo))
            {
                // Message
                SendMessageToPC(oCaster, "You created a light source to follow. It will attempt to move to the locationt you set before when you ask it to.");

                // Create light to follow
                oLight = CreateObject(OBJECT_TYPE_CREATURE, "phs_s_findthepath", lTarget);

                // Set on the caster that we have one
                SetLocalObject(oCaster, "PHS_SPELL_FIND_THE_PATH_LIGHT", oLight);

                // Set location it should move to
                SetLocalObject(oLight, "PHS_SPELL_FIND_THE_PATH_OBJECT", oLocationMoveTo);

                // Set number of heartbeats until destroy
                SetLocalInt(oLight, "PHS_SPELL_FIND_THE_PATH_DURATION_COUNTER", nCasterLevel);

                // Add henchmen
                AddHenchman(oCaster, oLight);
            }
            else
            {
                // Message
                SendMessageToPC(oCaster, "You cannot find the path to no where! You need to place a location marker to find the way to.");
            }
        }
        else
        {
            // Message
            SendMessageToPC(oCaster, "You are already finding the path.");
        }
    }
}
