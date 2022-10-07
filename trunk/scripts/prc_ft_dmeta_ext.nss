//::///////////////////////////////////////////////
//:: Divine Metamagic: Extend
//:: prc_ft_dmeta_ext.nss
//:://////////////////////////////////////////////
//:: Applies Extend to next spell cast.
//:: Removes 2 turn undead uses
//:://////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;

    if(GetLocalInt(oPC, "DivineMeta") & METAMAGIC_EXTEND)
    {
        FloatingTextStringOnCreature("Divine Metamagic is already active.", oPC, FALSE);
        return;
    }

    if(!CheckTurnUndeadUses(oPC, 2))
    {
        FloatingTextStringOnCreature("You don't have enough daily uses of Turn Undead to use this ability.", oPC, FALSE);
        return;
    }

    int nMeta = GetLocalInt(oPC, "DivineMeta");
        nMeta |= METAMAGIC_EXTEND;
    SetLocalInt(oPC, "DivineMeta", nMeta);
    FloatingTextStringOnCreature("Divine Metamagic (Extend) Activated", oPC, FALSE);
}