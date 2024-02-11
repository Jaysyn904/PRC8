#include "tetris_inc"

void main()
{
    int nEventID = GetUserDefinedEventNumber();
    object oArea = OBJECT_SELF;

    switch(nEventID)
    {
        case TETRIS_EVENT_LEFT:
        case TETRIS_EVENT_RIGHT:
            if(!GetLocalInt(oArea, "TetrisMoveing"))
            {
                //get current information
                object oBlock = GetLocalObject(oArea, "TetrisBlock");
                object oBlock2 = GetLocalObject(oArea, "TetrisBlock2");
                object oBlock3 = GetLocalObject(oArea, "TetrisBlock3");
                object oBlock4 = GetLocalObject(oArea, "TetrisBlock4");
                object oWP = GetNearestObjectByTag("Tetris_Corner", oBlock);
                int nColumn = GetLocalInt(oArea, "TetrisBlockColumn");
                int nRow    = GetLocalInt(oArea, "TetrisBlockRow");
                struct Tetris_Block tb = Tetris_GetLocalBlock(oArea, "TetrisBlock");
                int nCurrentRow = Tetris_GetRowFromLocation(GetLocation(oBlock), oWP);
                //different events move different directions
                if(nEventID == TETRIS_EVENT_LEFT)
                    nColumn -= 1;
                else if (nEventID == TETRIS_EVENT_RIGHT)
                    nColumn += 1;
                //test if it can be moved
                int bIsFull;
                bIsFull += Tetris_GetValueForGrid(oArea, nColumn, nCurrentRow);
                bIsFull += Tetris_GetValueForGrid(oArea, nColumn+tb.n2Col, nCurrentRow+tb.n2Row);
                bIsFull += Tetris_GetValueForGrid(oArea, nColumn+tb.n3Col, nCurrentRow+tb.n3Row);
                bIsFull += Tetris_GetValueForGrid(oArea, nColumn+tb.n4Col, nCurrentRow+tb.n4Row);
                //if it can be moved, do it
                if(!bIsFull)
                {
                    int nTargetRow = Tetris_GetFreeRowForBlock(oArea, nColumn, tb, nCurrentRow);
                    location lNewTarget = Tetris_GetLocationByCoord(oWP, nColumn, nTargetRow);
                    location lNewStart = Tetris_GetLocationByCoord(oWP, nColumn, nCurrentRow);
                    location lNewTarget2 = Tetris_GetLocationByCoord(oWP, nColumn+tb.n2Col, nTargetRow+tb.n2Row);
                    location lNewStart2 = Tetris_GetLocationByCoord(oWP, nColumn+tb.n2Col, nCurrentRow+tb.n2Row);
                    location lNewTarget3 = Tetris_GetLocationByCoord(oWP, nColumn+tb.n3Col, nTargetRow+tb.n3Row);
                    location lNewStart3 = Tetris_GetLocationByCoord(oWP, nColumn+tb.n3Col, nCurrentRow+tb.n3Row);
                    location lNewTarget4 = Tetris_GetLocationByCoord(oWP, nColumn+tb.n4Col, nTargetRow+tb.n4Row);
                    location lNewStart4 = Tetris_GetLocationByCoord(oWP, nColumn+tb.n4Col, nCurrentRow+tb.n4Row);
                    AssignCommand(oBlock, ClearAllActions());
                    DelayCommand(0.5, AssignCommand(oBlock, ActionJumpToLocation(lNewStart)));
                    DelayCommand(0.51, AssignCommand(oBlock, ActionDoCommand( SetLocalInt(oArea, "TetrisMoveing", GetLocalInt(oArea, "TetrisMoveing")-1))));
                    DelayCommand(0.53, AssignCommand(oBlock, ActionDoCommand(Tetris_RotatePause(oArea, lNewTarget))));
                    AssignCommand(oBlock2, ClearAllActions());
                    DelayCommand(0.5, AssignCommand(oBlock2, ActionJumpToLocation(lNewStart2)));
                    DelayCommand(0.51, AssignCommand(oBlock2, ActionDoCommand( SetLocalInt(oArea, "TetrisMoveing", GetLocalInt(oArea, "TetrisMoveing")-1))));
                    DelayCommand(0.53, AssignCommand(oBlock2, ActionDoCommand(Tetris_RotatePause(oArea, lNewTarget2))));
                    AssignCommand(oBlock3, ClearAllActions());
                    DelayCommand(0.5, AssignCommand(oBlock3, ActionJumpToLocation(lNewStart3)));
                    DelayCommand(0.51, AssignCommand(oBlock3, ActionDoCommand( SetLocalInt(oArea, "TetrisMoveing", GetLocalInt(oArea, "TetrisMoveing")-1))));
                    DelayCommand(0.53, AssignCommand(oBlock3, ActionDoCommand(Tetris_RotatePause(oArea, lNewTarget3))));
                    AssignCommand(oBlock4, ClearAllActions());
                    DelayCommand(0.5, AssignCommand(oBlock4, ActionJumpToLocation(lNewStart4)));
                    DelayCommand(0.51, AssignCommand(oBlock4, ActionDoCommand( SetLocalInt(oArea, "TetrisMoveing", GetLocalInt(oArea, "TetrisMoveing")-1))));
                    DelayCommand(0.53, AssignCommand(oBlock4, ActionDoCommand(Tetris_RotatePause(oArea, lNewTarget4))));
                    //store new target etc
                    SetLocalInt(oArea, "TetrisMoveing", 4);
                    SetLocalInt(oArea, "TetrisBlockColumn", nColumn);
                    SetLocalInt(oArea, "TetrisBlockRow", nTargetRow);
                }

            }
            break;

        case TETRIS_EVENT_ROTATE_CLOCKWISE:
        case TETRIS_EVENT_ROTATE_ANTICLOCKWISE:
            if(!GetLocalInt(oArea, "TetrisMoveing"))
            {
                object oBlock = GetLocalObject(oArea, "TetrisBlock");
                object oBlock2 = GetLocalObject(oArea, "TetrisBlock2");
                object oBlock3 = GetLocalObject(oArea, "TetrisBlock3");
                object oBlock4 = GetLocalObject(oArea, "TetrisBlock4");
                object oWP = GetNearestObjectByTag("Tetris_Corner", oBlock);
                int nColumn = GetLocalInt(oArea, "TetrisBlockColumn");
                int nRow    = GetLocalInt(oArea, "TetrisBlockRow");
                struct Tetris_Block tb = Tetris_GetLocalBlock(oArea, "TetrisBlock");
                int bIsFull = TRUE;
                int nRotationCount = 1;
                struct Tetris_Block newtb;
                newtb = Tetris_GetLocalBlock(oArea, "TetrisBlock");
                int nCurrentRow = Tetris_GetRowFromLocation(GetLocation(oBlock), oWP);
                while(bIsFull != 0 && nRotationCount < 4)
                {
                    if(nEventID == TETRIS_EVENT_ROTATE_CLOCKWISE)
                        newtb = Tetris_RotateBlockClock(newtb);
                    else if(nEventID == TETRIS_EVENT_ROTATE_ANTICLOCKWISE)
                        newtb = Tetris_RotateBlockAntiClock(newtb);
                    bIsFull = 0;
                    bIsFull += Tetris_GetValueForGrid(oArea, nColumn, nCurrentRow);
                    bIsFull += Tetris_GetValueForGrid(oArea, nColumn+newtb.n2Col, nCurrentRow+newtb.n2Row);
                    bIsFull += Tetris_GetValueForGrid(oArea, nColumn+newtb.n3Col, nCurrentRow+newtb.n3Row);
                    bIsFull += Tetris_GetValueForGrid(oArea, nColumn+newtb.n4Col, nCurrentRow+newtb.n4Row);
//DEBUG
/*
PrintString("nRotationCount = "+IntToString(nRotationCount));
PrintString("bIsFull = "+IntToString(bIsFull));
PrintString("newtb.n2Col = "+IntToString(newtb.n2Col));
PrintString("newtb.n2Row = "+IntToString(newtb.n2Row));
PrintString("newtb.n3Col = "+IntToString(newtb.n3Col));
PrintString("newtb.n3Row = "+IntToString(newtb.n3Row));
PrintString("newtb.n4Col = "+IntToString(newtb.n4Col));
PrintString("newtb.n4Row = "+IntToString(newtb.n4Row));
*/
                    nRotationCount++;
                }
                if(nRotationCount >= 4)
                {
                    //cant rotate, no room
                    break; //end switch
                }
                //get the next row it can fit into
                int nTargetRow = Tetris_GetFreeRowForBlock(oArea, nColumn, newtb, nCurrentRow);
                //calculate new locations
                location lNewTarget  = Tetris_GetLocationByCoord(oWP, nColumn, nTargetRow);
                location lNewStart   = Tetris_GetLocationByCoord(oWP, nColumn, nCurrentRow);
                location lNewTarget2 = Tetris_GetLocationByCoord(oWP, nColumn+newtb.n2Col, nTargetRow +newtb.n2Row);
                location lNewStart2  = Tetris_GetLocationByCoord(oWP, nColumn+newtb.n2Col, nCurrentRow+newtb.n2Row);
                location lNewTarget3 = Tetris_GetLocationByCoord(oWP, nColumn+newtb.n3Col, nTargetRow +newtb.n3Row);
                location lNewStart3  = Tetris_GetLocationByCoord(oWP, nColumn+newtb.n3Col, nCurrentRow+newtb.n3Row);
                location lNewTarget4 = Tetris_GetLocationByCoord(oWP, nColumn+newtb.n4Col, nTargetRow +newtb.n4Row);
                location lNewStart4  = Tetris_GetLocationByCoord(oWP, nColumn+newtb.n4Col, nCurrentRow+newtb.n4Row);
                //tell the blocks to move
                AssignCommand(oBlock, ClearAllActions());
                DelayCommand(0.5, AssignCommand(oBlock, ActionJumpToLocation(lNewStart)));
                DelayCommand(0.51, AssignCommand(oBlock, ActionDoCommand( SetLocalInt(oArea, "TetrisMoveing", GetLocalInt(oArea, "TetrisMoveing")-1))));
                DelayCommand(0.53, AssignCommand(oBlock, ActionDoCommand(Tetris_RotatePause(oArea, lNewTarget))));
                AssignCommand(oBlock2, ClearAllActions());
                DelayCommand(0.5, AssignCommand(oBlock2, ActionJumpToLocation(lNewStart2)));
                DelayCommand(0.51, AssignCommand(oBlock2, ActionDoCommand( SetLocalInt(oArea, "TetrisMoveing", GetLocalInt(oArea, "TetrisMoveing")-1))));
                DelayCommand(0.53, AssignCommand(oBlock2, ActionDoCommand(Tetris_RotatePause(oArea, lNewTarget2))));
                AssignCommand(oBlock3, ClearAllActions());
                DelayCommand(0.5, AssignCommand(oBlock3, ActionJumpToLocation(lNewStart3)));
                DelayCommand(0.51, AssignCommand(oBlock3, ActionDoCommand( SetLocalInt(oArea, "TetrisMoveing", GetLocalInt(oArea, "TetrisMoveing")-1))));
                DelayCommand(0.53, AssignCommand(oBlock3, ActionDoCommand(Tetris_RotatePause(oArea, lNewTarget3))));
                AssignCommand(oBlock4, ClearAllActions());
                DelayCommand(0.5, AssignCommand(oBlock4, ActionJumpToLocation(lNewStart4)));
                DelayCommand(0.51, AssignCommand(oBlock4, ActionDoCommand( SetLocalInt(oArea, "TetrisMoveing", GetLocalInt(oArea, "TetrisMoveing")-1))));
                DelayCommand(0.53, AssignCommand(oBlock4, ActionDoCommand(Tetris_RotatePause(oArea, lNewTarget4))));
                //store data for later
                SetLocalInt(oArea, "TetrisMoveing", 4);
                SetLocalInt(oArea, "TetrisBlockColumn", nColumn);
                SetLocalInt(oArea, "TetrisBlockRow", nTargetRow);
                Tetris_SetLocalBlock(oArea, "TetrisBlock", newtb);
            }
            break;

        case TETRIS_EVENT_DROP:
            {
                if(!GetLocalInt(oArea, "TetrisMoveing"))
                {
                    int nColumn = GetLocalInt(oArea, "TetrisBlockColumn");
                    int nRow    = GetLocalInt(oArea, "TetrisBlockRow");
                    struct Tetris_Block tb = Tetris_GetLocalBlock(oArea, "TetrisBlock");
                    object oBlock = GetLocalObject(oArea, "TetrisBlock");
                    object oBlock2 = GetLocalObject(oArea, "TetrisBlock2");
                    object oBlock3 = GetLocalObject(oArea, "TetrisBlock3");
                    object oBlock4 = GetLocalObject(oArea, "TetrisBlock4");
                    object oWP = GetNearestObjectByTag("Tetris_Corner", oBlock);
                    location lTarget = Tetris_GetLocationByCoord(oWP, nColumn, nRow);
                    location lTarget2 = Tetris_GetLocationByCoord(oWP, nColumn+tb.n2Col, nRow+tb.n2Row);
                    location lTarget3 = Tetris_GetLocationByCoord(oWP, nColumn+tb.n3Col, nRow+tb.n3Row);
                    location lTarget4 = Tetris_GetLocationByCoord(oWP, nColumn+tb.n4Col, nRow+tb.n4Row);
                    AssignCommand(oBlock, ClearAllActions());
                    DelayCommand(0.5, AssignCommand(oBlock, JumpToLocation(lTarget)));
                    DelayCommand(0.51, AssignCommand(oBlock, ActionDoCommand(SignalEvent(oArea, EventUserDefined(TETRIS_EVENT_INPLACE)))));
                    AssignCommand(oBlock2, ClearAllActions());
                    DelayCommand(0.5, AssignCommand(oBlock2, JumpToLocation(lTarget2)));
                    DelayCommand(0.51, AssignCommand(oBlock2, ActionDoCommand(SignalEvent(oArea, EventUserDefined(TETRIS_EVENT_INPLACE)))));
                    AssignCommand(oBlock3, ClearAllActions());
                    DelayCommand(0.5, AssignCommand(oBlock3, JumpToLocation(lTarget3)));
                    DelayCommand(0.51, AssignCommand(oBlock3, ActionDoCommand(SignalEvent(oArea, EventUserDefined(TETRIS_EVENT_INPLACE)))));
                    AssignCommand(oBlock4, ClearAllActions());
                    DelayCommand(0.5, AssignCommand(oBlock4, JumpToLocation(lTarget4)));
                    DelayCommand(0.51, AssignCommand(oBlock4, ActionDoCommand(SignalEvent(oArea, EventUserDefined(TETRIS_EVENT_INPLACE)))));
                }
            }
            break;
        case TETRIS_EVENT_END:
            {
                //delete previous grid
                int nColumn;
                int nRow;
                for(nColumn = 0; nColumn < TETRIS_GRID_WIDTH; nColumn++)
                {
                    for(nRow = 0; nRow < TETRIS_GRID_HEIGHT; nRow++)
                    {
                        DeleteLocalInt(oArea,
                            "TetrisGrid_"+IntToString(nColumn)+"_"+IntToString(nRow));
                        DeleteLocalObject(oArea,
                            "TetrisGridObject_"+IntToString(nColumn)+"_"+IntToString(nRow));
                    }
                }
                DeleteLocalObject(oArea, "TetrisBlock");
                DeleteLocalObject(oArea, "TetrisBlock2");
                DeleteLocalObject(oArea, "TetrisBlock3");
                DeleteLocalObject(oArea, "TetrisBlock4");
                DeleteLocalInt(oArea, "TetrisBlockColumn");
                DeleteLocalInt(oArea, "TetrisBlockRow");
                DeleteLocalInt(oArea, "TetrisBlockCount");
                DeleteLocalInt(oArea, "TetrisMoveing");
                DeleteLocalInt(oArea, "TetrisRows");
                DeleteLocalInt(oArea, "TetrisScore");
                DeleteLocalInt(oArea, "TetrisRowsAdded");
                //destroy any blocks
                object oTest = GetFirstObjectInArea(oArea);
                while(GetIsObjectValid(oTest))
                {
                    if(GetTag(oTest) == "tetris_block")
                        DestroyObject(oTest);
                    oTest = GetNextObjectInArea(oArea);
                }
            }
            break;
        case TETRIS_EVENT_START:
            {
                //start a new block
                Tetris_MakeBlock();
            }
            break;
        case TETRIS_EVENT_INPLACE:
            {
                //check all 4 droppped
                int nCount = GetLocalInt(oArea, "TetrisBlockCount");
                if(nCount > 1)
                {
                    SetLocalInt(oArea, "TetrisBlockCount",nCount-1);
                    break;
                }
                DeleteLocalInt(oArea, "TetrisBlockCount");
    WriteTimestampedLogEntry("Debug: nEventID = "+IntToString(nEventID));
    Tetris_DebugGrid(oArea);
                //store the block
                int nColumn    = GetLocalInt(oArea, "TetrisBlockColumn");
                int nRow       = GetLocalInt(oArea, "TetrisBlockRow");
                struct Tetris_Block tb = Tetris_GetLocalBlock(oArea, "TetrisBlock");
                object oBlock  = GetLocalObject(oArea, "TetrisBlock");
                object oBlock2 = GetLocalObject(oArea, "TetrisBlock2");
                object oBlock3 = GetLocalObject(oArea, "TetrisBlock3");
                object oBlock4 = GetLocalObject(oArea, "TetrisBlock4");
                Tetris_DeleteLocalBlock(oArea, "TetrisBlock");
                DeleteLocalObject(oArea, "TetrisBlock");
                DeleteLocalObject(oArea, "TetrisBlock2");
                DeleteLocalObject(oArea, "TetrisBlock3");
                DeleteLocalObject(oArea, "TetrisBlock4");
                DeleteLocalInt(oArea, "TetrisBlockColumn");
                DeleteLocalInt(oArea, "TetrisBlockRow");
                object oWP = GetNearestObjectByTag("Tetris_Corner", oBlock);
                int bDropped = FALSE;
                if(GetIsObjectValid(oBlock))
                {
                    SetLocalInt(oArea,    "TetrisGrid_"+IntToString(nColumn)+"_"+IntToString(nRow),       TRUE);
                    SetLocalObject(oArea, "TetrisGridObject_"+IntToString(nColumn)+"_"+IntToString(nRow), oBlock);
                }
                if(GetIsObjectValid(oBlock2))
                {
                    SetLocalInt(oArea,    "TetrisGrid_"+IntToString(nColumn+tb.n2Col)+"_"+IntToString(nRow+tb.n2Row),  TRUE);
                    SetLocalObject(oArea, "TetrisGridObject_"+IntToString(nColumn+tb.n2Col)+"_"+IntToString(nRow+tb.n2Row), oBlock2);
                }
                if(GetIsObjectValid(oBlock3))
                {
                    SetLocalInt(oArea,    "TetrisGrid_"+IntToString(nColumn+tb.n3Col)+"_"+IntToString(nRow+tb.n3Row),  TRUE);
                    SetLocalObject(oArea, "TetrisGridObject_"+IntToString(nColumn+tb.n3Col)+"_"+IntToString(nRow+tb.n3Row), oBlock3);
                }
                if(GetIsObjectValid(oBlock4))
                {
                    SetLocalInt(oArea,    "TetrisGrid_"+IntToString(nColumn+tb.n4Col)+"_"+IntToString(nRow+tb.n4Row),  TRUE);
                    SetLocalObject(oArea, "TetrisGridObject_"+IntToString(nColumn+tb.n4Col)+"_"+IntToString(nRow+tb.n4Row), oBlock4);
                }
                //check if any rows are filled
                //only drop one row at a time
                for(nRow = 0; nRow < TETRIS_GRID_HEIGHT && !bDropped; nRow++)
                {
                    int nCount;
                    for(nColumn = 0; nColumn < TETRIS_GRID_WIDTH; nColumn++)
                    {
                        int nValue = Tetris_GetValueForGrid(oArea, nColumn, nRow);
                        if(nValue)
                            nCount++;
                    }
                    if(nCount == TETRIS_GRID_WIDTH)
                    {
                        //row full, clear it
                        for(nColumn = 0; nColumn < TETRIS_GRID_WIDTH; nColumn++)
                        {
                            object oTemp = Tetris_GetObjectForGrid(oArea, nColumn, nRow);
//DEBUG
//if(!GetIsObjectValid(oTemp)) PrintString("**** oTemp is not valid ****");
                            DestroyObject(oTemp);
                            ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                                EffectVisualEffect(VFX_IMP_UNSUMMON),
                                GetLocation(oTemp));
                            DeleteLocalInt(oArea,
                                "TetrisGrid_"+IntToString(nColumn)+"_"+IntToString(nRow));
                            DeleteLocalObject(oArea,
                                "TetrisGridObject_"+IntToString(nColumn)+"_"+IntToString(nRow));

                        }
                        SetLocalInt(oArea, "TetrisRows", GetLocalInt(oArea, "TetrisRows")+1);
                        SetLocalInt(oArea, "TetrisRowsAdded", GetLocalInt(oArea, "TetrisRowsAdded")+1);
                        DelayCommand(3.0, EvalScore(oArea));
                        //move everything down one
                        //start on the next row up from the cleared row
                        int nRow2;
                        for(nRow2 = nRow+1; nRow2 <= TETRIS_GRID_HEIGHT; nRow2++)
                        {
                            for(nColumn = 0; nColumn < TETRIS_GRID_WIDTH; nColumn++)
                            {
                                object oTemp = Tetris_GetObjectForGrid(oArea, nColumn, nRow2);
                                int nValue   = Tetris_GetValueForGrid(oArea, nColumn, nRow2);
                                SetLocalInt(oArea,   "TetrisGrid_"      +IntToString(nColumn)+"_"+IntToString(nRow2), FALSE);
                                SetLocalObject(oArea,"TetrisGridObject_"+IntToString(nColumn)+"_"+IntToString(nRow2), OBJECT_INVALID);
                                SetLocalInt(oArea,   "TetrisGrid_"      +IntToString(nColumn)+"_"+IntToString(nRow2-1), nValue);
                                SetLocalObject(oArea,"TetrisGridObject_"+IntToString(nColumn)+"_"+IntToString(nRow2-1), oTemp);
                                if(GetIsObjectValid(oTemp))
                                {
                                    location lTarget = Tetris_GetLocationByCoord(oWP, nColumn, nRow2-1);
                                    //start it walking
                                    AssignCommand(oTemp,
                                        JumpToLocation(lTarget));
                                    AssignCommand(oTemp,
                                        ActionDoCommand(
                                            SignalEvent(oArea,
                                                EventUserDefined(TETRIS_EVENT_INPLACE))));
                                    SetLocalInt(oArea, "TetrisBlockCount",
                                        GetLocalInt(oArea, "TetrisBlockCount")+1);
                                }
                            }
                        }
                        return;//end script here
                        bDropped = TRUE;
                    }
                }
                //start a new block
                if(!bDropped)
                    Tetris_MakeBlock();
            }
            break;
    }
}
