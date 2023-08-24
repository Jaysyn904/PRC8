//::///////////////////////////////////////////////
//:: Tide of Battle
//:: x2_s0_TideBattle
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Uses spell effect to cause d100 damage to
    all enemies and friends around pc, including pc.
    (Area effect always centered on PC)
    Minimum 30 points of damage will be done to each target
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Jan 2/03
//:://////////////////////////////////////////////
//:: Updated by: Andrew Nobbs
//:: Updated on: March 28, 2003
//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetLocation(oCaster);

    effect eVis = EffectVisualEffect(VFX_IMP_DEATH_WARD);
    effect eVis2 = EffectVisualEffect(VFX_FNF_METEOR_SWARM);
    effect eDamage;
    effect eLink;
    int nDamage;
    float fDelay;

    //Apply Spell Effects
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, lTarget);

    //ApplyDamage and Effects to all targets in area
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
    while(GetIsObjectValid(oTarget))
    {
        fDelay = PRCGetRandomDelay();
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
        nDamage = d100();
        if(nDamage < 30)
            nDamage = 30;

        //Set damage type and amount
        eDamage = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_DIVINE);
        //Link visual and damage effects
        eLink = EffectLinkEffects(eVis, eDamage);
        //Apply effects to oTarget
        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));

        //Get next target in shape
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
    }
    PRCSetSchool();
}