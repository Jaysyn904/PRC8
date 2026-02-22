/*
1/1/20 by Stratovarius

Brass Mane Throat Bind 

The hair of your brass mane extends down your neck, forming brassy scales that cover your throat and reach down to your breastbone. 
Your voice gets louder unless you make a conscious effort to keep it quiet.

Once per minute, you can loose a devastating roar. All creatures within 10 feet must succeed on a Will save or become fatigued. 
The range of this effect is extended by 10 feet for every point of essentia invested in the soulmeld.
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 19:18:18
//::
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"

void main()  
{  
    object oMeldshaper = OBJECT_SELF;  
    int nMeldId = MELD_BRASS_MANE;  
  
    // Check if bound to Throat chakra (regular or double)  
    int nBoundToThroat = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_THROAT)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_THROAT)) == nMeldId)  
        nBoundToThroat = TRUE;  
  
    if (!nBoundToThroat) return; // Exit if not bound to Throat  
  
    int nMeldshaperLevel = GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_BRASS_MANE);  
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_BRASS_MANE);  
    int nDC = GetMeldshaperDC(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_BRASS_MANE);  
    location lTarget = GetLocation(oMeldshaper);  
    float fRange = 10.0 + (10.0 * nEssentia);  
    effect eVis = EffectVisualEffect(VFX_IMP_SOUND_SYMBOL_STUNNING);  
  
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(fRange), lTarget, TRUE, OBJECT_TYPE_CREATURE);  
    while (GetIsObjectValid(oTarget))  
    {  
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oMeldshaper != oTarget)  
        {  
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
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(fRange), lTarget, TRUE, OBJECT_TYPE_CREATURE);  
    }  
}


/* void main()
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
} */
