/*
Blink Shirt

This rough-looking garment looks like it has been made of coarse brown fur, but it displays obviously magical features. The shirt seems to shift and move on its own, and it 
fades into a barely corporeal mist near your waist. Most disconcerting of all, patches of the garment seem transparent, as if they have temporarily shifted to some strange 
elsewhere. Because different parts of the garment appear phased out at different times, these patches of incorporeality seem to roam over the surface of the shirt.

You gain the ability to teleport yourself (as dimension door) up to 10 feet at will. Using this ability is a standard action. 

Essentia: For every point of essentia invested, you can teleport an additional 10 feet.  
*/

#include "spinc_dimdoor"
#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = OBJECT_SELF;
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_BLINK_SHIRT); 
    location lTarget = PRCGetSpellTargetLocation();
    float fDist = GetDistanceBetweenLocations(lTarget, GetLocation(oMeldshaper));
    
    // It's a move action if done this way
    if (GetIsMeldBound(oMeldshaper, MELD_ACROBAT_BOOTS) == CHAKRA_TOTEM)
    	if(!TakeMoveAction(oMeldshaper)) return;
    
    // If it's within range
    if (FeetToMeters(10 + (10.0 * nEssentia)) >= fDist)
    {
    	DimensionDoor(oMeldshaper, GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_BLINK_SHIRT));  
    }
    else
    	FloatingTextStringOnCreature("Target is too far away for Blink Shirt!", oMeldshaper, FALSE);
}

