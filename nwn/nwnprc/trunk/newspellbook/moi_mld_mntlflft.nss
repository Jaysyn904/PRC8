/*
7/1/20 by Stratovarius

Mantle of Flame

Descriptors: Fire  
Classes: Incarnate 
Chakra: Shoulders
Saving Throw: See text

You shape incarnum into a cloak of wispy blue flame. The cloak covers your arms and almost closes in front of you, where a band of fire crosses over your heart to connect the cloak’s two edges. The fire does not harm you, though it keeps you as warm and dry as any heavy cloak in cold or rainy weather.

While you wear your mantle of flame, any creature that strikes you takes 1d6 points of fire damage.

Essentia: Every point of essentia you invest in your mantle of flame increases the damage dealt by 1d6 points.  

Chakra Bind (Shoulders)

Your mantle of flame burns particularly brightly around your shoulders, forming a high collar behind your head and neck.

As a standard action, you can briefly expand the mantle of flame to encompass all adjacent squares. Any creatures in those squares take damage as if they had attacked you with a handheld weapon (Reflex half). 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 14:32:51
//::
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"

void main()  
{  
    object oMeldshaper = OBJECT_SELF;  
    int nMeldId = MELD_MANTLE_OF_FLAME;  
  
    // Check if bound to Shoulders chakra (regular or double)  
    int nBoundToShoulders = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_SHOULDERS)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_SHOULDERS)) == nMeldId)  
        nBoundToShoulders = TRUE;  
  
    if (!nBoundToShoulders) return; // Exit if not bound to Shoulders  
  
    int nMeldshaperLevel = GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_INCARNATE, MELD_MANTLE_OF_FLAME);  
    int nDice = GetEssentiaInvested(oMeldshaper, MELD_MANTLE_OF_FLAME) + 1;  
    int nDC = GetMeldshaperDC(oMeldshaper, CLASS_TYPE_INCARNATE, MELD_MANTLE_OF_FLAME);  
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
            SignalEvent(oTarget, EventSpellCastAt(oMeldshaper, MELD_MANTLE_OF_FLAME));  
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


/* 
void main()
{
    object oMeldshaper = OBJECT_SELF;
    int nMeldshaperLevel = GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_INCARNATE, MELD_MANTLE_OF_FLAME);
    int nDice = GetEssentiaInvested(oMeldshaper, MELD_MANTLE_OF_FLAME) + 1;
    int nDC = GetMeldshaperDC(oMeldshaper, CLASS_TYPE_INCARNATE, MELD_MANTLE_OF_FLAME);
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
            SignalEvent(oTarget, EventSpellCastAt(oMeldshaper, MELD_MANTLE_OF_FLAME));
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
} */
