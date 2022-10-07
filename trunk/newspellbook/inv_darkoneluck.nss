//::///////////////////////////////////////////////
//:: Name      Dark One's Own Luck
//:: FileName  inv_darkoneluck.nss
//::///////////////////////////////////////////////
/*

Least Invocation
2nd Level Spell

You are favored by the dark powers, and gain a
bonus to one saving throw equal to your Charisma
modifier. This invocation lasts for 24 hours, and
you can only affect one save at a time.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if(!PreInvocationCastCode()) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int CasterLvl = GetInvokerLevel(oCaster, GetInvokingClass());
    int nBonus = GetAbilityModifier(ABILITY_CHARISMA, oCaster);
    int nSpellID = GetSpellId();
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nSaveType;

    switch(nSpellID)
    {
        case INVOKE_DARK_ONES_OWN_LUCK_FORT:   nSaveType = SAVING_THROW_FORT;   break;
        case INVOKE_DARK_ONES_OWN_LUCK_REFLEX: nSaveType = SAVING_THROW_REFLEX; break;
        case INVOKE_DARK_ONES_OWN_LUCK_WILL:   nSaveType = SAVING_THROW_WILL;   break;
    }

    effect eSave = EffectSavingThrowIncrease(nSaveType, nBonus);
    effect eLink = EffectLinkEffects(eSave, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, FALSE));
    if(GetHasSpellEffect(INVOKE_DARK_ONES_OWN_LUCK_FORT, oTarget)
    || GetHasSpellEffect(INVOKE_DARK_ONES_OWN_LUCK_REFLEX, oTarget)
    || GetHasSpellEffect(INVOKE_DARK_ONES_OWN_LUCK_WILL, oTarget))
    {
        PRCRemoveSpellEffects(INVOKE_DARK_ONES_OWN_LUCK_FORT, oCaster, oTarget);
        PRCRemoveSpellEffects(INVOKE_DARK_ONES_OWN_LUCK_REFLEX, oCaster, oTarget);
        PRCRemoveSpellEffects(INVOKE_DARK_ONES_OWN_LUCK_WILL, oCaster, oTarget);
    }
    //Apply the VFX impact and effect
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(24),TRUE,-1,CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}