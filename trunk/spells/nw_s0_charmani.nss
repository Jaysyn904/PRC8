//::///////////////////////////////////////////////
//:: [Charm Person or Animal]
//:: [nw_s0_charmani.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
Charm Person
Enchantment (Charm) [Mind-Affecting]
Level:            Brd 1, Sor/Wiz 1
Components:       V, S
Casting Time:     1 standard action
Range:            Close (25 ft. + 5 ft./2 levels)
Target:           One humanoid creature
Duration:         1 hour/level
Saving Throw:     Will negates
Spell Resistance: Yes

This charm makes a humanoid creature regard you as
its trusted friend and ally (treat the target’s
attitude as friendly). If the creature is currently
being threatened or attacked by you or your allies,
however, it receives a +5 bonus on its saving throw.

The spell does not enable you to control the
charmed person as if it were an automaton, but it
perceives your words and actions in the most
favorable way. You can try to give the subject
orders, but you must win an opposed Charisma check
to convince it to do anything it wouldn’t
ordinarily do. (Retries are not allowed.) An
affected creature never obeys suicidal or obviously
harmful orders, but it might be convinced that
something very dangerous is worth doing. Any act by
you or your apparent allies that threatens the
charmed person breaks the spell. You must speak the
person’s language to communicate your commands, or
else be good at pantomiming.

*/
//:://////////////////////////////////////////////
//:: Will save or the target is dominated for 1 round
//:: per caster level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 29, 2001
//:://////////////////////////////////////////////
//:: modified by mr_bumpkin Dec 4, 2003

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int CasterLvl = PRCGetCasterLevel(oCaster);
    int nPenetr = CasterLvl + SPGetPenetr();
    int nRacial = MyPRCGetRacialType(oTarget);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDuration = 2  + CasterLvl/3;
    nDuration = PRCGetScaledDuration(nDuration, oTarget);
    //Meta magic duration check
    if(nMetaMagic & METAMAGIC_EXTEND)
        nDuration *= 2;

    effect eVis   = EffectVisualEffect(VFX_IMP_CHARM);
    effect eCharm = EffectCharmed();
           eCharm = PRCGetScaledEffect(eCharm, oTarget);
    effect eMind  = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur   = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    //Link the charm and duration visual effects
    effect eLink  = EffectLinkEffects(eMind, eCharm);
           eLink  = EffectLinkEffects(eLink, eDur);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire spell cast at event to fire on the target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CHARM_PERSON_OR_ANIMAL, FALSE));
        //Make SR Check
        if (!PRCDoResistSpell(oCaster, oTarget, nPenetr))
        {
            //Make sure the racial type of the target is applicable
            if(PRCAmIAHumanoid(oTarget) ||
               nRacial == RACIAL_TYPE_ANIMAL)
            {
                //Make Will Save
                if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, oCaster), SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //Apply impact effects and linked duration and charm effect
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration), TRUE, SPELL_CHARM_PERSON_OR_ANIMAL, CasterLvl);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        }
    }
    PRCSetSchool();
}
