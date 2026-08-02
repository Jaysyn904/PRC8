//::////////////////////////////////////////////////////////
//:: tmp_hvamp_bdrain.nss
//::
//::////////////////////////////////////////////////////////
/*
	Blood Drain (Ex): Some half-vampires can suck blood from 
	a living victim with their fangs by making a successful 
	grapple check. If the half-vampire pins the foe, it 
	drains blood, dealing 1d4 points of Constitution drain 
	each round the pin is maintained. A half-vampire can't 
	drain more points of Constitution in a single hour than 
	its Constitution score. When a half-vampire drains a 
	victim's Constitution, it gains 5 temporary hit points, 
	no matter how many points it drains. Temporary hit 
	points gained in this way last for up to 1 hour. If a 
	half-vampire has this ability, it also gains the blood 
	dependency special quality described below.

	Blood Dependency (Ex): If a half-vampire does not use 
	its blood drain special attack against at least one 
	living creature each day, it must make a DC 15 
	Fortitude save or become fatigued. Each day after the 
	first that the half-vampire does not drink blood 
	directly from a living creature, the DC increases by 1 
	until it fails the save and becomes fatigued. After 
	that, it must make a DC 20 Fortitude save each week 
	(with the DC increasing by 1 each week thereafter) 
	that it does not use its blood drain or become exhausted.

*/
//::////////////////////////////////////////////////////////

#include "prc_inc_combmove"
#include "prc_inc_spells"
#include "inc_abil_damage"
#include "prc_inc_template"
 
void main()
{
    object oPC = OBJECT_SELF;  
    object oTarget = PRCGetSpellTargetObject();  
  
    if (!GetIsObjectValid(oTarget) || GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)  
        return;  
  
    // Sanity check - can't grapple/drain yourself  
    if (oTarget == oPC)  
    {  
        FloatingTextStringOnCreature("You cannot target yourself with Blood Drain.", oPC, FALSE);  
        return;  
    }  
 
	// If we're already grappling this target, attempt to pin
    if (GetGrapple(oPC) && GetGrappleTarget(oPC) == oTarget)
    {
        if (DoGrappleOptions(oPC, oTarget, 0, GRAPPLE_PIN))
        {
            SetIsPinned(oTarget);
            //DoBloodDrain(oPC, oTarget);
			SetLocalInt(oPC, "HVamp_BloodDrainGrapple", 1);
        }
        else
        {
            FloatingTextStringOnCreature("Failed to pin the target.", oPC, FALSE);
        }
    }
    else
    {
        // Initiate a new grapple
        if (DoGrapple(oPC, oTarget, 0))
        {
            // Grapple succeeded, now attempt pin
            if (DoGrappleOptions(oPC, oTarget, 0, GRAPPLE_PIN))
            {
                SetIsPinned(oTarget);
                //DoBloodDrain(oPC, oTarget);
				SetLocalInt(oPC, "HVamp_BloodDrainGrapple", 1);
            }
        }
        else
        {
            FloatingTextStringOnCreature("Grapple check failed.", oPC, FALSE);
        }
    }
}