//::///////////////////////////////////////////////
//:: Elemental Swarm
//:: NW_S0_EleSwarm.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell creates a conduit from the caster
    to the elemental planes.  The first elemental
    summoned is a 24 HD Air elemental.  Whenever an
    elemental dies it is replaced by the next
    elemental in the chain Air, Earth, Water, Fire
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 30, 2001
//:: modified by mr_bumpkin Dec 4, 2003

#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    int CasterLvl = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();

    if(GetPRCSwitch(PRC_PNP_ELEMENTAL_SWARM)
    && GetPRCSwitch(PRC_MULTISUMMON))
    {
        float fDuration = IntToFloat(60*10*CasterLvl);
        float fDelay = 600.0;
        if(GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL))
        {
            fDuration = RoundsToSeconds(CasterLvl);
            fDelay = RoundsToSeconds(1);
        }
        //Check for metamagic duration
        if ((nMetaMagic & METAMAGIC_EXTEND))
            fDuration = fDuration * 2.0;  //Duration is +100%
        MultisummonPreSummon();
        int i;
        int nVFX = VFX_FNF_SUMMON_MONSTER_3;
        string sResRef;
        int nElement = Random(4);
        switch(nElement)
        {
                case 0:
                    sResRef = "NW_S_AIRHUGE";
                    break;
                case 1:
                    sResRef = "NW_S_WATERHUGE";
                    break;
                case 2:
                    sResRef = "NW_S_FIREHUGE";
                    break;
                case 3:
                    sResRef = "NW_S_EARTHHUGE";
                    break;
        }
        effect eSummon = EffectSummonCreature(sResRef, nVFX);
        int nHugeElementals = d4(2);
        for(i=0; i<nHugeElementals; i++)
        {
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), fDuration);
        }
        
        switch(nElement)
        {
                case 0:
                    sResRef = "NW_S_AIRGREAT";
                    break;
                case 1:
                    sResRef = "NW_S_WATERGREAT";
                    break;
                case 2:
                    sResRef = "NW_S_FIREGREAT";
                    break;
                case 3:
                    sResRef = "NW_S_EARTHGREAT";
                    break;
        }
        eSummon = EffectSummonCreature(sResRef, nVFX);
        int nGreaterElementals = d4(1);
        for(i=0; i<nGreaterElementals; i++)
        {
            DelayCommand(fDelay, MultisummonPreSummon());
            DelayCommand(fDelay, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetLocation(OBJECT_SELF), fDuration-fDelay));
        }
        switch(nElement)
        {
                case 0:
                    sResRef = "NW_S_AIRELDER";
                    break;
                case 1:
                    sResRef = "NW_S_WATERELDER";
                    break;
                case 2:
                    sResRef = "NW_S_FIREELDER";
                    break;
                case 3:
                    sResRef = "NW_S_EARTHELDER";
                    break;
        }
        eSummon = EffectSummonCreature(sResRef, nVFX);
        DelayCommand(fDelay*2.0, MultisummonPreSummon());
        DelayCommand(fDelay*2.0, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetLocation(OBJECT_SELF), fDuration-(fDelay*2.0)));
    }
    else
    {
        int nDuration = 24;
        effect eSummon;
        effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
        float fDuration = HoursToSeconds(nDuration);
        if(GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL))
            fDuration = RoundsToSeconds(CasterLvl);
        //Check for metamagic duration
        if((nMetaMagic & METAMAGIC_EXTEND))
            fDuration = fDuration * 2.0;  //Duration is +100%
        //Set the summoning effect
        eSummon = EffectSwarm(FALSE, "NW_SW_AIRGREAT", "NW_SW_WATERGREAT","NW_SW_EARTHGREAT","NW_SW_FIREGREAT");
        //Apply the summon effect
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSummon, OBJECT_SELF, fDuration, TRUE,-1,CasterLvl);

        DelayCommand(0.5, AugmentSummonedCreature("NW_SW_AIRGREAT"));
    }
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

