/*
01/03/19 by Stratovarius

Shadowy Strike

Touch attack
*/

#include "prc_inc_combat"

void main()
{
    object oShadow = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    
    effect eNone;
    PerformAttackRound(oTarget, oShadow, eNone, 0.0, 0, 0, 0, FALSE, "Shadowy Strike Hit", "Shadowy Strike Miss", FALSE, TOUCH_ATTACK_MELEE);    

    DecrementRemainingFeatUses(oShadow, FEAT_UNERRING_STRIKE);
    DecrementRemainingFeatUses(oShadow, FEAT_UNEXPECTED_STRIKE);
    DecrementRemainingFeatUses(oShadow, FEAT_EPHEMERAL_WEAPON);
    DecrementRemainingFeatUses(oShadow, FEAT_FAR_SHADOW);
}
