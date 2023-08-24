//::///////////////////////////////////////////////
//:: Name      Caster's Lament
//:: FileName  inv_castlament.nss
//::///////////////////////////////////////////////
/*

Dark Invocation
8th Level Spell

With a touch you can attempt to dispel all effects
on a creature, as the break enchantment spell. The
maximum caster level for the dispel checks is 15.

*/
//::///////////////////////////////////////////////

#include "inc_dispel"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if(!PreInvocationCastCode()) return;

    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    int iTypeDispel = GetLocalInt(GetModule(), "BIODispel");
    effect eVis = EffectVisualEffect(VFX_IMP_BREACH);
    effect eImpact = EffectVisualEffect(VFX_FNF_DISPEL_GREATER);

    //--------------------------------------------------------------------------
    // Break Enchantment is capped at caster level 15
    //--------------------------------------------------------------------------
    if(nCasterLevel > 15)
        nCasterLevel = 15;

    if (GetIsObjectValid(oTarget))
    {
        //----------------------------------------------------------------------
        // Targeted Dispel - Dispel all
        //----------------------------------------------------------------------
          if(iTypeDispel)
             spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact);
          else
             spellsDispelMagicMod(oTarget, nCasterLevel, eVis, eImpact);
    }
}
