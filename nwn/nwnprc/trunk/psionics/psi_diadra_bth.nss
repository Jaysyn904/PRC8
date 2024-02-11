//::///////////////////////////////////////////////
//:: Psionic Breath Weapon feats for Diamond Dragon
//:: psi_diadra_bth.nss
//::///////////////////////////////////////////////
/*
    Handles the breath weapon for the Diamond Dragon prestige class.
    Since it acts like a power, it uses the psionics system ro handle 
    the costs, and the breath include to resolve the damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 14, 2007
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"
#include "prc_inc_spells"
#include "psi_inc_enrgypow"
#include "prc_inc_breath"


void main()
{

    object oManifester = OBJECT_SELF;
    struct manifestation manif =
        EvaluateDiaDragChannel(oManifester, OBJECT_INVALID,
                              PowerAugmentationProfile(1,
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              3 //Acts as a Level 3 Power in regards to PP cost
                              );

    if(manif.bCanManifest)
    {
        struct energy_adjustments enAdj =
            EvaluateEnergy(manif.nSpellID, POWER_DIADRAG_BREATH_COLD, POWER_DIADRAG_BREATH_ELEC, 
                           POWER_DIADRAG_BREATH_FIRE, POWER_DIADRAG_BREATH_SONIC,
                           VFX_IMP_FROST_L, VFX_IMP_LIGHTNING_S, VFX_IMP_FLAME_M, VFX_IMP_SONIC);
                           
        int nDCBoost         = GetLevelByClass(CLASS_TYPE_DIAMOND_DRAGON, oManifester) + enAdj.nDCMod;
        int nNumberOfDice    = 5 + manif.nTimesAugOptUsed_1;
        location lTarget     = PRCGetSpellTargetLocation();
        
        //create the breath
        struct breath DiamondBreath = 
            CreateBreath(oManifester, FALSE, 30.0, enAdj.nDamageType, 6, nNumberOfDice, ABILITY_INTELLIGENCE, nDCBoost, BREATH_NORMAL, 0);
        
        //adjust for electric line
        if(enAdj.nSaveType == SAVING_THROW_TYPE_ELECTRICITY)
        {
            DiamondBreath.bLine = TRUE;
            DiamondBreath.fRange = 60.0;
        }
        
        if(enAdj.nSaveType == SAVING_THROW_TYPE_COLD)
            DiamondBreath.nSaveUsed = SAVING_THROW_FORT;
        
        //resolve the breath
        ApplyBreath(DiamondBreath, lTarget);

    }// end if - Successfull manifestation
}
