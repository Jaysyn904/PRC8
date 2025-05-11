//:: tob_bcm_rend

/* 
	Turn Rending Claws off & on
*/
#include "prc_inc_function"

void main()
{
    object oPC = OBJECT_SELF;
	
	int bRend = GetLocalInt(oPC, "BCM_REND");
    
    if (bRend)
	{
		DeleteLocalInt(oPC, "BCM_REND");
		//DelayCommand(1.0, EvalPRCFeats(oPC));
		FloatingTextStringOnCreature("Rending Claws Disabled", oPC, FALSE);
	}
    else
    {
    	SetLocalInt(oPC, "BCM_REND", 1);
		effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
		//DelayCommand(1.0, EvalPRCFeats(oPC));	
		FloatingTextStringOnCreature("Rending Claws Enabled", oPC, FALSE);		
	}        
}