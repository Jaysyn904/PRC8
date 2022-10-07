// Written by Stratovarius
// Turns rune scribing on and off.

void main()
{
    object oPC = OBJECT_SELF;
    string nMes = "";

    if(!GetLocalInt(oPC, "InscribeRune"))
    {
        SetLocalInt(oPC, "InscribeRune", TRUE);
        nMes = "*Inscribe Rune Activated*";
    }
    else
    {
        // Removes effects
        DeleteLocalInt(oPC, "InscribeRune");
        nMes = "*Inscribe Rune Deactivated*";
    }

    FloatingTextStringOnCreature(nMes, oPC, FALSE);
}