/*
11/4/20 by Stratovarius

Frost Folk Ice Blast

Frost folk can produce a 20-foot cone of icy
mist from their left eye. This deals 2d6 points of cold damage
to all creatures within the area (Reflex save
DC 13 half). The save DC is Constitution-based. Once a frost folk uses his ice blast,
he must wait 1d4 rounds before he can
use this ability again
*/

#include "prc_inc_function"

void main()
{
    object oPC   = OBJECT_SELF;
    
	if (!GetLocalInt(oPC, "FrostFolkDelay"))
	{
    	object oTarget       = PRCGetSpellTargetObject();
    	int nDC = 10 + GetHitDice(oPC)/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
    	effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    	//Get the first target in the radius around the caster
    	oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, FeetToMeters(20.0), PRCGetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);
    	while(GetIsObjectValid(oTarget))
    	{
    	    if(oTarget != oPC)
    	    {            
            	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            	int nDamage = d6(2);
            	//Run the damage through the various reflex save and evasion feats
            	nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_COLD);
            	if(nDamage > 0)
            	{
            	    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_COLD), oTarget);
            	    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            	}
    	    }
    	    //Get the next target in the specified area around the caster
    	    oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, FeetToMeters(20.0), PRCGetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);
    	}
    	
    	SetLocalInt(oPC, "FrostFolkDelay", TRUE);
    	float fDelay = RoundsToSeconds(d4());
    	DelayCommand(fDelay, DeleteLocalInt(oPC, "FrostFolkDelay"));
    	DelayCommand(fDelay, FloatingTextStringOnCreature("You may use your Ice Blast again", oPC));
    }	
}