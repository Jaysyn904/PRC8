void main()
{
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("x0_ch_hen_percep", OBJECT_SELF);
    else
        ExecuteScript("x2_def_percept", OBJECT_SELF);
    ExecuteScript("prc_npc_percep", OBJECT_SELF);
}