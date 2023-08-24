/*
5/1/20 by Stratovarius

Lammasu Mantle Totem Bind

The golden-brown fur around your shoulders extends upward into an impressive mane around your head. There is a sensation in your mouth as if you were savoring a warm, sweet drink.

You can breathe a 15-foot cone of fire as a standard action. Creatures within the area take 1d4 points of fire damage, plus 1d4 points of fire damage per point of invested essentia (Reflex half). 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper   = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    int nDC = GetMeldshaperDC(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_LAMMASU_MANTLE);
    int nMeldshaperLvl = GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_LAMMASU_MANTLE);
    int nDice = 1 + GetEssentiaInvested(oMeldshaper, MELD_LAMMASU_MANTLE);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
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
            	int nDamage = d4(nDice);
            	//Run the damage through the various reflex save and evasion feats
            	nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_FIRE);
            	if(nDamage > 0)
            	{
            	    effect eFire = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
            	    // Apply effects to the currently selected target. 
            	    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget);
            	    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            	}
            }
        }
        //Get the next target in the specified area around the caster
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, FeetToMeters(15.0), PRCGetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);
    }
}