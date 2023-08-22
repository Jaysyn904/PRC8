//:://////////////////////////////////////////////
//:: FileName: "ss_ep_cont_resur"
/*   Purpose: Contingent Resurrection - sets a variable on the target, so that
        in the case of their death, they will automatically resurrect.
        NOTE: This contingency will last indefinitely, unless it triggers or the
        player dispels it in the pre-rest conversation.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 13, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_epicspells"

// Brings oPC back to life, via the contingency of 'Contingent Resurrection'.
void ContingencyResurrect(object oTarget, int nCount, object oCaster);

void main()
{
    object oCaster = OBJECT_SELF;

    DeleteLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }

    if (GetCanCastSpell(oCaster, SPELL_EPIC_CON_RES))
    {
        object oTarget   = PRCGetSpellTargetObject();
        location lTarget = GetLocation(oTarget);
        effect eVis      = EffectVisualEffect(VFX_FNF_LOS_HOLY_20);
        effect eVisFail  = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
        // If the target is of a race that could be resurrected, go ahead.
        int bRaise = FALSE;


        int nMyRace = MyPRCGetRacialType(oTarget);
        int nRace = GetRacialType(oTarget);

        // PRC Shifting Polymorph -caused racial type override. Stored with offset +1 to differentiate value 0 from non-existence
        int nShiftingTrueRace = GetPersistantLocalInt(oCaster, "PRC_ShiftingTrue_Race");
        if(nShiftingTrueRace)
            nMyRace = nShiftingTrueRace - 1;

        if(nMyRace == RACIAL_TYPE_UNDEAD || nMyRace == RACIAL_TYPE_CONSTRUCT)
            bRaise = FALSE;
        else
            bRaise = TRUE;

        
        if(bRaise)
        {
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
            PenalizeSpellSlotForCaster(oCaster);
            // Start the contingency.
            SetLocalInt(oCaster, "nContingentRez", GetLocalInt(oCaster, "nContingentRez") + 1);
            ContingencyResurrect(oTarget, 1, oCaster);
        }
        else
        {
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisFail, lTarget);
            SendMessageToPC(oCaster, "Spell failed - Invalid target!");
        }
    }
    DeleteLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR");
}

void ContingencyResurrect(object oTarget, int nCount, object oCaster)
{
    // If the contingency has been turned off, terminate HB
    if(!GetLocalInt(oCaster, "nContingentRez"))
        return;
    
    // If the target isn't dead, just toss out a notice that the heartbeat is running
    if(!GetIsDead(oTarget))
    {
        nCount++;
        if((nCount % 20) == 0)
            FloatingTextStringOnCreature("*Contingency active*", oTarget, FALSE);
    }
    else // Resurrect the target, and end the contingency.
    {
        nCount = 0;
        
        effect eRez = EffectResurrection();
        effect eHea = EffectHeal(GetMaxHitPoints(oTarget) + 10);
        effect eVis = EffectVisualEffect(VFX_IMP_RAISE_DEAD);

        // Resurrect the target
        FloatingTextStringOnCreature("*Contingency triggered*", oTarget);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eRez, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHea, oTarget);

        // Bookkeeping of epic spell slots in contingent use
        RestoreSpellSlotForCaster(oCaster);
        SetLocalInt(oCaster, "nContingentRez", GetLocalInt(oCaster, "nContingentRez") - 1);

        // PW death stuff
        ExecuteScript("prc_pw_contress", oTarget);
        if(GetPRCSwitch(PRC_PW_DEATH_TRACKING) && GetIsPC(oTarget))
            SetPersistantLocalInt(oTarget, "persist_dead", FALSE);
    }

    DelayCommand(6.0, ContingencyResurrect(oTarget, nCount, oCaster)); //Schedule next heartbeat (it will terminate itself if no longer needed)
}

