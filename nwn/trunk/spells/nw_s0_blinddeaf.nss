//::///////////////////////////////////////////////
//:: Blindness/Deafness
//:: [NW_S0_BlindDead.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
Necromancy
Level:            Brd 2, Clr 3, Sor/Wiz 2
Components:       V
Casting Time:     1 standard action
Range:            Medium (100 ft. + 10 ft./level)
Target:           One living creature
Duration:         Permanent (D)
Saving Throw:     Fortitude negates
Spell Resistance: Yes

You call upon the powers of unlife to render the
subject blinded or deafened, as you choose.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////
//:: modified by mr_bumpkin Dec 4, 2003

//TODO: convert to subradials

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    //Declare major varibles
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int CasterLvl = PRCGetCasterLevel(oCaster);
    int nPenetr = CasterLvl + SPGetPenetr();

    float fDuration = RoundsToSeconds(CasterLvl);
    //Metamagic check for duration
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2;

    effect eVis   = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);

    effect eBlind = EffectBlindness();
    effect eDeaf  = EffectDeaf();
    effect eDur   = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink  = EffectLinkEffects(eBlind, eDeaf);
           eLink  = EffectLinkEffects(eLink, eDur);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BLINDNESS_AND_DEAFNESS));
        //Do SR check
        if (!PRCDoResistSpell(oCaster, oTarget, nPenetr) && PRCGetIsAliveCreature(oTarget))
        {
            // Make Fortitude save to negate
            if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget, oCaster)))
            {

                //Apply visual and effects
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, SPELL_BLINDNESS_AND_DEAFNESS, CasterLvl);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
    PRCSetSchool();
}
