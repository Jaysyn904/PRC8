int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oMaster = GetMaster(OBJECT_SELF);
    object oOldMaster = oMaster;
    while(GetIsObjectValid(oMaster))
    {
        oOldMaster = oMaster;
        oMaster = GetMaster(OBJECT_SELF);
    }
    if(GetIsPC(oOldMaster))
        return FALSE;   //dont show it, the PC can order it around
    else
        return TRUE;
}
