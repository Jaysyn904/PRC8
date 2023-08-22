/*:://////////////////////////////////////////////
//:: Name AI Include
//:: FileName SMP_AI_INCLUDE
//:://////////////////////////////////////////////
//:: Description
//:://////////////////////////////////////////////
    This is an include for AI for summons and monsters.

    NOT for use with the default AI, and default monsters. This AI is stripped
    down and NOT NOT NOT generic! It is very VERY specific to monsters that
    are summoned - both for realism, and for speed (as summons have the highest
    CPU speed).

    Usually a summon AI file is executed (and there is a default one which has
    some generic "Attack" and "Heal" behaviour), to do combat.

    States the AI can be in:

    Nominal Movement/Override Status Flag:
    - Off: Caused by debugging normally.
    - Default Follow Master: Follow at a set range in thier spawn script (Based on size)
        * Caused by shout: "Follow", or dialog
    - Follow Another (At range): Follow something else, at XXX range (set, otherwise default above)
        * Set in dialog. Can be re-set in conversation too (IE: Saves information)
    - Force Heal Master: Forces the use of healing spells to heal master
        * Caused by shout "Heal me" by master
    - Force Guard Master: Cannot go out of sight, or away from master. Protects with long lasting spells.
        * Caused by dialog, or shout "Guard me"
    - Stand here, and only attack at range with spells, or attack in melee if you
      don't move.
        * Dialog option
    - Do not attack
        * "Stand Ground" shout.


    Behaviour not in combat flag(s):
    Note: There would be default, if normal behaviour, that might always go on.
    If a summon isn't specifically told to do nothing, it might, for example, talk
    to allies, complain if talkative, heal itself, sit down, disarm any weapons
    it is carrying, look around, and go into search mode.

    - Do nothing/Off: Default (normally). Doesn't do anything.
    - Heal allies, cast long duration spells.
        * Dialog option. Can be on or off. Overrides trap searching
          ONLY useable with intelligent beings.
    - Search and wander for traps, unlock things by yourself, tell caster information
        * Dialog option. Might split. It will, when stopped moving for a while,
          wander around (to a cirtain distance) looking for traps, unlocking
          chests nearby, and so forth.
          Information is like "I see a trap here" if they can talk.
          ONLY useable with intelligent beings.
          - Shouldn't open doors doing any random movement.
    - Hide and stay silent
        * Stealth mode is always on when not fighting (and isn't turned off by caster)
    - Sneak around the back of anything I'm facing
        * Makes the summon, after a while after following, move behind any
          non-party creatures that the caster is facing, ready to attack normally.
    - Do/Do not talk about things to the caster, or talk with others
        * The caster has to turn this off specifically, as many talking summons
          might talk to other things
    - Loot the ground and boxes of goods, and carry it for the caster.
        * Off by default. While there is one for opening/unlocking boxes, and
          for disarming traps found, if they can, the caster might want to look
          at things themselves.
    - Identify items they possess
        * If I enable carrying of items, they might, in thier spare time (or if
          asked) look over thier items and identify them.

    A creature can be told to:



//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

// Include constants
#include "SMP_INC_CONSTANT"

// Strings
const string SMPAI_SUMMON_SETTING_NAME  = "SMPAI_SUMMON_MASTER";
// AI temp object used in the combat AI file
const string SMPAI_SUMMON_TEMP_TARGET = "SMPAI_SUMMON_TEMP_TARGET";
// AI target last attacked
const string SMPAI_SUMMON_LAST_ATTACK_TARGET = "SMPAI_SUMMON_LAST_ATTACK_TARGET";
// Summon DEFAULT AI combat file
const string SMPAI_SUMMON_AI_FILE     = "SMPAI_SUMM_FIGH";

// Spell we were summoned with
const string SMPAI_SUMMON_SPELL = "SMPAI_SUMMON_SPELL";

const int SMPAI_SUMMON_CANNOT_DOOR_OPEN       = 0x00000001;// Can NOT open doors
const int SMPAI_SUMMON_CANNOT_DOOR_BASH       = 0x00000002;// Can NOT bash doors
const int SMPAI_SUMMON_CAN_USE_SPELLS         = 0x00000004;// Has spells to use
//const int NW_FLAG_SEARCH                      = 0x00000008;
//const int NW_FLAG_SET_WARNINGS                = 0x00000010;
//const int NW_FLAG_ESCAPE_RETURN               = 0x00000020; //Failed
//const int NW_FLAG_ESCAPE_LEAVE                = 0x00000040;
//const int NW_FLAG_TELEPORT_RETURN             = 0x00000080; //Failed
//const int NW_FLAG_TELEPORT_LEAVE              = 0x00000100;
//const int NW_FLAG_PERCIEVE_EVENT              = 0x00000200;
//const int NW_FLAG_ATTACK_EVENT                = 0x00000400;
//const int NW_FLAG_DAMAGED_EVENT               = 0x00000800;
//const int NW_FLAG_SPELL_CAST_AT_EVENT         = 0x00001000;
//const int NW_FLAG_DISTURBED_EVENT             = 0x00002000;
//const int NW_FLAG_END_COMBAT_ROUND_EVENT      = 0x00004000;
//const int NW_FLAG_ON_DIALOGUE_EVENT           = 0x00008000;
//const int NW_FLAG_RESTED_EVENT                = 0x00010000;
//const int NW_FLAG_DEATH_EVENT                 = 0x00020000;
//const int NW_FLAG_SPECIAL_COMBAT_CONVERSATION = 0x00040000;
//const int NW_FLAG_AMBIENT_ANIMATIONS          = 0x00080000;
//const int NW_FLAG_HEARTBEAT_EVENT             = 0x00100000;
//const int NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS = 0x00200000;
//const int NW_FLAG_DAY_NIGHT_POSTING           = 0x00400000;
//const int NW_FLAG_AMBIENT_ANIMATIONS_AVIAN    = 0x00800000;
//const int NW_FLAG_APPEAR_SPAWN_IN_ANIMATION   = 0x01000000;
//const int NW_FLAG_SLEEPING_AT_NIGHT           = 0x02000000;
//const int NW_FLAG_FAST_BUFF_ENEMY             = 0x04000000;


// Sets the specified spawn-in condition on the caller as directed.
void SMPAI_SetSummonSetting(int nCondition, int bValid = TRUE);
// Returns TRUE if the specified condition has been set on the
// caller, otherwise FALSE.
int SMPAI_GetSummonSetting(int nCondition);
// This executes the combat AI file on the creature, causing a combat round.
// oTarget - The thing inputted.
void SMPAI_SummonAttack(object oTarget = OBJECT_INVALID);
// This will run any AI override scripts for nEvent - use EVENT_* constants.
// * TRUE if any found
int SMPAI_RunEventAIScript(int nEventId);

// Fighting routine functions

// Gets a enemy target for the AI to attack.
object SMPAI_GetTarget();

// Sets the specified spawn-in condition on the caller as directed.
void SMPAI_SetSummonSetting(int nCondition, int bValid = TRUE)
{
    int nSpawnInConditions = GetLocalInt(OBJECT_SELF, SMPAI_SUMMON_SETTING_NAME);
    if(bValid == TRUE)
    {
        // Add the given spawn-in condition
        nSpawnInConditions = nSpawnInConditions | nCondition;
        SetLocalInt(OBJECT_SELF, SMPAI_SUMMON_SETTING_NAME, nSpawnInConditions);
    }
    else if(bValid == FALSE)
    {
        // Remove the given spawn-in condition
        nSpawnInConditions = nSpawnInConditions & ~nCondition;
        SetLocalInt(OBJECT_SELF, SMPAI_SUMMON_SETTING_NAME, nSpawnInConditions);
    }
}

// Returns TRUE if the specified condition has been set on the
// caller, otherwise FALSE.
int SMPAI_GetSummonSetting(int nCondition)
{
    int nPlot = GetLocalInt(OBJECT_SELF, SMPAI_SUMMON_SETTING_NAME);
    if(nPlot & nCondition)
    {
        return TRUE;
    }
    return FALSE;
}

// This executes the combat AI file on the creature, causing a combat round.
// oTarget - The thing inputted.
void SMPAI_SummonAttack(object oTarget = OBJECT_INVALID)
{
    SetLocalObject(OBJECT_SELF, SMPAI_SUMMON_TEMP_TARGET, oTarget);
    string sScript = GetLocalString(OBJECT_SELF, SMPAI_SUMMON_AI_FILE);
    // Defaults to SMP_SUMMON_AI_FILE if SMP_SUMMON_AI_FILE is not found
    if(sScript == "")
    {
        sScript = SMPAI_SUMMON_AI_FILE;
    }
    // Execute the combat script to do combat.
    ExecuteScript(SMPAI_SUMMON_AI_FILE, OBJECT_SELF);
}

// This will run any AI override scripts for nEvent - use EVENT_* constants.
// * TRUE if any found
int SMPAI_RunEventAIScript(int nEventId)
{
    return FALSE;

    string sAI = GetLocalString(OBJECT_SELF, "AI_SCRIPT" + IntToString(nEventId));

    if(sAI != "")
    {
        ExecuteScript(sAI, OBJECT_SELF);
        return TRUE;
    }
    return FALSE;
}

////////////////////////////////////////////////////////////////////////////////
// Fighting functions
////////////////////////////////////////////////////////////////////////////////

// Doesn't attack things we cannot see or hear, for instance.
int SMPAI_GetIsAValidTarget(object oTarget)
{
    if(!GetIsObjectValid(oTarget) ||
      (!GetObjectSeen(oTarget) && !GetObjectHeard(oTarget)) ||
       GetIsDead(oTarget))
    {
        return FALSE;
    }
    return TRUE;
}

// Gets a enemy target for the AI to attack.
object SMPAI_GetTarget()
{
    // Who is the most appropriate person to fight?
    // 0. Override target (inputted to start combat)

    // 1. Whoever we attacked last
    // 2. Whoever our master is attacking (If we have noone really nearby to attack)
    // 3. Whoever we attacked last (If we have no one really nearby to attack)
    // 4. Whoever is nearest

    // 0. Override target
    object oTarget = GetLocalObject(OBJECT_SELF, SMPAI_SUMMON_TEMP_TARGET);
    DeleteLocalObject(OBJECT_SELF, SMPAI_SUMMON_TEMP_TARGET);
    if(!SMPAI_GetIsAValidTarget(oTarget))
    {
        // Who is the nearest (seen) enemy?
        object oNearest = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, CREATURE_TYPE_IS_ALIVE, TRUE);
        oTarget = oNearest;
        if(!SMPAI_GetIsAValidTarget(oTarget) || GetDistanceToObject(oTarget) > 5.0)
        {
            // Who we attacked last
            oTarget = GetLocalObject(OBJECT_SELF, SMPAI_SUMMON_LAST_ATTACK_TARGET);

            if(!SMPAI_GetIsAValidTarget(oTarget))
            {
                // Who our master is attacking
                GetAttackTarget(GetMaster());
                if(!SMPAI_GetIsAValidTarget(oTarget))
                {
                    // Nearest enemy
                    oTarget = oNearest;

                    // If this is invalid, we don't do combat
                    if(!SMPAI_GetIsAValidTarget(oTarget))
                    {
                        DeleteLocalObject(OBJECT_SELF, SMPAI_SUMMON_LAST_ATTACK_TARGET);
                        return OBJECT_INVALID;
                    }
                }
            }
        }
    }

    // Set oTarget to local, and return
    SetLocalObject(OBJECT_SELF, SMPAI_SUMMON_LAST_ATTACK_TARGET, oTarget);
    return oTarget;
}





// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
