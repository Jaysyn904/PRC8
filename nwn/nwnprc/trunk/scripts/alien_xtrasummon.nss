//::///////////////////////////////////////////////
//:: Summon Creature Series
//:: alien_extrasummon.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Carries out the summoning of the appropriate
    creature for the Summon Monster Series of spells
    1 to 9
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 8, 2002
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_inc_spells"

int GetMaxSpellLevel(object oCaster)
{
    int i = 9;
    for(i; i > 0; i--)
    {
        if(!GetLocalInt(oCaster, "PRC_ArcSpell"+IntToString(i)))
            return i;
    }
    return 1;
}

void main()
{
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    if(!X2PreSpellCastCode()) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nSwitch = GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL);
    float fDuration = nSwitch == 0 ? HoursToSeconds(24) :
                                     RoundsToSeconds(GetLevelByTypeArcaneFeats(oCaster) * nSwitch);

    int nMaxSpellLvl = GetMaxSpellLevel(oCaster);
    if(GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER, oCaster) && nMaxSpellLvl < 9)
        nMaxSpellLvl++;
    int nFNF_Effect;
    string sSummon;

    if(nMaxSpellLvl > 6)
    {
        string sElem;
        switch(GetSpellId())
        {
            case 2048: sElem = "air";   break;
            case 2049: sElem = "earth"; break;
            case 2050: sElem = "fire";  break;
            case 2051: sElem = "water"; break;
        }
        switch(nMaxSpellLvl)
        {
            case 9: sSummon = "pseudo"+sElem+"elder"; nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3; break;
            case 8: sSummon = "pseudo"+sElem+"great"; nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3; break;
            case 7: sSummon = "pseudo"+sElem+"huge";  nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3; break;
        }
    }
    else
    {
        switch(nMaxSpellLvl)
        {
            case 6: sSummon = "pseudodiretiger"; nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2; break;
            case 5: sSummon = "pseudobeardire";  nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2; break;
            case 4: sSummon = "pseudospiddire";  nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2; break;
            case 3: sSummon = "pseudodirewolf";  nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1; break;
            case 2: sSummon = "pseudoboardire";  nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1; break;
            case 1: sSummon = "pseudodirebadg";  nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1; break;
        }
    }
    effect eSummon = EffectSummonCreature(sSummon, nFNF_Effect);

    //Apply the VFX impact and summon effect
    MultisummonPreSummon();
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), fDuration);

    DelayCommand(0.5, AugmentSummonedCreature(sSummon));

    PRCSetSchool();
}