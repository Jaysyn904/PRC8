/*
    ----------------
    Step of the Dancing Moth

    tob_sdhd_moth
    ----------------

    12/09/18 by Stratovarius

    Step of the Dancing Moth

    Shadow Hand (Stance)
    Level: Swordsage 5
    Prerequisite: Two Shadow Hand maneuvers
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    Duration: Stance

    You focus your inner reserve of ki energy to generate flowing shadows that lift you off the ground. You walk across the roughest ground, even water, with ease.
    
    You take a 33% penalty to speed, but are immune to all other movement penalties. You gain a bonus on Hide and Move Silently equal to your initiator level
*/

#include "tob_inc_move"
#include "tob_movehook"
#include "x0_i0_modes"

void main()
{
    if(!PreManeuverCastCode()) return;

    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
        int nInitiatorLevel  = GetInitiatorLevel(oInitiator);
        effect eLink = EffectVisualEffect(PSI_DUR_SHADOW_BODY);
               eLink = EffectLinkEffects(eLink, EffectMovementSpeedDecrease(33));
               eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
               eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SLOW));
               eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE));
               eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE));
               eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE));
               eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_HIDE, nInitiatorLevel));
               eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_MOVE_SILENTLY, nInitiatorLevel));
               
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
        AssignCommand(oInitiator, ClearAllActions());
        DelayCommand(0.2, SetActionMode(oInitiator, ACTION_MODE_STEALTH, TRUE));
        DelayCommand(0.21, UseStealthMode());
        DelayCommand(0.2, ActionUseSkill(SKILL_HIDE, oInitiator));
        DelayCommand(0.2, ActionUseSkill(SKILL_MOVE_SILENTLY, oInitiator));
    }
}