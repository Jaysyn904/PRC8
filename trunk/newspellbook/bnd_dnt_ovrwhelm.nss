/*
10/03/21 by Stratovarius

Scion of Dantalion, the Star Emperor
  
As a standard action, you send your thoughts out to
a single creature whose thoughts you are reading (so it has
already failed its Will save against your read thoughts ability),
forcing it to succeed on a Will save (DC 10 + 1/2 your effective
binder level + your Cha modifier) or be dazed for 1d4 rounds. 
A successful save allows the creature to break free
of your thought reading.
*/

#include "bnd_inc_bndfunc"

void DantalionOverwhelm(object oBinder, object oTarget, int nDC)
{
	if (GetHasSpellEffect(VESTIGE_DANTALION_READ_THOUGHTS, oTarget))
	{
    	if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
    	{
    		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(PSI_IMP_CONCUSSION_BLAST), oTarget);
    		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazed(), oTarget, RoundsToSeconds(d4()));
    	}	
    	else // Enemy succeeded on saving throw here
    	{
    		FloatingTextStringOnCreature(GetName(oTarget)+" breaks your Read Thoughts!", oBinder, FALSE);
			PRCRemoveSpellEffects(VESTIGE_DANTALION_READ_THOUGHTS, oBinder, oTarget);
			GZPRCRemoveSpellEffects(VESTIGE_DANTALION_READ_THOUGHTS, oTarget, FALSE);
    	}	    	
    }	
}    

void main()
{
	object oBinder = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
    int nDC = 10 + GetBinderLevel(oBinder, VESTIGE_DANTALION)/2 + GetAbilityModifier(ABILITY_CHARISMA, oBinder);
    
    DantalionOverwhelm(oBinder, oTarget, nDC);
	
	if (GetLevelByClass(CLASS_TYPE_SCION_DANTALION, oBinder) >= 5)
	{
	    location lTarget = GetLocation(oBinder);
	    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DEEP_SLUMBER), oBinder);
	    // Use the function to get the closest creature as a target
	    object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(45.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
	    while(GetIsObjectValid(oAreaTarget))
	    {
	        if(oAreaTarget != oBinder && oAreaTarget != oTarget && GetIsEnemy(oBinder, oAreaTarget)) // Enemies only
	        {
				DantalionOverwhelm(oBinder, oAreaTarget, nDC);	
	        }
	    //Select the next target within the spell shape.
	    oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(45.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
	    }	
	}    
}