//::///////////////////////////////////////////////
//:: Divine Metamagic: Maximize
//:: prc_ft_dmeta_max.nss
//:://////////////////////////////////////////////
//:: Applies Maximize to next spell cast.
//:: Removes 4 turn undead uses
//:://////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;

    if(GetLocalInt(oPC, "DivineMeta") & METAMAGIC_MAXIMIZE)
    {
        FloatingTextStringOnCreature("Divine Metamagic is already active.", oPC, FALSE);
        return;
    }

    if(!CheckTurnUndeadUses(oPC, 4))
    {
        FloatingTextStringOnCreature("You don't have enough daily uses of Turn Undead to use this ability.", oPC, FALSE);
        return;
    }

    int nMeta = GetLocalInt(oPC, "DivineMeta");
        nMeta |= METAMAGIC_MAXIMIZE;
    SetLocalInt(oPC, "DivineMeta", nMeta);
    FloatingTextStringOnCreature("Divine Metamagic (Maximize) Activated", oPC, FALSE);
}