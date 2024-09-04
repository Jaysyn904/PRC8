#include "prc_x2_itemprop"
#include "inc_acp"
#include "prc_ipfeat_const"

void main()
{
    object oPC = OBJECT_SELF;
    if(!GetHasFeat(FEAT_ACP_QUICK_FEAT)
    && GetPRCSwitch(PRC_ACP_MANUAL))
    {
        IPSafeAddItemProperty(GetPCSkin(OBJECT_SELF), PRCItemPropertyBonusFeat(IP_CONST_ACP_QUICK_FEAT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        return;
    }
    if(!GetHasFeat(FEAT_ACP_HEAVY_FEAT)
    && GetPRCSwitch(PRC_ACP_MANUAL))
    {
        IPSafeAddItemProperty(GetPCSkin(OBJECT_SELF), PRCItemPropertyBonusFeat(IP_CONST_ACP_HEAVY_FEAT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        return;
    }
    if(!GetHasFeat(FEAT_ACP_UNARMED_FEAT)
    && GetPRCSwitch(PRC_ACP_MANUAL))
    {
        IPSafeAddItemProperty(GetPCSkin(OBJECT_SELF), PRCItemPropertyBonusFeat(IP_CONST_ACP_UNARMED_FEAT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        return;
    }	
    else if(((GetPRCSwitch(PRC_ACP_AUTOMATIC) && GetIsPC(OBJECT_SELF))
            ||(GetPRCSwitch(PRC_ACP_NPC_AUTOMATIC) && !GetIsPC(OBJECT_SELF))
            ||(GetLocalInt(OBJECT_SELF, PRC_ACP_NPC_AUTOMATIC) && !GetIsPC(OBJECT_SELF)))
        && !GetLocalInt(OBJECT_SELF, sLock))
    {
        int nKensaiScore,
            nAssassinScore,
            nBarbarianScore,
            nFencingScore;

        object oOffhand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
        object oOnhand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

        if(GetBaseItemType(oOffhand) != BASE_ITEM_TOWERSHIELD
        && GetBaseItemType(oOffhand) != BASE_ITEM_LARGESHIELD)
        {
            nKensaiScore += GetLevelByClass(CLASS_TYPE_SAMURAI);
            nKensaiScore += GetLevelByClass(CLASS_TYPE_CW_SAMURAI);
            nKensaiScore += GetLevelByClass(CLASS_TYPE_MONK);
            nKensaiScore += GetLevelByClass(CLASS_TYPE_IAIJUTSU_MASTER);
            nKensaiScore += GetLevelByClass(CLASS_TYPE_SHOU);

            nAssassinScore += GetLevelByClass(CLASS_TYPE_ASSASSIN);
            nAssassinScore += GetLevelByClass(CLASS_TYPE_SHADOWDANCER);
            nAssassinScore += GetLevelByClass(CLASS_TYPE_NINJA_SPY);
            nAssassinScore += GetLevelByClass(CLASS_TYPE_NIGHTSHADE);
            nAssassinScore += GetLevelByClass(CLASS_TYPE_BFZ);
            nAssassinScore += GetLevelByClass(CLASS_TYPE_SHADOWLORD);

            nFencingScore += GetLevelByClass(CLASS_TYPE_BARD);
            nFencingScore += GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST);
			nFencingScore += GetLevelByClass(CLASS_TYPE_SWASHBUCKLER);
            nFencingScore += GetLevelByClass(CLASS_TYPE_BLADESINGER);
            nFencingScore += GetLevelByClass(CLASS_TYPE_TEMPEST);
            if(GetAbilityScore(OBJECT_SELF, ABILITY_DEXTERITY)>20)
                nFencingScore += (GetAbilityScore(OBJECT_SELF, ABILITY_DEXTERITY)-10)/2;
        }

        nBarbarianScore += GetLevelByClass(CLASS_TYPE_BARBARIAN);
        nBarbarianScore += GetLevelByClass(CLASS_TYPE_PRC_EYE_OF_GRUUMSH);
        nBarbarianScore += GetLevelByClass(CLASS_TYPE_ORC_WARLORD);
        nBarbarianScore += GetLevelByClass(CLASS_TYPE_FRE_BERSERKER);
        nBarbarianScore += GetLevelByClass(CLASS_TYPE_BATTLERAGER);
        nBarbarianScore += GetLevelByClass(CLASS_TYPE_RUNESCARRED);
        if(GetAbilityScore(OBJECT_SELF, ABILITY_STRENGTH) > 20)
            nBarbarianScore += (GetAbilityScore(OBJECT_SELF, ABILITY_STRENGTH)-10)/2;

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

        if(GetPhenoType(OBJECT_SELF) != nAutoPhenotype)
        {
            SetPhenoType(nAutoPhenotype);
            LockThisFeat();
        }
    }
}