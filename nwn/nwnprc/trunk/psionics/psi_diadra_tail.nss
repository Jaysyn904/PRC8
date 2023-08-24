//::///////////////////////////////////////////////
//:: Channel Dragon Tail feat for Diamond Dragon
//:: psi_diadra_tail.nss
//::///////////////////////////////////////////////
/*
    Handles the Channel Dragon Tail for the Diamond Dragon prestige class.
    Since it acts like a power, it uses the psionics system and constants.
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 15, 2007
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"
#include "prc_inc_natweap"
#include "prc_alterations"


//removes wings at the end of the power
void RemoveTail(object oPC, int nTailCounter)
{
    if(GetPersistantLocalInt(oPC, "ChannelingTail") == nTailCounter)
    {
        SetPersistantLocalInt(oPC, "ChannelingTail", FALSE);
        SetCreatureTailType(CREATURE_TAIL_TYPE_NONE, oPC);
    }
}

//internal function to handle turning the wings on and off
void ChannelTail(object oPC, float fDuration)
{
    //already has tail, keep it
    if(GetCreatureTailType(oPC) != CREATURE_TAIL_TYPE_NONE) 
        return;   
    //otherwise grant tail
    SetCreatureTailType(PRC_TAIL_TYPE_DRAGON_SILVER, oPC);
    int nTailCounter = GetPersistantLocalInt(oPC, "ChannelingTail");
    if(nTailCounter > 9) nTailCounter = 0;
    SetPersistantLocalInt(oPC, "ChannelingTail", nTailCounter + 1);
    
    //set up tail removal after power expiration
    DelayCommand(fDuration, RemoveTail(oPC, nTailCounter + 1));
}


void main()
{

    object oManifester = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateDiaDragChannel(oManifester, OBJECT_INVALID,
                              PowerAugmentationProfile(2,
                                                       2, 5 //Augmentation only up to +5
                                                       ),
                              5 //Acts as a Level 5 Power for PP cost
                              );

    if(manif.bCanManifest)
    {
        // Set up some data
        int nTailSize             = PRCGetCreatureSize(oTarget);
        int nBaseDamage;
        int nEnhancement          = manif.nTimesAugOptUsed_1;
        effect eVis               = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
        effect eDur               = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        float fDuration           = 60.0f * manif.nManifesterLevel;

        
        // Do VFX
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        DelayCommand(2.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration, FALSE);
        
        //add the claws to the Natural Attack system
        string sResRef;        
        switch(nEnhancement)
        {
            case 0: sResRef = "prc_diatail_0_"; break;
            case 1: sResRef = "prc_diatail_1_"; break;
            case 2: sResRef = "prc_diatail_2_"; break;
            case 3: sResRef = "prc_diatail_3_"; break;
            case 4: sResRef = "prc_diatail_4_"; break;
            case 5: sResRef = "prc_diatail_5_"; break;       
        }
        sResRef += GetAffixForSize(PRCGetCreatureSize(oTarget));
        
        AddNaturalSecondaryWeapon(oTarget, sResRef);
        DelayCommand(6.0f, 
            NaturalSecondaryWeaponTempCheck(oManifester, oTarget, manif.nSpellID, FloatToInt(fDuration) / 6, sResRef));
        
        //Add a lizard tail if no tail exists already    
        ChannelTail(oTarget, fDuration);
            
        
    }// end if - Successfull manifestation
}