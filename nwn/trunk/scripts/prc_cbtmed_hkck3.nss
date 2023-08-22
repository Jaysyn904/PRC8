#include "prc_feat_const"

void main()
{
    object oPC = OBJECT_SELF;
    if(GetLocalInt(oPC, "Heal_Kicker") == 3)
    {
        DeleteLocalInt(oPC, "Heal_Kicker");
        FloatingTextStringOnCreature("*Healing Kicker (Aid) deactivated*", oPC, FALSE);
    }
    else
    {
        SetLocalInt(oPC, "Heal_Kicker", 3);
        FloatingTextStringOnCreature("*Healing Kicker (Aid) activated*", oPC, FALSE);
    }
    IncrementRemainingFeatUses(oPC, FEAT_HEALING_KICKER_3);
}