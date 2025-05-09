//::///////////////////////////////////////////////
//:: Name      Epic Spell: Risen Reunited
//:: FileName  ss_ep_reunited.nss
//:://////////////////////////////////////////////9
/** @file Epic Spell: Risen Reunited
School: Conjuration (Healing)
Components: V,S
Range: Personal
Target: Any known deceased creature
Duration: Instantaneous
Saving Throw: None (harmless)
Spell Resistance: No (harmless)

You concentrate on any deceased creature*, regardless of proximity, 
and resurrect them. Following the instant they regain life, the spell
 teleports the subject to your location.

*Upon casting this spell, a conversation will appear listing all 
available players who are dead. Choose the player from this list to 
resurrect and teleport to you.

Author:    Stratovarius
Created:   12/10/06

Updated: Jaysyn
Modified: 2025-05-09 17:41:28
**/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "inc_dynconv"

void main()
{
	PRCSetSchool(SPELL_SCHOOL_CONJURATION);
	
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	//Define vars
	object oPC = OBJECT_SELF;

	StartDynamicConversation("ep_cnv_risres", oPC, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, TRUE, oPC);

	PRCSetSchool();
}
				
				