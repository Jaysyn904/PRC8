//////////////////////////////////////////////////
//  Avalanche of Blades
//  tob_dmnd_avlvld.nss
//  Tenjac  9/28/07
//////////////////////////////////////////////////
/** @file Avalanche of Blades
Diamond Mind (Strike)
Level: Swordsage 7, warblade 7
Prerequisite: Three Diamond Mind maneuvers
Initiation Action: 1 full-round action
Range: Melee attack
Target: One creature

In a flashing blur of steel, you unleash a devastating volley of deadly 
attacks against your enemy, striking it again and again.

You lash at an opponent. If your attack hits, you can repeat the same 
attack again and again at nearly superhuman speed, allowing you to score
multiple hits in a blur of activity. Unfortunately, as soon as an attack
misses, your tempo breaks, and this delicate maneuver crumbles into a 
flurry of wasted motion.

As part of this maneuver, you make a single melee attack against an 
opponent. If that attack hits, resolve your damage as normal. You can then
make another attack against that foe with a -4 penalty on your attack roll.
If that attack hits, you can make another attack against that opponent with
a -8 penalty. You continue to make additional attacks, each one with an
additional -4 penalty, until you miss or your opponent is reduced to -1 hp
or fewer. You must direct all of these attacks at a single foe.
*/

void Owieowieowowow(object oInitiator, object oTarget, int nHit, int nPenalty);

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
            int nHit = 1;
        	int nPenalty = 0;
            DelayCommand(0.1, Owieowieowowow(oInitiator, oTarget, nHit, nPenalty));			
        }
}

void Owieowieowowow(object oInitiator, object oTarget, int nHit, int nPenalty)
{
    if (GetLocalInt(oInitiator, "SupernalAttack")) nPenalty += 1;

    if (nHit == 1)
    {
        effect eNone;
        PerformAttack(oTarget, oInitiator, eNone, 0.0, nPenalty, 0, 0, "Avalanche of Blades Hit", "Avalanche of Blades Miss");

        // Check result of attack
        if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
        {
            nPenalty -= 4;
            if (GetLocalInt(oInitiator, "SupernalAttack")) nPenalty -= 1;
            
            // Continue the loop only on hit
            DelayCommand(0.1, Owieowieowowow(oInitiator, oTarget, 1, nPenalty));
			
			DelayCommand(3.0, DeleteLocalInt(oTarget, "PRCCombat_StruckByAttack"));
        }
        // No else block: if the attack missed, don't queue another call
    }
}



/* void Owieowieowowow(object oInitiator, object oTarget, int nHit, int nPenalty)
{
	    if (GetLocalInt(oInitiator, "SupernalAttack")) nPenalty += 1;
        if(nHit == 1)
        {
        	effect eNone;
            PerformAttack(oTarget, oInitiator, eNone, 0.0, nPenalty, 0, 0, "Avalanche of Blades Hit", "Avalanche of Blades Miss");
                
            if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack")) nHit = 1;
            else
            	nHit = 0;
                
            nPenalty -= 4;
            // Make sure the bonus doesn't get passed around
    		if (GetLocalInt(oInitiator, "SupernalAttack")) nPenalty -= 1;
            //Again! Again!
            DelayCommand(0.1, Owieowieowowow(oInitiator, oTarget, nHit, nPenalty));
        }
}  */         