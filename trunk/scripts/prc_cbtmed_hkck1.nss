#include "prc_feat_const"

void main()
{
    object oPC = OBJECT_SELF;
    if(GetLocalInt(oPC, "Heal_Kicker") == 1)
    {
        DeleteLocalInt(oPC, "Heal_Kicker");
        FloatingTextStringOnCreature("*Healing Kicker (Sanctuary) deactivated*", oPC, FALSE);
    }
    else
    {
        SetLocalInt(oPC, "Heal_Kicker", 1);
        FloatingTextStringOnCreature("*Healing Kicker (Sanctuary) activated*", oPC, FALSE);
    }
    IncrementRemainingFeatUses(oPC, FEAT_HEALING_KICKER_1);
}