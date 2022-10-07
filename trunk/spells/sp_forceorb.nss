#include "prc_inc_spells"
#include "prc_add_spell_dc"
#include "prc_inc_sp_tch"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    object oCaster = OBJECT_SELF;
	effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);
    int nSpellId = PRCGetSpellId();
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nPenetr = nCasterLvl + SPGetPenetr();
    int nDice = nCasterLvl;
    if (nDice > 10) nDice = 10;    
    
    int nAtk = PRCDoRangedTouchAttack(oTarget, TRUE, oCaster);
    if(nAtk)
    {   
        //Make SR Check
        if (!PRCDoResistSpell(oCaster, oTarget, nCasterLvl))
        {          	
        	effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);        	
        	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        	{
        	    //Fire cast spell at event for the specified target
        	    PRCSignalSpellEvent(oTarget, TRUE, nSpellId);
        	    
        	    //Roll damage for each target
        	    int nDamage = PRCGetMetaMagicDamage(DAMAGE_TYPE_MAGICAL, nDice, 6);
        	    nDamage += SpellDamagePerDice(oCaster, nDice);
        	    // Succeeded on the save
        	    if (PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget, oCaster)))
        	    	nDamage = nDamage/2;
        	    
        	    // Apply the damage and the damage visible effect to the target.
        	    ApplyTouchAttackDamage(oCaster, oTarget, nAtk, nDamage, DAMAGE_TYPE_MAGICAL);
        	    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        	}
        }	
    }
    else // If it misses, it becomes an AoE
    {
    	location lTarget = PRCGetSpellTargetLocation();
		oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    	//Cycle through the targets within the spell shape until an invalid object is captured.
    	while (GetIsObjectValid(oTarget))
    	{
    	    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
    	    {
    	        //Fire cast spell at event for the specified target
    	        SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellId));
    	        //Get the distance between the explosion and the target to calculate delay
    	        float fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
    	        if (!PRCDoResistSpell(oCaster, oTarget, nCasterLvl, fDelay))
    	        {	
    	        	int nDamage = nDice * 2;
    	        	nDamage += SpellDamagePerDice(oCaster, nDice);
    	            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, (PRCGetSaveDC(oTarget, oCaster)), SAVING_THROW_TYPE_SPELL);
    	            if(nDamage > 0)
    	            {
    	                //Set the damage effect
    	                effect eDam = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_MAGICAL);
    	                // Apply effects to the currently selected target.
    	                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
    	                //This visual effect is applied to the target object not the location as above.  This visual effect
    	                //represents the flame that erupts on the target not on the ground.
    	                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    	            }
    	        }
    	    }
    	   //Select the next target within the spell shape.
    	   oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    	}
    }
    PRCSetSchool();
}
