// This script displays debug information about the PC.
// Called from debug console only.

#include "prc_shifter_info"

void main()
{
    object oPC = OBJECT_SELF;
    DelayCommand(0.0f, _prc_inc_ShapePrintDebug(oPC, oPC, TRUE));
}
