//:://////////////////////////////////////////////
//:: FileName: "ss_ep_rainoffire"
/*   Purpose: Rain of Fire - AoE spell that lasts 20 hours and does 3d6 points
        of fire damage per round to all in the AoE.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_epicspells"
//#include "x2_inc_spellhook"

int VFX_PER_RAIN_OF_FIRE = 100;

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_RAINFIR))
    {
        effect eAOE = EffectAreaOfEffect(VFX_PER_RAIN_OF_FIRE);
        location lTarget = GetLocation(OBJECT_SELF);
        int nDuration = 20;
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,
            eAOE, lTarget, HoursToSeconds(nDuration));
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,
            eAOE, lTarget, HoursToSeconds(nDuration));
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,
            eAOE, lTarget, HoursToSeconds(nDuration));
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

