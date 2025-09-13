#include "prc_inc_spells"

//:: End Spell Effects
//:: Removes spell effects created by the caster on the chosen target or ground.

void main()
{
    object oCaster = OBJECT_SELF;
    object oTarget = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();

    // If the target is valid, handle creature/placeable effects
    if (GetIsObjectValid(oTarget))
    {
        effect eEff = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eEff))
        {
            if (GetEffectCreator(eEff) == oCaster)
            {
                RemoveEffect(oTarget, eEff);
            }
            eEff = GetNextEffect(oTarget);
        }

        // Play cessate VFX on the object target
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REMOVE_CONDITION), oTarget);
    }
    else
    {
        // Otherwise, look for persistent AoEs at the location
        float fRadius = 10.0; // cover typical AoE spell size
        object oAOE = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_AREA_OF_EFFECT);
        int bFound = FALSE;

        while (GetIsObjectValid(oAOE))
        {
            if (GetAreaOfEffectCreator(oAOE) == oCaster)
            {
                DestroyObject(oAOE);
                bFound = TRUE;
            }
            oAOE = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_AREA_OF_EFFECT);
        }

        // If we destroyed at least one AoE, show cessate VFX at ground target
        if (bFound)
        {
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REMOVE_CONDITION), lTarget);
        }
    }
}
