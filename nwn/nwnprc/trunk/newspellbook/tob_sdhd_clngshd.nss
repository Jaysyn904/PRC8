/*
   ----------------
   Clinging Shadow Strike

   tob_sdhd_clngshd
   ----------------

   31/03/07 by Stratovarius
*/ /** @file

    Clinging Shadow Strike

    Shadow Hand (Strike)
    Level: Swordsage 1
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature
    Saving Throw: Fortitude Partial.

    You weapon transforms into solid darkness. When it strikes home,
    it discharges in a swirling orb of shadow that engulfs your foe's eyes.
    
    Your attack deals an additional 1d6 damage. If the foe fails a Fort save vs 11 + Wisdom modifier
    the foe suffers a 20% miss chance for one round.
    This is a supernatural maneuver.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
	int nDamage = d6();
    	int nDamageType = DAMAGE_TYPE_MAGICAL;
    	
    	effect eNone;
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, nDamage, nDamageType, "Clinging Shadow Strike Hit", "Clinging Shadow Strike Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
    		int nDC = 11 + GetAbilityModifier(ABILITY_WISDOM, oInitiator);
			
			int nBladeMed = HasBladeMeditationForDiscipline(oInitiator, GetDisciplineByManeuver(PRCGetSpellId()));
			if (nBladeMed)
			{
				nDC += 1;
			}		
			
			// Saving Throw
    		if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
    		{
			effect eLink = SupernaturalEffect(EffectVisualEffect(VFX_IMP_HEAD_EVIL));
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
			eLink = SupernaturalEffect(EffectMissChance(20));
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
		}
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