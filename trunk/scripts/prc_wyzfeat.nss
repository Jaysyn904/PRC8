//::///////////////////////////////////////////////
//:: [Prerequisite feat]
//:: [prc_prereq.nss]
//:://////////////////////////////////////////////
//:: This script addesses prerequisite feats not
//:: assigned to a scpecific prestige class
//:://////////////////////////////////////////////
//:: Created By: Wyz_sub10
//:: Created On: Mar 3, 2004
//:://////////////////////////////////////////////
// x - moved to prc_feats.nss

#include "prc_alterations"
#include "prc_feat_const"

// * Applies the Endurance (Vigilant prereq.) saving throw bonus as CompositeBonuses on the object's skin.
/*void EnduranceBonus(object oPC, object oSkin, int iLevel, int iType)
{
    if(GetLocalInt(oSkin, "EnduranceBonus") == iLevel) return;

    SetCompositeBonus(oSkin, "EnduranceBonus", iLevel, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, iType);
}

//*Applies the Track (Vigilant prereq.) skill bonuses as CompositeBonuses on the object's skin.
void TrackSkill(object oPC, object oSkin, int iLevel)
{
    if(GetLocalInt(oSkin, "TrackSkill") == iLevel) return;

    SetCompositeBonus(oSkin, "TrackSkillSP", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_SPOT);
    SetCompositeBonus(oSkin, "TrackSkillSR", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_SEARCH);
    SetCompositeBonus(oSkin, "TrackSkillLS", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_LISTEN);
}

//*Applies Ethran (Hathran prereq.) Charisma skill bonuses as CompositeBonuses on the object's skin.
void Ethran(object oPC ,object oSkin ,int iLevel)
{
   if(GetLocalInt(oSkin, "Ethran") == iLevel) return;

    SetCompositeBonus(oSkin, "EthranA", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_ANIMAL_EMPATHY);
    SetCompositeBonus(oSkin, "EthranP", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERFORM);
    SetCompositeBonus(oSkin, "EthranPe", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERSUADE);
    SetCompositeBonus(oSkin, "EthranT", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_TAUNT);
    SetCompositeBonus(oSkin, "EthranA", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_APPRAISE);
    SetCompositeBonus(oSkin, "EthranB", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_BLUFF);
    SetCompositeBonus(oSkin, "EthranI", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);
}*/


void main()
{
/*    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int bGen = GetGender(oPC);
    int bEnd = GetHasFeat(FEAT_ENDURANCE, oPC)        ? 4 : 0;
    int bTS = GetHasFeat(FEAT_TRACK, oPC)        ? 1 : 0;
    int bEthran = GetHasFeat(FEAT_ETHRAN, oPC) ? 2 : 0;

    if(bEnd > 0) EnduranceBonus(oPC, oSkin, bEnd, IP_CONST_SAVEVS_DEATH);
    if(bTS > 0) TrackSkill(oPC, oSkin, bTS);
    if((bGen = 1) && (bEthran > 0)) Ethran(oPC, oSkin,bEthran);
    //if(bEthran>0) Ethran(oPC, oSkin,bEthran);
*/
}
