/*
15/02/19 by Stratovarius

Curtain of Shadows

Initiate, Veil of Shadows 
Level/School: 5th/Transmutation 
Range: Close (25 ft. + 5 ft./2 levels) 
Effect: Shadowy wall 
Duration: 1 minute/level 
Saving Throw: None 
Spell Resistance: No

You create a wall of frigid shadow that wracks all who pass through it with cold.

You create a wall of shadow. Any creature passing through the wall takes 1d6 points of cold damage per caster level (maximum 15d6).
*/

#include "shd_inc_shdfunc"

void main()
{
    if (!GetIsObjectValid(GetAreaOfEffectCreator()))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    //Declare major variables
    object oShadow = GetAreaOfEffectCreator();
    int nDamage;
    object oAoE = GetAreaOfEffectObject(GetLocalLocation(oShadow, "BlackFire_Loc"), "VFX_PER_CURTAIN_SHADOWS");
    struct mystery myst = GetLocalMystery(oShadow, MYST_HOLD_MYST+"3");
    int nDice = PRCMin(15, myst.nShadowcasterLevel);

    //Capture the first target object in the shape.
    object oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oTarget))
    {    
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oShadow))
        {
            int nDamage = MetashadowsDamage(myst, 6, nDice);
            // Apply effects to the currently selected target.
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_COLD), oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M_PURPLE), oTarget);
        }
        //Select the next target within the spell shape.
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }    
}
