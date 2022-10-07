/*
01/03/19 by Stratovarius

Far Shadow

+10ft reach
*/

#include "prc_inc_combat"

void main()
{
    object oShadow = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    
    SetLocalInt(oShadow, "PRC_SB_FARSHAD", TRUE);
    effect eNone;
    PerformAttackRound(oTarget, oShadow, eNone, 0.0, 0, 0, 0, FALSE, "Far Shadow Hit", "Far Shadow Miss");    
    DelayCommand(6.0, DeleteLocalInt(oShadow, "PRC_SB_FARSHAD"));

    DecrementRemainingFeatUses(oShadow, FEAT_UNERRING_STRIKE);
    DecrementRemainingFeatUses(oShadow, FEAT_UNEXPECTED_STRIKE);
    DecrementRemainingFeatUses(oShadow, FEAT_EPHEMERAL_WEAPON);
    DecrementRemainingFeatUses(oShadow, FEAT_SHADOWY_STRIKE);
}