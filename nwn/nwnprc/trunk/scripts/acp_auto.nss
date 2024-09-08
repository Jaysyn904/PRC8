#include "prc_x2_itemprop"
#include "inc_acp"
#include "prc_ipfeat_const"

void main()
{
    object oPC = OBJECT_SELF;
	
    if(!GetHasFeat(FEAT_ACP_QUICK_FEAT)
    && GetPRCSwitch(PRC_ACP_MANUAL))
    {
        IPSafeAddItemProperty(GetPCSkin(oPC), PRCItemPropertyBonusFeat(IP_CONST_ACP_QUICK_FEAT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        return;
    }
    if(!GetHasFeat(FEAT_ACP_HEAVY_FEAT)
    && GetPRCSwitch(PRC_ACP_MANUAL))
    {
        IPSafeAddItemProperty(GetPCSkin(oPC), PRCItemPropertyBonusFeat(IP_CONST_ACP_HEAVY_FEAT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        return;
    }
    if(!GetHasFeat(FEAT_ACP_UNARMED_FEAT)
    && GetPRCSwitch(PRC_ACP_MANUAL))
    {
        IPSafeAddItemProperty(GetPCSkin(oPC), PRCItemPropertyBonusFeat(IP_CONST_ACP_UNARMED_FEAT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        return;
    }	
    else if(((GetPRCSwitch(PRC_ACP_AUTOMATIC) && GetIsPC(oPC))
            ||(GetPRCSwitch(PRC_ACP_NPC_AUTOMATIC) && !GetIsPC(oPC))
            ||(GetLocalInt(oPC, PRC_ACP_NPC_AUTOMATIC) && !GetIsPC(oPC)))
        && !GetLocalInt(oPC, sLock))
    {
        int nKensaiScore,
            nAssassinScore,
			nArcaneScore,
            nBarbarianScore,
            nFencingScore,
			nDemonbladeScore,
			nWarriorScore,
			nTigerFangScore,
			nSunFistScore,
			nDragonPalmScore,
			nBearsClawScore;
		
		//:: Unarmed Strike
		int nImpUnarmed = GetHasFeat(FEAT_IMPROVED_UNARMED_STRIKE);
		if(nImpUnarmed)
		{
			nTigerFangScore		+= 5;
			nSunFistScore		+= 5;
			nDragonPalmScore	+= 5;
			nBearsClawScore		+= 5;
		}
		
		int nFocus = GetHasFeat(FEAT_WEAPON_FOCUS_UNARMED_STRIKE);
		if(nFocus)
		{
			nTigerFangScore		+= 10;
			nSunFistScore		+= 10;
			nDragonPalmScore	+= 10;
			nBearsClawScore		+= 10;
		}
		int nImpCrit = GetHasFeat(FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE);
		if(nImpCrit)
		{
			nTigerFangScore		+= 10;
			nSunFistScore		+= 5;
			nDragonPalmScore	+= 20;
			nBearsClawScore		+= 15;
		}	
		int nEFocus = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_UNARMED);
		if(nEFocus)
		{
			nTigerFangScore		+= 15;
			nSunFistScore		+= 15;
			nDragonPalmScore	+= 15;
			nBearsClawScore		+= 15;
		}	
		int nSuperior = GetHasFeat(FEAT_SUPERIOR_UNARMED_STRIKE, oPC);
		if(nSuperior)
		{
			nTigerFangScore		+= 20;
			nSunFistScore		+= 20;
			nDragonPalmScore	+= 20;
			nBearsClawScore		+= 20;
		}
		
		//:: Creature weapons
		int nCreFocus = GetHasFeat(FEAT_WEAPON_FOCUS_CREATURE);
		if(nCreFocus)
		{
			nTigerFangScore		+= d6(1) + 5;
			nSunFistScore		+= 5;
			nDragonPalmScore	+= d6(1) + 5;
			nBearsClawScore		+= d6(1) + 5;
		}
		int nCreImpCrit = GetHasFeat(FEAT_IMPROVED_CRITICAL_CREATURE);
		if(nCreImpCrit)
		{
			nTigerFangScore		+= d6(1) + 5;
			nSunFistScore		+= 5;
			nDragonPalmScore	+= d6(1) + 5;
			nBearsClawScore		+= d6(1) + 5;
		}	
		int nECreFocus = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_CREATURE);
		if(nECreFocus)
		{
			nTigerFangScore		+= d6(1) + 5;
			nSunFistScore		+= 5;
			nDragonPalmScore	+= d6(1) + 5;
			nBearsClawScore		+= d6(1) + 5;
		}	

        object oOffhand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
        object oOnhand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

        if(GetBaseItemType(oOffhand) != BASE_ITEM_TOWERSHIELD
        && GetBaseItemType(oOffhand) != BASE_ITEM_LARGESHIELD)
        {
			if (GetIsObjectValid(oOnhand) == FALSE && GetIsObjectValid(oOffhand) == FALSE)
			{
				nTigerFangScore += GetLevelByClass(CLASS_TYPE_MONK);
				nTigerFangScore += (3 * GetLevelByClass(CLASS_TYPE_BLOODCLAW_MASTER));
			
				nSunFistScore += (2 * GetLevelByClass(CLASS_TYPE_MONK));
				nSunFistScore += (3 * GetLevelByClass(CLASS_TYPE_FISTRAZIEL));
				nSunFistScore += (3 * GetLevelByClass(CLASS_TYPE_SACREDFIST));
				nSunFistScore += (3 * GetLevelByClass(CLASS_TYPE_FIST_OF_ZUOKEN));
				nSunFistScore += (3 * GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST));
				nSunFistScore += (3 * GetLevelByClass(CLASS_TYPE_HENSHIN_MYSTIC));
				nSunFistScore += (3 * GetLevelByClass(CLASS_TYPE_FIST_DAL_QUOR));
			
				nDragonPalmScore += GetLevelByClass(CLASS_TYPE_MONK);
				nDragonPalmScore += (4 * GetLevelByClass(CLASS_TYPE_INITIATE_DRACONIC));
			
				nBearsClawScore += GetLevelByClass(CLASS_TYPE_MONK);
				nBearsClawScore += (3 * GetLevelByClass(CLASS_TYPE_TOTEMIST));
				nBearsClawScore += (3 * GetLevelByClass(CLASS_TYPE_CELEBRANT_SHARESS));
				nBearsClawScore += (3 * GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER));
				nBearsClawScore += (3 * GetLevelByClass(CLASS_TYPE_REAPING_MAULER));
			}
			
			nKensaiScore += GetLevelByClass(CLASS_TYPE_SAMURAI);
            nKensaiScore += GetLevelByClass(CLASS_TYPE_CW_SAMURAI);
			nKensaiScore += GetLevelByClass(CLASS_TYPE_SOULKNIFE);
			nKensaiScore += GetLevelByClass(CLASS_TYPE_SWORDSAGE);
            nKensaiScore += GetLevelByClass(CLASS_TYPE_IAIJUTSU_MASTER);
            nKensaiScore += GetLevelByClass(CLASS_TYPE_SHOU);
			nKensaiScore += GetLevelByClass(CLASS_TYPE_SOHEI);

            nAssassinScore += GetLevelByClass(CLASS_TYPE_ASSASSIN);
            nAssassinScore += GetLevelByClass(CLASS_TYPE_SHADOWDANCER);
            nAssassinScore += GetLevelByClass(CLASS_TYPE_NINJA_SPY);
            nAssassinScore += GetLevelByClass(CLASS_TYPE_NIGHTSHADE);
            nAssassinScore += GetLevelByClass(CLASS_TYPE_BFZ);
            nAssassinScore += GetLevelByClass(CLASS_TYPE_SHADOWLORD);
			nAssassinScore += GetLevelByClass(CLASS_TYPE_NINJA);

            nFencingScore += GetLevelByClass(CLASS_TYPE_BARD);
            nFencingScore += GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST);
			nFencingScore += GetLevelByClass(CLASS_TYPE_SWASHBUCKLER);
            nFencingScore += GetLevelByClass(CLASS_TYPE_BLADESINGER);
            nFencingScore += GetLevelByClass(CLASS_TYPE_TEMPEST);
            if(GetAbilityScore(oPC, ABILITY_DEXTERITY)>20)
                nFencingScore += (GetAbilityScore(oPC, ABILITY_DEXTERITY)-10)/2;
        }

		nDemonbladeScore	+=  GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC)
							+ GetLevelByClass(CLASS_TYPE_FIGHTER, oPC)
							+ GetLevelByClass(CLASS_TYPE_ARCHIVIST, oPC)
							+ GetLevelByClass(CLASS_TYPE_PSYWAR, oPC)
							+ GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC)
							+ GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN, oPC)
							+ GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oPC)
							+ GetLevelByClass(CLASS_TYPE_HEXBLADE, oPC)
							+ GetLevelByClass(CLASS_TYPE_INCARNATE, oPC)
							+ GetLevelByClass(CLASS_TYPE_WARBLADE, oPC);
				
		nWarriorScore	+= GetLevelByClass(CLASS_TYPE_CW_SAMURAI, oPC)
						+ GetLevelByClass(CLASS_TYPE_KNIGHT, oPC)
						+ GetLevelByClass(CLASS_TYPE_MARSHAL, oPC)
						+ GetLevelByClass(CLASS_TYPE_SAMURAI, oPC)
						+ GetLevelByClass(CLASS_TYPE_DUSKBLADE, oPC)
						+ GetLevelByClass(CLASS_TYPE_INCARNATE, oPC)
						+ GetLevelByClass(CLASS_TYPE_SOULBORN, oPC)
						+ GetLevelByClass(CLASS_TYPE_PALADIN, oPC)
						+ GetLevelByClass(CLASS_TYPE_PSYWAR, oPC);
				
		nArcaneScore	= GetLevelByClass(CLASS_TYPE_WIZARD, oPC)
						+ GetLevelByClass(CLASS_TYPE_SORCERER, oPC)								
						+ GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT, oPC)
						+ GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN, oPC)			
						+ GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER, oPC)
						+ GetLevelByClass(CLASS_TYPE_SHADOWCASTER, oPC)
						+ GetLevelByClass(CLASS_TYPE_KNIGHT_WEAVE, oPC)
						+ GetLevelByClass(CLASS_TYPE_SHADOWLORD, oPC)			
						+ GetLevelByClass(CLASS_TYPE_WARLOCK, oPC)
						+ (GetLevelByClass(CLASS_TYPE_ARCHMAGE, oPC) * 2)
						+ (GetLevelByClass(CLASS_TYPE_HELLFIRE_WARLOCK, oPC) * 2)
						
						+ ((GetLevelByClass(CLASS_TYPE_PSION, oPC)								
						+ GetLevelByClass(CLASS_TYPE_WILDER, oPC)
						+ GetLevelByClass(CLASS_TYPE_PSYWAR, oPC)
						+ GetLevelByClass(CLASS_TYPE_PSYCHIC_ROGUE, oPC)) /2)							
						
						+ ((GetLevelByClass(CLASS_TYPE_BEGUILER, oPC)								
						+ GetLevelByClass(CLASS_TYPE_WARMAGE, oPC)
						+ GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC)
						+ GetLevelByClass(CLASS_TYPE_CELEBRANT_SHARESS, oPC)
						+ GetLevelByClass(CLASS_TYPE_CULTIST_SHATTERED_PEAK, oPC)
						+ GetLevelByClass(CLASS_TYPE_DUSKBLADE, oPC)			
						+ GetLevelByClass(CLASS_TYPE_HARPER, oPC)
						+ GetLevelByClass(CLASS_TYPE_HEXBLADE, oPC)
						+ GetLevelByClass(CLASS_TYPE_SUBLIME_CHORD, oPC)
						+ GetLevelByClass(CLASS_TYPE_SUEL_ARCHANAMACH, oPC)		
						+ GetLevelByClass(CLASS_TYPE_BARD, oPC)) /2);
								
        nBarbarianScore += GetLevelByClass(CLASS_TYPE_BARBARIAN);
        nBarbarianScore += GetLevelByClass(CLASS_TYPE_PRC_EYE_OF_GRUUMSH);
        nBarbarianScore += GetLevelByClass(CLASS_TYPE_ORC_WARLORD);
        nBarbarianScore += GetLevelByClass(CLASS_TYPE_FRE_BERSERKER);
        nBarbarianScore += GetLevelByClass(CLASS_TYPE_BATTLERAGER);
        nBarbarianScore += GetLevelByClass(CLASS_TYPE_RUNESCARRED);
        if(GetAbilityScore(oPC, ABILITY_STRENGTH) > 20)
            nBarbarianScore += (GetAbilityScore(oPC, ABILITY_STRENGTH)-10)/2;
		if(GetAbilityScore(oPC, ABILITY_CONSTITUTION) > 20)
            nBarbarianScore += (GetAbilityScore(oPC, ABILITY_CONSTITUTION)-10)/2;

        int nAutoPhenotype = PHENOTYPE_NORMAL;
        int nBestScore;

        if(nKensaiScore > nBestScore)
        {
            nAutoPhenotype = PHENOTYPE_KENSAI;
            nBestScore = nKensaiScore;
        }
        if(nAssassinScore > nBestScore)
        {
            nAutoPhenotype = PHENOTYPE_ASSASSIN;
            nBestScore = nAssassinScore;
        }
        if(nBarbarianScore > nBestScore)
        {
            nAutoPhenotype = PHENOTYPE_BARBARIAN;
            nBestScore = nBarbarianScore;
        }
        if(nFencingScore > nBestScore)
        {
            nAutoPhenotype = PHENOTYPE_FENCING;
            nBestScore = nFencingScore;
        }
        if(nArcaneScore > nBestScore && nArcaneScore > 12)
        {
            nAutoPhenotype = PHENOTYPE_ARCANE;
            nBestScore = nArcaneScore;
        }		
        if(nDemonbladeScore > nBestScore)
        {
            nAutoPhenotype = PHENOTYPE_DEMONBLADE;
            nBestScore = nDemonbladeScore;
        }
        if(nWarriorScore > nBestScore)
        {
            nAutoPhenotype = PHENOTYPE_WARRIOR;
            nBestScore = nWarriorScore;
        }		
        if(GetPhenoType(oPC) != nAutoPhenotype)
        {
            SetPhenoType(nAutoPhenotype);
            LockThisFeat();
        }
    }
}