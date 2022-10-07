//////////////////////////////////////////////////////
// Sacred Vengeance
// prc_sac_veng.nss
//////////////////////////////////////////////////////
/** @file SACRED VENGEANCE [DIVINE]
You can channel energy to deal extra damage against undead in melee.
Prerequisite: Ability to turn undead.
Benefit: As a free action, spend one of your turn undead
attempts to add 2d6 points of damage to all your successful melee
attacks against undead until the end of the current round.
*/
////////////////////////////////////////////////////////
// Tenjac 5/15/08
////////////////////////////////////////////////////////

#include "prc_alterations"

void main()
{
        object oPC = OBJECT_SELF;
        
        if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
        {
                SendMessageToPC(oPC, "You must be able to Turn Undead to use this feat.");
                return;
        }
        
        if(!GetHasFeat(FEAT_TURN_UNDEAD, oPC))
        {
                SendMessageToPC(oPC, "You have no remaining uses of Turn Undead");
                return;
        }
        
        DecrementRemainingFeatUses(oPC, FEAT_TURN_UNDEAD);
        
        effect eBonus = VersusRacialTypeEffect(EffectDamageIncrease(DAMAGE_BONUS_2d6, DAMAGE_TYPE_DIVINE) ,RACIAL_TYPE_UNDEAD);
               eBonus = EffectLinkEffects(eBonus, EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS));
               
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, 6.0f);
}  