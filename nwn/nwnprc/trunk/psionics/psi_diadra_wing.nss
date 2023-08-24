//::///////////////////////////////////////////////
//:: Channel Dragon Wings feat for Diamond Dragon
//:: psi_diadra_wing.nss
//::///////////////////////////////////////////////
/*
    Handles the wing channeling for the Diamond Dragon prestige class.
    Since it acts like a power, it uses the psionics system and constants.
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 15, 2007
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"
#include "prc_alterations"

//removes wings at the end of the power
void RemoveWings(object oPC, int nWingCounter)
{
    if(GetPersistantLocalInt(oPC, "ChannelingWings") == nWingCounter)
    {
        SetPersistantLocalInt(oPC, "ChannelingWings", FALSE);
        SetCreatureWingType(CREATURE_WING_TYPE_NONE, oPC);
    }
}

//internal function to handle turning the wings on and off
void ChannelWings(object oPC, float fDuration)
{
    //already has wings, keep them
    if(GetCreatureWingType(oPC) != CREATURE_WING_TYPE_NONE) 
        return;   
    //otherwise grant wings
    SetCreatureWingType(PRC_WING_TYPE_DRAGON_SILVER, oPC);
    int nWingCounter = GetPersistantLocalInt(oPC, "ChannelingWings");
    if(nWingCounter > 9) nWingCounter = 0;
    SetPersistantLocalInt(oPC, "ChannelingWings", nWingCounter + 1);
    
    //set up wing removal after power expiration
    DelayCommand(fDuration, RemoveWings(oPC, nWingCounter + 1));
}

void main()
{

    object oManifester = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateDiaDragChannel(oManifester, OBJECT_INVALID,
                              PowerAugmentationProfile(),
                              4 //Acts as a Level 4 Power for PP cost
                              );

    if(manif.bCanManifest)
    {
        effect eLink = SupernaturalEffect(EffectSkillIncrease(SKILL_JUMP, 10));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        float fDur = 60.0f * manif.nManifesterLevel;

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur, TRUE, -1, manif.nManifesterLevel);
        
        ChannelWings(oManifester, fDur);
            
    }// end if - Successfull manifestation
}
