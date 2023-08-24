#include "inv_inc_invfunc"

void main()
{
    object oTarget = GetEnteringObject();
    int nCasterLevel = GetInvokerLevel(GetAreaOfEffectCreator(), CLASS_TYPE_WARLOCK);
    
    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectConcealment(50), oTarget);
    
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE , GetAreaOfEffectCreator())
        && oTarget != GetAreaOfEffectCreator()
        && GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE)
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(),
            INVOKE_NIGHTMARES_MADE_REAL));
        
        //save
		if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetInvocationSaveDC(oTarget, GetAreaOfEffectCreator(), INVOKE_NIGHTMARES_MADE_REAL), SAVING_THROW_TYPE_SPELL))
		{
            effect eEntangle = EffectLinkEffects(EffectEntangle(), EffectVisualEffect(VFX_DUR_ENTANGLE));
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEntangle, oTarget, RoundsToSeconds(nCasterLevel));
        }
    }
    
    if(oTarget != GetAreaOfEffectCreator())
    {
        itemproperty iHide = ItemPropertyBonusFeat(31); //HIPS
        object oSkin = GetPCSkin(GetAreaOfEffectCreator());
        IPSafeAddItemProperty(oSkin, iHide, RoundsToSeconds(nCasterLevel), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

}
