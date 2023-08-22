/*
13/4/20 by Stratovarius

Once per day, a marrulurk can
breathe a 10-foot cone of nauseating gas as a free action. All
creatures except other marrulurks
within the area must succeed on a DC
13 Fortitude save or be nauseated 1
round. The save DC is Constitutionbased
*/

#include "prc_inc_function"

void main()
{
    object oPC   = OBJECT_SELF;
    
    object oTarget       = PRCGetSpellTargetObject();
    int nDC = 10 + GetHitDice(oPC)/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
    effect eVis = EffectVisualEffect(VFX_IMP_DISEASE_S);
    //Get the first target in the radius around the caster
    oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, FeetToMeters(10.0), PRCGetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        if((GetRacialType(oTarget) != RACIAL_TYPE_MARRULURK))
        {            
        	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        	if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
        	{
        	    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNausea(oTarget, 6.0), oTarget, 6.0);
        	    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        	}
        }
        //Get the next target in the specified area around the caster
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, FeetToMeters(10.0), PRCGetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);
    }
}