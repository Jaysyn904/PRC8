/*
   ----------------
   Diamond Nightmare Blade

   tob_dmnd_dmndbld
   ----------------

   04/09/2007 by Tenjac
*/ /** @file

    Diamond Nightmare Blade

    Diamond Mind (Strike)
    Level: Swordsage 8, Warblade 8
    Prerequisite: Three Diamond Mind Maneuvers
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    With a moment's thought, you instantly perceive the deadliest place to strike your enemy
    as you study her defences, note gaps in her armour, and read subtle but important clues
    in how she carries herself or maintains her fighting stance.
    
    You make a Concentration check against the target's AC. If you succeed, the target
    takes quadruple normal damage. If you fail, you take a -2 penalty on the attack.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

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
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
        effect eNone;
        int nDC = GetDefenderAC(oTarget, oInitiator);		
        int nAB = -2;
        if (GetIsSkillSuccessful(oInitiator, SKILL_CONCENTRATION, nDC))
        {
            nAB = 0;
        	SetLocalInt(oTarget, "NightmareBlade", 4);
        }
      	if (GetLocalInt(oInitiator, "SupernalAttack")) nAB += 1;
        DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, nAB, 0, 0, "Diamond Nightmare Blade Hit", "Diamond Nightmare Blade Miss"));
        DelayCommand(1.0, DeleteLocalInt(oTarget, "NightmareBlade"));
    }
}