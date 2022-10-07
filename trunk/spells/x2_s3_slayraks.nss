//::///////////////////////////////////////////////
//:: Slay Rakshasa
//:: x2_s3_slayraks
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    When hit by an item that cast this spell on hit
    (usually a blessed bolt), an Rakshasa is instantly
    slain

    The spell considers any creature that looks like a
    rakshasha (appearance type) or has Rakshasa in its
    Subrace field vulnerable (to cope with illusions)

*/
//:://////////////////////////////////////////////
//:: Created By: 2003-07-07
//:: Created On: Brent, Georg
//:://////////////////////////////////////////////

#include "prc_racial_const"
#include "prc_inc_combat"

void main()
{
    // route all onhit-cast spells through the unique power script (hardcoded to "prc_onhitcast")
    // in order to fix the Bioware bug, that only executes the first onhitcast spell found on an item
    // any onhitcast spell should have the check ContinueOnHitCast() at the beginning of its code
    // if you want to force the execution of an onhitcast spell script, that has the check, without routing the call
    // through prc_onhitcast, you must use ForceExecuteSpellScript(), to be found in prc_inc_spells
    if(!ContinueOnHitCastSpell(OBJECT_SELF)) return;

    object oBlessedBolt = GetSpellCastItem();
    object oRak = GetSpellTargetObject();
    effect eVis  = EffectVisualEffect(VFX_IMP_DEATH);
    effect eSlay = EffectLinkEffects(eVis,EffectDeath());

    if(!GetIsObjectValid(oBlessedBolt) || !GetIsObjectValid(oRak))
        return;

    //assume target is not a rakshasa
    int bSlay = FALSE;

    //check racial type
    switch(GetRacialType(oRak))
    {
        case RACIAL_TYPE_ZAKYA_RAKSHASA:
        case RACIAL_TYPE_RAKSHASA:
        case RACIAL_TYPE_NAZTHARUNE_RAKSHASA:
            bSlay = TRUE;
            break;
    }

    //check appearance
    switch(GetAppearanceType(oRak))
    {
        case APPEARANCE_TYPE_RAKSHASA_TIGER_FEMALE:
        case APPEARANCE_TYPE_RAKSHASA_TIGER_MALE:
        case APPEARANCE_TYPE_RAKSHASA_BEAR_MALE:
        case APPEARANCE_TYPE_RAKSHASA_WOLF_MALE:
            bSlay = TRUE;
            break;
    }

    //check subrace
    if (FindSubString(GetStringLowerCase(GetSubRace(oRak)), "rakshasa", 0) > -1)
        bSlay = TRUE;

    if(bSlay)
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eSlay,oRak);
}
