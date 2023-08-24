void main()
{
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("x0_ch_hen_rest", OBJECT_SELF);
    else
        ExecuteScript("x2_def_rested", OBJECT_SELF);
    ExecuteScript("prc_npc_rested", OBJECT_SELF);
}