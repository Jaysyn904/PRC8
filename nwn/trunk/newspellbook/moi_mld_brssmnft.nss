/*
1/1/20 by Stratovarius

Brass Mane Throat Bind 

The hair of your brass mane extends down your neck, forming brassy scales that cover your throat and reach down to your breastbone. 
Your voice gets louder unless you make a conscious effort to keep it quiet.

Once per minute, you can loose a devastating roar. All creatures within 10 feet must succeed on a Will save or become fatigued. 
The range of this effect is extended by 10 feet for every point of essentia invested in the soulmeld.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = OBJECT_SELF;
    int nMeldshaperLevel = GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_BRASS_MANE);
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_BRASS_MANE);
    int nDC = GetMeldshaperDC(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_BRASS_MANE);
    location lTarget = GetLocation(oMeldshaper);
    float fRange = 10.0 + (10.0 * nEssentia);
    effect eVis = EffectVisualEffect(VFX_IMP_SOUND_SYMBOL_STUNNING);

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(fRange), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oMeldshaper != oTarget)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oMeldshaper, MELD_BRASS_MANE));
            if (!PRCDoResistSpell(oMeldshaper, oTarget, nMeldshaperLevel))
            {
				if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SONIC))
				{	
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectFatigue(), oTarget, 9999.0);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				}	
            }
        }
       //Select the next target within the spell shape.
       oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(fRange), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}
