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


void main()
{
    object oPC = OBJECT_SELF;

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
