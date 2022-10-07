//::///////////////////////////////////////////////
//:: Summon Hamatula
//:: Summon_Hama
//:://////////////////////////////////////////////
/*
    Summons a Hamatula to fight for the character
*/
//:://////////////////////////////////////////////
//:: Created By: Sir Attilla
//:: Created On: January 3 , 2004
//:://////////////////////////////////////////////
#include "prc_class_const"
#include "x2_inc_spellhook"
#include "prc_feat_const"
#include "prc_alterations"
void main()
{
    //Declare major variables
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    object oPC = OBJECT_SELF;
    effect eSummon = EffectSummonCreature("NW_DMVROCK");
    if(GetPRCSwitch(MARKER_PRC_COMPANION))
        eSummon = EffectSummonCreature("prc_hamatula");

    if (GetHasFeat(FEAT_IMP_SUMMON_HAMATULA, oPC))
    {
        eSummon = EffectSummonCreature("NW_DEMON");
        if(GetPRCSwitch(MARKER_PRC_COMPANION))
            eSummon = EffectSwarm(FALSE, "prc_hamatula", "prc_hamatula");
    }

    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
    //Make metamagic check for extend
    if (nMetaMagic & METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Apply the VFX impact and summon effect
    MultisummonPreSummon(OBJECT_SELF);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
}
