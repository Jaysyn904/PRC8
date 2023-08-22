//::///////////////////////////////////////////////
//:: Summon Spider Servant
//:: prc_dj_sumspider
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Summons the appropriate spider servant for the
Drow Judicator
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 8, 2002
//:: Modified By: PsychicToaster
//:: Modified On: 7-25-04
//:://////////////////////////////////////////////

effect SetSummonEffect(int nSpellID);

#include "prc_inc_spells"

void main()
{

    //Declare major variables
    int nSpellID = PRCGetSpellId();

    //Debug
    //SpeakString("Spell ID:"+IntToString(nSpellID));

    effect eSummon = SetSummonEffect(nSpellID);

    //Apply the VFX impact and summon effect
    MultisummonPreSummon(OBJECT_SELF);
    ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eSummon, PRCGetSpellTargetLocation());
}


effect SetSummonEffect(int nSpellID)
{
    int nJLevel = GetLevelByClass(CLASS_TYPE_JUDICATOR);
    int nFNF_Effect;
    int nSLevel;
    string sSummon;

    if(nJLevel<11)
        {
            switch(nJLevel)
            {
            case 5:
                nSLevel=1;
                break;
            case 6:
                nSLevel=2;
                break;
            case 7:
                nSLevel=2;
                break;
            case 8:
                nSLevel=3;
                break;
            case 9:
                nSLevel=3;
                break;
            case 10:
                nSLevel=4;
                break;
            }
        }
    //In case someone raises the limit manually and levels beyond 10.
    else nSLevel=4;

    string sSLevel = IntToString(nSLevel);

    if(nSpellID == SPELL_SUMMON_MYRLOCHAR)
    {
        nFNF_Effect = VFX_FNF_SUMMON_UNDEAD;
        sSummon = "ch_dj_myrlochar"+sSLevel;
        //debug
        //SpeakString("Summoning Myrlochar, level: "+sSLevel);
    }
    else if(nSpellID == SPELL_SUMMON_SWORDSPID)
    {
        nFNF_Effect = VFX_FNF_SUMMON_UNDEAD;
        sSummon = "ch_dj_swordspid"+sSLevel;
        //debug
        //SpeakString("Summoning Sword Spider, level: "+sSLevel);
    }
    else if(nSpellID == SPELL_SUMMON_PHASESPID)
    {
        nFNF_Effect = VFX_FNF_SUMMON_UNDEAD;
        sSummon = "ch_dj_phasespid"+sSLevel;
        //debug
        //SpeakString("Summoning Phase Spider, level: "+sSLevel);
    }
    else if(nSpellID == SPELL_SUMMON_MONSTROUS)
    {
        nFNF_Effect = VFX_FNF_SUMMON_UNDEAD;
        sSummon = "ch_dj_monstspid"+sSLevel;
        //SpeakString("Summoning Phase Spider, level: "+sSLevel);
    }

    //effect eVis = EffectVisualEffect(nFNF_Effect);
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, PRCGetSpellTargetLocation());
    effect eSummonedMonster = EffectSummonCreature(sSummon, nFNF_Effect, 0.0f, TRUE);
    return eSummonedMonster;
}

