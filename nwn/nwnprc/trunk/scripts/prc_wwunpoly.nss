//::///////////////////////////////////////////////
//:: Removing Polymorph Effect, and Summoned Wolf on Level
//:: prc_wwunpoly
//:: Copyright (c) 2004 Shepherd Soft
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Russell S. Ahlstrom
//:: Created On: May 14, 2004
//:: Updated On: 2012 11-27 (Added check for PnP Shifter Polymorphing instead of Bioware)
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "prc_feat_const"

#include "pnp_shft_poly"
#include "prc_inc_template"
#include "prc_inc_wwolf"


void main()
{
    object oPC = OBJECT_SELF;
    int bTemplateTransition = PRCWWHasTemplate(oPC)
        && (GetLocalInt(oPC, PRC_WW_FORM_TRANSITION)
            || GetLocalInt(oPC, "WWWolf")
            || GetLocalInt(oPC, "WWHybrid")
            || PRCWWGetActiveForm(oPC) != PRC_WW_FORM_NONE
            || PRCWWHasTemplateFormEffect(oPC));

    if(bTemplateTransition)
        PRCWWBeginFormTransition(oPC);

    // The template hybrid uses PRC-style appearance shifting so worn gear
    // remains real equipment. It does not belong to the generic PnP shifter.
    if(PRCWWHasHybridData(oPC))
    {
        PRCWWRemoveHybrid(oPC);
        PRCWWRemoveFormSpeed(oPC);
        PRCWWUpdateTemplateSkin(oPC, FALSE);
        PRCWWQueueFormTransitionEval(oPC);
        return;
    }

    // If currently flagged as shifted, then play the polymorph FX, since ShifterCheck/UnShift does not play FX
    if (GetPersistantLocalInt(oPC,"nPCShifted"))
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POLYMORPH), oPC);

    // Check if a shifter, and if shifted then UnShift
    // Alwasy perform this check, even if not using the PnP Shifting for Werewolf, 
    // since it doens't hurt, and acts as a safety for flipping the module flag after shifting
    ShifterCheck(oPC);


    effect ePoly = GetFirstEffect(oPC);
    while (GetIsEffectValid(ePoly))
    {
        if (GetEffectType(ePoly) == EFFECT_TYPE_POLYMORPH)
        {
            RemoveEffect(oPC, ePoly);
            break;
        }
        ePoly = GetNextEffect(oPC);
    }

    // The old class's Wolf Empathy feat summons a wolf and expects it to be
    // dismissed here. The 3.0 template uses passive empathy instead.
    if(!PRCWWHasTemplate(oPC))
    {
        object oWolf = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);
        int nCount = 1;
        while (GetIsObjectValid(oWolf))
        {
            if (GetName(oWolf) == "Wolf")
            {
                effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oWolf);
                DelayCommand(2.3, DestroyObject(oWolf));
                IncrementRemainingFeatUses(oPC, FEAT_PRESTIGE_WOLF_EMPATHY);
                break;
            }
            nCount++;
            oWolf = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, nCount);
        }
    }

    if(bTemplateTransition)
        PRCWWQueueFormTransitionEval(oPC);
}
