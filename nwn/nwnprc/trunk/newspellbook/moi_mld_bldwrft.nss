/*
31/12/19 by Stratovarius

Bloodwar Gauntlets Bind (Arms) 

Your bloodwar gauntlets bind themselves to your wrists and forearms. Instead of separate rings of metal extending up your arms, they now 
form a solid sheath of completely unreflective metal in which fiendish visages manifest and subside, always contorted with rage and pain.

You can use a standard action to release the soulmeld’s violent energy in a tumultuous blast, unshaping the soulmeld in the process. 
The blast deals 3d6 points of damage for every point of essentia invested to all creatures within a 20-foot radius burst, excluding you. 
A successful Fortitude save halves this damage. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = OBJECT_SELF;
    int nMeldshaperLevel = GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_INCARNATE, MELD_BLOODWAR_GAUNTLETS);
    int nDice = GetEssentiaInvested(oMeldshaper, MELD_BLOODWAR_GAUNTLETS) * 3;
    int nDC = GetMeldshaperDC(oMeldshaper, CLASS_TYPE_INCARNATE, MELD_BLOODWAR_GAUNTLETS);
	location lTarget = PRCGetSpellTargetLocation();
    int nDamage;
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eDam;

    //Apply the fireball explosion at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oMeldshaper != oTarget)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oMeldshaper, MELD_BLOODWAR_GAUNTLETS));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            if (!PRCDoResistSpell(oMeldshaper, oTarget, nMeldshaperLevel, fDelay))
            {
            	nDamage = d6(nDice);
				if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
					nDamage /= 2;
					
				ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_FIRE), oTarget);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
       //Select the next target within the spell shape.
       oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
    
    // Using this ability ends the meld until tomorrow.
    PRCRemoveSpellEffects(MELD_BLOODWAR_GAUNTLETS, oMeldshaper, oMeldshaper);
}
