/**
 * @file
 * Locate Object for Ashardalon
 *
 */

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    DoRacialSLA(SPELL_LOCATE_OBJECT, GetBinderLevel(oBinder, VESTIGE_ASHARDALON), GetBinderDC(oBinder, VESTIGE_ASHARDALON));    
}
        