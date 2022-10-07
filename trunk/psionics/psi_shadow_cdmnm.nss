void main()
{
    object oCaster = OBJECT_SELF;
    SetLocalInt(oCaster, "ShadowCloudMindMass", TRUE);
    FloatingTextStringOnCreature("Reducing Cloud Mind, Mass Cost", oCaster, FALSE);
}