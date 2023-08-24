void main()
{   
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("x2_hen_death", OBJECT_SELF);
    else
        ExecuteScript("x2_def_ondeath", OBJECT_SELF);
    ExecuteScript("prc_npc_death", OBJECT_SELF);
}