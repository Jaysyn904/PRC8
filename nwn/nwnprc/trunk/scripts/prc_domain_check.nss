// Written by Stratovarius
// Checks what Bonus domains you have and in what slots.

#include "inc_newspellbook"
#include "prc_inc_domain"

void main()
{
    object oPC = OBJECT_SELF;
    int nDomain, i;
    string sName;
    for(i = 1; i < 6; i++)
    {
        nDomain = GetBonusDomain(oPC, i);
        sName = GetDomainName(nDomain);
        FloatingTextStringOnCreature("Bonus Domain in Slot " + IntToString(i) + ": " + sName, oPC, FALSE);
    }
}