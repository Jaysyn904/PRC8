//::////////////////////////////////////////////////////////
//:: Name      Epic Repulsion
//:: FileName  ss_ep_epicrepuls.nss
//::////////////////////////////////////////////////////////
/** @file Epic Repulsion
School: Abjuration
Components: V,S
Range: Touch
Target: Creature or object touched
Duration: 24 hours
Saving Throw: None
Spell Resistance: Yes, see text

You can create a ward against a specific type of creature for 
the duration. Any creature of the specific type cannot come 
within the aura of the warded creature or object. Spell 
resistance can allow a creature to overcome this protection 
and enter the aura of the warded subject.

*/
//::////////////////////////////////////////////////////////
//::
//:: Created By: Boneshank
//:: Last Updated On:
//::
//:: Fixed By: Jaysyn
//:: Date: 2026-09-20 18:21:40
//::
//::////////////////////////////////////////////////////////
#include "prc_alterations"
#include "inc_epicspells"
#include "inc_dynconv" 
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
        //AssignCommand(OBJECT_SELF, ActionStartConversation(OBJECT_SELF, "ss_ep_repulsion", TRUE, FALSE));
		StartDynamicConversation("ss_ep_repulsion", OBJECT_SELF, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, OBJECT_SELF);
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
