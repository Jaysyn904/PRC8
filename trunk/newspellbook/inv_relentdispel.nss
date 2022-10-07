//::///////////////////////////////////////////////
//:: Dispel Magic
//:: NW_S0_DisMagic.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: Attempts to dispel all magic on a targeted
//:: object, or simply the most powerful that it
//:: can on every object in an area if no target
//:: specified.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:: Updated On: Oct 20, 2003, Georg Zoeller
//:://////////////////////////////////////////////


#include "inv_inc_invfunc"
#include "inv_invokehook"
#include "inc_dispel"

void main()
{
    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    effect    eVis         = EffectVisualEffect(VFX_IMP_BREACH);
    effect    eImpact      = EffectVisualEffect(VFX_FNF_DISPEL);
    object    oTarget      = PRCGetSpellTargetObject();
    location  lLocal       = PRCGetSpellTargetLocation();
    int       nCasterLevel = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    int iTypeDispel = GetLocalInt(GetModule(),"BIODispel");

    //--------------------------------------------------------------------------
    // Dispel Magic is capped at caster level 10
    //--------------------------------------------------------------------------
    if(nCasterLevel > 10)
    {
        nCasterLevel = 10;
    }
    
    if (GetIsObjectValid(oTarget))
    {
        //----------------------------------------------------------------------
        // Targeted Dispel - Dispel all
        //----------------------------------------------------------------------
          if (iTypeDispel)
          {
             spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact);
             DelayCommand(RoundsToSeconds(1), spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact));
          }
          else
          {
             spellsDispelMagicMod(oTarget, nCasterLevel, eVis, eImpact);
             DelayCommand(RoundsToSeconds(1), spellsDispelMagicMod(oTarget, nCasterLevel, eVis, eImpact));
          }
  
    }
    
}



