//////////////////////////////////////////////////
// Stalker in the Night
// tob_sdhd_stalker.nss
// Stratovarius   30/09/18
//////////////////////////////////////////////////
/** @file Stalker in the Night
Shadow Hand (Strike)
Level: Swordsage 6
Prerequisite: None
Initiation Action: 1 standard action
Range: Melee attack
Target: One creature

You slide through the dark like a bird of prey, emerging only to strike down your foe before sliding back into shadow's welcoming embrace.

Choose a location up a medium distance away. The first enemy along that path is struck by a single melee attack. You automatically hide at the end of the attack.
*/

#include "tob_inc_move"
#include "tob_movehook"
#include "x0_i0_modes"

void DoSneak(object oInitiator, location lTarget)
{
    // Move the PC to the location
    AssignCommand(oInitiator, ClearAllActions(TRUE));
    AssignCommand(oInitiator, JumpToLocation(lTarget));
    AssignCommand(oInitiator, ClearAllActions());
    SetActionMode(oInitiator, ACTION_MODE_STEALTH, TRUE);
    UseStealthMode();
    ActionUseSkill(SKILL_HIDE, oInitiator);
    ActionUseSkill(SKILL_MOVE_SILENTLY, oInitiator);    
}

void DoAttack(object oTarget, object oInitiator, location lTarget)
{
    // Move the PC to the location
    AssignCommand(oInitiator, ClearAllActions(TRUE));
    AssignCommand(oInitiator, JumpToLocation(GetLocation(oTarget)));
    effect eNone;
    PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Stalker in the Night Hit", "Stalker in the Night Miss");
    DelayCommand(0.1, DoSneak(oInitiator, lTarget));
}

void DoStalker(object oInitiator, location lTarget)
{
    vector vOrigin = GetPosition(oInitiator);
    int nContinue = TRUE;

    // Find a target
    object oTarget = MyFirstObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget, TRUE, OBJECT_TYPE_CREATURE, vOrigin); 
    while(GetIsObjectValid(oTarget) && nContinue) // Find the targets
    {
        if(oTarget != oInitiator && GetIsEnemy(oTarget, oInitiator)) // Don't overrun friends or yourself
        {
            DelayCommand(0.0, DoAttack(oTarget, oInitiator, lTarget));
        }// end if - Target validity check
    // Get next target
    oTarget = MyNextObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget, TRUE, OBJECT_TYPE_CREATURE, vOrigin);
    }// end while - Target loop  
}

void main()
{
    if (!PreManeuverCastCode())
    {
        // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    // End of Spell Cast Hook
    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    location lTarget     = PRCGetSpellTargetLocation();
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);
    
    if(move.bCanManeuver)
    {
        DoStalker(oInitiator, lTarget);
    }
}


