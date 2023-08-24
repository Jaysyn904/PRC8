/*
13/1/20 by Stratovarius

Winter Mask

Descriptors: Cold
Classes: Totemist
Chakra: Throat (totem)
Saving Throw: See text

Chakra Bind (Throat) 

White fur spreads down from your winter mask to cover your throat. Your mouth is filled with a pleasant cold, like sucking a piece of ice on a hot day.

You gain the ability to breathe a cone of cold. Once every 1d4 rounds, you can emit a 15-foot-long cone of cold. Targets in the cone take 2d6 points of cold damage
plus 2d6 additional points of damage for every point of invested essentia (Reflex half). 

*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper   = OBJECT_SELF;
    
    if (!GetLocalInt(oMeldshaper, "WinterMaskTimer"))
    {
    	object oTarget       = PRCGetSpellTargetObject();
    	int nDC = GetMeldshaperDC(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_WINTER_MASK);
    	int nMeldshaperLvl = GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_WINTER_MASK);
    	int nDice = 1 + GetEssentiaInvested(oMeldshaper, MELD_WINTER_MASK);
    	effect eVis = EffectVisualEffect(VFX_IMP_FROST_L);
    	//Get the first target in the radius around the caster
    	oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, FeetToMeters(15.0), PRCGetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);
    	while(GetIsObjectValid(oTarget))
    	{
    	    if(oTarget != oMeldshaper)
    	    {
    	        // Check Spell Resistance
    	        if(!PRCDoResistSpell(oMeldshaper, oTarget, nMeldshaperLvl))
    	        {             
    	        	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
    	        	int nDamage = d6(nDice*2);
    	        	//Run the damage through the various reflex save and evasion feats
    	        	nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_COLD);
    	        	if(nDamage > 0)
    	        	{
    	        	    effect eFire = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
    	        	    // Apply effects to the currently selected target. 
    	        	    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget);
    	        	    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    	        	}
    	        }
    	    }
    	    //Get the next target in the specified area around the caster
    	    oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, FeetToMeters(15.0), PRCGetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);
    	}
    	
    	SetLocalInt(oMeldshaper, "WinterMaskTimer", TRUE);
    	float fDelay = RoundsToSeconds(d4());
    	DelayCommand(fDelay, DeleteLocalInt(oMeldshaper, "WinterMaskTimer"));
    	DelayCommand(fDelay, FloatingTextStringOnCreature("You may use your Winter's Mask Breath Attack", oMeldshaper, FALSE));
    }	
}