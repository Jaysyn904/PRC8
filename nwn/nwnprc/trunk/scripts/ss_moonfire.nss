//::///////////////////////////////////////////////
//:: Silverstar: Moonfire
//:: ss_moonfire
//::///////////////////////////////////////////////

#include "prc_ss_inc"

void main()
{
    object oPC = OBJECT_SELF;

    if (SSGetClassLevel(oPC) < 10
    || !GetHasFeat(SS_FEAT_MOONFIRE, oPC, TRUE))
        return;

    int nUsed = SSGetDailyUses(oPC, SS_MOONFIRE_USED);
    if (nUsed >= 1)
    {
        SSRefreshDailyUses(oPC);
        FloatingTextStringOnCreature(
            "Moonfire has no uses remaining until you rest.",
            oPC, FALSE);
        return;
    }

    SSSetDailyUses(oPC, SS_MOONFIRE_USED, 1);
    SSRefreshDailyUses(oPC);
    DoRacialSLA(SS_SPELL_MOONFIRE,
                SSGetCasterLevel(oPC),
                SSGetCharismaDC(oPC, 9));

    FloatingTextStringOnCreature(
        "Moonfire has no uses remaining until you rest.",
        oPC, FALSE);
}
