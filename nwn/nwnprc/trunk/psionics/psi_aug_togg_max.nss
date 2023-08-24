//::///////////////////////////////////////////////
//:: Maximum Augmentation toggle
//:: psi_aug_togg_max
//::///////////////////////////////////////////////
/**
    Switches the maximum augmentation feature on
    and off.

    @author Ornedan
    @data   Created - 2006.07.15
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "psi_inc_psifunc"


void main()
{
    object oPC = OBJECT_SELF;

    // Toggle it and do feedback
    SetLocalInt(oPC, PRC_AUGMENT_MAXAUGMENT, !GetLocalInt(oPC, PRC_AUGMENT_MAXAUGMENT));
    FloatingTextStringOnCreature(GetStringByStrRef(16823677) + " " + (GetLocalInt(oPC, PRC_AUGMENT_MAXAUGMENT) ? GetStringByStrRef(63798/*Activated*/):GetStringByStrRef(63799/*Deactivated*/)), oPC, FALSE);
}