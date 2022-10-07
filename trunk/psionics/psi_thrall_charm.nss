void main()
{
    object oCaster = OBJECT_SELF;
    SetLocalInt(oCaster, "ThrallCharm", TRUE);
    FloatingTextStringOnCreature("Reducing Charm Cost", oCaster, FALSE);
}