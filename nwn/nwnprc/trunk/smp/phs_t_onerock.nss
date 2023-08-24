/*:://////////////////////////////////////////////
//:: Trap Name One Rock Fall trap
//:: Trap FileName PHS_T_OneRock
//:://////////////////////////////////////////////
//:: Trap Description / Effects
//:://////////////////////////////////////////////
    One rock falls onto the entering object/person who set it off. Visual effect
    and 3d6 bludgeoning damage, relfex for none.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Declare major variables
    object oTarget = GetEnteringObject();
    // Reflex adjusted
    int nDam = GetReflexAdjustedDamage(d6(3), oTarget, 20, SAVING_THROW_TYPE_TRAP);

    if(nDam > 0)
    {
        effect eDam = EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING);
        effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);

        // Apply damage
        PHS_ApplyInstantAndVFX(oTarget, eVis, eDam);
    }
}
