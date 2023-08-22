/*
   ----------------
   Strength Draining Strike

   tob_sdhd_strdrn
   ----------------

   15/07/07 by Stratovarius
*/ /** @file

    Strength Draining Strike

    Shadow Hand (Strike)
    Level: Swordsage 3
    Prerequisite: One Shadow Hand maneuver.
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creatures
    Save: Fort partial, see text.

    Liquid, black energy covers your weapon. As you strike your opponent,
    this material flows into the wound, spreads along his veins, and leaves 
    him weakened.
    
    You make a single melee attack. If it is successful, the target takes 4 strength damage.
    If the target succeeds on a Fortitude save, it takes 2 damage.
    This is a supernatural maneuver.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
    	effect eNone;
    	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Strength Draining Strike Hit", "Strength Draining Strike Miss");
       
        if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
    		int nDC = 13 + GetAbilityModifier(ABILITY_WISDOM, oInitiator);
    		int nDamage = 4;
		if (PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
			nDamage = 2;
		ApplyAbilityDamage(oTarget, ABILITY_STRENGTH,     nDamage, DURATION_TYPE_PERMANENT);    
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oTarget);
    	}
}

void main()
{
    if (!PreManeuverCastCode())
    {
    // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
    	DelayCommand(0.0, TOBAttack(oTarget, oInitiator));
    }
}