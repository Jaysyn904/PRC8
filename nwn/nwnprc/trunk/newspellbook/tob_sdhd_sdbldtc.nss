/*
   ----------------
   Shadow Blade Technique

   tob_sdhd_sdbldtc
   ----------------

   01/04/07 by Stratovarius
*/ /** @file

    Shadow Blade Technique

    Shadow Hand (Strike)
    Level: Swordsage 1
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    You weave your weapon in an elaborate pattern, creating an illusory double
    that glows with white energy. As you make your attack, both you true weapon
    and the illusion slash at your foe.
    
    You roll to attack twice, once for the normal blade and once for the double.
    The normal blade deals standard damage. If the illusion hits, it deals 1d6 cold damage.
    This is a supernatural maneuver.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

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
    	// Normal attack
    	effect eNone;
	DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Shadow Blade Technique Hit", "Shadow Blade Technique Miss"));
	// Shadow double blade
	if (GetAttackRoll(oTarget, oInitiator, GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator)))
	{
		// If we hit, do the damage
		effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_IMP_FROST_S), EffectDamage(d6(), DAMAGE_TYPE_COLD));
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
	}
	
    }
}