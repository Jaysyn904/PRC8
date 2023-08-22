/*
    Activates Reckless Wand
*/    

void main()
{
    object oPC = OBJECT_SELF;

    if(GetLocalInt(oPC, "RecklessWand"))
    {
        FloatingTextStringOnCreature("Reckless Wand  Wielder Deactivated.", oPC, FALSE);
        DeleteLocalInt(oPC, "RecklessWand");
    }
    else
    {
        FloatingTextStringOnCreature("Reckless Wand Wielder Activated.", oPC, FALSE);
        SetLocalInt(oPC, "RecklessWand", TRUE);    
    }
}