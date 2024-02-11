/////////////////////////////////////////////////////////////////////
//
// Savnok Move Ally - Swap the caster and target's positions,
// the target must be a member of the caster's party.
//
/////////////////////////////////////////////////////////////////////

#include "bnd_inc_bndfunc"
#include "spinc_trans"

void main()
{
	if(!BindAbilCooldown(OBJECT_SELF, GetSpellId(), VESTIGE_SAVNOK)) return;
	DoTransposition(FALSE, FALSE);
}
