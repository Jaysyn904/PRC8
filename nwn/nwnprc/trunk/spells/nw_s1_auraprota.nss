//::///////////////////////////////////////////////
//:: Aura of Protection: On Enter
//:: NW_S1_AuraProtA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Acts as a double strength Magic Circle against
    evil and a Minor Globe for those friends in
    the area.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:Jan 8, 2002, 2001
//:://////////////////////////////////////////////
#include "prc_inc_spells"
//#include "wm_include"
void main()
{
    //Declare major variables
    effect eProt = PRCCreateProtectionFromAlignmentLink(ALIGNMENT_EVIL);
    effect eGlobe = EffectSpellLevelAbsorption(3, 0);
    effect eDur = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);

    effect eLink = EffectLinkEffects(eProt, eGlobe);
    eLink = EffectLinkEffects(eLink, eDur);

    object oTarget = GetEnteringObject();
    //if (NullMagicOverride(GetArea(oTarget), oTarget, oTarget)) {return;}
    //Faction Check
    if(GetIsFriend(oTarget, GetAreaOfEffectCreator()))
    {
        //Apply the VFX impact and effects
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
    }
}
