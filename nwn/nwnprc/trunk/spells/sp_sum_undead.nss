//::///////////////////////////////////////////////
//:: Summon Undead Series
//:: sp_sum_undead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Carries out the summoning of the appropriate
    creature for the Summon Undead Series of spells
    1 to 5
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 8, 2002
//:://////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nSpellID = PRCGetSpellId();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nFNF_Effect;
    string sSummon;
    float fDuration = HoursToSeconds(24);
    if(GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL))
        fDuration = RoundsToSeconds(PRCGetCasterLevel(oCaster)*GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL));
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2;   //Duration is +100%

    switch(nSpellID)
    {
        case SPELL_SUMMON_UNDEAD_1: sSummon = "wo_skel";        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1; break;
        case SPELL_SUMMON_UNDEAD_2: sSummon = "wo_zombie_bugb"; nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1; break;
        case SPELL_SUMMON_UNDEAD_3: sSummon = "wo_zombie_ogre"; nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1; break;
        case SPELL_SUMMON_UNDEAD_4: sSummon = "wo_zombie_wyv";  nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2; break;
        case SPELL_SUMMON_UNDEAD_5: sSummon = "wo_mummy";       nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2; break;
    }

    effect eSummon = EffectSummonCreature(sSummon, nFNF_Effect);

    MultisummonPreSummon();
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), fDuration);

    DelayCommand(0.5, AugmentSummonedCreature(sSummon));

    PRCSetSchool();
}