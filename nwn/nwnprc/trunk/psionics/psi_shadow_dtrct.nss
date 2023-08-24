void main()
{
    object oCaster = OBJECT_SELF;
    SetLocalInt(oCaster, "ShadowDistract", TRUE);
    FloatingTextStringOnCreature("Reducing Distract Cost", oCaster, FALSE);
}