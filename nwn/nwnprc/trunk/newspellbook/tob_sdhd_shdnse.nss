//////////////////////////////////////////////////
// Shadow Noose
// tob_sdhd_shdnse.nss
// Tenjac   12/12/07
//////////////////////////////////////////////////
/** @file Shadow Noose
Shadow Hand (Strike)
Level: Swordsage 6
Initiation Action: 1 standard action
Range: 60 ft.
Target: One flat-footed living creature
Duration: 1 round
Saving Throw: Fortitude partial
As your foe struggles to ready his defenses, you make a subtle gesture in the air. A noose 
formed of shadow drops from above him, wraps around his throat, and hoists him aloft. His limbs 
flail as he struggles to free himself from the strangling noose.

As part of this maneuver, you form a noose of shadow that wraps around your target and strangles him.
This maneuver only works against a flat-footed target. As part of this maneuver, you make a ranged
touch attack against a flat-footed creature within range. If it hits, your opponent takes 8d6 points 
of damage. In addition, he must make a Fortitude save (DC 16 + your Wis modifier) or be stunned for 1
round. A successful save negates the stun, but not the extra damage. This strike has no effect against
non-living creatures, such as constructs and the undead.
This maneuver is a supernatural ability.

*/
#include "tob_inc_move"
#include "tob_movehook"
#include "prc_inc_sp_tch"

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
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(oInitiator, PRCGetSpellId()));
                effect eRay = EffectBeam(VFX_BEAM_EVIL, oInitiator, BODY_NODE_HAND);
                
                
                int iAttackRoll = PRCDoRangedTouchAttack(oTarget);;
                if(iAttackRoll > 0)
                {       
                        //Apply the VFX impact
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7,FALSE);

                        if(GetIsDeniedDexBonusToAC(oTarget, oInitiator) && PRCGetIsAliveCreature(oTarget))
                        {     
                                // perform ranged touch attack and apply sneak attack if any exists
                                ApplyTouchAttackDamage(oInitiator, oTarget, iAttackRoll, d6(8), DAMAGE_TYPE_MAGICAL);
                        
                                //Apply the stun effect
                                int nDC = 16 + GetAbilityModifier(ABILITY_WISDOM, oInitiator);  
								
								int nBladeMed = HasBladeMeditationForDiscipline(oInitiator, GetDisciplineByManeuver(PRCGetSpellId()));
								if (nBladeMed)
								{
									nDC += 1;
								}
								
                                if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                                {
                                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, RoundsToSeconds(1));                                
                                }
                        }
                }
        }
}