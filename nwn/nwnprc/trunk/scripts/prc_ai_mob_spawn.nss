void main()
{
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("x0_ch_hen_spawn", OBJECT_SELF);
    else
        ExecuteScript("x2_def_spawn", OBJECT_SELF);
    ExecuteScript("prc_npc_spawn", OBJECT_SELF);
}