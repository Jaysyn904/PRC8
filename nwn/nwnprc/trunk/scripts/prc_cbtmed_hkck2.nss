#include "prc_feat_const"

void main()
{
    object oPC = OBJECT_SELF;
    if(GetLocalInt(oPC, "Heal_Kicker") == 2)
    {
        DeleteLocalInt(oPC, "Heal_Kicker");
        FloatingTextStringOnCreature("*Healing Kicker (Reflex Saves) deactivated*", oPC, FALSE);
    }
    else
    {
        SetLocalInt(oPC, "Heal_Kicker", 2);
        FloatingTextStringOnCreature("*Healing Kicker (Reflex Saves) activated*", oPC, FALSE);
    }
    IncrementRemainingFeatUses(oPC, FEAT_HEALING_KICKER_2);
}