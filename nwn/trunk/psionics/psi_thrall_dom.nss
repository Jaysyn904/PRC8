void main()
{
    object oCaster = OBJECT_SELF;
    SetLocalInt(oCaster, "ThrallDom", TRUE);
    FloatingTextStringOnCreature("Reducing Dominate Cost", oCaster, FALSE);
}