/*
02/03/21 by Stratovarius

Paimon, the Dancer
  
Granted Abilities: 
Paimon gives you the ability to dance in and out of combat, and to make whirling attacks against multiple foes.

Dance of Death: When you use this ability as a standard action, you move up to your speed in a line and make a single attack against any creature you move 
past, provoking attacks of opportunity normally. Once you have used this ability, you cannot do so again for 5 rounds.
*/

#include "bnd_inc_bndfunc"
#include "prc_inc_combat"

void main()
{
    //Declare major variables
    object oBinder = OBJECT_SELF;
    if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_PAIMON)) return;
    object oTarget = PRCGetSpellTargetObject();
    location lTarget = PRCGetSpellTargetLocation();
    effect eDummy;

    effect eCharge = SupernaturalEffect(EffectMovementSpeedIncrease(99)); // Just to speed things up a bit
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharge, oBinder, 5.0);
    float fLength = GetDistanceBetweenLocations(GetLocation(oBinder), lTarget);
    vector vOrigin = GetPosition(oBinder);
       
    // Step one is check to see if we're using oTarget or not
    if (GetIsObjectValid(oTarget))
    {
        lTarget = GetLocation(oTarget);
        fLength = GetDistanceBetweenLocations(GetLocation(oBinder), lTarget);
        if (DEBUG) FloatingTextStringOnCreature("Paimon Dance of Death: Valid Target", oBinder, FALSE);
    }
    else
        oTarget = MyFirstObjectInShape(SHAPE_SPELLCYLINDER, fLength, lTarget, TRUE, OBJECT_TYPE_CREATURE, vOrigin); // Only change targets if invalid

    // Move the PC to the location
    AssignCommand(oBinder, ClearAllActions(TRUE));
    AssignCommand(oBinder, ActionForceMoveToLocation(lTarget, TRUE));
    if (DEBUG) FloatingTextStringOnCreature("Paimon Dance of Death: Distance: "+FloatToString(fLength), oBinder, FALSE);
    
    // Loop over targets in the line shape
    if (DEBUG) FloatingTextStringOnCreature("Paimon Dance of Death: First Target: "+GetName(oTarget), oBinder, FALSE);
    while(GetIsObjectValid(oTarget)) // Find the targets
    {
        if (DEBUG) FloatingTextStringOnCreature("Paimon Dance of Death: Loop 1, Target: "+GetName(oTarget), oBinder, FALSE);
        if(oTarget != oBinder && GetIsEnemy(oTarget, oBinder)) // Don't overrun friends or yourself
        {
            float fDelay = PRCGetSpellEffectDelay(GetLocation(oBinder), oTarget) * 2.5;
            if (DEBUG) FloatingTextStringOnCreature("Paimon Dance of Death: Loop 2, Delay: "+FloatToString(fDelay), oBinder, FALSE);
            DelayCommand(fDelay, PerformAttack(oTarget, oBinder, eDummy, 0.0, 0, 0, 0, "Dance of Death Hit", "Dance of Death Miss")); 
        }// end if - Target validity check
    // Get next target
    oTarget = MyNextObjectInShape(SHAPE_SPELLCYLINDER, fLength, lTarget, TRUE, OBJECT_TYPE_CREATURE, vOrigin);
    }// end while - Target loop  
}
