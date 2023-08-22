//::///////////////////////////////////////////////
//:: Psionic Dragonfear
//:: psi_diadra_aura.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the player
    must make a will save or be struck with fear because
    of the creatures presence.
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 15, 2007
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "psi_inc_psifunc"

void main()
{
    object oManifester = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateDiaDragChannel(oManifester, OBJECT_INVALID,
                              PowerAugmentationProfile(1,
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              6 //Acts as a Level 6 Power for PP cost
                              );

    if(manif.bCanManifest)
    {
        int AOESize = AOE_MOB_DRAGON_FEAR;
        float fDuration = 30.0f + 6.0f * manif.nTimesAugOptUsed_1;

        if(DEBUG) SendMessageToPC(OBJECT_SELF," Size" +IntToString(AOESize));
        //Set and apply AOE object
        effect eAOE = SupernaturalEffect(EffectAreaOfEffect(AOESize,"psi_diadra_afear"));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, fDuration);
    }//end manifestation
}
