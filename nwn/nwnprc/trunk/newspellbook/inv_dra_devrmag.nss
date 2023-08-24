//::///////////////////////////////////////////////
//:: Name      Devour Magic
//:: FileName  inv_dra_devrmag.nss
//::///////////////////////////////////////////////
/*

Greater Invocation
6th Level Spell

You attempt to strip all magical effects from a
single target. You can also target a group of
creatures, attempting to remove the most powerful
spell effect from each creature. To remove an
effect, the caster makes a dispel check of 1d20, +1
per caster level (to a maximum of +20) against a DC
of 11 + the spell effect's caster level. You gain
5 temporary HP per spell level of any spell
dispelled for 1 minute, and if you devour a new
spell the new temporary hit points replace the old.

*/
//::///////////////////////////////////////////////

#include "inc_dispel"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if(!PreInvocationCastCode()) return;

    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    location lLocal = PRCGetSpellTargetLocation();
    int nCasterLevel = GetInvokerLevel(oCaster, GetInvokingClass());
    int iTypeDispel = GetLocalInt(GetModule(),"BIODispel");
    effect eVis = EffectVisualEffect(VFX_IMP_BREACH);
    effect eImpact = EffectVisualEffect(VFX_FNF_DISPEL_GREATER);

    //--------------------------------------------------------------------------
    // Greater Dispel Magic is capped at caster level 20
    //--------------------------------------------------------------------------
    if(nCasterLevel >20)
        nCasterLevel = 20;

    if(GetIsObjectValid(oTarget))
    {
        //----------------------------------------------------------------------
        // Targeted Dispel - Dispel all
        //----------------------------------------------------------------------
          if (iTypeDispel)
             spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact);
           else
             spellsDispelMagicMod(oTarget, nCasterLevel, eVis, eImpact);
    }
    else
    {
        //----------------------------------------------------------------------
        // Area of Effect - Only dispel best effect
        //----------------------------------------------------------------------
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lLocal);
        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
        while (GetIsObjectValid(oTarget))
        {
            if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
            {
                //--------------------------------------------------------------
                // Handle Area of Effects
                //--------------------------------------------------------------
                if (iTypeDispel)
                   spellsDispelAoE(oTarget, oCaster, nCasterLevel);
                else
                   spellsDispelAoEMod(oTarget, oCaster, nCasterLevel);
 
            }
            else if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
            {
                SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_DEVOUR_MAGIC));
            }
            else
            {
                  if (iTypeDispel)
                     spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact, FALSE);
                  else
                     spellsDispelMagicMod(oTarget, nCasterLevel, eVis, eImpact, FALSE);
            }
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
        }
    }
}
