/*
   ----------------
   Lingering Inferno

   tob_dw_lpngflm.nss
   ----------------

    31/08/07 by Stratovarius
*/ /** @file

    Lingering Inferno

    Desert Wind (Strike) [Fire]
    Level: Swordsage 5
    Prerequisite: Two Desert Wind Maneuvers
    Initiation Action: 1 Standard Action
    Range: Melee
    Target: One creature
    Duration: 3 rounds; see text

    A blue, dancing flame appears on your weapon. As you strike your foe,
    this flame slides off your weapon and covers your enemy in raging fire.
    
    You make a single melee attack that deals an extra 2d6 fire damage. If it hits
    the foe takes 2d6 fire damage again in each of the next three rounds.
    This is a supernatural maneuver.
*/

#include "tob_inc_move"
#include "tob_movehook"

void TOBAttack(object oTarget, object oInitiator)
{
    effect eNone = EffectVisualEffect(VFX_IMP_FLAME_M);
    int nDamage = d6(2);
    if (GetLocalInt(oInitiator, "DesertFire")) nDamage += d6();
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, nDamage, DAMAGE_TYPE_FIRE, "Lingering Inferno Hit", "Lingering Inferno Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    {
    	// Making sure we reroll damage each time.
		effect eDam = EffectLinkEffects(EffectDamage(d6(2), DAMAGE_TYPE_FIRE), eNone);
		DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
		eDam = EffectLinkEffects(EffectDamage(d6(2), DAMAGE_TYPE_FIRE), eNone);
		DelayCommand(12.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
		eDam = EffectLinkEffects(EffectDamage(d6(2), DAMAGE_TYPE_FIRE), eNone);
		DelayCommand(18.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
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