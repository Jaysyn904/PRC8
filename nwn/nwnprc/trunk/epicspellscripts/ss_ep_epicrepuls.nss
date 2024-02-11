//:://////////////////////////////////////////////
//:: FileName: "ss_ep_epicrepuls"
/*   Purpose: Epic Repulsion - repel a specific creature type for 24 hours.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_epicspells"
//#include "x2_inc_spellhook"


void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_EP_RPLS))
    {
        object oTarget = PRCGetSpellTargetObject();
        location lTarget = GetLocation(oTarget);
        effect eVis = EffectVisualEffect(VFX_FNF_PWSTUN);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
        SetLocalObject(OBJECT_SELF, "oRepulsionTarget", oTarget);
        AssignCommand(OBJECT_SELF, ActionStartConversation(OBJECT_SELF,
            "ss_ep_repulsion", TRUE, FALSE));
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
