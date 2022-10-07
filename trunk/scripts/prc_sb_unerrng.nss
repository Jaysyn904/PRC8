/*
01/03/19 by Stratovarius

Unerring Strike

Ignore Concealment
*/

#include "prc_inc_combat"

void main()
{
    object oShadow = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    
    SetLocalInt(oShadow, "PRC_SB_UNERRING", TRUE);
    effect eNone;
    PerformAttackRound(oTarget, oShadow, eNone, 0.0, 0, 0, 0, FALSE, "Unerring Strike Hit", "Unerring Strike Miss");    
    DelayCommand(0.2, DeleteLocalInt(oShadow, "PRC_SB_UNERRING"));
    
    DecrementRemainingFeatUses(oShadow, FEAT_UNEXPECTED_STRIKE);
    DecrementRemainingFeatUses(oShadow, FEAT_EPHEMERAL_WEAPON);
    DecrementRemainingFeatUses(oShadow, FEAT_SHADOWY_STRIKE);
    DecrementRemainingFeatUses(oShadow, FEAT_FAR_SHADOW);
}