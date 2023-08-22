//::///////////////////////////////////////////////
//:: Channel Dragon Claws feat for Diamond Dragon
//:: psi_diadra_claw.nss
//::///////////////////////////////////////////////
/*
    Handles the Channel Dragon Claws for the Diamond Dragon prestige class.
    Since it acts like a power, it uses the psionics system and constants.
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 15, 2007
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"
#include "prc_inc_natweap"


void main()
{

    object oManifester = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateDiaDragChannel(oManifester, OBJECT_INVALID,
                              PowerAugmentationProfile(2,
                                                       2, 5 //Augmentation only up to +5
                                                       ),
                              1 //Acts as a Level 1 Power for PP cost
                              );

    if(manif.bCanManifest)
    {
        // Set up some data
        int nClawSize             = PRCGetCreatureSize(oTarget);
        int nBaseDamage;
        int nEnhancement          = manif.nTimesAugOptUsed_1;
        effect eVis               = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
        effect eDur               = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        object oLClaw, oRClaw;
        float fDuration           = 60.0f * manif.nManifesterLevel;

        // Determine base damage
        switch(nClawSize)
        {
            case 1: nBaseDamage = IP_CONST_MONSTERDAMAGE_1d3; break;
            case 2: nBaseDamage = IP_CONST_MONSTERDAMAGE_1d4; break;
            case 3: nBaseDamage = IP_CONST_MONSTERDAMAGE_1d6; break;
            case 4: nBaseDamage = IP_CONST_MONSTERDAMAGE_1d8; break;
            case 5: nBaseDamage = IP_CONST_MONSTERDAMAGE_2d6; break;
            case 6: nBaseDamage = IP_CONST_MONSTERDAMAGE_3d6; break;
            case 7: nBaseDamage = IP_CONST_MONSTERDAMAGE_4d6; break;

            /*default:{
                string sErr = "psi_pow_clwbeast: ERROR: Unknown nClawSize value: " + IntToString(nClawSize);
                if(DEBUG) DoDebug(sErr);
                else      WriteTimestampedLogEntry(sErr);
            }*/
        }
        // Catch exceptions here
        if (nClawSize < 0) nBaseDamage = IP_CONST_MONSTERDAMAGE_1d3;
        else if (nClawSize > 7) nBaseDamage = IP_CONST_MONSTERDAMAGE_4d6;

        // Create the creature weapon
        oLClaw = GetPsionicCreatureWeapon(oTarget, "PRC_UNARMED_SP", INVENTORY_SLOT_CWEAPON_L, fDuration);
        oRClaw = GetPsionicCreatureWeapon(oTarget, "PRC_UNARMED_SP", INVENTORY_SLOT_CWEAPON_R, fDuration);

        // Add the base damage
        AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyMonsterDamage(nBaseDamage), oLClaw, fDuration);
        AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyMonsterDamage(nBaseDamage), oRClaw, fDuration);
        
        //Add the enhancement
        AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonus(nEnhancement), oLClaw, fDuration);
        AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonus(nEnhancement), oRClaw, fDuration);

        // Do VFX
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        DelayCommand(2.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration, FALSE);
        
        //add the claws to the Natural Attack system
        string sResRef;        
        switch(nEnhancement)
        {
            case 0: sResRef = "prc_diaclaw_0_"; break;
            case 1: sResRef = "prc_diaclaw_1_"; break;
            case 2: sResRef = "prc_diaclaw_2_"; break;
            case 3: sResRef = "prc_diaclaw_3_"; break;
            case 4: sResRef = "prc_diaclaw_4_"; break;
            case 5: sResRef = "prc_diaclaw_5_"; break;       
        }
        sResRef += GetAffixForSize(PRCGetCreatureSize(oTarget));
        
        AddNaturalPrimaryWeapon(oTarget, sResRef, 2, TRUE);
        //activate Clawswipe in Psi Spellhook
        SetLocalInt(oManifester, "DiamondClawsOn", TRUE); 
        //Set up claws to expire at end of power
        DelayCommand(6.0f, 
            NaturalPrimaryWeaponTempCheck(oManifester, oTarget, manif.nSpellID, FloatToInt(fDuration) / 6, sResRef));
        //set clawswipe to turn off when power expires
        DelayCommand(fDuration, DeleteLocalInt(oManifester, "DiamondClawsOn"));
            
        
    }// end if - Successfull manifestation
}