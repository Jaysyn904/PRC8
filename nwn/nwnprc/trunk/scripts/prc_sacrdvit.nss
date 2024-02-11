//////////////////////////////////////////////////////////////////////////////////
// Sacred Vitality
// prc_sacrvit.nss
//////////////////////////////////////////////////////////////////////////////////
/** @file Sacred Vitality [Divine]
Prerequisite: Ability to turn undead.
Benefit: As a standard action, you can spend one of your turning attempts to gain 
immunity to ability damage, ability drain, and energy drain for 1 minute.
*/
//////////////////////////////////////////////////////////////////////////////////
// Author: Tenjac
// Created: 4/22/08
//////////////////////////////////////////////////////////////////////////////////

#include "prc_alterations"

void main()
{
        object oPC = OBJECT_SELF;
        
        if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
        {
                SendMessageToPC(oPC, "You must be able to Turn Undead to use this feat.");
                return;
        }
             
        if(GetHasFeat(FEAT_TURN_UNDEAD, oPC))
        {
                DecrementRemainingFeatUses(oPC, FEAT_TURN_UNDEAD);
                
                effect eLink = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL), EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
                eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR));
                
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(1));
        }
}                