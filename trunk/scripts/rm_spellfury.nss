#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;

    if(!GetHasSpellEffect(SPELL_SPELL_RAGE, oPC))
    {
        IncrementRemainingFeatUses(oPC, FEAT_SPELL_FURY);
        FloatingTextStringOnCreature("You can use this ability only during the Spell Rage.", oPC, FALSE);
    }
    else
    {
        int nMeta = GetLocalInt(oPC, "SuddenMeta");
            nMeta |= METAMAGIC_EMPOWER;
        SetLocalInt(oPC, "SuddenMeta", nMeta);
        FloatingTextStringOnCreature("Sudden Empower Activated", oPC, FALSE);
    }
}