/*
   ----------------
   Stunning Strike

   prc_dalqur_stun.nss
   ----------------
    
    If your strike hits, you deal your opponent is stunned.
*/

#include "prc_inc_combat"

void main()
{
    object oPC     = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    
        if(IPGetIsMeleeWeapon(oWeapon))
        {
    		effect eNone;
		PerformAttackRound(oTarget, oPC, eNone, 0.0, 0, 0, 0, FALSE, "Stunning Strike Hit", "Stunning Strike Miss");
		if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    		{
    			// Saving Throw
    			if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (10 + GetAbilityModifier(ABILITY_WISDOM, oPC)) + (GetHitDice(oPC)/2) ))
    			{
				effect eLink = SupernaturalEffect(EffectLinkEffects(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED), EffectStunned()));
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
			}
        	}
    	}
}