/**
 * @file
 * Blade Barrier for Halphax
 *
 */

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    DoRacialSLA(SPELL_MORDENKAINENS_MAGNIFICENT_MANSION, GetBinderLevel(oBinder, VESTIGE_HALPHAX), GetBinderDC(oBinder, VESTIGE_HALPHAX));    
}
        