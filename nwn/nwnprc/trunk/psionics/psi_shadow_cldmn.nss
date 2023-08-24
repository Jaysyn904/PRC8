void main()
{
    object oCaster = OBJECT_SELF;
    SetLocalInt(oCaster, "ShadowCloudMind", TRUE);
    FloatingTextStringOnCreature("Reducing Cloud Mind Cost", oCaster, FALSE);
}