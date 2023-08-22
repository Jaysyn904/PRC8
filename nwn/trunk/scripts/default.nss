//::///////////////////////////////////////////////
//:: Default eventscript
//:: default
//:://////////////////////////////////////////////
/** @file
    This script is executed by the engine for events
    when a creature does not have a script defined
    for the event in question. This includes PCs.

    The purpose of this script is to determine
    which particular event triggered it's execution
    and to route execution to scripts dedicated to
    that event.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_leadersh"

const int LOCAL_DEBUG = FALSE; //DEBUG;

/**************************/
/* Declarations for Tests */
/**************************/

int IsBlocked();                // test GetBlockingDoor()
int IsCombatRoundEnd();         // Need to fake this
int IsConversation();           // test a local variable
int IsDamaged();                // test GetLastDamager()
int IsDeath();                  // test GetIsDead(OBJECT_SELF)
int IsDisturbed();              // test GetLastDisturbed()
int IsHeartbeat();              // test game time
int IsPerception();             // test GetLastPerceived()
int IsPhysicalAttacked();       // test GetLastAttacker()
int IsRested();                 // test GetIsResting(GetMaster())
int IsSpawn();                  // run once, never again
int IsSpellCastAt();            // test GetLastSpellCaster()
int IsUserDefined();            // test GetUserDefinedEventNumber()

/*********************************/
/* Utility Function declarations */
/*********************************/

//void ForceAddHenchman(object oHenchman);
//int IsLinkboyAttached();
//void GetLinkboy();
int IsObjectChanged(object oTest, string sVarname);
int IsIntChanged(int iTest, string sVarname);
int IsStringChanged(string sTest, string sVarname);
void RunScript(int nEvent);
//void SpawnRecallLocals(object oPC);
//void StartGroupDiscussion();

/*****************************/
/* Implementation of Actions */
/*****************************/

void OnSpawn()            { RunScript(EVENT_VIRTUAL_ONSPAWNED);          }
void OnDeath()            { RunScript(EVENT_VIRTUAL_ONDEATH);            }
void OnRested()           { RunScript(EVENT_VIRTUAL_ONRESTED);           }
void OnHeartbeat()        { RunScript(EVENT_VIRTUAL_ONHEARTBEAT);        }
void OnPerception()       { RunScript(EVENT_VIRTUAL_ONPERCEPTION);       }
void OnBlocked()          { RunScript(EVENT_VIRTUAL_ONBLOCKED);          }
void OnCombatRoundEnd()   { RunScript(EVENT_VIRTUAL_ONCOMBATROUNDEND);   }
void OnDisturbed()        { RunScript(EVENT_VIRTUAL_ONDISTURBED);        }
void OnPhysicalAttacked() { RunScript(EVENT_VIRTUAL_ONPHYSICALATTACKED); }
void OnSpellCastAt()      { RunScript(EVENT_VIRTUAL_ONSPELLCASTAT);      }
void OnDamaged()          { RunScript(EVENT_VIRTUAL_ONDAMAGED);          }
void OnUserDefined()      { RunScript(EVENT_VIRTUAL_ONUSERDEFINED);      }
void OnConversation()     { RunScript(EVENT_VIRTUAL_ONCONVERSATION);     }

/******************/
/* Main Procedure */
/******************/

void main()
{
    if(LOCAL_DEBUG) DoDebug("default running for " + DebugObject2Str(OBJECT_SELF));

    // OnConversation is exclusive of everything else, since it is just routed through this script
    if(IsConversation())             OnConversation();
    else
    {
        if(IsBlocked())              OnBlocked();
        if(IsCombatRoundEnd())       OnCombatRoundEnd();
        if(IsDamaged())              OnDamaged();
        if(IsDeath())                OnDeath();
        if(IsDisturbed())            OnDisturbed();
        if(IsHeartbeat())            OnHeartbeat();
        if(IsPerception())           OnPerception();
        if(IsPhysicalAttacked())     OnPhysicalAttacked();
        if(IsRested())               OnRested();
        if(IsSpawn())                OnSpawn();
        if(IsSpellCastAt())          OnSpellCastAt();
        if(IsUserDefined())          OnUserDefined();
    }
}

/************************/
/* Tests for conditions */
/************************/

int IsBlocked()
{
  return IsObjectChanged(GetBlockingDoor(), "BlockingDoor");
}

int IsCombatRoundEnd()
{
    // Need to fake this.
    // Return TRUE iff you are in combat and not doing anything useful
    if(GetIsInCombat() ||
       (GetIsObjectValid(GetMaster()) &&
        GetIsInCombat(GetMaster())
        )
       )
    {
        int nGCA = GetCurrentAction();
        if(nGCA == ACTION_ATTACKOBJECT  ||
           nGCA == ACTION_CASTSPELL     ||
           nGCA == ACTION_COUNTERSPELL  ||
           nGCA == ACTION_HEAL          ||
           nGCA == ACTION_FOLLOW        ||
           nGCA == ACTION_ITEMCASTSPELL ||
           nGCA == ACTION_KIDAMAGE      ||
           nGCA == ACTION_OPENDOOR      ||
           nGCA == ACTION_SMITEGOOD
           )
        {
            return FALSE;
        }
        else
        {
            return TRUE;
        }
    }
    else
    {
        return FALSE;
    }
}

int IsConversation()
{
    object oCreature = OBJECT_SELF;
    if(GetLocalInt(oCreature, "default_conversation_event"))
    {
        DeleteLocalInt(oCreature, "default_conversation_event");
        return TRUE;
    }

    return FALSE;
}

int IsDamaged()
{
    object oCreature = OBJECT_SELF;
    object oDamager  = GetLastDamager(oCreature);

    // The damage source must be valid
    if(GetIsObjectValid(oDamager))
    {
        // Get previous damage data
        string sOldDamage = GetLocalString(oCreature, "PRC_Event_OnDamaged_Data");

        // Create string based on current damage values
        // Start with the damaging object
        string sNewDamage = ObjectToString(oDamager);
        // Catenate amount of damage of each damage type
        int i;
        for(i = DAMAGE_TYPE_BLUDGEONING; i <= DAMAGE_TYPE_BASE_WEAPON; i = i << 1)
            sNewDamage += IntToString(GetDamageDealtByType(i));

        // Determine if the damage dealt has changed
        if(sOldDamage != sNewDamage)
        {
            if(LOCAL_DEBUG) DoDebug("default: Damage has changed:\n" + sNewDamage);
            SetLocalString(oCreature, "PRC_Event_OnDamaged_Data", sNewDamage);

            // Update damage counter
            SetLocalInt(oCreature, "PRC_LastDamageTaken", GetTotalDamageDealt());

            return TRUE;
        }
    }

    return FALSE;
}

int IsDeath()
{
    return GetIsDead(OBJECT_SELF);
}

int IsDisturbed()
{
    object oCreature  = OBJECT_SELF;
    object oDisturber = GetLastDisturbed();

    if(GetIsObjectValid(oDisturber)) // The creature has been disturbed at least once during the game
    {
        // Get previous disturb data
        string sOldDisturb = GetLocalString(oCreature, "PRC_Event_OnDisturbed_Data");

        // Create string based on current disturb values
        string sNewDisturb  = ObjectToString(oDisturber);
               sNewDisturb += IntToString(GetInventoryDisturbType());
               sNewDisturb += ObjectToString(GetInventoryDisturbItem());

        // Determine if the data has changed
        if(sOldDisturb != sNewDisturb)
        {
            if(LOCAL_DEBUG) DoDebug("default: Disturbed has changed:\n" + sNewDisturb);
            SetLocalString(oCreature, "PRC_Event_OnDisturbed_Data", sNewDisturb);
            return TRUE;
        }
    }

    return FALSE;
}

int IsHeartbeat()
{
    object oCreature = OBJECT_SELF;
    // PCs use the module HB
    if(!GetIsPC(oCreature))
    {
        // Check how long since last recorded heartbeat
        int nSecsChange  = (GetTimeSecond() - GetLocalInt(oCreature, "PRC_LastHeartbeatSeconds") + 60) % 60;

        // See if the master clock has ticked or 9 seconds have elapsed anyway
        if(nSecsChange >= 6)
        {
            SetLocalInt(oCreature, "PRC_LastHeartbeatSeconds", GetTimeSecond());
            return TRUE;
        }
    }

    return FALSE;
}

int IsPerception()
{
    object oCreature  = OBJECT_SELF;
    object oPerceived = GetLastPerceived();

    if(GetIsObjectValid(oPerceived)) // The creature has perceived something at least once during the game
    {
        // Get previous perception data
        string sOldPerception = GetLocalString(oCreature, "PRC_Event_OnPerception_Data");

        // Create string based on current perception values
        string sNewPerception  = ObjectToString(oPerceived);
               sNewPerception += IntToString(GetLastPerceptionHeard());
               sNewPerception += IntToString(GetLastPerceptionInaudible());
               sNewPerception += IntToString(GetLastPerceptionSeen());
               sNewPerception += IntToString(GetLastPerceptionVanished());;

        // Determine if the data has changed
        if(sOldPerception != sNewPerception)
        {
            if(LOCAL_DEBUG) DoDebug("default: Perception has changed:\n" + sNewPerception);
            SetLocalString(oCreature, "PRC_Event_OnPerception_Data", sNewPerception);
            return TRUE;
        }
    }

    return FALSE;
}

int IsPhysicalAttacked()
{
    object oCreature = OBJECT_SELF;
    object oAttacker = GetLastAttacker();

    // Recent enough event that the attacker is at least still valid
    if(GetIsObjectValid(oAttacker))
    {
        // Get previous attack data
        string sOldAttack = GetLocalString(oCreature, "PRC_Event_OnPhysicalAttacked_Data");

        // Create string for the current attack data
        string sNewAttack  = ObjectToString(oAttacker);
               sNewAttack += ObjectToString(GetLastWeaponUsed(oAttacker));
               sNewAttack += IntToString(GetLastAttackMode(oAttacker));
               sNewAttack += IntToString(GetLastAttackType(oAttacker));

        // Determine if the data has changed
        if(sOldAttack != sNewAttack)
        {
            if(LOCAL_DEBUG) DoDebug("default: Attack has changed:\n" + sNewAttack);
            SetLocalString(oCreature, "PRC_Event_OnPhysicalAttacked_Data", sNewAttack);
            return TRUE;
        }
    }

    return FALSE;
}

int IsRested()
{
    // PCs use the module OnRest events
    if(!GetIsPC(OBJECT_SELF))
    {
        // Goes TRUE when Master starts resting
        int bMasterIsResting = GetIsResting(GetMaster());
        return IsIntChanged(bMasterIsResting,"MasterIsResting") && bMasterIsResting;
    }

    return FALSE;
}

int IsSpawn()
{
    object oCreature = OBJECT_SELF;
    if(!GetLocalInt(oCreature, "PRC_OnSpawn_Marker"))
    {
        SetLocalInt(oCreature, "PRC_OnSpawn_Marker", TRUE);
        return TRUE;
    }

    return FALSE;
}

int IsSpellCastAt()
{
    object oCreature = OBJECT_SELF;
    if(LOCAL_DEBUG) DoDebug("default: IsSpellCastAt():\n"
                    + "GetLastSpellCaster() = " + DebugObject2Str(GetLastSpellCaster()) + "\n"
                    + "GetLastSpell() = " + IntToString(GetLastSpell()) + "\n"
                    + "GetLastSpellHarmful() = " + IntToString(GetLastSpellHarmful()) + "\n"
                      );
    // If the event data does not contain the fake value, a spell has been cast
    if(GetLastSpell() != -1)
    {
        // Reset the event data to the fake value
        DelayCommand(0.0f, SignalEvent(oCreature, EventSpellCastAt(oCreature, -1, FALSE)));

        return TRUE;
    }

    return FALSE;
}

int IsUserDefined()
{
    object oCreature = OBJECT_SELF;
    if(LOCAL_DEBUG) DoDebug("default: IsUserDefined():\n"
                          + "GetUserDefinedEventNumber() = " + IntToString(GetUserDefinedEventNumber()) + "\n"
                            );

    if(GetUserDefinedEventNumber() != -1)
    {
        // Reset the event data to the fake value
        DelayCommand(0.0f, SignalEvent(oCreature, EventUserDefined(-1)));

        return TRUE;
    }

    return FALSE;
}

/*********************/
/* Utility Functions */
/*********************/

int IsObjectChanged(object oTest, string sName)
{
    if(oTest != GetLocalObject(OBJECT_SELF, "PRC_Event_" + sName))
    {
        SetLocalObject(OBJECT_SELF, "PRC_Event_" + sName, oTest);
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

int IsIntChanged(int iTest, string sName)
{
    if(iTest != GetLocalInt(OBJECT_SELF, "PRC_Event_" + sName))
    {
        SetLocalInt(OBJECT_SELF, "PRC_Event_" + sName, iTest);
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

int IsStringChanged(string sTest, string sName)
{
    if(sTest != GetLocalString(OBJECT_SELF, "PRC_Event_" + sName))
    {
        SetLocalString(OBJECT_SELF, "PRC_Event_" + sName, sTest);
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

void RunScript(int nEvent)
{
    object oSelf = OBJECT_SELF;

    if(LOCAL_DEBUG) DoDebug("default, event = " + IntToString(nEvent));

    if(nEvent == EVENT_VIRTUAL_ONDAMAGED)
        SignalEvent(oSelf, EventUserDefined(EVENT_DAMAGED));
    // Determine NPC script name and run generic eventhook
    ExecuteAllScriptsHookedToEvent(oSelf, nEvent);
}