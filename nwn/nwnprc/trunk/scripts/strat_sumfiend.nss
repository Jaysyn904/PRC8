//::///////////////////////////////////////////////
//:: Greater Planar Binding
//:: NW_S0_GrPlanar.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons an outsider dependant on alignment, or
    holds an outsider if the creature fails a save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells"

void main()
{
    //Declare major variables
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCasterLevel = GetLevelByClass(CLASS_TYPE_ACOLYTE, OBJECT_SELF);
    int nDuration = ( 100 );
    effect eSummon;
    effect eGate;
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);

    effect eLink = EffectLinkEffects(eDur, EffectParalyze());
    eLink = EffectLinkEffects(eLink, eDur2);
    eLink = EffectLinkEffects(eLink, eDur3);

    object oTarget = PRCGetSpellTargetObject();
    int nRacial = MyPRCGetRacialType(oTarget);
    //Check for metamagic extend
    if (nMetaMagic & METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    eSummon = EffectSummonCreature("NW_S_VROCK", VFX_FNF_SUMMON_GATE, 3.0);
    if(GetPRCSwitch(MARKER_PRC_COMPANION))
        eSummon = EffectSummonCreature("prc_gelugon", VFX_FNF_SUMMON_GATE, 3.0);
    //Apply the VFX impact and summon effect
    MultisummonPreSummon(OBJECT_SELF);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), RoundsToSeconds(nDuration));


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

