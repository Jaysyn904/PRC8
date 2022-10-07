void main()
{
    object oPC = GetPCSpeaker();

    AssignCommand(oPC, TakeGoldFromCreature(10000, oPC, TRUE));
    CreateItemOnObject("shadowwalkerstok", oPC);
    SetLocalInt(oPC, "PRC_PrereqTelflam", 0);
}