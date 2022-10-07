/*
21/02/19 by Stratovarius

Mystic Reflections

Fundamental 
Level/School: 0/Divination 
Range: Close 
Target: One creature 
Duration: Instantaneous

You peer slightly into the Plane of Shadow and can see the distortion in an object’s shadow-self caused by the presence of magic.

This mystery lists all magical effects on a target creature.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    object oShadow      = OBJECT_SELF;
    // Get infinite uses at this level
    if (GetLevelByClass(CLASS_TYPE_SHADOWCASTER, oShadow) >= 14) IncrementRemainingFeatUses(oShadow, 23668);
    if(!ShadPreMystCastCode()) return;

    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_NONE);

    if(myst.bCanMyst)
    {
        effect eAOE = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eAOE))
        {
            FloatingTextStringOnCreature(GetName(oTarget)+" is under the effect of "+GetMysteryName(GetEffectSpellId(eAOE)), oShadow, FALSE);
            // Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }// end while - Effect loop             
    }
}