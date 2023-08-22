void main()
{
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("x0_ch_hen_damage", OBJECT_SELF);
    else
        ExecuteScript("x2_def_ondamage", OBJECT_SELF);
    ExecuteScript("prc_npc_damaged", OBJECT_SELF);
}