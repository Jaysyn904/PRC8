void main()
{
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("x0_ch_hen_attack", OBJECT_SELF);
    else
        ExecuteScript("x2_def_attacked", OBJECT_SELF);
    ExecuteScript("prc_npc_attacked", OBJECT_SELF);
}