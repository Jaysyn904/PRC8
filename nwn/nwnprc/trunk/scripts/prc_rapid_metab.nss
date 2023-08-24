//::///////////////////////////////////////////////
//:: Rapid Metabolism evaluation and execution script
//:: prc_rapid_metab
//:://////////////////////////////////////////////
/*
    Heals the possessor by 1 + ConMod HP every
    turn, or HD + ConMod per day if the PnP
    version is active.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 24.03.2005
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    object oCreature = OBJECT_SELF;

    if(GetCurrentThread() == "")
    {
        float fInterval = TurnsToSeconds(1);
        if(GetPRCSwitch(PRC_PNP_RAPID_METABOLISM))
            fInterval = HoursToSeconds(24);
        if(!SpawnNewThread("RapidMetabolism", "prc_rapid_metab", fInterval, oCreature))
            WriteTimestampedLogEntry("Failed to spawn thread for Rapid Metabolism on " + GetName(oCreature));
    }
    else
    {
        int nHP = 1;
        if(GetPRCSwitch(PRC_PNP_RAPID_METABOLISM))
            nHP = GetHitDice(oCreature);
        effect eHeal = EffectHeal(nHP + GetAbilityModifier(ABILITY_CONSTITUTION, oCreature));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oCreature);
    }
}
