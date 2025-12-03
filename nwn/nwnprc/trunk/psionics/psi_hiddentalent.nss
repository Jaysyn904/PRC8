//::///////////////////////////////////////////////
//:: Hidden Talent
//:: psi_hiddentalent.nss
//:://////////////////////////////////////////////
/*
	Your latent power of psionics flares to life, conferring upon you
	the designation of a psionic character. As a psionic character, 
	you gain a reserve of 2 power points, and you can take psionic 
	feats, metapsionic feats, and psionic item creation feats. If you
	have or take a class that grants power points, the power points 
	gained from Hidden Talent are added to your total power point 
	reserve.

	When you take this feat, choose one 1st-level power from any 
	psionic class list. You know this power (it becomes one of your 
	powers known). You can manifest this power with the power points 
	provided by this feat if you have a Charisma score of 11 or higher.
	If you have no psionic class levels, you are considered a 
	1st-level manifester when manifesting this power. If you have 
	psionic class levels, you can manifest the power at the highest 
	manifester level you have attained. (This is not a manifester 
	level, and it does not add to any manifester levels gained by 
	taking psionic classes.) If you have no psionic class levels, 
	use Charisma to determine how powerful a power you can manifest 
	and how hard those powers are to resist. 
*/
//:://////////////////////////////////////////////
//:: Created By: Jaysyn
//:: Created On: 2025-01-29 09:52:24
//:://////////////////////////////////////////////
#include "prc_feat_const"
#include "psi_inc_core"
#include "psi_inc_powknown"

int GetPowerRowID(int nPowerList, int nPower)
{
    string sPowerFile = GetAMSDefinitionFileName(nPowerList);
    int nCheck = -1;
    int i;
    for(i = 0; i < GetPRCSwitch(FILE_END_CLASS_POWER); i++)
    {
        nCheck = StringToInt(Get2DACache(sPowerFile, "RealSpellID", i));
        
        // Find the row ID of the power we need and return it
        if(nCheck == nPower)
        {
            return i;
        }
    }
    // this should never trigger
    return -1;
}

void GrantHiddenTalent(object oPC, int nPowerList, int nFeat, int nPower, string sTag)
{
    if (GetHasFeat(nFeat, oPC) && !GetPersistantLocalInt(oPC, sTag))
    {
        if(DEBUG) DoDebug("psi_hiddentalent: Adding power ID " + IntToString(nPower));
        AddPowerKnown(oPC, nPowerList, GetPowerRowID(nPowerList, nPower), TRUE, 1);
        SetKnownPowersModifier(oPC, nPowerList, GetKnownPowersModifier(oPC, nPowerList) + 1);
        SetPersistantLocalInt(oPC, sTag, TRUE);
    }
}

void main()
{
    object oPC = OBJECT_SELF;
    int nPowerTotal 	= 1;  //:: Can't have more than one Hidden Talent.
	int nClass 			= CLASS_TYPE_INVALID;
	int nPowerList 		= POWER_LIST_MISC;
	
    // Determine why this script is running
    if(GetRunningEvent() != EVENT_ONPLAYERLEVELDOWN)
    {
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_BIOFEEDBACK, POWER_BIOFEEDBACK, "PRC_HT_BiofeedbackGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_BITE_WOLF, POWER_BITE_WOLF, "PRC_HT_BiteOfTheWolfGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_BOLT, POWER_BOLT, "PRC_HT_BoltGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_BURST, POWER_BURST, "PRC_HT_BurstGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_CALLTOMIND, POWER_CALLTOMIND, "PRC_HT_CallToMindGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_CALL_WEAPONRY, POWER_CALL_WEAPONRY, "PRC_HT_CallWeaponryGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_CHAMELEON, POWER_CHAMELEON, "PRC_HT_ChameleonGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_CLAWS_BEAST, POWER_CLAWS_BEAST, "PRC_HT_ClawsOfTheBeastGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_COMPRESSION, POWER_COMPRESSION, "PRC_HT_CompressionGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_CONCEALTHOUGHT, POWER_CONCEALTHOUGHT, "PRC_HT_ConcealThoughtsGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_CREATESOUND, POWER_CREATESOUND, "PRC_HT_CreateSoundGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_CRYSTALSHARD, POWER_CRYSTALSHARD, "PRC_HT_CrystalShardGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_DAZE, POWER_DAZE, "PRC_HT_DazeGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_DECELERATION, POWER_DECELERATION, "PRC_HT_DecelerationGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_DEFPRECOG, POWER_DEFPRECOG, "PRC_HT_DefensivePrecognitionGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_DEMORALIZE, POWER_DEMORALIZE, "PRC_HT_DemoralizeGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_DISABLE, POWER_DISABLE, "PRC_HT_DisableGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_DISSIPATINGTOUCH, POWER_DISSIPATINGTOUCH, "PRC_HT_DissipatingTouchGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_DISTRACT, POWER_DISTRACT, "PRC_HT_DistractGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_ELFSIGHT, POWER_ELFSIGHT, "PRC_HT_ElfSightGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_EMPATHY, POWER_EMPATHY, "PRC_HT_EmpathyGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_EMPTYMIND, POWER_EMPTYMIND, "PRC_HT_EmptyMindGained");
      //GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_ENERGYRAY, POWER_ENERGYRAY, "PRC_HT_EnergyRayGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_ENTANGLE, POWER_ENTANGLE, "PRC_HT_EntangleGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_EXPANSION, POWER_EXPANSION, "PRC_HT_ExpansionGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_FARHAND, POWER_FARHAND, "PRC_HT_FarHandGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_FORCESCREEN, POWER_FORCESCREEN, "PRC_HT_ForceScreenGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_GREASE, POWER_GREASE, "PRC_HT_GreaseGained");
        GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_GRIP_IRON, POWER_GRIP_IRON, "PRC_HT_GripIronGained");
		GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_HAMMER, POWER_HAMMER, "PRC_HT_HammerGained");		
		GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_INERTIALARMOUR, POWER_INERTIALARMOUR, "PRC_HT_InertialArmourGained"); 
		GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_MATTERAGITATION, POWER_MATTERAGITATION, "PRC_HT_MatterAgitationGained");
		GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_METAPHYSICAL_CLAW, POWER_METAPHYSICAL_CLAW, "PRC_HT_MetaClawGained");
		GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_METAPHYSICAL_WEAPON, POWER_METAPHYSICAL_WEAPON, "PRC_HT_MetaWeaponGained");
		GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_MINDTHRUST, POWER_MINDTHRUST, "PRC_HT_MindThrustGained");
		GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_MYLIGHT, POWER_MYLIGHT, "PRC_HT_MyLightGained");
		GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_OFFPRECOG, POWER_OFFPRECOG, "PRC_HT_OffPrecogGained");
		GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_OFFPRESC, POWER_OFFPRESC, "PRC_HT_OffPrescGained");
		GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_PREVENOM, POWER_PREVENOM, "PRC_HT_PrevenomGained");
		GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_PREVENOM_WEAPON, POWER_PREVENOM_WEAPON, "PRC_HT_PrevenomWeaponGained");
		GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_SKATE, POWER_SKATE, "PRC_HT_SkateGained");
		GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_STOMP, POWER_STOMP, "PRC_HT_StompGained");
		GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_SYNESTHETE, POWER_SYNESTHETE, "PRC_HT_SynestheteGained");
		GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_TELEMPATHICPRO, POWER_TELEMPATHICPRO, "PRC_HT_TeleProjGained");
		GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_THICKSKIN, POWER_THICKSKIN, "PRC_HT_ThickSkinGained");
		GrantHiddenTalent(oPC, POWER_LIST_MISC, FEAT_HIDDEN_TALENT_VIGOR, POWER_VIGOR, "PRC_HT_VigorGained");		
    }

	else if(GetRunningEvent() == EVENT_ONPLAYERLEVELDOWN)
	{
		// Has lost Biofeedback, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_BiofeedbackGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_BIOFEEDBACK, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_BiofeedbackGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Bite of the Wolf, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_BiteOfTheWolfGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_BITE_WOLF, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_BiteOfTheWolfGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}     
		// Has lost Bolt, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_BoltGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_BOLT, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_BoltGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}  	
		// Has lost Burst, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_BurstGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_BURST, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_BurstGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Call to Mind, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_CallToMindGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_CALLTOMIND, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_CallToMindGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Call Weaponry, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_CallWeaponryGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_CALL_WEAPONRY, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_CallWeaponryGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Chameleon, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_ChameleonGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_CHAMELEON, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_ChameleonGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Claws of the Beast, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_ClawsOfTheBeastGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_CLAWS_BEAST, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_ClawsOfTheBeastGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Compression, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_CompressionGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_COMPRESSION, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_CompressionGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Conceal Thought, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_ConcealThoughtGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_CONCEALTHOUGHT, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_ConcealThoughtGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Create Sound, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_CreateSoundGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_CREATESOUND, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_CreateSoundGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Crystal Shard, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_CrystalShardGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_CRYSTALSHARD, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_CrystalShardGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Daze, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_DazeGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_DAZE, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_DazeGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Deceleration, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_DecelerationGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_DECELERATION, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_DecelerationGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Deflection Precognition, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_DeflectionPrecognitionGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_DEFPRECOG, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_DeflectionPrecognitionGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Demoralize, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_DemoralizeGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_DEMORALIZE, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_DemoralizeGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Disable, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_DisableGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_DISABLE, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_DisableGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Dissipating Touch, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_DissipatingTouchGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_DISSIPATINGTOUCH, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_DissipatingTouchGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Distract, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_DistractGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_DISTRACT, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_DistractGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Elf Sight, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_ElfSightGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_ELFSIGHT, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_ElfSightGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Empathy, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_EmpathyGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_EMPATHY, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_EmpathyGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Empty Mind, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_EmptyMindGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_EMPTYMIND, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_EmptyMindGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Energy Ray, but the slot is still present
 		if(GetPersistantLocalInt(oPC, "PRC_HT_EnergyRayGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_ENERGYRAY, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_EnergyRayGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Entangling Ectoplasm, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_EntangleEctoGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_ENTANGLE, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_EntangleEctoGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}		
		// Has lost Expansion, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_ExpansionGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_EXPANSION, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_ExpansionGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}	
		// Has lost Far Hand, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_FarHandGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_FARHAND, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_FarHandGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}	
		// Has lost Force Screen, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_ForceScreenGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_FORCESCREEN, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_ForceScreenGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}	
		// Has lost Grease, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_GreaseGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_GREASE, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_GreaseGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}			
		// Has lost Hammer, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_HammerGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_HAMMER, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_HammerGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}		
		// Has lost Inertial Armour, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_InertialArmourGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_INERTIALARMOUR, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_InertialArmourGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}			
		// Has lost Matter Agitation, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_MatterAgitationGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_MATTERAGITATION, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_MatterAgitationGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}	
		// Has lost Metaphysical Claw, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_MetaClawGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_METAPHYSICAL_CLAW, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_MetaClawGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}	
		// Has lost Metaphysical Weapon, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_MetaWeaponGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_METAPHYSICAL_WEAPON, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_MetaWeaponGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}	
		// Has lost Mind Thrust, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_MindThrustGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_MINDTHRUST, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_MindThrustGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}	
		// Has lost My Light, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_MyLightGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_MYLIGHT, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_MyLightGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}			
		// Has lost Precognition, Offensive, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_OffPrecogGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_OFFPRECOG, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_OffPrecogGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}			
		// Has lost Prescience, Offensive, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_OffPrescGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_OFFPRESC, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_OffPrescGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}	
		// Has lost Prevenom, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_PrevenomGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_PREVENOM, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_PrevenomGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}	
		// Has lost Prevenom Weapon, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_PrevenomWeaponGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_PREVENOM_WEAPON, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_PrevenomWeaponGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}		
		// Has lost Skate, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_SkateGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_SKATE, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_SkateGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}	
		// Has lost Stomp, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_StompGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_STOMP, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_StompGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}	
		// Has lost Synesthete, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_SynestheteGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_SYNESTHETE, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_SynestheteGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Telempathic Projection, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_TeleProjGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_TELEMPATHICPRO, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_TeleProjGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Thicken Skin, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_ThickSkinGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_THICKSKIN, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_ThickSkinGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}		
		// Has lost Vigor, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_VigorGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_VIGOR, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_VigorGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}
		// Has lost Grip of Iron, but the slot is still present
		if(GetPersistantLocalInt(oPC, "PRC_HT_GripIronGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_GRIP_IRON, oPC))
		{
			DeletePersistantLocalInt(oPC, "PRC_HT_GripIronGained");
			SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
		}		
		
	//:: Remove eventhook if the character no longer has any Hidden Talent feats
		if(!IsHiddenTalent())
			RemoveEventScript(oPC, EVENT_ONPLAYERLEVELDOWN, "psi_hiddentalent", TRUE, FALSE);
	}
}























/* #include "psi_inc_core"
#include "psi_inc_powknown"

int GetPowerRowID(int nPowerList, int nPower)
{
	string sPowerFile = GetAMSDefinitionFileName(nPowerList);
	int nCheck = -1;
	int i;
	for(i = 0; i < GetPRCSwitch(FILE_END_CLASS_POWER) ; i++)
	{
		nCheck = StringToInt(Get2DACache(sPowerFile, "RealSpellID", i));
		
		// Find the row ID of the power we need and return it
		if(nCheck == nPower)
		{
		    return i;
		}

	}
	// this should never trigger
	return -1;
}

void main()
{
    object oPC = OBJECT_SELF;
    int nPowerList = GetPrimaryPsionicClass(oPC);
    int nPowerTotal = GetKnownPowersModifier(oPC, nPowerList);

    // Determine why this script is running
    if(GetRunningEvent() == EVENT_ONPLAYERLEVELUP)
    {
        if (GetHasFeat(FEAT_HIDDEN_TALENT_BIOFEEDBACK, oPC) && !GetPersistantLocalInt(oPC, "PRC_HT_BiofeedbackGained"))
        {
            if(DEBUG) DoDebug("psi_hiddentalent: Adding Biofeedback");
            AddPowerKnown(oPC, nPowerList, GetPowerRowID(nPowerList, POWER_BIOFEEDBACK), TRUE, GetHitDice(oPC));
            SetKnownPowersModifier(oPC, nPowerList, ++nPowerTotal);
            SetPersistantLocalInt(oPC, "PRC_HT_BiofeedbackGained", TRUE);
        }     
        if (GetHasFeat(FEAT_HIDDEN_TALENT_BITE_WOLF, oPC) && !GetPersistantLocalInt(oPC, "PRC_HT_BiteOfTheWolfGained"))
        {
            if(DEBUG) DoDebug("psi_hiddentalent: Adding Bite of the Wolf");
            AddPowerKnown(oPC, nPowerList, GetPowerRowID(nPowerList, POWER_BITEWOLF), TRUE, GetHitDice(oPC));
            SetKnownPowersModifier(oPC, nPowerList, ++nPowerTotal);
            SetPersistantLocalInt(oPC, "PRC_HT_BiteOfTheWolfGained", TRUE);
        }		
		if (GetHasFeat(FEAT_HIDDEN_TALENT_BOLT, oPC) && !GetPersistantLocalInt(oPC, "PRC_HT_BoltGained"))
        {
            if(DEBUG) DoDebug("psi_hiddentalent: Adding Bolt");
            AddPowerKnown(oPC, nPowerList, GetPowerRowID(nPowerList, POWER_BOLT), TRUE, GetHitDice(oPC));
            SetKnownPowersModifier(oPC, nPowerList, ++nPowerTotal);
            SetPersistantLocalInt(oPC, "PRC_HT_BoltGained", TRUE);
        }
        if (GetHasFeat(FEAT_HIDDEN_TALENT_BURST, oPC) && !GetPersistantLocalInt(oPC, "PRC_HT_BurstGained"))
        {
            if(DEBUG) DoDebug("psi_hiddentalent: Adding Burst");
            AddPowerKnown(oPC, nPowerList, GetPowerRowID(nPowerList, POWER_BURST), TRUE, GetHitDice(oPC));
            SetKnownPowersModifier(oPC, nPowerList, ++nPowerTotal);
            SetPersistantLocalInt(oPC, "PRC_HT_BurstGained", TRUE);
        }
        if (GetHasFeat(FEAT_HIDDEN_TALENT_CALLTOMIND, oPC) && !GetPersistantLocalInt(oPC, "PRC_HT_CallToMindGained"))
        {
            if(DEBUG) DoDebug("psi_hiddentalent: Adding Call To Mind");
            AddPowerKnown(oPC, nPowerList, GetPowerRowID(nPowerList, POWER_CALLTOMIND), TRUE, GetHitDice(oPC));
            SetKnownPowersModifier(oPC, nPowerList, ++nPowerTotal);
            SetPersistantLocalInt(oPC, "PRC_HT_CallToMindGained", TRUE);
        }




    // Hook to OnLevelDown to remove the power slots granted here
        AddEventScript(oPC, EVENT_ONPLAYERLEVELDOWN, "psi_hiddentalent", TRUE, FALSE);
    }
    else if(GetRunningEvent() == EVENT_ONPLAYERLEVELDOWN)
    {
        // Has lost Biofeedback, but the slot is still present
        if(GetPersistantLocalInt(oPC, "PRC_HT_BiofeedbackGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_BIOFEEDBACK, oPC))
        {
            DeletePersistantLocalInt(oPC, "PRC_HT_BiofeedbackGained");
            SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
        }
        // Has lost Bolt, but the slot is still present
        if(GetPersistantLocalInt(oPC, "PRC_HT_BiteOfTheWolfGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_BITE_WOLF, oPC))
        {
            DeletePersistantLocalInt(oPC, "PRC_HT_BiteOfTheWolfGained");
            SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
        }     
        // Has lost Bolt, but the slot is still present
        if(GetPersistantLocalInt(oPC, "PRC_HT_BoltGained") && !GetHasFeat(FEAT_HIDDEN_TALENT_BOLT, oPC))
        {
            DeletePersistantLocalInt(oPC, "PRC_HT_BoltGained");
            SetKnownPowersModifier(oPC, nPowerList, --nPowerTotal);
        }  		

        // Remove eventhook if the character no longer has any Hidden Talent feats
        if(!IsHiddenTalent)
            RemoveEventScript(oPC, EVENT_ONPLAYERLEVELDOWN, "psi_hiddentalent", TRUE, FALSE);
    }
} */