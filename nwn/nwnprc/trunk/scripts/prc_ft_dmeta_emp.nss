//::///////////////////////////////////////////////
//:: Divine Metamagic: Empower
//:: prc_ft_dmeta_emp.nss
//:://////////////////////////////////////////////
//:: Applies Empower to next spell cast.
//:: Removes 3 turn undead uses
//:://////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;

    if(GetLocalInt(oPC, "DivineMeta") & METAMAGIC_EMPOWER)
    {
        FloatingTextStringOnCreature("Divine Metamagic is already active.", oPC, FALSE);
        return;
    }

    if(!CheckTurnUndeadUses(oPC, 3))
    {
        FloatingTextStringOnCreature("You don't have enough daily uses of Turn Undead to use this ability.", oPC, FALSE);
        return;
    }

    int nMeta = GetLocalInt(oPC, "DivineMeta");
        nMeta |= METAMAGIC_EMPOWER;
    SetLocalInt(oPC, "DivineMeta", nMeta);
    FloatingTextStringOnCreature("Divine Metamagic (Empower) Activated", oPC, FALSE);
}