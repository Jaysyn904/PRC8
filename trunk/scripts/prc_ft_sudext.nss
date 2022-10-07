//::///////////////////////////////////////////////
//:: Sudden Extend
//:: prc_ft_sudext.nss
//:://////////////////////////////////////////////
//:: Applies Extend to next spell cast.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 24/06/2007
//:://////////////////////////////////////////////

void main()
{
    object oPC = OBJECT_SELF;
    int nMeta = GetLocalInt(oPC, "SuddenMeta");
        nMeta |= METAMAGIC_EXTEND;
    SetLocalInt(oPC, "SuddenMeta", nMeta);
    FloatingTextStringOnCreature("Sudden Extend Activated", oPC, FALSE);
}