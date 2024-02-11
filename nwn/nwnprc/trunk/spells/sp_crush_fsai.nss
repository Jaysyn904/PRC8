/**
 * Crushing Fist of Spite
 *
 * This just tells it to move to the nearest enemy
 */

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
   	if (DEBUG) DoDebug("Starting Crushing Fist AI");
   	object oCaster = GetMaster();
   	location lTarget = GetLocation(OBJECT_SELF);
   	
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 20.0, lTarget, TRUE);
    while(GetIsObjectValid(oTarget))
    {
		if (GetIsEnemy(oTarget, oCaster))
		{
			AssignCommand(OBJECT_SELF, ClearAllActions(TRUE));
   			AssignCommand(OBJECT_SELF, ActionForceMoveToObject(oTarget, TRUE));
   			// End script for this heartbeat
   			return;
		}
        //Get next target in the spell cone
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, 20.0, lTarget, TRUE);
    }
    
    // Now actually do something
    int nCasterLvl = GetLocalInt(oCaster, "CrushingFistOfSpite");
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(5.0), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	//Cycle through the targets within the spell shape until an invalid object is captured.
	while (GetIsObjectValid(oTarget))
	{
	    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	    {
	        //Fire cast spell at event for the specified target
	        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CRUSHING_FIST_OF_SPITE));
	        if (!PRCDoResistSpell(oCaster, oTarget, nCasterLvl))
	        {
				int nDamage = d6(nCasterLvl);
				nDamage += SpellDamagePerDice(oCaster, nCasterLvl);
	            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, (PRCGetSaveDC(oTarget, oCaster)), SAVING_THROW_TYPE_SPELL);
	            if(nDamage > 0)
	            {
	                //Set the damage effect
	                effect eDam = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_POSITIVE);
	                // Apply effects to the currently selected target.
	                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
	            }
	        }
	    }
	   //Select the next target within the spell shape.
	   oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(5.0), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
   
   if (DEBUG) DoDebug("Ending Crushing Fist AI");
}
