//::///////////////////////////////////////////////
//:: Mordenkainen's Disjunction
//:: NW_S0_MordDisj.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Massive Dispel Magic and Spell Breach rolled into one
    If the target is a general area of effect they lose
    6 spell protections.  If it is an area of effect everyone
    in the area loses 2 spells protections.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:: Updated On: Oct 20, 2003, Georg Zoeller
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "inc_dispel"  


void StripEffects(int nNumber, object oTarget);




void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);
    //--------------------------------------------------------------------------
    /*
      Spellcast Hook Code
      Added 2003-06-20 by Georg
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more
    */
    //--------------------------------------------------------------------------
    if (!X2PreSpellCastCode())
    {
        return;
    }
    // End of Spell Cast Hook

     effect  eVis        = EffectVisualEffect(VFX_IMP_HEAD_ODD);
    effect   eImpact     = EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION);
    object   oTarget     = PRCGetSpellTargetObject();
    location lLocal      = PRCGetSpellTargetLocation();
    int      nCasterLevel= PRCGetCasterLevel(OBJECT_SELF);
    int iTypeDispel = GetLocalInt(GetModule(),"BIODispel");


    //--------------------------------------------------------------------------
    // Mord's is not capped anymore as we can go past level 20 now
    //--------------------------------------------------------------------------
    /*
        if(nCasterLevel > 20)
        {
            nCasterLevel = 20;
        }
    */

    if (GetIsObjectValid(oTarget))
    {
        //----------------------------------------------------------------------
        // Targeted Dispel - Dispel all
        //----------------------------------------------------------------------
          if (iTypeDispel)
             spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact,TRUE,TRUE);
           else
             spellsDispelMagicMod(oTarget, nCasterLevel, eVis, eImpact,TRUE,TRUE);

    }
    else
    {
        //----------------------------------------------------------------------
        // Area of Effect - Only dispel best effect
        //----------------------------------------------------------------------

        //Apply the VFX impact and effects
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
                     spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact, FALSE,TRUE);
                  else
                     spellsDispelMagicMod(oTarget, nCasterLevel, eVis, eImpact, FALSE,TRUE);
            }

           oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

