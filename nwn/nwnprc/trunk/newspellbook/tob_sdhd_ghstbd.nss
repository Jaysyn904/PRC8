//////////////////////////////////////////////////
// Ghost Blade
// tob_sdhd_ghstbd.nss
// Tenjac   12/12/07
//////////////////////////////////////////////////
/** @file Ghost Blade
Shadow Hand (Strike)
Level: Swordsage 6
Prerequisite: Three Shadow Hand maneuvers
Initiation Action: 1 standard action
Range: Melee attack
Target: One creature

A smile brightens your foe’s eyes; he has dodged your blow. But that was merely the ghost blade. 
The real blade is cutting swiftly from underneath, and yet he still smiles.

As part of this maneuver, you make a melee attack. As you strike at your opponent, you create an 
illusory double of your weapon. This double slashes at your opponent, tricking him into mistaking 
it for your attack. In truth, the illusion cloaks your real attack. Your opponent is caught flat-
footed against this strike, as the hidden attack from a new direction ruins his defenses.

This maneuver is a supernatural ability.

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
        effect eNone;
        
        if(move.bCanManeuver)
        {
                AssignCommand(oTarget, ClearAllActions(TRUE));
                
                DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Ghost Blade Hit", "Ghost Blade Miss"));
        }
}