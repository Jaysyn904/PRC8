/*:://////////////////////////////////////////////
//:: Name Wild Magic Apply
//:: Spell FileName SMP_AIL_WILDMAGC
//:://////////////////////////////////////////////
//:: Effects Applied / Notes
//:://////////////////////////////////////////////

    This hold the functions used for wild magic, that usually is checked in
    "SMP_Inc_Spellhok"

    This is executed on the caster.

//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_AILMENT"

// Applys wild magic to the TARGET, IE the target of the spell being cast.
// * Ro return, called from SMP_WildMagicAreaSurge, if there is a wild magic surge.
void SMP_WildMagicTarget(object oTarget);

// Applys wild magic to the AREA, IE the target area of the spell being cast.
// * Ro return, called from SMP_WildMagicAreaSurge, if there is a wild magic surge.
void SMP_WildMagicArea(location lTarget);

// MAJOR BAD EFFECTS

// Applys a random dispel to the area.
void SMP_WildDispel(location lTarget);

// MINOR BAD EFFECTS

// Applys -1 saves to the target.
void SMP_WildMildCurse(object oTarget);

void main()
{
    // Get if it was AOE or location. It is executed on the caster always.
    if(!GetLocalInt(OBJECT_SELF, SMP_WILD_MAGIC_LOCATIONTARGET))
    {
        // Location
        SMP_WildMagicArea(GetSpellTargetLocation());
    }
    else
    {
        // Target
        SMP_WildMagicTarget(GetSpellTargetObject());
    }
}

// MAIN FUNCTIONS

// Applys wild magic to the caster, or whatever. This can be edited, and put
// to some use as some generic wild magic stuff.
// * Ro return, called from SMP_WildMagicAreaSurge, if there is a wild magic surge.
void SMP_WildMagicTarget(object oTarget)
{
    effect eDam = EffectDamage(d6());
    effect eVis = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
}

// Applys wild magic to the AREA, IE the target area of the spell being cast.
// * Ro return, called from SMP_WildMagicAreaSurge, if there is a wild magic surge.
void SMP_WildMagicArea(location lTarget)
{
    SMP_WildDispel(lTarget);
}

// MAJOR BAD EFFECTS

// Applys a random dispel to the area.
void SMP_WildDispel(location lTarget)
{
    // Random level of dispel - 2d20
    int iRandom = d20(2);
    effect eDispel;
    effect eDispelVis = EffectVisualEffect(VFX_IMP_BREACH);
    // Randomly make it dispel magic all, or dispel magic best
    if(d4() <= 3)
    {
        eDispel = EffectDispelMagicBest(iRandom);
    }
    else
    {
        eDispel = EffectDispelMagicAll(iRandom);
    }
    // Random size of the effect
    float fRange = IntToFloat(d10());

    effect eAOEVis;
    // Random visual for AOE
    iRandom = d4();
    if(iRandom == 1)
    {
        eAOEVis = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    }
    else if(iRandom == 2)
    {
        eAOEVis = EffectVisualEffect(VFX_FNF_DISPEL);
    }
    else if(iRandom == 3)
    {
        eAOEVis = EffectVisualEffect(VFX_FNF_DISPEL_GREATER);
    }
    else if(iRandom == 4)
    {
        eAOEVis = EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION);
    }


    // Apply AOE location
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eAOEVis, lTarget);

    // All in a random location
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lTarget);
    while(GetIsObjectValid(oTarget))
    {
        // Apply effect
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDispel, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDispelVis, oTarget);
        // Next
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRange, lTarget);
    }
}

// MINOR BAD EFFECTS

// Applys -1 saves to the target.
void SMP_WildMildCurse(object oTarget)
{
    // Delcare effects
    effect eSave1 = EffectSavingThrowDecrease(SAVING_THROW_FORT, 1);
    effect eSave2 = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, 1);
    effect eSave3 = EffectSavingThrowDecrease(SAVING_THROW_WILL, 1);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

    effect eLink = EffectLinkEffects(eSave1, eSave2);
    eLink = EffectLinkEffects(eLink, eSave3);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Make supernatural
    eLink = SupernaturalEffect(eLink);

    // Apply effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
}


