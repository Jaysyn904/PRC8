/*:://////////////////////////////////////////////
//:: Name Summon Monster - On Conversation
//:: FileName SMP_AI_Summ_Conv
//:://////////////////////////////////////////////
    On Conversation.

    It will react to shouts sent to it, including Bioware's associate shouts
    for hold ground and so on.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_AI_INCLUDE"

void main()
{
    // Get who spoke
    object oSelf = OBJECT_SELF;
    object oSpeaker = GetLastSpeaker();
    object oMaster = GetMaster();
    object oTarget;
    int nConversation = GetListenPatternNumber();

    // Cannot not be the master
    if(oSpeaker != oMaster) return;

    // Check nConversation's number.
    switch(nConversation)
    {
        // If -1, it is a converastion thing
        case -1:
        {
            if(GetCommandable() == TRUE)
            {
                // Start the conversation
                BeginConversation();
            }
        }
        break;
        // Other things (not -1)

        // * toggle search mode for henchmen
        case ASSOCIATE_COMMAND_TOGGLESEARCH:
        {
            if(GetActionMode(OBJECT_SELF, ACTION_MODE_DETECT) == TRUE)
            {
                SetActionMode(OBJECT_SELF, ACTION_MODE_DETECT, FALSE);
            }
            else
            {
                SetActionMode(OBJECT_SELF, ACTION_MODE_DETECT, TRUE);
            }
        }
        break;
        // * toggle stealth mode for henchmen
        case ASSOCIATE_COMMAND_TOGGLESTEALTH:
        {
            if(GetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH) == TRUE)
            {
                SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, FALSE);
            }
            else
            {
                SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE);
            }
        }
        break;
        // * Stop spellcasting
        case ASSOCIATE_COMMAND_TOGGLECASTING:
        {
            // Use spawn conditions
            if(SMPAI_GetSummonSetting(SMPAI_SUMMON_CAN_USE_SPELLS))
            {
                SMPAI_SetSummonSetting(SMPAI_SUMMON_CAN_USE_SPELLS, FALSE);
            }
            else
            {
                SMPAI_SetSummonSetting(SMPAI_SUMMON_CAN_USE_SPELLS);
            }
        }
        break;
        // Open inventory
        case ASSOCIATE_COMMAND_INVENTORY:
        {
            // Don't open for summons.
            FloatingTextStringOnCreature("Summon's inventory cannot be edited", oMaster, FALSE);
            return;
        }
        break;
        // Pick the nearest lock or bash it.
        case ASSOCIATE_COMMAND_PICKLOCK:
        {
            // Call function "Pick Lock" with the nearest locked door.
            //oTarget =

        }
        break;
        // Disarm any traps.
        case ASSOCIATE_COMMAND_DISARMTRAP: // Disarm trap
        {
            // Call function "Disarm trap" with no target
            oTarget = GetNearestTrapToObject(oSelf, TRUE);


        }
        break;
        // Attack the nearest enemy - force combat!
        case ASSOCIATE_COMMAND_ATTACKNEAREST:
        {
            // Attack our masters target if they are valid.
            oTarget = GetAttackTarget(oMaster);
            if(GetIsObjectValid(oTarget) == TRUE)
            {
                if(GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE ||
                   GetObjectType(oTarget) == OBJECT_TYPE_DOOR)
                {
                    ActionAttack(oTarget);
                    return;
                }
            }
            // Else normal attack (even if oTarget is invalid, it'll use the nearest).
            SMPAI_SummonAttack(oTarget);
        }
        break;
        // Just move to the master
        case ASSOCIATE_COMMAND_FOLLOWMASTER:
        {
            ClearAllActions();
            ActionForceFollowObject(oMaster, 2.0);
        }
        break;
        // Attack the masters last attacker
        case ASSOCIATE_COMMAND_GUARDMASTER:
        {
            oTarget = GetLastHostileActor(oMaster);
            if(!GetIsObjectValid(oTarget))
            {
                oTarget = GetAttackTarget(oMaster);
            }
            SMPAI_SummonAttack(oTarget);
        }
        break;
        // Heal our master
        case ASSOCIATE_COMMAND_HEALMASTER:
        {
            // Heal the master! Well, only if we can...
        }
        break;
        // Will not guard master or follow.
        case ASSOCIATE_COMMAND_STANDGROUND:
        {

        }
        break;
        // Next ones are all done by the game engine!
        //  Master failed to pick a lock. We can't get what lock was failed, so
        //  get nearest locked object to the.
        case ASSOCIATE_COMMAND_MASTERFAILEDLOCKPICK:
        {

        }
        break;
        // Master saw a trap
        //  We can get the trap via. GetLastTrapDetected(oMaster).
        case ASSOCIATE_COMMAND_MASTERSAWTRAP:
        {
            if(!GetIsInCombat())
            {
            //    if(!GetAssociateState(NW_ASC_MODE_STAND_GROUND))
            //    {
                    oTarget = GetLastTrapDetected(oMaster);
            //    }
            }
        }
        break;
        // Master under attack
        //  We can get the last attacker with GetLastHostileActor().
        case ASSOCIATE_COMMAND_MASTERUNDERATTACK:
        {
            // Start combat if not already in combat
            oTarget = GetLastHostileActor(oMaster);
            if(!GetIsInCombat())
            {
                SMPAI_SummonAttack(oTarget);
            }
        }
        break;
        // Master has attacked someone - we should go into combat.
        //  We can get their target using GetAttackTarget().
        case ASSOCIATE_COMMAND_MASTERATTACKEDOTHER:
        {
            // Get the target
            oTarget = GetAttackTarget(oMaster);


        }
        break;
        // Master is going to be attacked.
        //  We can get who they will be attacked by with GetGoingToBeAttackedBy().
        //  Not sure when this is fired.
        case ASSOCIATE_COMMAND_MASTERGOINGTOBEATTACKED:
        {
            //if(!GetAssociateState(NW_ASC_MODE_STAND_GROUND))
            //{
                if(!GetIsInCombat(OBJECT_SELF))
                {
                    oTarget = GetGoingToBeAttackedBy(oMaster);
                    // April 2003: If my master can see the enemy, then I can too.
                    // Potential Side effect : Henchmen may run
                    // to stupid places, trying to get an enemy
                    if(GetIsObjectValid(oTarget) && GetObjectSeen(oTarget, oMaster))
                    {
                        ClearAllActions();
                        ActionMoveToObject(oTarget, TRUE, 7.0);
                        SMPAI_SummonAttack(oTarget);
                    }
                }
            //}
        }
        break;
        // We should leave the party.
        //  Summons become "unsummoned" and destroy themselves.
        case ASSOCIATE_COMMAND_LEAVEPARTY:
        {
            // Destroy self with nice effect
            // Do nothing for now (might change later, or it might be internal)
            // SMPAI_UnsummonSelf();
            return;
        }
        break;
        // End
    }
}
