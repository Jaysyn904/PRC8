//:://////////////////////////////////////////////
//:: FileName: "ss_ep_spellworm"
/*   Purpose: Spell Worm - the target loses one spell slot of his/her highest
        available level at the rate of 1 per round, for 20 hours, or until the
        target has no remaining spell slots available.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 11, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_epicspells"
//#include "x2_inc_spellhook"
#include "prc_getbest_inc"

void RunWorm(object oTarget, int nRoundsRemaining);

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_SP_WORM))
    {
        object oTarget = PRCGetSpellTargetObject();
        int nDuration = FloatToInt(HoursToSeconds(20) / 6);
        effect eVis = EffectVisualEffect(VFX_IMP_HEAD_MIND);
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE &&
            oTarget != OBJECT_SELF)
        {
            if (GetLocalInt(oTarget, "sSpellWormActive") != TRUE)
            {
                //Make SR check
                if (!PRCDoResistSpell(OBJECT_SELF, oTarget, GetTotalCastingLevel(OBJECT_SELF)+SPGetPenetr(OBJECT_SELF)))
                {
                     //Make Will save
                     if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetEpicSpellSaveDC(OBJECT_SELF, oTarget),
                        SAVING_THROW_TYPE_MIND_SPELLS))
                     {
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT,
                            eVis, oTarget);
                        SetLocalInt(oTarget, "sSpellWormActive", TRUE);
                        RunWorm(oTarget, nDuration);
                     }
                }
            }
        }
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

void RunWorm(object oTarget, int nRoundsRemaining)
{
    int nSpell = GetBestAvailableSpell(oTarget);
    if (nSpell != 99999)
    {
        DecrementRemainingSpellUses(oTarget, nSpell);
        nRoundsRemaining -= 1;
    }
    if (nRoundsRemaining > 0)
        DelayCommand(6.0, RunWorm(oTarget, nRoundsRemaining));
    if (nSpell == 99999 || nRoundsRemaining < 1)
        SetLocalInt(oTarget, "sSpellWormActive", FALSE);
}
