/*
    Activates Double Wand
*/    

void main()
{
    object oPC = OBJECT_SELF;

    if(GetLocalInt(oPC, "DoubleWand"))
    {
        FloatingTextStringOnCreature("Double Wand Wielder Deactivated.", oPC, FALSE);
        DeleteLocalInt(oPC, "DoubleWand");
    }
    else
    {
        FloatingTextStringOnCreature("Double Wand Wielder Activated.", oPC, FALSE);
        SetLocalInt(oPC, "DoubleWand", TRUE);    
    }
}