#include "prc_alterations"
#include "reg_inc"
void main()
{
    int nPCInArea = FALSE;
    object oPC = GetFirstPC();
    while(GetIsObjectValid(oPC) && !nPCInArea)
    {
        if(GetArea(oPC) == OBJECT_SELF)
        {
            nPCInArea = TRUE;
            break;
        }
        oPC = GetNextPC();
    }
    DoDebug("nPCInArea = "+IntToString(nPCInArea));
    if(!nPCInArea)
        return;
    //test if hostiles present
    int nHostilesPresent;
    object oTest = GetFirstObjectInArea(OBJECT_SELF);
    while(GetIsObjectValid(oTest))
    {
        if(GetIsEnemy(oPC, oTest) 
            && GetObjectType(oTest) == OBJECT_TYPE_CREATURE
            && !GetIsDead(oTest))
        {
            nHostilesPresent = TRUE;
            break;
        }
        oTest = GetNextObjectInArea(OBJECT_SELF);
    }
    DoDebug("nHostilesPresent = "+IntToString(nHostilesPresent));
    if(nHostilesPresent)
        return;
    //no enemies, spawn some
    float fEL = IntToFloat(GetECL(oPC));
    int nRace;
    int nPlayable;
    while(!nPlayable)
    {
        nRace = Random(REG_RACE_MAX);
        nPlayable = StringToInt(Get2DACache("racialtypes", "PlayerRace", nRace));
        //check that the minimum ECL for that race is less than the players
        int nMinECL = 1;
        if(GetPRCSwitch(PRC_XP_USE_SIMPLE_LA))
            nMinECL += StringToInt(Get2DACache("ECL", "LA", nRace));
        if(GetPRCSwitch(PRC_XP_USE_SIMPLE_RACIAL_HD))
            nMinECL += StringToInt(Get2DACache("ECL", "RaceHD", nRace));
        if(IntToFloat(nMinECL) > fEL)
            nPlayable = FALSE;
    }
    int nSize;
    oPC = GetFirstPC();
    while(GetIsObjectValid(oPC))
    {
        nSize++;
        oPC = GetNextPC();
    }    
    nSize += GetPRCSwitch(PRC_BONUS_COHORTS);
    location lSpawn = GetLocation(GetObjectByTag("arenaencounter", Random(2)));
    REG_SpawnEncounter(fEL, nSize, "", lSpawn, nRace, 0, -1.0);
    SetLocalInt(OBJECT_SELF, "Score", GetLocalInt(OBJECT_SELF, "Score")+1);
}
