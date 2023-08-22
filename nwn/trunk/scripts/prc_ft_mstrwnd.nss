/*
    Activates Master Wand
*/    

void main()
{
    object oPC = OBJECT_SELF;

    if(GetLocalInt(oPC, "MasterWand"))
    {
        FloatingTextStringOnCreature("Master Wand Deactivated.", oPC, FALSE);
        DeleteLocalInt(oPC, "MasterWand");
    }
    else
    {
        FloatingTextStringOnCreature("Master Wand Activated.", oPC, FALSE);
        SetLocalInt(oPC, "MasterWand", TRUE);    
    }
}