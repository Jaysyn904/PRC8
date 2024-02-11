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
    if(!nPCInArea)
    {
        oPC = GetExitingObject();
        int nScore = GetLocalInt(OBJECT_SELF, "Score");
        DeleteLocalInt(OBJECT_SELF, "Score");
        FloatingTextStringOnCreature("You scored : "+IntToString(nScore), oPC, TRUE);
        SignalEvent(OBJECT_SELF, EventUserDefined(501));
    }
}
