/*
    ----------------
    Bone Crusher

    tob_stdr_bncrsh
    ----------------

    18/08/07 by Stratovarius
*/ /** @file

    Bone Crusher

    Stone Dragon (Strike)
    Level: Crusader 3, Swordsage 3, Warblade 3
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature
    Save: Fortitude Partial; see text

    You deliver your attack, and your enemy's eyes jerk wide open in panic as his skeleton begins to fracture in hundreds of places.
    
    You make a single attack against an enemy. If this attack his, you do an extra 4d6 damage.
    If the target fails a Fortitude save vs 13 + Strength modifier, all further strikes gain a +10 to confirm critical hits.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
    	effect eNone = EffectVisualEffect(PSI_IMP_CONCUSSION_BLAST);
    	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, d6(4), GetWeaponDamageType(oWeap), "Bone Crusher Hit", "Bone Crusher Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
			int nDC = 13 + GetAbilityModifier(ABILITY_STRENGTH, oInitiator);
			int nBladeMed = HasBladeMeditationForDiscipline(oInitiator, GetDisciplineByManeuver(PRCGetSpellId()));;
			if (nBladeMed)
			{
				nDC += 1;
			}
		// Saving Throw
    		if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
    		{
			effect eLink = SupernaturalEffect(EffectVisualEffect(VFX_IMP_HEAD_EVIL));
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
			SetLocalInt(oTarget, "BoneCrusher", TRUE);
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