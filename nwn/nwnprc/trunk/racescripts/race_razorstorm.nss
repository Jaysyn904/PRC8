//::///////////////////////////////////////////////
//:: Razor Storm
//:: race_razorstorm.nss
//:://////////////////////////////////////////////
/*
// 2d6 slashing in a 15' cone, Reflex save(10+Con) for half
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Feb 8, 2008
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    //Declare major variables
    float fDist;
    int nDamage;
    int nDC = 10 + GetAbilityModifier(ABILITY_CONSTITUTION);
    effect eRazor;
    effect eArmorPenalty = EffectACDecrease(2);
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_SPIKE_TRAP);

    int RzrDmg = ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_SLASHING);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, FeetToMeters(15.0), GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);

    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Signal spell cast at event to fire.
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BLADELING_RAZOR_STORM));
            //Calculate the delay time on the application of effects based on the distance
            //between the caster and the target
            fDist = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            //Make saving throw.
            nDamage = d6(2);
            //Run the damage through the various reflex save and evasion feats
            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_NONE);
            eRazor = PRCEffectDamage(oTarget, nDamage, RzrDmg);
            if(nDamage > 0)
            {
                // Apply effects to the currently selected target. 
                DelayCommand(fDist, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eRazor, oTarget));
                DelayCommand(fDist, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }
        //Select the next target within the spell shape.
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, FeetToMeters(15.0), GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eArmorPenalty, OBJECT_SELF, HoursToSeconds(24));
}
