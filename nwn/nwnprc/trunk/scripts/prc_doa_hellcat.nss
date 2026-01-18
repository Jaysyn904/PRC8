//::///////////////////////////////////////////////
//:: Disciple of Asmodeus Summon Hellcat
//:: prc_doa_hellcat.nss
//::///////////////////////////////////////////////
/*
    Summons a Hellcat. At level 9, summons 1d4 Hellcats.
    Duration as per summon monster
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 27.2.2006
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    //Declare major variables
    object oPC = OBJECT_SELF;
    effect eSummon = EffectSummonCreature("prc_doa_hellcat");
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
    float fDuration = HoursToSeconds(24);
    int nDuration = PRCGetCasterLevel(oPC);
	if (nDuration == 0)
	{
		nDuration = 2 * GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oPC);
	}
	
    if(GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL))
        fDuration = RoundsToSeconds(nDuration*GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL));    

    if (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oPC) >= 9)
    {
        if(DEBUG) DoDebug("prc_doa_hellcat - MultiSummon Branch");
	// Override so they get 1d4 summons
    	
    	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    	
    	int i;
    	int nNumSummons = d4();
    	for(i = 1; i <= nNumSummons; i++)
        {
        	MultisummonPreSummon(oPC, TRUE);
    		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), fDuration);
    		if(DEBUG) DoDebug("prc_doa_hellcat - Summoning Loop");
    	}
    }
    else
    {
    	// 1 summon only
    	MultisummonPreSummon(oPC);
    	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), fDuration);
    }
}
