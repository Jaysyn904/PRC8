//::///////////////////////////////////////////////
//:: Web: Heartbeat
//:: NW_S0_WebC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a mass of sticky webs that cling to
    and entangle targets who fail a Reflex Save
    Those caught can make a new save every
    round.  Movement in the web is 1/5 normal.
    The higher the creatures Strength the faster
    they move within the web.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 8, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_inc_spells"
#include "prc_add_spell_dc"



void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator());


    //Declare major variables
    effect eWeb = EffectEntangle();
    effect eVis = EffectVisualEffect(VFX_DUR_WEB);
    object oTarget;
    //Spell resistance check
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
            {
            // *************
            // * Patch Fix
            // * Brent
            // * Moved the two spell cast events down after the reaction check check
                //Fire cast spell at event for the target
                SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_WEB));

                if(!PRCDoResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr))
                {
                    int nDC = PRCGetSaveDC(oTarget,GetAreaOfEffectCreator());

                    //Make a Fortitude Save to avoid the effects of the entangle.
                    if(!/*Reflex Save*/ PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, (nDC)))
                    {
                        //Entangle effect and Web VFX impact
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWeb, oTarget, RoundsToSeconds(1));
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(1));
                    }
                }
            }
        }
        oTarget = GetNextInPersistentObject();
    }
    


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
