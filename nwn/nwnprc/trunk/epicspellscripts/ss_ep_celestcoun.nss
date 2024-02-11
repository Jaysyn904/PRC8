//:://////////////////////////////////////////////
//:: FileName: "ss_ep_celestcoun"
/*   Purpose: Celestial Council - summons a "ghost" of a celestial NPC, which
        then starts a conversation with the caster.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_epicspells"
//#include "x2_inc_spellhook"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_DIVINATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_CELCOUN))
    {
        DelayCommand(5.0, AssignCommand(OBJECT_SELF,
            ActionStartConversation(OBJECT_SELF,
            "ss_celestialcoun", TRUE, FALSE)));
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

