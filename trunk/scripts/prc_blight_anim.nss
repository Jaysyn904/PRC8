//::///////////////////////////////////////////////
//:: Animate Dead
//:: NW_S0_AnimDead.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a powerful skeleton or zombie depending
    on caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 11, 2001
//:://////////////////////////////////////////////
//:: modified by mr_bumpkin Dec 4, 2003

#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDuration = HoursToSeconds(24);

    string sResRef;
    int nHD;

    //Summon the appropriate creature based on the summoner level
    sResRef = "prc_skelbear";
    nHD = 6;

    effect eSummon = EffectSummonCreature(sResRef, VFX_FNF_SUMMON_UNDEAD);

    MultisummonPreSummon();

    if(GetPRCSwitch(PRC_PNP_ANIMATE_DEAD))
    {
        int nMaxHD = GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER, oCaster) >= 8 ?
                     nCasterLevel * (4 + GetAbilityModifier(ABILITY_CHARISMA, oCaster)) : nCasterLevel * 4;

        int nTotalHD = GetControlledUndeadTotalHD();
        if((nTotalHD+nHD) <= nMaxHD)
        {
            eSummon = SupernaturalEffect(eSummon);
            ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eSummon, lTarget);
            FloatingTextStringOnCreature("Currently have "+IntToString(nTotalHD+nHD)+"HD out of "+IntToString(nMaxHD)+"HD.", oCaster);
        }
        else
            FloatingTextStringOnCreature("You cannot create more undead at this time.", oCaster);
    }
    else
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration);

    PRCSetSchool();
}
