/*
13/02/19 by Stratovarius

Black Fire. OnEnter

Apprentice, Dark Terrain 
Level/School: 2nd/Evocation [Cold] 
Range: Close (25 ft. + 5 ft./2 levels) 
Area: Wall of Black Flame
Duration: 1 round/level 
Saving Throw: Reflex negates
Spell Resistance: Yes

You open a conduit to the Plane of Shadow, drawing its elements into the world and igniting a black fire on the ground.

You create a shadowy curtain of black flame that covers the affected squares. The fire deals 1d6 points of cold damage per two caster levels, Reflex negates.
*/

#include "shd_inc_shdfunc"

void main()
{
    //Declare major variables
    object oShadow = GetAreaOfEffectCreator();
    struct mystery myst = GetLocalMystery(oShadow, MYST_HOLD_MYST+"1");  
    int nDice = myst.nShadowcasterLevel/2;    

    //Capture the first target object in the shape.
    object oTarget = GetEnteringObject();
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oShadow))
    {
        //Make SR check, and appropriate saving throw(s).
        if(!PRCDoResistSpell(oShadow, oTarget, myst.nPen) || myst.bIgnoreSR)
        {
            int nDamage = MetashadowsDamage(myst, 6, nDice);

            // Yes, it's reflex negates, not half
            if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, myst.nSaveDC, SAVING_THROW_TYPE_COLD))
            {
                // Apply effects to the currently selected target.
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_COLD), oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M_PURPLE), oTarget);
            }
        }
    }
}
