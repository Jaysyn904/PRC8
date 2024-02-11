//::///////////////////////////////////////////////
//:: Forest Dominion 
//:: prc_fm_forestdom.nss
//:://////////////////////////////////////////////
/*
	 At 2nd level, the forest master gains the ability to rebuke or command plants 
	 as an evil cleric can rebuke or command undead.  His effective level for this 
	 ability is his class level, and he may use it a number of times perday equal 
	 to 3 + his Charisma modifier. If he already has this ability because he is a 
	 cleric with the Plant domain, these levels stack with his cleric levels and 
	 vice versa. 	
*/
//:://////////////////////////////////////////////
//:: Modified:
//:: 20040101 by Cole Kleinschmit: for use as Command Spiders.
//:: 22021020 by Jaysyn: Fixed to actually work on all spiders.
//:: 20230107 by Jaysyn: for use as Command Plants.

#include "prc_class_const"
#include "prc_alterations"

int CheckTargetName(object oTarget, string sName);

int GetIsPlant(object oCreature, int nAppearance);

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

void RebukePlant(int nTurnLevel, int nTurnHD, int nPlants, int nClassLevel)
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
                if(GetIsPlant(oTarget, nTargetAppearance))
                {
                    bValid = TRUE;
                    //debug
                    SpeakString("Plant Found");
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
                        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FM_FORESTDOMINION));
                        //Destroy the target
                        DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeathLink, oTarget, RoundsToSeconds(nClassLevel + 5)));
                        //AssignCommand(oTarget, ClearAllActions());
                        //SetIsTemporaryFriend(oTarget, OBJECT_SELF, TRUE, RoundsToSeconds(nClassLevel + 5));
                        AddCommand(nHD);
                        DelayCommand(RoundsToSeconds(nClassLevel + 5), SubCommand(nHD));
                        //debug
                        SpeakString("Commanding Plant");
                    }
                    else
                    {
                        //Turn the target
                        //Fire cast spell at event for the specified target
                        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FM_FORESTDOMINION));
                        //AssignCommand(oTarget, ActionMoveAwayFromObject(OBJECT_SELF, TRUE));
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nClassLevel + 5));
                        //debug
                        SpeakString("Rebuking Plant");
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
//:: Declare major variables
    int nFMLevel	= GetLevelByClass(CLASS_TYPE_FORESTMASTER);
	int nCleric 	= GetLevelByClass(CLASS_TYPE_CLERIC);
	int nShaman 	= GetLevelByClass(CLASS_TYPE_SHAMAN);
	
	int nTotalLevel;
	
//:: Check for Plant Domain & adust turning & class level.
    int nPlants 	= GetHasFeat(FEAT_PLANT_DOMAIN_POWER);

	if (nPlants)
	{	
		nTotalLevel = nFMLevel + nCleric + nShaman;
	}
	else
	{
		nTotalLevel = nFMLevel;
	}
	
    int nTurnLevel = nTotalLevel;
    int nClassLevel = nTotalLevel;

//:: Make a turning check roll
    int nChrMod = GetAbilityModifier(ABILITY_CHARISMA);
    int nTurnCheck = d20() + nChrMod;              //:: The roll to apply to the max HD of plants that can be commanded --> nTurnLevel
    int nTurnHD = d6(2) + nChrMod + nClassLevel;   //:: The number of HD of plants that can be commanded.

//:: Determine the maximum HD of the plants that can be commanded.
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
//:: Stays the same
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

        RebukePlant(nTurnLevel, nTurnHD, nPlants, nClassLevel);
		
}

int GetIsPlant(object oTarget, int nAppearance)
{
//:: No actual plants in vanilla NWN	
	return (nAppearance == 1001	//:: [CEP3] Twig Blight* (Erendril)
		|| nAppearance == 1053 	//:: [CEP3] Fungus: Shrieker 1* (Lathspell)			
		|| nAppearance == 1055 	//:: [CEP3] Myconid* (Schazzwozzer)
		|| nAppearance == 1056 	//:: [CEP3] Myconid: Sprout* (Schazzwozzer)
		|| nAppearance == 1057 	//:: [CEP3] Myconid: Elder* (Schazzwozzer)
		|| nAppearance == 1060 	//:: [CEP3] Vegepygmy* (Lathspell)
		|| nAppearance == 1061 	//:: [CEP3] Thorny* (Lathspell)
		|| nAppearance == 1062 	//:: [CEP3] Vegepygmy: Thorny Rider T* (Lathspell)
		|| nAppearance == 1063 	//:: [CEP3] Vegepygmy: Thorny Rider* (Lathspell)
		|| nAppearance == 1064 	//:: [CEP3] Vegepygmy: Thorny Rider V* (Lathspell)
		|| nAppearance == 1492	//:: [CEP3] Treant 1* (DLA Team)
		|| nAppearance == 1496 	//:: [CEP3] Assassin Vine: Horizontal* (ShadowM)
		|| nAppearance == 1497 	//:: [CEP3] Assassin Vine: Vertical* (ShadowM)
		|| nAppearance == 2597	//:: [CEP3] Treant: Small*
		|| nAppearance == 3049 	//:: [CEP3] Pumpkin* (CEP-Barry_1066)
		|| nAppearance == 3397 	//:: [CEP3] Fungus: Mold: Brown* (CCP)
		|| nAppearance == 3398 	//:: [CEP3] Fungus: Mold: Yellow* (CCP)
		|| nAppearance == 3399 	//:: [CEP3] Fungus: Shrieker 2* (CCP)
		|| nAppearance == 3400 	//:: [CEP3] Fungus: Violet* (CCP)
		|| nAppearance == 3471 	//:: [CEP3] Shambling Mound 1* (CCP)
		|| nAppearance == 3480	//:: [CEP3] Strangle Weed* (CCP)
		|| nAppearance == 3492	//:: [CEP3] Treant 2* [WoW] (CCP)
		|| nAppearance == 3893 	//:: [CEP3] Shambling Mound 2* (Hardpoints)
		|| nAppearance == 6409 	//:: [CEP3] Fungus: Shrieker* (The Amethyst Dragon)
		|| nAppearance == 6410 	//:: [CEP3] Fungus: Violet Fungus* (The Amethyst Dragon)
		|| nAppearance == 6417 	//:: [CEP3] Treant: Wild Woods* (The Amethyst Dragon)
		|| nAppearance == 6437 	//:: [CEP3] Forrestal: Runner* (CCC-Cestus Dei)
		|| nAppearance == 6438 	//:: [CEP3] Forrestal: Strider* (CCC-Cestus Dei)
		|| nAppearance == 6439 	//:: [CEP3] Forrestal: Walkabout* (CCC-Cestus Dei)
		|| nAppearance == 6440 	//:: [CEP3] Forrestal: Elder* (CCC-Cestus Dei)
		|| nAppearance == 6441 	//:: [CEP3] Forrestal: Dreamwalker* (CCC-Cestus Dei)
		|| nAppearance == 6468 	//:: [CEP3] Topiary Guardian: Bear* (The Amethyst Dragon)
		|| nAppearance == 6469 	//:: [CEP3] Topiary Guardian: Boar* (The Amethyst Dragon)
		|| nAppearance == 6470 	//:: [CEP3] Topiary Guardian: Deer* (The Amethyst Dragon)
		|| nAppearance == 6471 	//:: [CEP3] Topiary Guardian: Lion* (The Amethyst Dragon)
		|| nAppearance == 6472 	//:: [CEP3] Topiary Guardian: Triceratops* (The Amethyst Dragon)
		|| nAppearance == 6473 	//:: [CEP3] Topiary Guardian: Wolf* (The Amethyst Dragon)
		|| nAppearance == 6474 	//:: [CEP3] Topiary Guardian: Horse* (The Amethyst Dragon)
		|| nAppearance == 6475 	//:: [CEP3] Topiary Guardian: Woman* (The Amethyst Dragon)
		|| (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_PLANT));	 
		
}