/*
    ----------------
    Fountain of Blood

    tob_tgcw_ftnbld
    ----------------

    18/08/07 by Stratovarius
*/ /** @file

    Fountain of Blood

    Tiger Claw (Boost)
    Level: Swordsage 4, Warblade 4
    Prerequisite: Two Tiger Claw maneuvers
    Initiation Action: 1 Swift Action
    Range: 30 ft.
    Area: 30 ft burst.
    Duration: 1 minute
    Saving Throw: Will partial; see text

    With a war cry, you leap into the air and lift your weapon high overhead. As you arc downward, your weight and momentum
    lend bone-crushing force to your attack.
    
    You strike a foe with less than 10 hit points for an additional 1d6, causing all creatures within the area to make a will
    save or be shaken for one minute.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

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
    	// Since we can't go to -10
    	if (10 >= GetCurrentHitPoints(oTarget))
    	{
    		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6()), oTarget);
    		effect eFNF = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
    		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(oInitiator));
		
    		oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), GetLocation(oInitiator));
    		while(GetIsObjectValid(oTarget))
    		{
        	        if(GetIsEnemy(oTarget, oInitiator))
        	        {
        	            // Saving Throw
						int nDC = 14 + GetAbilityModifier(ABILITY_STRENGTH, oInitiator);
						
						int nBladeMed = HasBladeMeditationForDiscipline(oInitiator, GetDisciplineByManeuver(PRCGetSpellId()));;
						if (nBladeMed)
						{
							nDC += 1;
						}		
						
    				if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
    				{
    					effect eLink = ExtraordinaryEffect(EffectLinkEffects(EffectShaken(), EffectVisualEffect(VFX_IMP_DOOM)));
        	            		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 60.0);
        	            	}
	
        	        }
        	oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), GetLocation(oInitiator));
    		}
    	}
    	else
    		FloatingTextStringOnCreature("The target has too many hit points for this maneuver", oInitiator, FALSE);
    }
}