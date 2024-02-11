//::///////////////////////////////////////////////
//:: Confusion
//:: nw_s0_confusion.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Enchantment (Compulsion) [Mind-Affecting]
Level: Brd 3, Sor/Wiz 4, Trickery 4
Components: V, S, M/DF
Casting Time: 1 standard action
Range: Medium (100 ft. + 10 ft./level)
Targets: All creatures in a 15-ft. radius burst
Duration: 1 round/level
Saving Throw: Will negates
Spell Resistance: Yes


This spell causes the targets to become confused,
making them unable to independently determine
what they will do.

Roll on the following table at the beginning of
each subject’s turn each round to see what the
subject does in that round.
d%     Behavior
01-10  Attack caster with melee or ranged weapons
       (or close with caster if attack is not possible).
11-20  Act normally.
21-50  Do nothing but babble incoherently.
51-70  Flee away from caster at top possible speed.
71-100 Attack nearest creature (for this purpose,
       a familiar counts as part of the subject’s self).

A confused character who can’t carry out the
indicated action does nothing but babble
incoherently. Attackers are not at any special
advantage when attacking a confused character.
Any confused character who is attacked
automatically attacks its attackers on its next
turn, as long as it is still confused when its
turn comes. Note that a confused character will
not make attacks of opportunity against any
creature that it is not already devoted to
attacking (either because of its most recent
action or because it has just been attacked).

Arcane Material Component
A set of three nut shells.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 30 , 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 25, 2001
//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    int CasterLvl = PRCGetCasterLevel(oCaster);
    int nPenetr = CasterLvl + SPGetPenetr();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDuration = CasterLvl;
    int nDur;
    float fDelay;

    //Perform metamagic checks
    if(nMetaMagic & METAMAGIC_EXTEND)
        nDuration *= 2;

    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
    effect eConfuse = PRCEffectConfused();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    //Link duration VFX and confusion effects
    effect eLink = EffectLinkEffects(eMind, eConfuse);
           eLink = EffectLinkEffects(eLink, eDur);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

    //Search through target area
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CONFUSION));
            fDelay = PRCGetRandomDelay();
            //Make SR Check and faction check
            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr, fDelay))
            {
                int nDC = PRCGetSaveDC(oTarget, oCaster);
                //Make Will Save
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster, fDelay))
                {
                    //Apply linked effect and VFX Impact
                    nDur = PRCGetScaledDuration(nDuration, oTarget);
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur), TRUE, SPELL_CONFUSION, CasterLvl));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
        //Get next target in the shape
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
    }
    PRCSetSchool();
}