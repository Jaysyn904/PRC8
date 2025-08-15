void main()
{
    string sSwitch = "PRC_SpontRegen";
    if(!GetLocalInt(OBJECT_SELF, sSwitch))
    {
        SetLocalInt(OBJECT_SELF, "PRC_SpontRegen", TRUE);
        FloatingTextStringOnCreature("Spontaneous regeneration spells activated", OBJECT_SELF, FALSE);
    }
    else
    {
        DeleteLocalInt(OBJECT_SELF, "PRC_SpontRegen");
        FloatingTextStringOnCreature("Spontaneous regeneration spells de-activated", OBJECT_SELF, FALSE);
    }
}