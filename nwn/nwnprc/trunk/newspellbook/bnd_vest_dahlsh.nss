/*
1/03/21 by Stratovarius

Dahlver Nar, the Tortured One
  
Once a human binder, Dahlver-Nar now grants powers just as other vestiges do. He gives his summoners tough skin, a frightening moan, protections against madness, 
and the ability to share injuries with allies.
  
Shield Self: At will as a standard action, you can designate one creature within 10 feet per effective binder level to share the damage you take. As long as the 
subject creature remains within range, you take only half damage from all effects that deal hit point damage, and it takes the rest. The effect ends immediately 
if you designate another creature or if either you or the subject dies. Any damage dealt to you after the effect ends is no longer split between you and the subject,
but damage already split is not reassigned to you. You can affect one creature at a time with this ability. An unwilling target of this ability 
can attempt a Will save to negate the effect.
*/

#include "bnd_inc_bndfunc"

void DispelMonitor(object oBinder, object oTarget, int nSpellID, int nBinderLevel);

void main()
{
    object oBinder = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nDC        = GetBinderDC(oBinder, VESTIGE_DAHLVERNAR);
    int nSpellID   = GetSpellId();
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_DAHLVERNAR);

    effect eDurPos  = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
    effect eDurNeg  = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);

    // Let the AI know
    PRCSignalSpellEvent(oTarget, TRUE, nSpellID, oBinder);

    // Save - Fortitude negates, or it's an ally
    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE) || GetIsFriend(oBinder, oTarget))
	{
    	// Get the OnHitCast: Unique on the manifester's armor / hide
    	ExecuteScript("prc_keep_onhit_a", oBinder);

    	// Hook eventscript
    	AddEventScript(oBinder, EVENT_ONHIT, "psi_pow_shrpnaux", TRUE, FALSE);

    	// Store the target for use in the damage script
    	SetLocalObject(oBinder, "PRC_Power_SharePain_Target", oTarget);

    	// Do VFX for the monitor to look for
    	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDurNeg, oTarget);
    	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDurPos, oBinder);

    	// Start effect end monitor
    	DelayCommand(6.0f, DispelMonitor(oBinder, oTarget, nSpellID, nBinderLevel));
    }	
}

void DispelMonitor(object oBinder, object oTarget, int nSpellID, int nBinderLevel)
{
    // The conditions that can end the effect
    if(GetIsDead(oTarget) ||
       GetDistanceBetween(oBinder, oTarget) > FeetToMeters(10.0 * nBinderLevel))
    {
        if(DEBUG) DoDebug("bnd_vest_dahlsh: Effect expired, clearing");
        // Clear the target local
        DeleteLocalObject(oBinder, "PRC_Power_SharePain_Target");
        // Remove the eventscript
        RemoveEventScript(oBinder, EVENT_ONHIT, "psi_pow_shrpnaux", TRUE, FALSE);

        // Remove remaining effects
        PRCRemoveSpellEffects(nSpellID, oBinder, oTarget);
        PRCRemoveSpellEffects(nSpellID, oBinder, oBinder);
    }
    else
       DelayCommand(6.0f, DispelMonitor(oBinder, oTarget, nSpellID, nBinderLevel));
}