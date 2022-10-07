/*
13/02/19 by Stratovarius

Clinging Darkness, OnEnter

Apprentice, Dark Terrain 
Level/School: 3rd/Conjuration (Creation) 
Range: Close (25 ft. + 5 ft./2 levels) 
Area: 20-ft.-radius emanation 
Duration: 1 minute/level 
Saving Throw: Reflex negates
Spell Resistance: Yes

Shadow oozes out of the floors, the walls, even the air, filling the area with wisps of writhing blackness. Creatures within the area become coated in these clinging shadows.

Any creature affected by this mystery must make a Reflex save or become immobilized for one round. This applies each round they are in the area of effect.
*/

#include "shd_inc_shdfunc"

void main()
{
    //Declare major variables
    object oShadow = GetAreaOfEffectCreator();
    struct mystery myst = GetLocalMystery(oShadow, MYST_HOLD_MYST+"2");  

    //Capture the first target object in the shape.
    object oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {    
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oShadow))
        {
            //Make SR check, and appropriate saving throw(s).
            if(!PRCDoResistSpell(oShadow, oTarget, myst.nPen) || myst.bIgnoreSR)
            {
                if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, myst.nSaveDC, SAVING_THROW_TYPE_SPELL))
                {
                    // Apply effects to the currently selected target.
                    myst.eLink = EffectCutsceneImmobilize();
                    if (myst.bIgnoreSR) myst.eLink = SupernaturalEffect(myst.eLink);
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, 6.0, TRUE, MYST_CLINGING_DARKNESS, myst.nShadowcasterLevel);               
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DIMENSIONLOCK), oTarget);
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
    }    
}
