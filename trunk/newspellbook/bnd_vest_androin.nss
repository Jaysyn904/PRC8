/**
 * @file
 * Hideous Laughter for Malphas
 *
 */

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    DoRacialSLA(SPELL_SEE_INVISIBILITY, GetBinderLevel(oBinder, VESTIGE_ANDROMALIUS), GetBinderDC(oBinder, VESTIGE_ANDROMALIUS));    
}
        