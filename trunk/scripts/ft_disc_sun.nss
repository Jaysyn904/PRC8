//::///////////////////////////////////////////////
//:: Discipline of the Sun
//:: ft_disc_sun.nss
//:://////////////////////////////////////////////
/*
    Type of Feat: Divine.
    Prerequisite: Turn Undead, Good Alignment.

    Specifics: You spend two turn attempts when
    you turn undead, to destroy the Undead instead
    of turning them.

    Use: Selected.
*/
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;

    if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD)
        return;

    if(!CheckTurnUndeadUses(oPC, 2))
    {
        SpeakStringByStrRef(40550);
        return;
    }

    ActionDoCommand(SetLocalInt(oPC, "UsingSunDomain", TRUE));
    ActionCastSpellAtObject(SPELLABILITY_TURN_UNDEAD, oPC, METAMAGIC_ANY, TRUE);
    ActionDoCommand(DeleteLocalInt(oPC, "UsingSunDomain"));
}