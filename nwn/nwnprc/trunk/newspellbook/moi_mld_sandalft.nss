/*
Cerulean Sandals

Descriptors: None
Classes: Incarnate, Soulborn
Chakra: Feet
Saving Throw: None

Incarnum forms into a pair of sandals that surround your feet and any other footwear you might have on. The sandals resemble blue crystal ice, but just beneath the surface, they seem to flow like water.

Your cerulean sandals make you immune to movement speed decreases.

Essentia: Every point of essentia invested in this soulmeld grants an enhancement bonus of +5 feet to your base land speed.

Chakra Bind (Feet)

Your feet and lower legs are encased in a sheath of blue-gray energy. This substance resembles ice, but motes of light like tiny stars drift through it as well.

You can use dimension door as the spell, up to a total distance of 10 feet per meldshaper level. You can use this ability (in increments of 10 feet) any number of times, until the total distance has been traversed, at which point the soulmeld unshapes. This requires a standard action to activate.
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 09:50:29
//::
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "spinc_dimdoor"
#include "moi_inc_moifunc"

void main()  
{  
    object oMeldshaper = OBJECT_SELF;  
    location lTarget = PRCGetSpellTargetLocation();  
    float fTraveled = GetLocalFloat(oMeldshaper, "CeruleanSandalsDist");  
    float fDist = GetDistanceBetweenLocations(lTarget, GetLocation(oMeldshaper));  
    // We know it's bound, now to check which class bound it   
    int nClass = GetMeldShapedClass(oMeldshaper, MELD_CERULEAN_SANDALS);  
    int nLevel = GetMeldshaperLevel(oMeldshaper, nClass, MELD_CERULEAN_SANDALS);  
    float fMax = 10.0 * nLevel;  
  
    // Check if bound to Feet chakra (regular or double)  
    int nMeldId = MELD_CERULEAN_SANDALS;  
    int nBoundToFeet = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_FEET)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_FEET)) == nMeldId)  
        nBoundToFeet = TRUE;  
  
    if (!nBoundToFeet)  
    {  
        FloatingTextStringOnCreature("Cerulean Sandals must be bound to Feet to use this ability.", oMeldshaper, FALSE);  
        return;  
    }  
  
    // If it's within range  
    if (fMax >= (fDist+fTraveled))  
    {  
        DimensionDoor(oMeldshaper, nLevel);    
        SetLocalFloat(oMeldshaper, "CeruleanSandalsDist", (fDist+fTraveled));  
        FloatingTextStringOnCreature("You have "+FloatToString(fMax - (fDist+fTraveled))+" of distance left in your Cerulean Sandals", oMeldshaper, FALSE);  
    }  
    else  
    {  
        // Using this ability ends the meld until tomorrow.  
        PRCRemoveSpellEffects(MELD_CERULEAN_SANDALS, oMeldshaper, oMeldshaper);  
        FloatingTextStringOnCreature("Cerulean Sandals unshaped", oMeldshaper, FALSE);  
        ExecuteScript("prc_speed", oMeldshaper); // This will remove any speed bonus from the spell  
    }	  
}

/* void main()
{
    object oMeldshaper = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    float fTraveled = GetLocalFloat(oMeldshaper, "CeruleanSandalsDist");
    float fDist = GetDistanceBetweenLocations(lTarget, GetLocation(oMeldshaper));
    // We know it's bound, now to check which class bound it 
    int nClass = GetMeldShapedClass(oMeldshaper, MELD_CERULEAN_SANDALS);
    int nLevel = GetMeldshaperLevel(oMeldshaper, nClass, MELD_CERULEAN_SANDALS);
    float fMax = 10.0 * nLevel;	
    // If it's within range
    if (fMax >= (fDist+fTraveled))
    {
    	DimensionDoor(oMeldshaper, nLevel);  
    	SetLocalFloat(oMeldshaper, "CeruleanSandalsDist", (fDist+fTraveled));
    	FloatingTextStringOnCreature("You have "+FloatToString(fMax - (fDist+fTraveled))+" of distance left in your Cerulean Sandals", oMeldshaper, FALSE);
    }
    else
    {
    	// Using this ability ends the meld until tomorrow.
    	PRCRemoveSpellEffects(MELD_CERULEAN_SANDALS, oMeldshaper, oMeldshaper);
    	FloatingTextStringOnCreature("Cerulean Sandals unshaped", oMeldshaper, FALSE);
    	ExecuteScript("prc_speed", oMeldshaper); // This will remove any speed bonus from the spell
    }	
} */

