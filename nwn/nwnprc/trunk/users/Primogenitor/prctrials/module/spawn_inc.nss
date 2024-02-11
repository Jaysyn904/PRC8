
void AddToSpawnQueue(string sResRef, location lLoc, float fCR, int nRace = -1);
object MyCreateObject(string sResRef, location lLoc, float fCR, int bUseAppearAnimation=FALSE, string sNewTag="");

#include "reg_inc"


const float SPAWN_DELAY_IDLE   = 3.0;
const float SPAWN_DELAY_ACTIVE = 1.0;

object MyCreateObject(string sResRef, location lLoc, float fCR, int bUseAppearAnimation=FALSE, string sNewTag="")
{
    object oSpawn;
    if(!GetIsObjectValid(oSpawn)) oSpawn = CreateObject(OBJECT_TYPE_CREATURE,  sResRef, lLoc, bUseAppearAnimation, sNewTag);
    if(!GetIsObjectValid(oSpawn)) oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lLoc, bUseAppearAnimation, sNewTag);
    if(!GetIsObjectValid(oSpawn)) oSpawn = CreateObject(OBJECT_TYPE_ITEM,      sResRef, lLoc, bUseAppearAnimation, sNewTag);
    if(!GetIsObjectValid(oSpawn)) oSpawn = CreateObject(OBJECT_TYPE_STORE,     sResRef, lLoc, bUseAppearAnimation, sNewTag);
    if(!GetIsObjectValid(oSpawn)) oSpawn = CreateObject(OBJECT_TYPE_WAYPOINT,  sResRef, lLoc, bUseAppearAnimation, sNewTag);
    if(!GetIsObjectValid(oSpawn))
        DoDebug("ERROR: spawn_inc MyCreateObject() Unable to create "+sResRef);
    SetLocalFloat(oSpawn, "CR", fCR);
    ExecuteScript(sResRef, oSpawn);
    return oSpawn;
}

void ProcessSpawnQueue()
{
    object oMod = GetModule();
    int nHead = GetLocalInt(oMod, "SpawnHead");
    int nTail = GetLocalInt(oMod, "SpawnTail");
    if(nHead != nTail)
    {
DoDebug("nHead = "+IntToString(nHead)+" nTail = "+IntToString(nTail));
        int nRace = GetLocalInt(oMod, "SpawnRace_"+IntToString(nHead));
        string sResRef = GetLocalString(oMod, "SpawnResRef_"+IntToString(nHead));
        location lSpawn = GetLocalLocation(oMod, "SpawnLoc_"+IntToString(nHead));
        float fCR = GetLocalFloat(oMod, "SpawnCR_"+IntToString(nHead));

DoDebug("sResRef = "+sResRef+" nRace = "+IntToString(nRace));
        object oSpawn;
        if(sResRef == "")
        {
            //spawn in limbo to avoid invisible npc syndrome
            location lLimbo = GetLocation(GetWaypointByTag("spawn_temp_"+IntToString(RandomI(25))));
            oSpawn = REG_CreateNPC(lLimbo, fCR, nRace);
            if(GetIsObjectValid(oSpawn))
                DelayCommand(6.0, 
                    AssignCommand(oSpawn, 
                        JumpToLocation(lSpawn)));
            else
                DelayCommand(SPAWN_DELAY_ACTIVE, ProcessSpawnQueue());
        }
        else
        {
            MyCreateObject(sResRef, lSpawn, fCR, TRUE);
        }
        nHead++;
        SetLocalInt(oMod, "SpawnHead", nHead);
        DelayCommand(SPAWN_DELAY_ACTIVE, ProcessSpawnQueue());
    }
    else
        DelayCommand(SPAWN_DELAY_IDLE, ProcessSpawnQueue());
}

void AddToSpawnQueue(string sResRef, location lLoc, float fCR, int nRace = -1)
{
    if(sResRef == "" && nRace < 0)
        return;
    object oMod = GetModule();
    int nTail = GetLocalInt(oMod, "SpawnTail");
    SetLocalInt(oMod, "SpawnRace_"+IntToString(nTail),nRace);
    SetLocalString(oMod, "SpawnResRef_"+IntToString(nTail), sResRef);
    SetLocalLocation(oMod, "SpawnLoc_"+IntToString(nTail), lLoc);
    SetLocalFloat(oMod, "SpawnCR_"+IntToString(nTail), fCR);
    nTail++;
    SetLocalInt(oMod, "SpawnTail", nTail);
}
