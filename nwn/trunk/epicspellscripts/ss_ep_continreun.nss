//:://////////////////////////////////////////////
//:: FileName: "ss_ep_continreun"
/*   Purpose: Contingent Reunion - upon casting this at a target, the caster
        must choose a condition which will later trigger the teleportation to
        the target.
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
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_CON_REU))
    {
        // Is the target a place, creature, or object?
        object oTarget = PRCGetSpellTargetObject();
        location lTarget = PRCGetSpellTargetLocation();
        effect eVis = EffectVisualEffect(VFX_FNF_LOS_HOLY_20);
        if (oTarget != OBJECT_INVALID)
        {
            if (oTarget == OBJECT_SELF) // If target is self, becomes location
            {
                SetLocalLocation(OBJECT_SELF, "lSpellTarget", lTarget);
                SetLocalObject(OBJECT_SELF, "oSpellTarget", OBJECT_INVALID);
            }
            else
            {
                SetLocalObject(OBJECT_SELF, "oSpellTarget", oTarget);
                if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
                    SetLocalInt(OBJECT_SELF, "nMyTargetIsACreature", TRUE);
            }
        }
        else
        {
            SetLocalLocation(OBJECT_SELF, "lSpellTarget", lTarget);
            SetLocalObject(OBJECT_SELF, "oSpellTarget", OBJECT_INVALID);
        }
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
        AssignCommand(OBJECT_SELF, ActionStartConversation(OBJECT_SELF,
            "ss_cont_reunion", TRUE, FALSE));
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

