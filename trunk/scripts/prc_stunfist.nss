#include "prc_alterations"
#include "prc_inc_stunfist"

void main()
{
    object oPC = OBJECT_SELF;
    IncrementRemainingFeatUses(oPC, FEAT_PRC_EXTRA_STUNNING);
    ConvertStunFistUses(oPC);
}
