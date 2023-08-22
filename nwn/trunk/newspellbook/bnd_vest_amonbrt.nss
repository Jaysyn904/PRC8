/*
03/02/21 by Stratovarius

Amon, the Void Before the Altar

Fire Breath: You can vomit forth a line of fire as a standard
action. The line extends 10 feet per effective binder level
(maximum 50 feet) and deals 1d6 points of fire damage per
binder level to every creature in its area. A successful Reflex
save halves this damage. Once you have used this ability, you
cannot do so again for 5 rounds.
*/

#include "bnd_inc_bndfunc"

void main()
{
	object oBinder = OBJECT_SELF;
    if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_AMON)) return;
	
	//Set the lightning stream to start at the caster's hands
	effect eLightning = EffectBeam(VFX_BEAM_FIRE, oBinder, BODY_NODE_CHEST);
	effect eVis  = EffectVisualEffect(VFX_IMP_FLAME_S);
	effect eDamage;
	location lTarget = PRCGetSpellTargetLocation();
	int nBinderLvl = GetBinderLevel(oBinder, VESTIGE_AMON);
	int nDC = GetBinderDC(oBinder, VESTIGE_AMON);
	float fDelay;
	float fDist = 10.0 + (10.0 * nBinderLvl);
	if (fDist > 50.0) fDist = 50.0;
	int nDamage;
	
	//Get first target in the area
	object oTarget = MyFirstObjectInShape(SHAPE_SPELLCYLINDER, FeetToMeters(fDist), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(oBinder));
	while (GetIsObjectValid(oTarget))
	{
	   //Exclude the caster from the damage effects
	   if (oTarget != oBinder)
	   {
	        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oBinder))
	        {
	           //Fire cast spell at event for the specified target
	           SignalEvent(oTarget, EventSpellCastAt(oBinder, SPELL_LIGHTNING_BOLT));
                //Roll damage
                nDamage =  d6(nBinderLvl);

                //Adjust damage based on Reflex Save, Evasion and Improved Evasion
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_FIRE);
                if(nDamage > 0)
                {
                	eDamage = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_FIRE);	                        
                    fDelay = PRCGetSpellEffectDelay(GetLocation(oTarget), oTarget);
                    //Apply VFX impcat, damage effect and lightning effect
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }

	            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oTarget, 1.0, FALSE);
	        }
	   }
	   //Get the next object in the lightning cylinder
	   oTarget = MyNextObjectInShape(SHAPE_SPELLCYLINDER, FeetToMeters(fDist), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(oBinder));
	}
}


