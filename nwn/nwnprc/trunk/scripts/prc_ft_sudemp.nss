//::///////////////////////////////////////////////
//:: Sudden Empower
//:: prc_ft_sudemp.nss
//:://////////////////////////////////////////////
//:: Applies Empower to next spell cast.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 24/06/2007
//:://////////////////////////////////////////////

void main()
{
    object oPC = OBJECT_SELF;
    int nMeta = GetLocalInt(oPC, "SuddenMeta");
        nMeta |= METAMAGIC_EMPOWER;
    SetLocalInt(oPC, "SuddenMeta", nMeta);
    FloatingTextStringOnCreature("Sudden Empower Activated", oPC, FALSE);
}