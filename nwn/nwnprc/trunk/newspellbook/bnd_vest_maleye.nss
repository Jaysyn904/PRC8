/**
 * @file
 * Arcane Eye for Malphas
 *
 */

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    DoRacialSLA(SPELL_ARCANE_EYE, GetBinderLevel(oBinder, VESTIGE_MALPHAS), GetBinderDC(oBinder, VESTIGE_MALPHAS));    
}
        