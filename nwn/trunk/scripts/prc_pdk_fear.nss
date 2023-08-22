/*
    Purple Dragon Knight's Fear
*/

#include "inc_newspellbook"
#include "prc_inc_core"

void main()
{
	object oPDK = OBJECT_SELF;
	int nHD = GetHitDice(oPDK);
	
	// Caster level for the spell is the character level
	ActionCastSpell(SPELL_FEAR, nHD);
}