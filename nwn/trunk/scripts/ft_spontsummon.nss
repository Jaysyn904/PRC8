void main()
{
    string sSwitch = "PRC_SpontSummon";
    if(!GetLocalInt(OBJECT_SELF, sSwitch))
    {
        SetLocalInt(OBJECT_SELF, "PRC_SpontSummon", TRUE);
        FloatingTextStringOnCreature("Spontaneous summoning activated", OBJECT_SELF, FALSE);
    }
    else
    {
        DeleteLocalInt(OBJECT_SELF, "PRC_SpontSummon");
        FloatingTextStringOnCreature("Spontaneous summoning de-activated", OBJECT_SELF, FALSE);
    }
}