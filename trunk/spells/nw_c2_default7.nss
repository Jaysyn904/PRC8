//:://////////////////////////////////////////////////
//:: NW_C2_DEFAULT7
/*
  Default OnDeath event handler for NPCs.

  Adjusts killer's alignment if appropriate and
  alerts allies to our death.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/22/2002
//:://////////////////////////////////////////////////
//:://////////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified On: April 1st, 2008
//:: Added Support for Dying Wile Mounted
//:://///////////////////////////////////////////////

const string sHenchSummonedFamiliar = "HenchSummonedFamiliar";
const string sHenchSummonedAniComp  = "HenchSummonedAniComp";
const string sHenchLastHeardOrSeen  = "LastSeenOrHeard";

#include "x2_inc_compon"
#include "x0_i0_spawncond"

// Clears the last unheard, unseen enemy location
void ClearEnemyLocation();

void main()
{
    object oKiller = GetLastKiller();
    object oMaster = GetMaster();

    int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);

    if(GetLocalInt(GetModule(), "X3_ENABLE_MOUNT_DB") && GetIsObjectValid(oMaster))
        SetLocalInt(oMaster, "bX3_STORE_MOUNT_INFO", TRUE);

    // If we're a good/neutral commoner,
    // adjust the killer's alignment evil
    if(GetLevelByClass(CLASS_TYPE_COMMONER)
    && (nAlign == ALIGNMENT_GOOD || nAlign == ALIGNMENT_NEUTRAL))
    {
        AdjustAlignment(oKiller, ALIGNMENT_EVIL, 5);
    }

//Start Hench AI
    if(GetLocalInt(OBJECT_SELF, "GaveHealing"))
    {
        // Pausanias: destroy potions of healing
        object oItem = GetFirstItemInInventory();
        while(GetIsObjectValid(oItem))
        {
            if(GetTag(oItem) == "NW_IT_MPOTION003")
                DestroyObject(oItem);
            oItem = GetNextItemInInventory();
        }
    }

    if(GetLocalInt(OBJECT_SELF, sHenchSummonedFamiliar))
    {
        object oFam = GetLocalObject(OBJECT_SELF, sHenchSummonedFamiliar);
        if(GetIsObjectValid(oFam))
        {
            //if(DEBUG) DoDebug(GetName(OBJECT_SELF) + " destroy familiar");
            DestroyObject(oFam, 0.1);
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(oFam));
        }
    }
    if(GetLocalInt(OBJECT_SELF, sHenchSummonedAniComp))
    {
        object oAni = GetLocalObject(OBJECT_SELF, sHenchSummonedAniComp);
        if(GetIsObjectValid(oAni))
        {
            //if(DEBUG) DoDebug(GetName(OBJECT_SELF) + " destroy ani comp");
            DestroyObject(oAni, 0.1);
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(oAni));
        }
    }

    ClearEnemyLocation();
//End Hench AI

    // Call to allies to let them know we're dead
    SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);

    //Shout Attack my target, only works with the On Spawn In setup
    SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);

    // NOTE: the OnDeath user-defined event does not
    // trigger reliably and should probably be removed
    if(GetSpawnInCondition(NW_FLAG_DEATH_EVENT))
         SignalEvent(OBJECT_SELF, EventUserDefined(1007));

    craft_drop_items(oKiller);

    ExecuteScript("prc_npc_death", OBJECT_SELF);
    ExecuteScript("prc_pwondeath", OBJECT_SELF);
}

void ClearEnemyLocation()
{
    DeleteLocalInt(OBJECT_SELF, sHenchLastHeardOrSeen);
    DeleteLocalLocation(OBJECT_SELF, sHenchLastHeardOrSeen);

    object oInvisTarget = GetLocalObject(OBJECT_SELF, sHenchLastHeardOrSeen);
    if (GetIsObjectValid(oInvisTarget))
    {
        DestroyObject(oInvisTarget);
        DeleteLocalObject(OBJECT_SELF, sHenchLastHeardOrSeen);
    }
}