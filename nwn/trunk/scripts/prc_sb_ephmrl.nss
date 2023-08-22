/*
01/03/19 by Stratovarius

Ephemeral Weapon

2d6 damage
*/

#include "prc_inc_combat"

void main()
{
    object oShadow = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    
    effect eNone;
    PerformAttackRound(oTarget, oShadow, eNone, 0.0, 0, d6(2), DAMAGE_TYPE_MAGICAL, FALSE, "Ephemeral Weapon Hit", "Ephemeral Weapon Miss"); 
    
    DecrementRemainingFeatUses(oShadow, FEAT_UNERRING_STRIKE);
    DecrementRemainingFeatUses(oShadow, FEAT_UNEXPECTED_STRIKE);
    DecrementRemainingFeatUses(oShadow, FEAT_SHADOWY_STRIKE);
    DecrementRemainingFeatUses(oShadow, FEAT_FAR_SHADOW);    
}