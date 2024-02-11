//::///////////////////////////////////////////////
//:: Cloud of Bewilderment
//:: X2_S0_CldBewldA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A cone of noxious air goes forth from the caster.
    Enemies in the area of effect are stunned and blinded
    1d6 rounds. Foritude save negates effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: November 04, 2002
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"

#include "prc_alterations"
#include "prc_add_spell_dc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    int nRounds;
    effect eStun = EffectStunned();
    effect eBlind = EffectBlindness();
    eStun = EffectLinkEffects(eBlind,eStun);
    effect eVis = EffectVisualEffect(VFX_DUR_BLIND);
    effect eFind;
    object oTarget;
    object oCreator;
    float fDelay;
    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator());

    //Get the first object in the persistant area
    oTarget = GetEnteringObject();
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF,SPELL_CLOUD_OF_BEWILDERMENT));
        //Make a SR check
        if(!PRCDoResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr))
        {
            //Make a Fort Save
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (PRCGetSaveDC(oTarget,GetAreaOfEffectCreator())), SAVING_THROW_TYPE_POISON))
            {
                if (!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))
                {
                   nRounds = d6(1);
                   fDelay = PRCGetRandomDelay(0.75, 1.75);
                   //Apply the VFX impact and linked effects
                   DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                   DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(nRounds),FALSE));
               }
            }
        }
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school

}
