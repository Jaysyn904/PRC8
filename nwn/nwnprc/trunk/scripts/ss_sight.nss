//::///////////////////////////////////////////////
//:: Silverstar: Prophet's Sight
//:: ss_sight
//::///////////////////////////////////////////////

#include "prc_ss_inc"

void main()
{
    object oPC = OBJECT_SELF;

    if (SSGetClassLevel(oPC) < 5
    || !GetHasFeat(SS_FEAT_PROPHETS_SIGHT, oPC, TRUE))
        return;

    int nLimit = SSGetSightLimit(oPC);
    int nUsed = SSGetDailyUses(oPC, SS_SIGHT_USED);

    if (nUsed >= nLimit)
    {
        SSRefreshDailyUses(oPC);
        FloatingTextStringOnCreature(
            "Prophet's Sight has no uses remaining until you rest.",
            oPC, FALSE);
        return;
    }

    SSSetDailyUses(oPC, SS_SIGHT_USED, nUsed + 1);
    SSRefreshDailyUses(oPC);

    // Prophet's Sight is supernatural, not a spell-like casting of True
    // Seeing. Apply it to the Silverstar directly: no verbal components,
    // spell resistance, spell failure, or dispellable spell effect.
    SSClearTaggedEffects(oPC, SS_SIGHT_TAG);

    effect eSight = EffectTrueSeeing();
    if (GetPRCSwitch(PRC_PNP_TRUESEEING))
    {
        int nSpot = GetPRCSwitch(PRC_PNP_TRUESEEING_SPOT_BONUS);
        if (nSpot == 0) nSpot = 15;
        eSight = EffectLinkEffects(EffectSeeInvisible(),
                                  EffectSkillIncrease(SKILL_SPOT, nSpot));
        eSight = EffectLinkEffects(eSight, EffectUltravision());
    }
    eSight = EffectLinkEffects(eSight,
                              EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT));
    eSight = TagEffect(SupernaturalEffect(eSight), SS_SIGHT_TAG);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSight, oPC,
                        TurnsToSeconds(SSGetCasterLevel(oPC)));

    FloatingTextStringOnCreature(
        "Prophet's Sight uses remaining: "
        + IntToString(nLimit - nUsed - 1),
        oPC, FALSE);
}
