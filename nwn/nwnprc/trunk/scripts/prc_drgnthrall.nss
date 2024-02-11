//::///////////////////////////////////////////////
//:: Dragonthrall/friend
//:: prc_drgnthrall.nss
//::///////////////////////////////////////////////
/*
    Dragonfriend and Dragonthrall feats
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Dec 23, 2007
//:://////////////////////////////////////////////
// x - moved to prc_feats_eff.nss

#include "prc_alterations"

void main()
{/*
	effect eSkillBonus;
	effect eFearBonus;
	effect eTotalBonus;
	object oPC = OBJECT_SELF;
        object oSkin = GetPCSkin(oPC);
	int bFriend = GetHasFeat(FEAT_DRAGONFRIEND, oPC);
	int bThrall = GetHasFeat(FEAT_DRAGONTHRALL, oPC);
	
	if(GetLocalInt(oSkin, "DragonThrall") == TRUE) return;
	
	if(bFriend)
	{
		eSkillBonus = EffectSkillIncrease(SKILL_PERSUADE, 4);
		eFearBonus = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_FEAR);
		eFearBonus = VersusAlignmentEffect(eFearBonus, ALIGNMENT_ALL, ALIGNMENT_GOOD);
		eTotalBonus = EffectLinkEffects(eSkillBonus, eFearBonus);
		eTotalBonus = VersusRacialTypeEffect(eTotalBonus, RACIAL_TYPE_DRAGON);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eTotalBonus), oPC);
		SetLocalInt(oSkin, "DragonThrall", TRUE);
		
	}
	
	if(bThrall)
	{
		eSkillBonus = EffectSkillIncrease(SKILL_BLUFF, 4);
		eFearBonus = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_FEAR);
		eFearBonus = VersusAlignmentEffect(eFearBonus, ALIGNMENT_ALL, ALIGNMENT_EVIL);
		effect eSubTotalBonus = EffectLinkEffects(eSkillBonus, eFearBonus);
		effect eSavePenalty = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_MIND_SPELLS);
		eTotalBonus = EffectLinkEffects(eSubTotalBonus, eSavePenalty);
		eTotalBonus = VersusRacialTypeEffect(eTotalBonus, RACIAL_TYPE_DRAGON);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eTotalBonus), oPC);
		SetLocalInt(oSkin, "DragonThrall", TRUE);	
	}*/
}
