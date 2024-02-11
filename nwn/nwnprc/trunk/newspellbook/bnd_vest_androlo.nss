/**
 * @file
 * Hideous Laughter for Malphas
 *
 */

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    DoRacialSLA(SPELL_LOCATE_OBJECT, GetBinderLevel(oBinder, VESTIGE_ANDROMALIUS), GetBinderDC(oBinder, VESTIGE_ANDROMALIUS));    
}
        