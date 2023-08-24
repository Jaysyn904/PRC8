void main()
{
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("x0_ch_hen_block", OBJECT_SELF);
    else
        ExecuteScript("x2_def_onblocked", OBJECT_SELF);
    ExecuteScript("prc_npc_block", OBJECT_SELF);
}