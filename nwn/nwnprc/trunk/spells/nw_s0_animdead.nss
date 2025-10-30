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
#include "prc_inc_template"


void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    //Declare major variables
    object oCaster = OBJECT_SELF;
	int nLichHD = GetHitDice(oCaster);
    location lTarget = PRCGetSpellTargetLocation();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDuration = HoursToSeconds(24);
    //Metamagic extension if needed
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2;  //Duration is +100%

    string sResRef;
    int nHD;

    //Summon the appropriate creature based on the summoner level
    if (nCasterLevel <= 5)
    {
        //Tyrant Fog Zombie
        sResRef = "NW_S_ZOMBTYRANT";
        nHD = 4;
    }
    else if ((nCasterLevel >= 6) && (nCasterLevel <= 9))
    {
        //Skeleton Warrior
        sResRef = "NW_S_SKELWARR";
        nHD = 6;
    }
    else
    {
        //Skeleton Chieftain
        sResRef = "NW_S_SKELCHIEF";
        nHD = 7;
    }

    effect eSummon = EffectSummonCreature(sResRef, VFX_FNF_SUMMON_UNDEAD);

    MultisummonPreSummon();

    if(GetPRCSwitch(PRC_PNP_ANIMATE_DEAD))
    {
        int nMaxHD = GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER, oCaster) >= 8 ?
                     nCasterLevel * (4 + GetAbilityModifier(ABILITY_CHARISMA, oCaster)) : nCasterLevel * 4;
                     
        if(GetHasSpellEffect(SPELL_DES_20) || GetHasSpellEffect(SPELL_DES_100) || GetHasSpellEffect(SPELL_DESECRATE))
        	nMaxHD *= 2;
	
		if(GetHasTemplate(TEMPLATE_ARCHLICH, oCaster)) //: Archlich
			nMaxHD = nLichHD;
			
        int nTotalHD = GetControlledUndeadTotalHD();
        
        int nGold = GetGold(oCaster);
        int nCost = nHD * 25;
        if((nTotalHD+nHD) <= nMaxHD)
        {
            if(nCost > nGold)
            {
                FloatingTextStringOnCreature("You have insufficient gold to animate this creature", oCaster, FALSE);
                return;
            }     
            else
            {
                TakeGoldFromCreature(nCost, oCaster, TRUE);
                eSummon = SupernaturalEffect(eSummon);
                ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eSummon, lTarget);
                FloatingTextStringOnCreature("Currently have "+IntToString(nTotalHD+nHD)+"HD out of "+IntToString(nMaxHD)+"HD.", oCaster);
            }    
        }
        else
            FloatingTextStringOnCreature("You cannot create more undead at this time.", oCaster);
    }
    else
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration);

    PRCSetSchool();
}