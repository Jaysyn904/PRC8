//::///////////////////////////////////////////////
//:: Grease: On Enter
//:: NW_S0_GreaseA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creatures entering the zone of grease must make
    a reflex save or fall down.  Those that make
    their save have their movement reduced by 1/2.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    int nMetaMagic = PRCGetMetaMagicFeat();
    effect eVis = EffectVisualEffect(VFX_IMP_SLOW);
    effect eSlow = EffectMovementSpeedDecrease(50);
    effect eLink = EffectLinkEffects(eVis, eSlow);
	object aoeCreator = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    float fDelay = PRCGetRandomDelay(1.0, 2.2);
    
    int nPenetr = SPGetPenetrAOE(aoeCreator);
	
	// Check Extraordinary Spell Aim  
    if(GetHasFeat(FEAT_EXTRAORDINARY_SPELL_AIM, aoeCreator)  
    && GetIsFriend(oTarget, aoeCreator))  
    {  
        string sTargetID = ObjectToString(oTarget);  
        if(!GetLocalInt(OBJECT_SELF, "ExtraordinarySpellAim_" + sTargetID))  
        {  
            if(GetIsSkillSuccessful(aoeCreator, SKILL_SPELLCRAFT, 25 + PRCGetSpellLevel(aoeCreator, SPELL_GREASE)))  
            {  
                SetLocalInt(OBJECT_SELF, "ExtraordinarySpellAim_" + sTargetID, TRUE);  
                return; // Target excluded  
            }  
        }  
    }	

    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, aoeCreator))
    {
        if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
        {
            //Fire cast spell at event for the target
            SignalEvent(oTarget, EventSpellCastAt(aoeCreator, SPELL_GREASE));
            int nDC = PRCGetSaveDC(oTarget, aoeCreator);
            if(DEBUG) DoDebug("nw_s0_greasec running, SpellId: " + IntToString(PRCGetSpellId()));

            if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, (nDC), SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
            {
                //Apply reduced movement effect and VFX_Impact
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget,0.0f,FALSE);
            }
        }
    }
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	// Getting rid of the local integer storing the spellschool name
}
