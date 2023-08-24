//::///////////////////////////////////////////////
//:: Command Spiders 
//:: dj_s2_comspider.nss
//:://////////////////////////////////////////////
/*
	Specifics: As a special dispensation from Lolth, 
	Selvetarm can grant his judicators the ability to
	command spiders. When a drow judicator reaches 2nd
	level, he gains the ability to compel spiders in
	the same way that an evil cleric can rebuke or
	command undead. The drow judicator can attempt to
	command spiders a number of times per day equal to
	3 + his Charisma modifier. He is treated as a cleric
	of a level equal to his drow judicator level for the
	purposes of turning checks and damage. 	
*/
//:://////////////////////////////////////////////
//:: Modified:
//:: 20040101 by Cole Kleinschmit: for use as Command Spiders.
//:: 22021020 by Jaysyn: Fixed to actually work on all spiders.

#include "prc_class_const"
#include "prc_alterations"

int CheckTargetName(object oTarget, string sName);

int GetIsSpider(object oCreature, int nAppearance);

int CanCommand(int nClassLevel, int nTargetHD)
{
    int nSlots = GetLocalInt(OBJECT_SELF, "wb_clr_comm_slots");
    int nNew = nSlots+nTargetHD;
    //FloatingTextStringOnCreature("The variable is " + IntToString(nSlots), OBJECT_SELF);
    if(nClassLevel >= nNew)
    {
        return TRUE;
    }
    return FALSE;
}

void AddCommand(int nTargetHD)
{
    int nSlots = GetLocalInt(OBJECT_SELF, "wb_clr_comm_slots");
    SetLocalInt(OBJECT_SELF, "wb_clr_comm_slots", nSlots + nTargetHD);
}

void SubCommand(int nTargetHD)
{
    int nSlots = GetLocalInt(OBJECT_SELF, "wb_clr_comm_slots");
    SetLocalInt(OBJECT_SELF, "wb_clr_comm_slots", nSlots - nTargetHD);
}

void RebukeSpider(int nTurnLevel, int nTurnHD, int nVermin, int nClassLevel)
    {
    //Gets all creatures in a 20m radius around the caster and rebukes them or not.  If the creatures
    //HD are 1/2 or less of the nClassLevel then the creature is commanded (dominated).
    int nCnt = 1;
    int nHD, nRacial, nHDCount, bValid, nDamage;
    nHDCount = 0;
    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
    effect eVisTurn = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
    effect eDamage;
    effect eTurned = EffectCutsceneParalyze();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eVisTurn, eTurned);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eDeath = SupernaturalEffect(EffectCutsceneDominated());
    effect eDomin = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDeathLink = EffectLinkEffects(eDeath, eDomin);

    effect eImpactVis = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, GetLocation(OBJECT_SELF));

    //Get nearest enemy within 20m (60ft)
    //Why are you using GetNearest instead of GetFirstObjectInShape
    // Because ability description says "gets closest first" :P
    object oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC , OBJECT_SELF, nCnt);
	
	int nTargetAppearance = GetAppearanceType(oTarget);
	
	while(GetIsObjectValid(oTarget) && nHDCount < nTurnHD && GetDistanceToObject(oTarget) <= 20.0)
    {
        if(!GetIsFriend(oTarget))
        {
            nHD = GetHitDice(oTarget) + GetTurnResistanceHD(oTarget);
            
            if(nHD <= nTurnLevel && nHD <= (nTurnHD - nHDCount))
            {
                //:: Check for correct turning target.
                if(GetIsSpider(oTarget, nTargetAppearance))
                {
                    bValid = TRUE;
                    //debug
                    SpeakString("Spider Found");
                }

                //Apply results of the turn
                if( bValid == TRUE)
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    //if(IntToFloat(nClassLevel)/2.0 >= IntToFloat(nHD))
                    //{

                    if((nClassLevel/2) >= nHD && CanCommand(nClassLevel, nHD))
                    {
                        //Fire cast spell at event for the specified target
                        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_COMMAND_SPIDERS));
                        //Destroy the target
                        DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeathLink, oTarget, RoundsToSeconds(nClassLevel + 5)));
                        //AssignCommand(oTarget, ClearAllActions());
                        //SetIsTemporaryFriend(oTarget, OBJECT_SELF, TRUE, RoundsToSeconds(nClassLevel + 5));
                        AddCommand(nHD);
                        DelayCommand(RoundsToSeconds(nClassLevel + 5), SubCommand(nHD));
                        //debug
                        SpeakString("Commanding Spider");
                    }
                    else
                    {
                        //Turn the target
                        //Fire cast spell at event for the specified target
                        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_COMMAND_SPIDERS));
                        //AssignCommand(oTarget, ActionMoveAwayFromObject(OBJECT_SELF, TRUE));
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nClassLevel + 5));
                        //debug
                        SpeakString("Rebuking Spider");
                    }
                    nHDCount = nHDCount + nHD;
                }
            }
            bValid = FALSE;
        }
        nCnt++;
        oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, OBJECT_SELF, nCnt);
    }
}

void main()
{
    int nClericLevel = GetLevelByClass(CLASS_TYPE_JUDICATOR);
    int nTotalLevel =  nClericLevel;

    int nTurnLevel = nClericLevel;
    int nClassLevel = nClericLevel;

    //Flags for bonus turning types
    int nVermin = GetHasFeat(FEAT_DOMAIN_POWER_SPIDER);

    //Make a turning check roll
    int nChrMod = GetAbilityModifier(ABILITY_CHARISMA);
    int nTurnCheck = d20() + nChrMod;              //The roll to apply to the max HD of spiders that can be commanded --> nTurnLevel
    int nTurnHD = d6(2) + nChrMod + nClassLevel;   //The number of HD of spiders that can be commanded.

    //Determine the maximum HD of the spiders that can be commanded.
    if(nTurnCheck <= 0)
    {
        nTurnLevel -= 4;
    }
    else if(nTurnCheck >= 1 && nTurnCheck <= 3)
    {
        nTurnLevel -= 3;
    }
    else if(nTurnCheck >= 4 && nTurnCheck <= 6)
    {
        nTurnLevel -= 2;
    }
    else if(nTurnCheck >= 7 && nTurnCheck <= 9)
    {
        nTurnLevel -= 1;
    }
    else if(nTurnCheck >= 10 && nTurnCheck <= 12)
    {
        //Stays the same
    }
    else if(nTurnCheck >= 13 && nTurnCheck <= 15)
    {
        nTurnLevel += 1;
    }
    else if(nTurnCheck >= 16 && nTurnCheck <= 18)
    {
        nTurnLevel += 2;
    }
    else if(nTurnCheck >= 19 && nTurnCheck <= 21)
    {
        nTurnLevel += 3;
    }
    else if(nTurnCheck >= 22)
    {
        nTurnLevel += 4;
    }

        RebukeSpider(nTurnLevel, nTurnHD, nVermin, nClassLevel);
		
}

int CheckTargetName(object oTarget, string sName)
{
    return FindSubString(GetStringLowerCase(GetName(oTarget)), sName) > -1;
}

int GetIsSpider(object oTarget, int nAppearance)
{
	
    return (nAppearance == APPEARANCE_TYPE_SPIDER_WRAITH
			|| nAppearance == APPEARANCE_TYPE_SPIDER_DIRE
			|| nAppearance == APPEARANCE_TYPE_SPIDER_GIANT
			|| nAppearance == APPEARANCE_TYPE_SPIDER_SWORD
			|| nAppearance == APPEARANCE_TYPE_SPIDER_PHASE
			|| nAppearance == 15045 	//:: Spider - Small
			|| nAppearance == 463	 	//:: Maggris 
	//:: CEP Appearances		
			|| nAppearance == 1168 	//:: Spider: Bloodback [cep]
			|| nAppearance == 1248 	//:: Spider: Redback [cep] 
			|| nAppearance == 1256 	//:: Spider: Wraith B [cep] 
			|| nAppearance == 1284 	//:: Spider: Ice [cep] 
			|| nAppearance == 1311 	//:: Spiderling [cep]
			|| nAppearance == 1312 	//:: Spiderling: Giant [cep]
			|| nAppearance == 1313 	//:: Spiderling: Dire [cep]
			|| nAppearance == 1314 	//:: Spiderling: Sword [cep]
			|| nAppearance == 1315 	//:: Spiderling: Phase [cep]
			|| nAppearance == 1894 	//:: Spider: Giant - Tiny [cep]
			|| nAppearance == 1895 	//:: Spider: Giant - Small [cep] 
			|| nAppearance == 1896 	//:: Spider: Giant - Medium [cep]
			|| nAppearance == 1897 	//:: Spider: Giant - Large [cep] 
			|| nAppearance == 1898 	//:: Spider: Giant - Gargantuan [cep]
			|| nAppearance == 1900 	//:: Spider: Dire - Tiny [cep]
			|| nAppearance == 1901 	//:: Spider: Dire - Small [cep] 
			|| nAppearance == 1902 	//:: Spider: Dire - Medium [cep] 
			|| nAppearance == 1903 	//:: Spider: Dire - Large [cep] 
			|| nAppearance == 1904 	//:: Spider: Dire - Gargantuan [cep] 
			|| nAppearance == 1906 	//:: Spider: Phase - Tiny [cep]
			|| nAppearance == 1907 	//:: Spider: Phase - Small [cep] 
			|| nAppearance == 1908 	//:: Spider: Phase - Medium [cep] 
			|| nAppearance == 1909 	//:: Spider: Phase - Large [cep] 
			|| nAppearance == 1910 	//:: Spider: Phase - Gargantuan [cep] 	
			|| nAppearance == 1912 	//:: Spider: Sword - Tiny [cep]
			|| nAppearance == 1913 	//:: Spider: Sword - Small [cep] 
			|| nAppearance == 1914 	//:: Spider: Sword - Medium [cep] 
			|| nAppearance == 1915 	//:: Spider: Sword - Large [cep] 
			|| nAppearance == 1916 	//:: Spider: Sword - Gargantuan [cep] 
			|| nAppearance == 1918 	//:: Spider: Wraith - Tiny [cep]
			|| nAppearance == 1919 	//:: Spider: Wraith - Small [cep] 
			|| nAppearance == 1920 	//:: Spider: Wraith - Medium [cep] 
			|| nAppearance == 1921 	//:: Spider: Wraith - Large [cep] 
			|| nAppearance == 1922 	//:: Spider: Wraith - Gargantuan [cep] 
			|| nAppearance == 2515 	//:: Spider: Small [cep]		 
			|| nAppearance == 2996 	//:: Spider: Giant: Infensa 1 [cep]
			|| nAppearance == 2997 	//:: Spider: Giant: Infensa 2 [cep] 
			|| nAppearance == 2998 	//:: Spider: Giant: Infensa 3 [cep] 
			|| nAppearance == 2999 	//:: Spider: Giant: Infensa 4 [cep] 
			|| nAppearance == 3000 	//:: Spider: Giant: Infensa 5 [cep] 		 
			|| nAppearance == 3997 	//:: Spider: Tyrant [cep] 
			|| nAppearance == 3998 	//:: Spider: Gold Queen [cep]				 
			|| nAppearance == 6276	 	//:: Spider: Purgatory* [cep]
			|| nAppearance == 6277	 	//:: Spider: MindEater* [cep]
			|| nAppearance == 6278	 	//:: Spider: Night* [cep]
			|| nAppearance == 6279	 	//:: Spider: Spinner* [cep]
			|| nAppearance == 6280	 	//:: Spider: Zebra* [cep]
			|| nAppearance == 6281	 	//:: Spider: Ooze* [cep]
			|| nAppearance == 6282	 	//:: Spider: Weirdo* [cep]
			|| nAppearance == 6283	 	//:: Spider: Maze [cep]
			|| nAppearance == 6295	 	//:: Spider: Bone [cep]		 
			|| nAppearance == 6304  	//:: Spider: Ravener [cep]	
			|| (CheckTargetName(oTarget, "spider") && (GetRacialType(oTarget) == RACIAL_TYPE_VERMIN)));	 
       
}