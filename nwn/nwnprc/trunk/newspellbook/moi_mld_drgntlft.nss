/*
1/2/21 by Stratovarius

Dragon Tail
Descriptors: Draconic
Classes: Incarnate, totemist
Chakra: Feet, waist (totem)
Saving Throw: See text

Incarnum forms a row of dragon vertebrae floating inches from your own spine. Ribs grow from the vertebrae, creating a cloak that conceals your back. The cloak continues to grow behind you, extending into a long dragon tail.

You form a draconic tail that can strike foes, dealing 1d8 points of bludgeoning damage + your Strength modifier. You can make one attack per round with the tail as a standard action.

Essentia: For every point of essentia invested in your dragon tail, the tail's attack gains a +1 enhancement bonus on attack rolls and damage rolls.

Chakra Bind (Feet)

The tail of this soulmeld grows broad and thick.

The dragon foil provides you with a measure of stability. You gain a +2 competence bonus on Balance and Jump checks. For each point of essentia invested in your dragon tail, the bonus improves by 2.

Chakra Bind (Waist)

The vertebrae fuse to your back, the ribs blending into your own. The tail becomes lively and animate, constantly twitching from side to side.

The dragon tail's damage dealt increases to 2d6 points + 1–1/2 × your Strength bonus.

Chakra Bind (Totem)

The tail takes on the appearance of flesh and bone and becomes more agile and animated

As a standard action, you can make a tail sweep. All creatures adjacent to you automatically take damage as if they had been struck by your dragon tail (Reflex half). 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 09:57:55
//::
//:: Double Chakra Bind support added
//:: Double Totem bind support added
//::
//::////////////////////////////////////////////////////////
#include "prc_inc_combat"
#include "moi_inc_moifunc"
  
void main()  
{  
    object oMeldshaper = OBJECT_SELF;  
    object oTarget     = PRCGetSpellTargetObject();  
    int nEssentia      = GetEssentiaInvested(oMeldshaper, MELD_DRAGON_TAIL);  
    int nClass         = GetMeldShapedClass(oMeldshaper, MELD_DRAGON_TAIL);		  
    int nDC            = GetMeldshaperDC(oMeldshaper, nClass, MELD_DRAGON_TAIL);    
    int nDamage;  
  
    // Helper to check if bound to Waist (regular or double)  
    int nBoundToWaist = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_WAIST)) == MELD_DRAGON_TAIL ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_WAIST)) == MELD_DRAGON_TAIL)  
        nBoundToWaist = TRUE;  
  
    if (GetSpellId() == MELD_DRAGON_TAIL_SWEEP)  
    {  
        location lTarget = GetLocation(oMeldshaper);  
        // Use the function to get the closest creature as a target  
        object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);  
        while(GetIsObjectValid(oAreaTarget))  
        {  
            if(oAreaTarget != oMeldshaper && // Not you  
               GetIsInMeleeRange(oMeldshaper, oAreaTarget) && // They must be in melee range  
               GetIsEnemy(oAreaTarget, oMeldshaper)) // Only enemies  
            {  
                nDamage = d8() + GetAbilityModifier(ABILITY_STRENGTH, oMeldshaper) + nEssentia;  
                if (nBoundToWaist) nDamage = d6(2) + FloatToInt(GetAbilityModifier(ABILITY_STRENGTH, oMeldshaper)*1.5) + nEssentia;   		  
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oAreaTarget, nDC, SAVING_THROW_TYPE_NONE);  
                ApplyEffectToObject(DURATION_TYPE_INSTANT, ExtraordinaryEffect(EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING)), oAreaTarget);  
            }  
            //Select the next target within the spell shape.  
            oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);  
        }     
    }  
    else // SLAM  
    {  
        int nAttack = GetAttackRoll(oTarget, oMeldshaper, OBJECT_INVALID, 0, nEssentia);  
        if(nAttack)  
        {	  
            nDamage = d8()+GetAbilityModifier(ABILITY_STRENGTH, oMeldshaper)+nEssentia;  
            if (nBoundToWaist) nDamage = d6(2)+ FloatToInt(GetAbilityModifier(ABILITY_STRENGTH, oMeldshaper)*1.5) + nEssentia;    	  
            // Critical hit  
            if (nAttack == 2)   
            {  
                nDamage += d8()+GetAbilityModifier(ABILITY_STRENGTH, oMeldshaper)+nEssentia;  
                if (nBoundToWaist) nDamage += d6(2)+ FloatToInt(GetAbilityModifier(ABILITY_STRENGTH, oMeldshaper)*1.5) + nEssentia;   		  
            }  
            ApplyEffectToObject(DURATION_TYPE_INSTANT, ExtraordinaryEffect(EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING)), oTarget);  
        }     
    }	  
}

/* void main()
{
    object oMeldshaper = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    int nEssentia      = GetEssentiaInvested(oMeldshaper, MELD_DRAGON_TAIL);
    int nClass         = GetMeldShapedClass(oMeldshaper, MELD_DRAGON_TAIL);		
	int nDC            = GetMeldshaperDC(oMeldshaper, nClass, MELD_DRAGON_TAIL);  
	int nDamage;

    if (GetSpellId() == MELD_DRAGON_TAIL_SWEEP)
    {
    	location lTarget = GetLocation(oMeldshaper);
    	// Use the function to get the closest creature as a target
    	object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    	while(GetIsObjectValid(oAreaTarget))
    	{
    	    if(oAreaTarget != oMeldshaper && // Not you
    	       GetIsInMeleeRange(oMeldshaper, oAreaTarget) && // They must be in melee range
    	       GetIsEnemy(oAreaTarget, oMeldshaper)) // Only enemies
    	    {
				nDamage = d8() + GetAbilityModifier(ABILITY_STRENGTH, oMeldshaper) + nEssentia;
				if (GetIsMeldBound(oMeldshaper, MELD_DRAGON_TAIL) == CHAKRA_WAIST) nDamage = d6(2) + FloatToInt(GetAbilityModifier(ABILITY_STRENGTH, oMeldshaper)*1.5) + nEssentia;   		
    	    	nDamage = PRCGetReflexAdjustedDamage(nDamage, oAreaTarget, nDC, SAVING_THROW_TYPE_NONE);
    	        ApplyEffectToObject(DURATION_TYPE_INSTANT, ExtraordinaryEffect(EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING)), oAreaTarget);
    	    }
    	//Select the next target within the spell shape.
    	oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    	}   
    }
    else // SLAM
    {
    	int nAttack = GetAttackRoll(oTarget, oMeldshaper, OBJECT_INVALID, 0, nEssentia);
    	if(nAttack)
    	{	
			nDamage = d8()+GetAbilityModifier(ABILITY_STRENGTH, oMeldshaper)+nEssentia;
			if (GetIsMeldBound(oMeldshaper, MELD_DRAGON_TAIL) == CHAKRA_WAIST) nDamage = d6(2)+ FloatToInt(GetAbilityModifier(ABILITY_STRENGTH, oMeldshaper)*1.5) + nEssentia;    	
    		// Critical hit
    		if (nAttack == 2) 
    		{
				nDamage += d8()+GetAbilityModifier(ABILITY_STRENGTH, oMeldshaper)+nEssentia;
				if (GetIsMeldBound(oMeldshaper, MELD_DRAGON_TAIL) == CHAKRA_WAIST) nDamage += d6(2)+ FloatToInt(GetAbilityModifier(ABILITY_STRENGTH, oMeldshaper)*1.5) + nEssentia;   		
    		}
    		ApplyEffectToObject(DURATION_TYPE_INSTANT, ExtraordinaryEffect(EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING)), oTarget);
    	}   
    }	
} */