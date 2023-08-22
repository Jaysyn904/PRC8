void main()
{
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("x0_ch_hen_combat", OBJECT_SELF);
    else
        ExecuteScript("x2_def_endcombat", OBJECT_SELF);
    ExecuteScript("prc_npc_combat", OBJECT_SELF);
}