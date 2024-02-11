#include "tetris_inc_block"

const int TETRIS_EVENT_LEFT  = 5001;
const int TETRIS_EVENT_RIGHT = 5002;
const int TETRIS_EVENT_DROP  = 5003;
const int TETRIS_EVENT_END = 5004;
const int TETRIS_EVENT_INPLACE= 5005;
const int TETRIS_EVENT_START = 5006;
const int TETRIS_EVENT_ROTATE_CLOCKWISE = 5007;
const int TETRIS_EVENT_ROTATE_ANTICLOCKWISE = 5008;

const int TETRIS_GRID_WIDTH = 10;//8
const int TETRIS_GRID_HEIGHT = 14;//11
const float TETRIS_TILE_SIZE = 2.0;//2.5

const int TETRIS_BLOCK_RUN = FALSE;


int Tetris_GetRandomAppearance(object oArea)
{
    int nCount = GetLocalInt(oArea, "Tetris_App_Count");
    //no precached count, do it by hand
    if(nCount == 0)
    {
        int nApp = GetLocalInt(oArea, "Tetris_App_"+IntToString(nCount));
        while(nApp != 0)
        {
            nCount++;
            nApp = GetLocalInt(oArea, "Tetris_App_"+IntToString(nCount));
        }
        SetLocalInt(oArea, "Tetris_App_Count", nCount);
    }
    int nAppearance;
    if(nCount == 0)
    {
        //no assigned counts, use default of elementals
        switch(Random(4)+1)
        {
            case 1: nAppearance = APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER; break;
            case 2: nAppearance = APPEARANCE_TYPE_ELEMENTAL_EARTH_ELDER; break;
            case 3: nAppearance = APPEARANCE_TYPE_ELEMENTAL_FIRE_ELDER; break;
            case 4: nAppearance = APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER; break;
            default: nAppearance = APPEARANCE_TYPE_SKELETAL_DEVOURER; break;
        }
        return nAppearance;
    }
    nCount = Random(nCount);
    nAppearance = GetLocalInt(oArea, "Tetris_App_"+IntToString(nCount));
    return nAppearance;
}

void Tetris_RemovePCEffects(object oPC, object oArea)
{
    effect eTest = GetFirstEffect(oPC);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectCreator(eTest) == oArea
            && GetEffectDurationType(eTest) == DURATION_TYPE_TEMPORARY
            && GetEffectSubType(eTest) == SUBTYPE_SUPERNATURAL)
            RemoveEffect(oPC, eTest);
        eTest = GetNextEffect(oPC);
    }

}

void Tetris_ApplyPCEffects(object oPC)
{
    effect eGhost = EffectCutsceneGhost();
    effect eVFX = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
    effect eParal = EffectCutsceneParalyze();
    effect eLink = EffectLinkEffects(eGhost, eVFX);
    eLink = EffectLinkEffects(eLink, eParal);
    eLink = SupernaturalEffect(eLink);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
        eLink,
        oPC,
        999999999.9);
}
object Tetris_GetObjectForGrid(object oArea, int nColumn, int nRow)
{
    object oReturn;
    if(nColumn < 0) return OBJECT_INVALID;
    if(nColumn >= TETRIS_GRID_WIDTH) return OBJECT_INVALID;
    if(nRow <0) return OBJECT_INVALID;
    oReturn = GetLocalObject(oArea,
            "TetrisGridObject_"+IntToString(nColumn)+"_"+IntToString(nRow));
    return oReturn;
}

int Tetris_GetValueForGrid(object oArea, int nColumn, int nRow)
{
    int nReturn;
    if(nColumn < 0) return TRUE;
    if(nColumn >= TETRIS_GRID_WIDTH) return TRUE;
    if(nRow <0) return TRUE;
    nReturn = GetLocalInt(oArea,
            "TetrisGrid_"+IntToString(nColumn)+"_"+IntToString(nRow));
    return nReturn;
}

int Tetris_GetFreeRowForBlock(object oArea, int nColumn, struct Tetris_Block tb, int nRow = TETRIS_GRID_HEIGHT)
{
    int bIsFull = GetLocalInt(oArea,
        "TetrisGrid_"+IntToString(nColumn)+"_"+IntToString(nRow));
    while(!bIsFull && nRow > -1)
    {
        nRow--;
        bIsFull  = 0;
        bIsFull += Tetris_GetValueForGrid(oArea, nColumn, nRow);
        bIsFull += Tetris_GetValueForGrid(oArea, nColumn+tb.n2Col, nRow+tb.n2Row);
        bIsFull += Tetris_GetValueForGrid(oArea, nColumn+tb.n3Col, nRow+tb.n3Row);
        bIsFull += Tetris_GetValueForGrid(oArea, nColumn+tb.n4Col, nRow+tb.n4Row);
    }
    return nRow+1;
}

int Tetris_GetFreeRow(object oArea, int nColumn, int nRow = TETRIS_GRID_HEIGHT)
{
    int bIsFull = GetLocalInt(oArea,
        "TetrisGrid_"+IntToString(nColumn)+"_"+IntToString(nRow));
    while(!bIsFull && nRow > -1)
    {
        nRow--;
        bIsFull = GetLocalInt(oArea,
            "TetrisGrid_"+IntToString(nColumn)+"_"+IntToString(nRow));
    }
    return nRow+1;
}

location Tetris_GetLocationByCoord(object oWP, int nColumn, int nRow)
{
    location lSpawn = GetLocation(oWP);
    float fSpawnX = GetPositionFromLocation(lSpawn).x;
    float fSpawnY = GetPositionFromLocation(lSpawn).y;
    float fSpawnZ = GetPositionFromLocation(lSpawn).z;
    //move it to center of first square
    fSpawnX += (TETRIS_TILE_SIZE*0.5);
    fSpawnY += (TETRIS_TILE_SIZE*0.5);
    //offset it
    fSpawnX += (TETRIS_TILE_SIZE*IntToFloat(nColumn));
    fSpawnY += (TETRIS_TILE_SIZE*IntToFloat(nRow));
    //reassemble it
    lSpawn = Location(GetArea(oWP),
        Vector(fSpawnX, fSpawnY, fSpawnZ),
        270.0);
    return lSpawn;
}

void Tetris_EndGame(object oPC, object oArea, int nOnExit = TRUE)
{
    if(!nOnExit)
    {
        FadeToBlack(oPC, FADE_SPEED_FAST);
        location lStart = GetLocalLocation(oPC, "Tetris_Start");
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_IMP_UNSUMMON),
            lStart);
        DelayCommand(3.0,
            AssignCommand(oPC, RestoreCameraFacing()));
        DelayCommand(3.1,
            SetCutsceneMode(oPC, FALSE));
        DelayCommand(5.0,
            FadeFromBlack(oPC, FADE_SPEED_FAST));
        DelayCommand(3.3,
            SetCameraHeight(oPC, 0.0));
        //remove effects
        DelayCommand(3.4,
            Tetris_RemovePCEffects(oPC, oArea));
        DelayCommand(3.5,
            AssignCommand(oPC,
                JumpToLocation(lStart)));
        int nRow = GetLocalInt(oArea, "TetrisRows");
        int nScore = GetLocalInt(oArea, "TetrisScore");
        DelayCommand(6.0,
            FloatingTextStringOnCreature("Game Over. You cleared "+IntToString(nRow)+" rows and scored "+IntToString(nScore)+" points.", oPC));
    }
    DelayCommand(5.0, DeleteLocalInt(OBJECT_SELF, "TetrisStarted"));
    DelayCommand(3.0,
        SignalEvent(oArea,
            EventUserDefined(TETRIS_EVENT_END)));
}

void Tetris_StartGame(object oPC, object oArea = OBJECT_INVALID)
{
    if(!GetIsObjectValid(oArea)
        || GetIsAreaNatural(oArea) != AREA_INVALID)
    {
        int i = 0;
        object oWP = GetObjectByTag("Tetris_Corner", i);
        oArea = GetArea(oWP);
        int nCount;
        while(GetIsObjectValid(oWP))
        {
PrintString("Checking area : "+GetResRef(oArea));
SendMessageToPC(oPC, "Checking area : "+GetResRef(oArea));
            if(!GetLocalInt(oArea, "TetrisStarted"))
            {
                SetLocalObject(GetModule(), "Tetris_Array_"+IntToString(nCount), oArea);
                nCount++;
PrintString("Adding area : "+GetResRef(oArea));
SendMessageToPC(oPC, "Adding area : "+GetResRef(oArea));
            }
            i++;
            oWP = GetObjectByTag("Tetris_Corner", i);
            oArea = GetArea(oWP);
        }
        oArea = OBJECT_INVALID;
        if(nCount)
        {
            nCount = Random(nCount);
            oArea = GetLocalObject(GetModule(), "Tetris_Array_"+IntToString(nCount));
        }
    }
    if(!GetIsObjectValid(oArea))
    {
        //no free areas, abort;
        FloatingTextStringOnCreature("All Tetris courts are in use, please try again later.", oPC);
        return;
    }
    object oWP;
    object oTest = GetFirstObjectInArea(oArea);
    while(GetIsObjectValid(oTest))
    {
        if(GetTag(oTest) == "Tetris_Corner")
        {
            oWP = oTest;
            break;// end while loop
        }
        oTest = GetNextObjectInArea(oArea);
    }
    location lPlayer = GetLocation(oWP);
    //move it into the court
    vector vPos = GetPositionFromLocation(lPlayer);
    vPos.x += 10.0;
    vPos.y += 10.0;
    lPlayer = Location(oArea, vPos, 90.0);
    SetLocalLocation(oPC, "Tetris_Start", GetLocation(oPC));
    FadeToBlack(oPC, FADE_SPEED_FAST);
    DelayCommand(3.0,
        AssignCommand(oPC,
            JumpToLocation(lPlayer)));
    //make them invisible and noclipand stationary
    //this has to be after the jump, but before the cutscene
    //assigned to the area so it can be removed
    DelayCommand(4.0,
        AssignCommand(GetArea(oWP),
            Tetris_ApplyPCEffects(oPC)));
    DelayCommand(5.0,
        SetCutsceneMode(oPC, TRUE, TRUE));
    //setup the camera
    StoreCameraFacing();
    DelayCommand(4.0,
        AssignCommand(oPC,
            SetCameraFacing(90.0, 25.0, 1.0)));
    DelayCommand(5.0,
        SetCameraHeight(oPC, 15.0));
    DelayCommand(5.0,
        FadeFromBlack(oPC, FADE_SPEED_FAST));
    //make sure last game was cleaned up
    DelayCommand(5.0,
        SignalEvent(GetArea(oWP),
            EventUserDefined(TETRIS_EVENT_END)));
    //start the game
    DelayCommand(8.0,
        SignalEvent(GetArea(oWP),
            EventUserDefined(TETRIS_EVENT_START)));
    //mark the player as playing tetris
    SetLocalObject(GetArea(oWP), "Tetris_Player", oPC);
    //mark court as inuse
    SetLocalInt(oArea, "TetrisStarted", TRUE);
}

void Tetris_MakeBlock()
{
    //start with simple 1x1 blocks
    object oArea = OBJECT_SELF;
    object oWP = GetFirstObjectInArea(oArea);
    while(GetIsObjectValid(oWP))
    {
        if(GetTag(oWP) == "Tetris_Corner")
            break;
        oWP = GetNextObjectInArea(oArea);
    }
    struct Tetris_Block tb = Tetris_GetRandomBlock();
    int nBlockMaxWidth  = Tetris_GetMaxColOffset(tb);
    //int nBlockMaxHeight = Tetris_GetMaxRowOffset(tb);
    int nBlockMinWidth  = Tetris_GetMinColOffset(tb);
    //int nBlockMinHeight = Tetris_GetMinRowOffset(tb);
    //move it to a random column
    //int nColumn = Random(TETRIS_GRID_WIDTH-nBlockMaxWidth+nBlockMinWidth)-nBlockMinWidth;
    //by tetris rules, blocks always start in the middle
    int nColumn = TETRIS_GRID_WIDTH/2;
    //put the end row to the right location
    int nRow = Tetris_GetFreeRowForBlock(oArea, nColumn, tb);
    //check for game over
    if(nRow >= TETRIS_GRID_HEIGHT-1)
    {
        object oPC = GetLocalObject(oArea, "Tetris_Player");
        DelayCommand(0.0, Tetris_EndGame(oPC, oArea, FALSE));
    }
    else
    {
        int nAppearance = Tetris_GetRandomAppearance(oArea);
        location lSpawn = Tetris_GetLocationByCoord(oWP, nColumn, TETRIS_GRID_HEIGHT);
        location lSpawn2= Tetris_GetLocationByCoord(oWP, nColumn+tb.n2Col, TETRIS_GRID_HEIGHT+tb.n2Row);
        location lSpawn3= Tetris_GetLocationByCoord(oWP, nColumn+tb.n3Col, TETRIS_GRID_HEIGHT+tb.n3Row);
        location lSpawn4= Tetris_GetLocationByCoord(oWP, nColumn+tb.n4Col, TETRIS_GRID_HEIGHT+tb.n4Row);
        location lTarget = Tetris_GetLocationByCoord(oWP, nColumn, nRow);
        location lTarget2 = Tetris_GetLocationByCoord(oWP, nColumn+tb.n2Col, nRow+tb.n2Row);
        location lTarget3 = Tetris_GetLocationByCoord(oWP, nColumn+tb.n3Col, nRow+tb.n3Row);
        location lTarget4 = Tetris_GetLocationByCoord(oWP, nColumn+tb.n4Col, nRow+tb.n4Row);
        //create the object
        object oBlock = CreateObject(OBJECT_TYPE_CREATURE, "tetris_block", lSpawn);
        object oBlock2 = CreateObject(OBJECT_TYPE_CREATURE, "tetris_block", lSpawn2);
        object oBlock3 = CreateObject(OBJECT_TYPE_CREATURE, "tetris_block", lSpawn3);
        object oBlock4 = CreateObject(OBJECT_TYPE_CREATURE, "tetris_block", lSpawn4);
        //set its appearance
        SetCreatureAppearanceType(oBlock, nAppearance);
        SetCreatureAppearanceType(oBlock2, nAppearance);
        SetCreatureAppearanceType(oBlock3, nAppearance);
        SetCreatureAppearanceType(oBlock4, nAppearance);
        //make it noclip
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneGhost(), oBlock, 999999999.9);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneGhost(), oBlock2, 999999999.9);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneGhost(), oBlock3, 999999999.9);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneGhost(), oBlock4, 999999999.9);
        //increase its speed based on difficulty
        int nRows = GetLocalInt(oArea, "TetrisRows");
        int nSpeed = (nRows/10)*10; // 10 rows is a level, so raise it once per level
        if(nSpeed > 99) nSpeed = 99;
        if(nSpeed <  0) nSpeed =  0;
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedIncrease(nSpeed), oBlock, 999999999.9);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedIncrease(nSpeed), oBlock2, 999999999.9);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedIncrease(nSpeed), oBlock3, 999999999.9);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedIncrease(nSpeed), oBlock4, 999999999.9);
        //mark the centre of rotation
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT), oBlock, 999999999.9);
        //set its name to nothing
        //still shows injury status, but better that the name too
        SetName(oBlock, " ");
        SetName(oBlock2, " ");
        SetName(oBlock3, " ");
        SetName(oBlock4, " ");
        //start it walking
        AssignCommand(oBlock,
            ActionJumpToLocation(lSpawn));
        AssignCommand(oBlock2,
            ActionJumpToLocation(lSpawn2));
        AssignCommand(oBlock3,
            ActionJumpToLocation(lSpawn3));
        AssignCommand(oBlock4,
            ActionJumpToLocation(lSpawn4));
        AssignCommand(oBlock,
            ActionMoveToLocation(lTarget, TETRIS_BLOCK_RUN));
        AssignCommand(oBlock2,
            ActionMoveToLocation(lTarget2, TETRIS_BLOCK_RUN));
        AssignCommand(oBlock3,
            ActionMoveToLocation(lTarget3, TETRIS_BLOCK_RUN));
        AssignCommand(oBlock4,
            ActionMoveToLocation(lTarget4, TETRIS_BLOCK_RUN));
        //add the action to mark it as in-place
        AssignCommand(oBlock,
            ActionDoCommand(
                SignalEvent(oArea,
                    EventUserDefined(TETRIS_EVENT_INPLACE))));
        AssignCommand(oBlock2,
            ActionDoCommand(
                SignalEvent(oArea,
                    EventUserDefined(TETRIS_EVENT_INPLACE))));
        AssignCommand(oBlock3,
            ActionDoCommand(
                SignalEvent(oArea,
                    EventUserDefined(TETRIS_EVENT_INPLACE))));
        AssignCommand(oBlock4,
            ActionDoCommand(
                SignalEvent(oArea,
                    EventUserDefined(TETRIS_EVENT_INPLACE))));
        //store the block and target
        SetLocalObject(oArea,
            "TetrisBlock",
            oBlock);
        SetLocalObject(oArea,
            "TetrisBlock2",
            oBlock2);
        SetLocalObject(oArea,
            "TetrisBlock3",
            oBlock3);
        SetLocalObject(oArea,
            "TetrisBlock4",
            oBlock4);
        SetLocalInt(oArea,
            "TetrisBlockColumn",
            nColumn);
        SetLocalInt(oArea,
            "TetrisBlockRow",
            nRow);
        Tetris_SetLocalBlock(oArea,
            "TetrisBlock",
            tb);
        SetLocalInt(oArea, "TetrisBlockCount",
            GetLocalInt(oArea, "TetrisBlockCount")+4);

//DEBUG
//      ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
//          EffectVisualEffect(VFX_IMP_UNSUMMON),
//          lTarget);
//      ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
//          EffectVisualEffect(VFX_IMP_UNSUMMON),
//          lSpawn);
    }
}

int Tetris_GetRowFromLocation(location lLoc, object oCorner)
{
    int nRow;
    float fY = GetPositionFromLocation(lLoc).y;
//DEBUG
//PrintString("fY="+FloatToString(fY));
    float fCornerY = GetPositionFromLocation(GetLocation(oCorner)).y;
    fY -= fCornerY;
//DEBUG
//PrintString("fY="+FloatToString(fY));
//    fY -= (TETRIS_TILE_SIZE*0.5);//remove first offset
//DEBUG
//PrintString("fY="+FloatToString(fY));
    fY /= TETRIS_TILE_SIZE;
//DEBUG
//PrintString("fY="+FloatToString(fY));
    nRow = FloatToInt(fY);
    return nRow;
}

void Tetris_RotatePause(object oArea, location lNewTarget)
{
    if(GetLocalInt(oArea, "TetrisMoveing"))
    {
        DelayCommand(0.1, Tetris_RotatePause(oArea, lNewTarget));
        return;
    }
    ActionMoveToLocation(lNewTarget, TETRIS_BLOCK_RUN);
    ActionDoCommand(SignalEvent(oArea,EventUserDefined(TETRIS_EVENT_INPLACE)));
}

void Tetris_DebugGrid(object oArea)
{
    PrintString("***********************************");
    int nRow;
    for(nRow = TETRIS_GRID_HEIGHT; nRow >= 0; nRow--)
    {
        string sDebug = "| ";
        int nColumn;
        int nCount;
        for(nColumn = 0; nColumn < TETRIS_GRID_WIDTH; nColumn++)
        {
            int nValue = Tetris_GetValueForGrid(oArea, nColumn, nRow);
            object oTest = Tetris_GetObjectForGrid(oArea, nColumn, nRow);
            if(nValue)
                nCount++;
            if(!nValue && GetIsObjectValid(oTest))
                PrintString("Mismatch + @ "+IntToString(nColumn)+", "+IntToString(nRow));
            if(nValue && !GetIsObjectValid(oTest))
                PrintString("Mismatch - @ "+IntToString(nColumn)+", "+IntToString(nRow));
            sDebug += IntToString(nValue)+" | ";
        }
        sDebug+= "("+IntToString(nCount)+")";
        PrintString(sDebug);
    }
    PrintString("***********************************");
}

void EvalScore(object oArea)
{
    int nRows = GetLocalInt(oArea, "TetrisRows");
    int nScore = GetLocalInt(oArea, "TetrisScore");
    int nAddedRows = GetLocalInt(oArea, "TetrisRowsAdded");
    DeleteLocalInt(oArea, "TetrisRowsAdded");
    int nMultiplier;
    if(nAddedRows == 1)      nMultiplier =   40;
    else if(nAddedRows == 2) nMultiplier =  100;
    else if(nAddedRows == 3) nMultiplier =  300;
    else if(nAddedRows == 4) nMultiplier = 1200;
    else                     nMultiplier = nAddedRows*400;
    int nExtraScore = ((nRows/10)+1)*nMultiplier;
    nScore += nExtraScore;
    object oPC = GetLocalObject(oArea, "Tetris_Player");
    if(!nExtraScore)
        FloatingTextStringOnCreature(IntToString(nScore)+ "(+"+IntToString(nExtraScore)+")", oPC);
    SetLocalInt(oArea, "TetrisScore", nScore);
}
