//////////////////////////////////////////////////
// Enervating Shadow Strike
// tob_sdhd_enshds.nss
// Tenjac   12/14/07
//////////////////////////////////////////////////
/** @file 
Shadow Hand (Strike)
Level: Swordsage 8
Prerequisite: Three Shadow Hand maneuvers
Initiation Action: 1 standard action
Range: Melee attack
Target: One creature
Saving Throw: Fortitude negates

Your weapon becomes cloaked in an inky, black nimbus. As you strike your opponent, that energy flows 
into the wound and leaves him pale, weak, and shaking.

As part of this maneuver, you make a single melee attack. If this attack hits, the target must make a
successful Fortitude save (DC 18 + your Wis modifier) or gain 1d4 negative levels. You gain 5 temporary
hit points for each negative level your enemy gains. Temporary hit points gained in this manner last 
until the end of the encounter. The effects of any negative levels bestowed by this strike disappear 
in 24 hours.

If the target has at least as many negative levels as Hit Dice, it dies. Each negative level gives a 
creature a -1 penalty on attack rolls, saving throws, skill checks, ability checks, and effective level 
(for determining the power, duration, DC, and other details of spells or special abilities). Additionally,
a spellcaster loses one spell or spell slot from her highest available level. Negative levels stack.

In addition to the negative levels, your attack deals normal damage, even if the target succeeds on the 
saving throw.

This maneuver is a supernatural ability.

*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
		effect eNone;
                
                PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Enervating Shadow Strike Hit", "Enervating Shadow Strike Miss");
                
                if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
                {
                        int nDC = 18 + GetAbilityModifier(ABILITY_WISDOM, oInitiator);
						
						int nBladeMed = HasBladeMeditationForDiscipline(oInitiator, GetDisciplineByManeuver(PRCGetSpellId()));
						if (nBladeMed)
						{
							nDC += 1;
						}				
						
						if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
                        {
                                int nLevels = d4();
                                
                                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectNegativeLevel(nLevels), oTarget);
                                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(5 * nLevels), oInitiator);
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
                        
                        