//::///////////////////////////////////////////////
//:: Sudden Maximize
//:: prc_ft_sudmax.nss
//:://////////////////////////////////////////////
//:: Applies Maximize to next spell cast.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 24/06/2007
//:://////////////////////////////////////////////

void main()
{
    object oPC = OBJECT_SELF;
    int nMeta = GetLocalInt(oPC, "SuddenMeta");
        nMeta |= METAMAGIC_MAXIMIZE;
    SetLocalInt(oPC, "SuddenMeta", nMeta);
    FloatingTextStringOnCreature("Sudden Maximize Activated", oPC, FALSE);
}