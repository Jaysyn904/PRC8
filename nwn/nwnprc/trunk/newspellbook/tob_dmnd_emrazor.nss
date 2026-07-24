/*
   ----------------
   Emerald Razor

   tob_dmnd_emrazor.nss
   ----------------

    06/06/07 by Stratovarius
*/ /** @file

    Emerald Razor

    Diamond Mind (Strike)
    Level: Swordsage 2, Warblade 2
    Prerequisite: One Diamond Mind maneuver
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature.
    
    You stare at your enemy, studying his every move. You mentally
    probe his defenses in search of a weakness. A lesser warrior could
    spend long minutes pondering this problem, but you see an opening
    and seize upon it in an instant.
    
    You make a single melee attack as a touch attack.
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
	    int nAB = 0;
    	if (GetLocalInt(oInitiator, "SupernalAttack")) nAB += 1;    	
		DelayCommand(0.0, PerformAttack(oTarget, oInitiator, EffectVisualEffect(VFX_IMP_DOMINATE_S), 0.0, nAB, 0, 0, "Emerald Razor Hit", "Emerald Razor Miss", TRUE));
    }
}