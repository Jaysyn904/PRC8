//:://////////////////////////////////////////////
//:: FileName: "ss_ep_psionicsal"
/*   Purpose: Psionic Salvo - subject loses WIS and INT until both are at 3, or
        until the subject makes a Will saving throw.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_epicspells"

void DoSalvo(object oTarget, int nDC);

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_PSION_S))
    {
        object oTarget = PRCGetSpellTargetObject();
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget,
            EventSpellCastAt(OBJECT_SELF, SPELL_BESTOW_CURSE, FALSE));
        //Make SR Check
        if (!PRCDoResistSpell(OBJECT_SELF, oTarget, GetTotalCastingLevel(OBJECT_SELF)+SPGetPenetr(OBJECT_SELF)))
        {
            DoSalvo(oTarget, GetEpicSpellSaveDC(OBJECT_SELF, oTarget));
        }
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

void DoSalvo(object oTarget, int nDC)
{
    //Make a Will save each time
    if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
    {
        effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
        effect eWIS = EffectAbilityDecrease(ABILITY_WISDOM, 1);
        effect eINT = EffectAbilityDecrease(ABILITY_INTELLIGENCE, 1);
        eWIS = EffectLinkEffects(eWIS, eVis);
        eINT = EffectLinkEffects(eINT, eVis);
        eWIS = SupernaturalEffect(eWIS);
        eINT = SupernaturalEffect(eINT);
        if (GetAbilityScore(oTarget, ABILITY_WISDOM) > 3)
            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eWIS, oTarget);
        if (GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) > 3)
            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eINT, oTarget);
        if (GetAbilityScore(oTarget, ABILITY_WISDOM) > 3 ||
            GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) > 3)
            DelayCommand(6.0, DoSalvo(oTarget, nDC));
    }
}
