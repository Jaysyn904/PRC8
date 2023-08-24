/*
   ----------------
   Baffling Defense

   tob_stsn_bfldfsn.nss
   ----------------

    08/06/07 by Stratovarius
*/ /** @file

    Baffling Defense

    Setting Sun (Counter)
    Level: Swordsage 2
    Prerequisite: One Setting Sun maneuver
    Initiation Action: 1 Immediate Action
    Range: Personal.
    Target: You.
    Duration: 1 Round

    You crouch balanced on one foot, hands held high over your head.
    Your foe hesistates, unsure of how to attack you in this unlikely stance.
    
    You make a Sense Motive. If it is higher than your armour class, the result
    of the roll becomes your armour class until the end of the round.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

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
	int nAC = GetDefenderAC(oInitiator, oTarget);
	// Skill check
	int nAttack = GetSkillRank(SKILL_SENSE_MOTIVE, oInitiator) + d20();
	if (GetLocalInt(oInitiator, "EventideBaffle")) nAttack = 99;
	// Add bonus if greater
	if (nAttack > nAC)
	{
		int nBonus = nAttack - nAC;
		effect eAC = EffectLinkEffects(EffectACIncrease(nBonus), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eAC), oTarget, 6.0);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_AC_BONUS), oTarget);
	}
    }
}