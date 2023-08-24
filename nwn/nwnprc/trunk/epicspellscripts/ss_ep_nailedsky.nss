//:://////////////////////////////////////////////
//:: FileName: "ss_ep_nailedsky"
/*   Purpose: Nailed to the Sky - the target, if it fails its Will save, is
        thrust into the sky, where it dies in a vacuum
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 11, 2004
//:://////////////////////////////////////////////

// Fixed by Strat because Boneshank was a bloody idiot

#include "prc_alterations"
//#include "x2_inc_spellhook"
#include "inc_epicspells"
#include "prc_inc_teleport"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    object oTarget = PRCGetSpellTargetObject();
        if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_NAILSKY))
        {
            //Declare major variables
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));

            // Teleportation spell, so can be prevented by teleportation blocking effects
            if(GetCanTeleport(oTarget, GetLocation(oTarget), FALSE, TRUE, TRUE))
            {
			    if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetEpicSpellSaveDC(OBJECT_SELF, oTarget)) && !GetIsDead(oTarget))
			    {
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath(TRUE)), oTarget);           
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDamage(9999)), oTarget);  
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDamage(9999)), oTarget);  
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDamage(9999)), oTarget);  
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDamage(9999)), oTarget);  
				}	
			}
        }

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}