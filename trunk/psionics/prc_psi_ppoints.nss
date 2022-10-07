/*
   ----------------
   prc_psi_ppoints
   ----------------

   19/10/04 by Stratovarius

   Calculates the power point allotment of each class.
   Psion, Psychic Warrior, Wilder. (Soulknife does not have Power Points)
*/

#include "psi_inc_psifunc"

void main()
{
    object oCaster = OBJECT_SELF;

    ResetPowerPoints(oCaster);
    if(GetCurrentPowerPoints(oCaster) > 0)
        TellCharacterPowerPointStatus(oCaster);
}