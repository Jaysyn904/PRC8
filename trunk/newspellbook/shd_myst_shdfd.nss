/*
14/02/19 by Stratovarius

Shadows Fade

Initiate, Unbinding Shade 
Level/School: 4th/Abjuration 
Range: Medium (100 ft. + 10 ft./level) 
Target: One creature or object; or 20-ft.-radius burst 
Duration: Instantaneous 

You reach into shadow and draw forth the reflection of active magic, merging it with that magic and causing them to cancel each other.

This mystery functions like the spell dispel magic.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"
#include "inc_dispel"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_NONE);

    if(myst.bCanMyst)
    {
        effect    eVis         = EffectVisualEffect(VFX_IMP_BREACH);
        effect    eImpact      = EffectVisualEffect(VFX_FNF_DISPEL);
        location  lLocal       = PRCGetSpellTargetLocation();
        
        int iTypeDispel = GetLocalInt(GetModule(),"BIODispel");

        //--------------------------------------------------------------------------
        // Dispel Magic is capped at caster level 10
        //--------------------------------------------------------------------------
        int nCasterLevel = min(myst.nShadowcasterLevel, 10);
        if (myst.nMystId == MYST_SHADOWS_FADE_GREATER)
            nCasterLevel = min(myst.nShadowcasterLevel, 20);
        
        if (GetIsObjectValid(oTarget))
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
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, PRCGetSpellTargetLocation());
            oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE );
            while (GetIsObjectValid(oTarget))
            {
                if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
                {
                    //--------------------------------------------------------------
                    // Handle Area of Effects
                    //--------------------------------------------------------------
                    if (iTypeDispel)
                       spellsDispelAoE(oTarget, OBJECT_SELF,nCasterLevel);
                    else
                       spellsDispelAoEMod(oTarget, OBJECT_SELF,nCasterLevel);
                }
                else if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
                {
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
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
}