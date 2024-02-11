//Constants only. Lets me change stuff later.

//These two lines are DEPRECATED
//const int GRID_SIZE = 8;
//const int MINE_AMOUNT = 10;

int GridSize()
{
    string sTemp = GetTag(GetArea(OBJECT_SELF));
    sTemp = GetSubString(sTemp, 9, 2); //Example: "GameRoom_08x08" yields "08"

    return StringToInt(sTemp);
}
int MineAmount(int iGridSizeNumber)
{
    object oStatCounter = GetObjectByTag("StatisticsCounter_" + IntToString(iGridSizeNumber));
    return GetLocalInt(oStatCounter, "mine_amount");
}
