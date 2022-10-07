/*
3/1/21 by Stratovarius

Fast Healing (Su): When you reach 2nd level, the irrepressible force of your soul restores your vitality whenever you are wounded, granting you fast healing at a rate equal to the points of essentia you invest in this
ability. This fast healing is usable for a number of rounds per day equal to your incandescent champion level. For example, a 5th-level incandescent champion who invests 2 points of essentia in this ability gains fast healing 2 for
a maximum of 5 rounds per day. Activating this ability requires no action, but investing essentia in it requires a swift action, as normal.

At 9th level, each ally who is adjacent to you when you activate the ability gains fast healing
*/

#include "moi_inc_moifunc"
#include "prc_inc_combat"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia      = GetEssentiaInvested(oMeldshaper, MELD_INCANDESCENT_HEAL);
    int nClass         = GetLevelByClass(CLASS_TYPE_INCANDESCENT_CHAMPION, oMeldshaper);
	effect eLink;
	
    if (nEssentia) 
    {
    	eLink = EffectLinkEffects(EffectRegenerate(nEssentia, 6.0), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, RoundsToSeconds(nClass+1));
    
    	if (nClass >= 9)
    	{
    		location lTarget = GetLocation(oMeldshaper);
    		// Use the function to get the closest creature as a target
    		object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    		while(GetIsObjectValid(oAreaTarget))
    		{
    		    if(oAreaTarget != oMeldshaper && // Not you
    		       GetIsInMeleeRange(oMeldshaper, oAreaTarget) && // They must be in melee range
    		       GetIsFriend(oAreaTarget, oMeldshaper)) // Only allies
    		    {
    		        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oAreaTarget, RoundsToSeconds(nClass+1));
    		    }
    		//Select the next target within the spell shape.
    		oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    		}	
    	}
    }
    else
    {
    	FloatingTextStringOnCreature("You have no essentia invested in Incandescent Healing!", oMeldshaper, FALSE);
    	IncrementRemainingFeatUses(oMeldshaper, 8922);
    }	
}