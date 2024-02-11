#include "prc_alterations"
#include "inc_eventhook"
#include "spawn_inc"

const int errorcode5fix = 999;
const int AREA_SETUP_EVENT_ID = 500;
const int AREA_CLEAR_EVENT_ID = 501;

void main()
{
    int nEventID = GetUserDefinedEventNumber();
    object oArea = OBJECT_SELF;
    switch(nEventID)
    {
        case AREA_SETUP_EVENT_ID:
        if(!GetLocalInt(oArea, "Spawned"))
        {
            SetLocalInt(oArea, "Spawned", TRUE);
            object oTest = GetFirstObjectInArea(oArea);
            while(GetIsObjectValid(oTest))
            {
                //randomize doors
                if(GetObjectType(oTest) == OBJECT_TYPE_DOOR)
                {
                    //all doors can be locked
                    SetLockLockable(oTest, TRUE);
                    //all doors are untrapped by default
                    SetTrapActive(oTest, FALSE);
                    SetTrapDetectable(oTest, FALSE);
                    object oPC = GetFirstPC();
                    while(GetIsObjectValid(oPC))
                    {
                        SetTrapDetectedBy(oTest, oPC, FALSE);
                        oPC = GetNextPC();
                    }
                    //hook in the respawning door stuff
                    AddEventScript(oTest, EVENT_DOOR_ONDAMAGED, "door_damaged", TRUE, FALSE);
                    AddEventScript(oTest, EVENT_DOOR_ONUSERDEFINED, "door_ud", TRUE, FALSE);
                    //hook in transitioning
                    AddEventScript(oTest, EVENT_DOOR_ONTRANSITION, "NW_G0_Transition", TRUE, FALSE);
                    //now the random part
                    /*
                    switch(Random(5))
                    {
                        //destroyed
                        case 0:
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetMaxHitPoints(oTest)-1), oTest);
                            break;
                        //opened
                        case 1:
                            if(Random(2))
                                AssignCommand(oTest, PlayAnimation(ANIMATION_DOOR_OPEN1));
                            else
                                AssignCommand(oTest, PlayAnimation(ANIMATION_DOOR_OPEN2));
                            break;
                        //locked
                        case 2:
                            SetLocked(oTest, TRUE);
                    }
                    */
                }
                else if(GetObjectType(oTest) == OBJECT_TYPE_WAYPOINT
                    && GetTag(oTest) == "encounter")
                {
                    switch(Random(5))
                    {
                        //creatures
                        default:
                        case 0:
                        case 1:
                        case 2:
                        case 3:
                        case 4:
                            location lSpawn = GetLocation(oTest);
                            float fEL = GetLocalFloat(GetModule(), "QuestEL")-1.0;
                            int nRace = GetLocalInt(GetModule(), "QuestRace")-1;
                            int nSize;
                            object oPC = GetFirstPC();
                            while(GetIsObjectValid(oPC))
                            {
                                nSize++;
                                oPC = GetNextPC();
                            }    
                            nSize += GetPRCSwitch(PRC_BONUS_COHORTS);
                            if(fEL < 0.0)
                            {
                                fEL = IntToFloat(GetECL(GetFirstPC()));
                                SetLocalFloat(GetModule(), "QuestEL", fEL+1.0);
                            }
                            if(nRace < 0)
                            {
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
                                SetLocalInt(GetModule(), "QuestRace", nRace+1);
                            }
                            REG_SpawnEncounter(fEL, nSize, "", lSpawn, nRace, 0, -1.0);
                            break;
                        //traps
                            break;
                    }

                }
                oTest = GetNextObjectInArea(oArea);
            }
        }
        break;

        case AREA_CLEAR_EVENT_ID:
        {
            object oTest = GetFirstObjectInArea(oArea);
            while(GetIsObjectValid(oTest))
            {
                //clean up stuff
                if(!GetIsPC(oTest)
                    && !GetPlotFlag(oTest)
                    && GetObjectType(oTest) != OBJECT_TYPE_DOOR
                    && GetObjectType(oTest) != OBJECT_TYPE_TRIGGER
                    && GetObjectType(oTest) != OBJECT_TYPE_WAYPOINT
                    )
                {
                    if(GetHasInventory(oTest))
                    {
                        object oTest2 = GetFirstItemInInventory(oTest);
                        while(GetIsObjectValid(oTest2))
                        {
                            if(GetHasInventory(oTest2))
                            {
                                object oTest3 = GetFirstItemInInventory(oTest2);
                                while(GetIsObjectValid(oTest3))
                                {
                                    DestroyObject(oTest3);
                                    oTest3 = GetNextItemInInventory(oTest2);
                                }
                            }
                            DestroyObject(oTest2);
                            oTest2 = GetNextItemInInventory(oTest);
                        }
                        DestroyObject(oTest2);
                    }
                    DestroyObject(oTest);
                }

                //respawn doors
                if(GetObjectType(oTest) == OBJECT_TYPE_DOOR)
                    SignalEvent(oTest, EventUserDefined(500));

                //destroy trigger traps as these must have come from trap kits
                //or they may have been spawned
                if(GetObjectType(oTest) == OBJECT_TYPE_TRIGGER
                    && GetIsTrapped(oTest))
                    DestroyObject(oTest);

                oTest = GetNextObjectInArea(oArea);
            }
            DeleteLocalInt(oArea, "Spawned");
            DeleteLocalFloat(GetModule(), "QuestEL");
            DeleteLocalInt(GetModule(), "QuestRace");
        }
        break;
    }
}
