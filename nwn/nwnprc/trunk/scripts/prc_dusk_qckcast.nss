// Written by Stratovarius
// Turns Quick Cast on

void main()
{
    object oPC = OBJECT_SELF;
    SetLocalInt(oPC, "QuickCast", TRUE);
    FloatingTextStringOnCreature("*Quick Cast Activated*", oPC, FALSE);
}