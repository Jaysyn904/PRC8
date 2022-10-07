//::///////////////////////////////////////////////
//:: Stinking Cloud
//:: NW_S0_StinkCldC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Those within the area of effect must make a
    fortitude save or be dazed.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_inc_spells"

#include "prc_add_spell_dc"


void main()
{
 DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    effect eStink = EffectDazed();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eMind, eStink);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
    effect eFind;
    object oTarget;
    object oCreator;
    float fDelay;
    
    int CasterLvl = PRCGetCasterLevel(GetAreaOfEffectCreator());
    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator(),CasterLvl);
    
    

    //Get the first object in the persistant area
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectConcealment(20), oTarget, 6.0);
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_STINKING_CLOUD));
            //Make a SR check
            if(!PRCDoResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr))
            {
                int nDC = PRCGetSaveDC(oTarget,GetAreaOfEffectCreator());
                //Make a Fort Save
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (nDC), SAVING_THROW_TYPE_POISON))
                {
                   fDelay = PRCGetRandomDelay(0.75, 1.75);
                   //Apply the VFX impact and linked effects
                   if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) == FALSE)
                   {
                     DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2)));
                   }
                }
                else
                {
                    //If the Fort save was successful remove the Dazed effect
                    eFind = GetFirstEffect(oTarget);
                    while (GetIsEffectValid(eFind))
                    {
                        if(eFind == EffectDazed())
                        {
                            oCreator = GetEffectCreator(eFind);
                            if(oCreator == GetAreaOfEffectCreator())
                            {
                                RemoveEffect(oTarget, eFind);
                            }
                        }
                        eFind = GetNextEffect(oTarget);
                    }
                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextInPersistentObject();
    }
    

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
