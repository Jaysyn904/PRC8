/**
 * @file
 * Fear for Ashardalon
 *
 */

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_ASHARDALON)) return;
    DoRacialSLA(SPELL_FEAR, GetBinderLevel(oBinder, VESTIGE_ASHARDALON), GetBinderDC(oBinder, VESTIGE_ASHARDALON));    
}
        