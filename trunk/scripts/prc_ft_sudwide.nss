//::///////////////////////////////////////////////
//:: Sudden Widen
//:: prc_ft_sudwide.nss
//:://////////////////////////////////////////////
//:: Applies Widen to next spell cast.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 24/06/2007
//:://////////////////////////////////////////////
#include "prc_inc_switch"
#include "prc_feat_const"

void main()
{
    object oPC = OBJECT_SELF;

    if(GetLocalFloat(oPC, PRC_SPELL_AREA_SIZE_MULTIPLIER) < 2.0)
    {
        SetLocalFloat(oPC, PRC_SPELL_AREA_SIZE_MULTIPLIER, 2.0);
        FloatingTextStringOnCreature("Sudden Widen Activated", oPC, FALSE);
    }
    else
    {
        IncrementRemainingFeatUses(oPC, FEAT_SUDDEN_WIDEN);
        FloatingTextStringOnCreature("Widen Spell Already Active", oPC, FALSE);
    }
}