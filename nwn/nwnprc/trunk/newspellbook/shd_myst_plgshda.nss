/*
18/02/19 by Stratovarius

Shadow Plague, OnEnter

Master, Shadow Calling 
Level/School: 8th/Conjuration (Creation) [Cold]

This mystery functions like the spell incendiary cloud, except that it deals cold damage rather than fire damage.
*/

#include "shd_inc_shdfunc"

void main()
{
    //Declare major variables
    object oShadow = GetAreaOfEffectCreator();
    struct mystery myst = GetLocalMystery(oShadow, MYST_HOLD_MYST+"4");

    //Capture the first target object in the shape.
    object oTarget = GetEnteringObject();
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oShadow))
    {
        int nDamage = MetashadowsDamage(myst, 6, 4);
        nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, myst.nSaveDC, SAVING_THROW_TYPE_COLD);
        if(nDamage > 0)
        {
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_COLD), oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_OTIL_COLDSPHERE), oTarget);
        }
    }
}
