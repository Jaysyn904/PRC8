/*
01/03/19 by Stratovarius

Eldritch Vortex

 At 10th level, you can emit mystic energies in a 20-foot-radius burst around yourself. Any creature other than you within that area takes a –4 penalty to caster level for any 
 mysteries, spells, or spell-like abilities it casts or uses. The vortex lasts 1 minute and can be used once per day. 
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    location lTarget    = GetLocation(oShadow);

    effect eImplode= EffectVisualEffect(VFX_DUR_ANTILIFE_SHELL);
    effect eVis = EffectVisualEffect(VFX_IMP_NEGBLAST_ENERGY);
    //Apply the implode effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eImplode, lTarget, 3.0);
    //Get the first target in the shape
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lTarget);
    while (GetIsObjectValid(oTarget))
    {
        if (oTarget != oShadow)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            SetLocalInt(oTarget, "EldritchVortex", TRUE);
            DelayCommand(60.0, DeleteLocalInt(oTarget, "EldritchVortex"));            
        }
       //Get next target in the shape
       oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lTarget);
    }
}