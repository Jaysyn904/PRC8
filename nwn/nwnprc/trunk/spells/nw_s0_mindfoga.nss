//::///////////////////////////////////////////////
//:: Mind Fog: On Enter
//:: NW_S0_MindFogA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a bank of fog that lowers the Will save
    of all creatures within who fail a Will Save by
    -10.  Affect lasts for 2d6 rounds after leaving
    the fog
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
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);

    //Declare major variables
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eLower = EffectSavingThrowDecrease(SAVING_THROW_WILL, 10);
    effect eLink = EffectLinkEffects(eVis, eLower);
    int bValid = FALSE;
    float fDelay = PRCGetRandomDelay(1.0, 2.2);
    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator());

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MIND_FOG));
        //Make SR check
        effect eAOE = GetFirstEffect(oTarget);
        if(GetHasSpellEffect(SPELL_MIND_FOG, oTarget))
        {
            while (GetIsEffectValid(eAOE))
            {
                //If the effect was created by the Mind_Fog then remove it
                if (GetEffectSpellId(eAOE) == SPELL_MIND_FOG && oCaster == GetEffectCreator(eAOE))
                {
                    if(GetEffectType(eAOE) == EFFECT_TYPE_SAVING_THROW_DECREASE)
                    {
                        RemoveEffect(oTarget, eAOE);
                        bValid = TRUE;
                    }
                }
                //Get the next effect on the creation
                eAOE = GetNextEffect(oTarget);
            }
        //Check if the effect has been put on the creature already.  If no, then save again
        //If yes, apply without a save.
        }
        if(bValid == FALSE)
        {
            if(!PRCDoResistSpell(OBJECT_SELF, oTarget,nPenetr))
            {
                //Make Will save to negate
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, oCaster), SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //Apply VFX impact and lowered save effect
                    if ( GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCaster) == FALSE )
                    {
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget,0.0f,FALSE));
                    }
                }
            }
        }
        else
        {
            if ( GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCaster) == FALSE )
            {
                //Apply VFX impact and lowered save effect
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget,0.0f,FALSE);
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
