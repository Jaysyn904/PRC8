/*
01/03/19 by Stratovarius

Unexpected Strike

Denied Dex
*/

#include "prc_inc_combat"

void main()
{
    object oShadow = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    
    SetLocalInt(oShadow, "PRC_SB_UNEXPECTED", TRUE);
    effect eNone;
    PerformAttackRound(oTarget, oShadow, eNone, 0.0, 0, 0, 0, FALSE, "Unexpected Strike Hit", "Unexpected Strike Miss");    
    DelayCommand(0.2, DeleteLocalInt(oShadow, "PRC_SB_UNEXPECTED"));
    
    DecrementRemainingFeatUses(oShadow, FEAT_UNERRING_STRIKE);
    DecrementRemainingFeatUses(oShadow, FEAT_EPHEMERAL_WEAPON);
    DecrementRemainingFeatUses(oShadow, FEAT_SHADOWY_STRIKE);
    DecrementRemainingFeatUses(oShadow, FEAT_FAR_SHADOW);    
}