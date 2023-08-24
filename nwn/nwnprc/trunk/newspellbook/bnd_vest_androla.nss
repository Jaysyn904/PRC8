/**
 * @file
 * Hideous Laughter for Malphas
 *
 */

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_ANDROMALIUS)) return;
    DoRacialSLA(SPELL_TASHAS_HIDEOUS_LAUGHTER, GetBinderLevel(oBinder, VESTIGE_ANDROMALIUS), GetBinderDC(oBinder, VESTIGE_ANDROMALIUS));    
}
        