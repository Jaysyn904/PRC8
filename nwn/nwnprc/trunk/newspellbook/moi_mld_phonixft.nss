/*
10/1/20 by Stratovarius

Phoenix Belt

Descriptors: Fire
Classes: Totemist
Chakra: Waist (totem)
Saving Throw: See text

You shape a belt made of feathers the color of flame—various reds, oranges, and yellows. The feathers seem to shift in color, pulsing softly, like the embers of a dying fire.

While wearing a frost helm, you gain the Heat Endurance feat.

Essentia: If you invest essentia in your phoenix belt, it also protects you from fire damage. You gain resistance to fire equal to 5 times the number of points of essentia you invest in this soulmeld. 

Chakra Bind (Waist) 

Your frost helm fuses to the top of your head, actually opening a breathing channel in the strange nodule at the helm’s crown.

You can turn fire damage into fast healing. Whenever your resistance to fire reduces the damage dealt to you by a fire-based spell, you gain fast healing 1 for a number of rounds equal to the amount of damage negated by your resistance. For example, if you were hit with a fireball for 22 points of damage and had resistance to fire 10, you would gain fast healing 1 for 10 rounds (since your resistance negated 10 points of damage). If instead you were hit with burning hands for 6 points of damage, you would gain fast healing 1 for only 6 rounds (since your resistance negated only 6 points of damage). 

Chakra Bind (Totem) 

Your frost helm fuses to your head and seems to spread downward, changing the appearance of your upper face to resemble the head of a frost worm. Your eyes meld into the helm’s strange nodule, your cheeks twist into lumpy protrusions, and the skin of your face grows thick and blue-white.

As a standard action, you can create a momentary ring of fire that surrounds you. Creatures adjacent to you take 1d6 points of fire damage per point of essentia 
you invest in your phoenix belt. A successful Reflex save reduces this damage by half. 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 21:30:51
//::
//:: Double Totem Bind support added
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"

void main()  
{  
    object oMeldshaper = OBJECT_SELF;  
    int nMeldId = MELD_PHOENIX_BELT;  
  
    // Check if bound to Totem chakra (regular or double)  
    int nBoundToTotem = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_TOTEM)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_TOTEM)) == nMeldId)  
        nBoundToTotem = TRUE;  
  
    if (!nBoundToTotem) return;  
  
    int nMeldshaperLevel = GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_PHOENIX_BELT);  
    int nDice = GetEssentiaInvested(oMeldshaper, MELD_PHOENIX_BELT);  
    int nDC = GetMeldshaperDC(oMeldshaper, CLASS_TYPE_INCARNATE, MELD_PHOENIX_BELT);  
    location lTarget = PRCGetSpellTargetLocation();  
    int nDamage;  
    float fDelay;  
    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);  
    effect eDam;  
  
    //Apply the fireball explosion at the location captured above.  
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);  
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.  
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(7.0), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);  
    //Cycle through the targets within the spell shape until an invalid object is captured.  
    while (GetIsObjectValid(oTarget))  
    {  
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oMeldshaper != oTarget)  
        {  
            //Fire cast spell at event for the specified target  
            SignalEvent(oTarget, EventSpellCastAt(oMeldshaper, MELD_PHOENIX_BELT));  
            //Get the distance between the explosion and the target to calculate delay  
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;  
            if (!PRCDoResistSpell(oMeldshaper, oTarget, nMeldshaperLevel, fDelay))  
            {  
                nDamage = d6(nDice);  
                //Adjust damage based on Reflex Save, Evasion and Improved Evasion  
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_FIRE);  
                if(nDamage > 0)  
                {  
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_FIRE), oTarget);  
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M), oTarget);  
                }  
            }  
        }  
       //Select the next target within the spell shape.  
       oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(7.0), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);  
    }  
}


/* void main()
{
    object oMeldshaper = OBJECT_SELF;
    int nMeldshaperLevel = GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_PHOENIX_BELT);
    int nDice = GetEssentiaInvested(oMeldshaper, MELD_PHOENIX_BELT);
    int nDC = GetMeldshaperDC(oMeldshaper, CLASS_TYPE_INCARNATE, MELD_PHOENIX_BELT);
	location lTarget = PRCGetSpellTargetLocation();
    int nDamage;
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
    effect eDam;

    //Apply the fireball explosion at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(7.0), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oMeldshaper != oTarget)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oMeldshaper, MELD_PHOENIX_BELT));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            if (!PRCDoResistSpell(oMeldshaper, oTarget, nMeldshaperLevel, fDelay))
            {
            	nDamage = d6(nDice);
	            //Adjust damage based on Reflex Save, Evasion and Improved Evasion
	            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_FIRE);
	            if(nDamage > 0)
	            {
	                ApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_FIRE), oTarget);
	                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M), oTarget);
	            }
            }
        }
       //Select the next target within the spell shape.
       oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(7.0), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
 */