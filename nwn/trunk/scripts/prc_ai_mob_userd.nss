void main()
{
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("x0_ch_hen_usrdef", OBJECT_SELF);
    else
        ExecuteScript("x2_def_userdef", OBJECT_SELF);
    ExecuteScript("prc_npc_userdef", OBJECT_SELF);
}