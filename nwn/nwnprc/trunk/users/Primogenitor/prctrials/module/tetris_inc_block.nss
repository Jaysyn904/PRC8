struct Tetris_Block
{
    int n2Row;
    int n2Col;
    int n3Row;
    int n3Col;
    int n4Row;
    int n4Col;
};

struct Tetris_Block Tetris_GetBlockByID(int nID)
{
    struct Tetris_Block tb;
    switch(nID)
    {
        default:
        case  0: tb.n2Row = -1; tb.n2Col =  0; tb.n4Row =  1; tb.n4Col =  0; tb.n3Row =  2; tb.n3Col =  0; break; //line
        case  1: tb.n2Row =  1; tb.n2Col =  0; tb.n4Row =  0; tb.n4Col =  1; tb.n3Row =  1; tb.n3Col =  1; break; //square
        case  2: tb.n2Row =  0; tb.n2Col = -1; tb.n4Row =  1; tb.n4Col =  0; tb.n3Row =  0; tb.n3Col =  1; break; //T piece
        case  3: tb.n2Row = -1; tb.n2Col =  0; tb.n4Row =  1; tb.n4Col =  0; tb.n3Row =  1; tb.n3Col =  1; break; //L piece
        case  4: tb.n2Row = -1; tb.n2Col =  0; tb.n4Row =  1; tb.n4Col =  0; tb.n3Row =  1; tb.n3Col = -1; break; //L piece
        case  5: tb.n2Row = -1; tb.n2Col =  0; tb.n4Row =  0; tb.n4Col =  1; tb.n3Row =  1; tb.n3Col =  1; break; //Z piece
        case  6: tb.n2Row = -1; tb.n2Col =  0; tb.n4Row =  0; tb.n4Col = -1; tb.n3Row =  1; tb.n3Col = -1; break; //Z piece
    }
    return tb;
}

void Tetris_SetLocalBlock(object oTarget, string sVar, struct Tetris_Block tb)
{
    SetLocalInt(oTarget, sVar+".n2Row", tb.n2Row);
    SetLocalInt(oTarget, sVar+".n2Col", tb.n2Col);
    SetLocalInt(oTarget, sVar+".n3Row", tb.n3Row);
    SetLocalInt(oTarget, sVar+".n3Col", tb.n3Col);
    SetLocalInt(oTarget, sVar+".n4Row", tb.n4Row);
    SetLocalInt(oTarget, sVar+".n4Col", tb.n4Col);
}

struct Tetris_Block Tetris_GetLocalBlock(object oTarget, string sVar)
{
    struct Tetris_Block tb;
    tb.n2Row = GetLocalInt(oTarget, sVar+".n2Row");
    tb.n2Col = GetLocalInt(oTarget, sVar+".n2Col");
    tb.n3Row = GetLocalInt(oTarget, sVar+".n3Row");
    tb.n3Col = GetLocalInt(oTarget, sVar+".n3Col");
    tb.n4Row = GetLocalInt(oTarget, sVar+".n4Row");
    tb.n4Col = GetLocalInt(oTarget, sVar+".n4Col");
    return tb;
}

void Tetris_DeleteLocalBlock(object oTarget, string sVar)
{
    DeleteLocalInt(oTarget, sVar+".n2Row");
    DeleteLocalInt(oTarget, sVar+".n2Col");
    DeleteLocalInt(oTarget, sVar+".n3Row");
    DeleteLocalInt(oTarget, sVar+".n3Col");
    DeleteLocalInt(oTarget, sVar+".n4Row");
    DeleteLocalInt(oTarget, sVar+".n4Col");
}

struct Tetris_Block Tetris_RotateBlockClock(struct Tetris_Block tb)
{
    struct Tetris_Block newtb;
    newtb.n2Row = 0-tb.n2Col;
    newtb.n2Col = tb.n2Row;
    newtb.n3Row = 0-tb.n3Col;
    newtb.n3Col = tb.n3Row;
    newtb.n4Row = 0-tb.n4Col;
    newtb.n4Col = tb.n4Row;
    return newtb;
}

struct Tetris_Block Tetris_RotateBlockAntiClock(struct Tetris_Block tb)
{
    struct Tetris_Block newtb;
    newtb.n2Row = tb.n2Col;
    newtb.n2Col = 0-tb.n2Row;
    newtb.n3Row = tb.n3Col;
    newtb.n3Col = 0-tb.n3Row;
    newtb.n4Row = tb.n4Col;
    newtb.n4Col = 0-tb.n4Row;
    return newtb;
}

struct Tetris_Block Tetris_GetRandomBlock()
{
    struct Tetris_Block tb = Tetris_GetBlockByID(Random(7));
    int i;
    int nCount = Random(4);
    for(i=0; i<nCount; i++)
    {
        tb = Tetris_RotateBlockClock(tb);
    }
    return tb;
}


int Tetris_GetMaxRowOffset(struct Tetris_Block tb)
{
    int nMax = 0;
    if(tb.n2Row > nMax) nMax = tb.n2Row;
    if(tb.n3Row > nMax) nMax = tb.n3Row;
    if(tb.n4Row > nMax) nMax = tb.n4Row;
    return nMax;
}

int Tetris_GetMaxColOffset(struct Tetris_Block tb)
{
    int nMax = 0;
    if(tb.n2Col > nMax) nMax = tb.n2Col;
    if(tb.n3Col > nMax) nMax = tb.n3Col;
    if(tb.n4Col > nMax) nMax = tb.n4Col;
    return nMax;
}

int Tetris_GetMinRowOffset(struct Tetris_Block tb)
{
    int nMin = 0;
    if(tb.n2Row < nMin) nMin = tb.n2Row;
    if(tb.n3Row < nMin) nMin = tb.n3Row;
    if(tb.n4Row < nMin) nMin = tb.n4Row;
    return nMin;
}

int Tetris_GetMinColOffset(struct Tetris_Block tb)
{
    int nMin = 0;
    if(tb.n2Col < nMin) nMin = tb.n2Col;
    if(tb.n3Col < nMin) nMin = tb.n3Col;
    if(tb.n4Col < nMin) nMin = tb.n4Col;
    return nMin;
}
