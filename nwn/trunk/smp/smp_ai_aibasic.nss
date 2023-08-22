/*:://////////////////////////////////////////////
//:: Name AI Summon - Basic AI file
//:: FileName SMP_AI_AIBASIC
//:://////////////////////////////////////////////
//:: Description
//:://////////////////////////////////////////////
    Basicest of Combat AI files.

    This is for summoned AI. For normal AI I'll be implimenting a slightly altered
    version of my AI.

    Summoned AI is very basic, although it has soem special things. For most creatures,
    there will be a special AI script they'll run (still using things from
    SMP_AI_INCFIGHT however), which will do special attacks, spells they possess
    and so on.

    This will use talents, and very basic attack maneuvers.

    SMP_SUMMON_TEMP_TARGET - What we want to attack.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_AI_INCCOMBAT"

void main()
{
    SpeakString("Fighting");

    // Declare everything
    object oSelf = OBJECT_SELF;
    object oMaster = GetMaster();
    object oTarget = GetLocalObject(oSelf, "SMP_SUMMON_TEMP_TARGET");

    // Check if we can attack and do an action
    if(!SMPAI_CanAttack(oMaster)) return;

    // Sanity check against oTarget
    //if(!SMPAI_SanityCheck(oTarget))
    //{
    //    // Get new target
    //}

    // If we now have no valid target, stop
    if(!GetIsObjectValid(oTarget)) return;

    // Check if we flee
    if(SMPAI_FleeCheck(oTarget)) return;

    // Note: Additional: we check for Wall of XXX here!
    // * Works out what to do when we are surrounded by, or have in the way,
    //   some walls.
    int nWall = SMPAI_WallCheck(oTarget);
    // 0 is OK, 2 is "Attack ranged, else do special attack wall", and 1 is stuck.
    if(nWall == TRUE) return;

    // We check if we can heal us or others
    //if(SMPAI_BasicCheckHealing(oMaster)) return;

    // We check if we want to apply, and do apply, a buff/protection/helpful spell
    // to us, which is not for attacking in melee or range with.
    // Includes Aura spells, Bard Song, etc.
    //if(SMPAI_BasicProtectionCasting(OBJECT_SELF)) return;

    // As above, but for our master.
    //if(SMPAI_BasicProtectionCasting(oMaster)) return;

    // We check if we can cast a spell or use an ability
    //if(SMPAI_BasicHostileCasting(oTarget)) return;

    // We cast helpful buffs to help us attack, such as weapon spells, and
    // Bulls Strength. Also includes polymorphing.
    //if(SMPAI_BasicBuffMeleeSpells(OBJECT_SELF)) return;

    // Attack oTarget
    //if(SMPAI_BasicAttack(oTarget)) return;


}
