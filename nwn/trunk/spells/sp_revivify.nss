//::///////////////////////////////////////////////
//:: Name      Revivify
//:: FileName  sp_revivify.nss
//:://////////////////////////////////////////////
/** @file Revivify
Conjuration (Healing)
Level: Clr 5, Hlr 5
Components: V,S,M
Casting Time: 1 standard action
Range: Touch
Target: Dead creature touched
Duration: Instantaneous
Saving Throw: None
Spell Resistance: Yes (harmless)

Revivify miraculously restores life to a recently
deceased creature.  However, the spell must be cast
within 1 round of the victim's dead.  Before the 
soul of the deceased has completely left the body,
this spell halts its journey while repairing 
somewhat the damage to the body.  This spell 
functions like raise dead, except that the raised
creature receives no level loss, no Constitution
loss, and no loss of spells.  The creature is only
restored to -1 hit points (but is stable).

Material Component: Diamonds worth at least 1000 gp.
**/
///////////////////////////////////////////////////
// Author: Tenjac
// Date:   6.10.06
///////////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_CONJURATION);
	
	object oPC = OBJECT_SELF;
	object oTarget = PRCGetSpellTargetObject();
	effect eResurrect = EffectResurrection();
	effect eVis       = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
	
	// Make sure the target is in fact dead
	if(GetIsDead(oTarget))
	{
		// Let the AI know - Special handling
		PRCSignalSpellEvent(oTarget, FALSE, SPELL_RAISE_DEAD, oPC);
		
		// Apply effects
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eResurrect, oTarget);
			       
	        // Do special stuff
	        ExecuteScript("prc_pw_raisedead", oPC);
	        if(GetPRCSwitch(PRC_PW_DEATH_TRACKING) && GetIsPC(oTarget))
	            SetPersistantLocalInt(oTarget, "persist_dead", FALSE);
	}
	// end if - Deadness check
	
	PRCSetSchool();
}