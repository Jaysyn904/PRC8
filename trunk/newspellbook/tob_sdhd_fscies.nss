//////////////////////////////////////////////////
// Five-Shadow Creeping Ice Enervation Strike
// tob_sdhd_fscies.nss
// Tenjac   12/7/07
//////////////////////////////////////////////////
/** @file Five-Shadow Creeping Ice Enervation Strike
Shadow Hand (Strike)
Level: Swordsage 9
Prerequisite: Five Shadow Hand maneuvers
Initiation Action: 1 standard action
Range: Melee attack
Target: One creature
Duration: 1 minute
Saving Throw: Fortitude partial; see text

With a single lunge, you pierce your enemy to the core. A shadow of ultimate cold falls over
his heart and begins to worm through his veins to the five points of his body.

As part of this maneuver, you make a single melee attack. If you hit, you deal normal melee 
damage plus an extra 15d6 points of damage, and a shadow spreads out from your enemy’s heart, 
freezing the blood in his veins.

Roll a d20 and refer to the information below to determine toward which point of his body the 
freezing shadow spreads. This effect functions even if your opponent is not humanoid; once you 
have struck your foe’s heart, the shadow produces the same effects even in a creature with a 
different anatomy.

Result of 1-7: Spreads out to legs. Ability damage: 2d6 Dex. Special effect: Speed is reduced to 0 feet.

Result of 8-14: Spreads out to arms. Ability damage: 2d6 Str. Special effect: -6 penalty on attack rolls
and Concentration checks.

Result of 15-20: Struck in the heart. Ability damage: 2d6 Dex, 2d6 Str. Special effect: 2d6 points of 
Constitution damage.

A foe struck by this attack must make a successful Fortitude save (DC 19 + your Wis modifier)
to resist its effects. On a successful save, the target ignores any special effect from the attack 
and takes half the indicated ability damage (but still takes normal melee damage as well as the extra
15d6 points of damage). Each of the special effects lasts for 1d6 rounds.
This maneuver is a supernatural ability.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
		object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
                effect eNone = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_GREASE);
                PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, d6(15), GetWeaponDamageType(oWeap), "Five-Shadow Creeping Ice Enervation Strike Hit", "Five-Shadow Creeping Ice Enervation Strike Miss");
                
                if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack") && PRCGetIsAliveCreature(oTarget))
                {
                        // Saving Throw
                        int nSave = PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (19 + GetAbilityModifier(ABILITY_WISDOM, oInitiator)));
                        int nRoll = d20(1);
                        int nDam;
                        
                        //Legs
                        if(nRoll < 8)
                        {
                                if(!nSave)
                                {
                                        ApplyAbilityDamage(oTarget, ABILITY_DEXTERITY, d6(2), DURATION_TYPE_TEMPORARY, FALSE, -1.0);
                                        effect eImm = SupernaturalEffect(EffectCutsceneImmobilize());                                                                                
                                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImm, oTarget, RoundsToSeconds(d6(1)));
                                }
                                
                                else ApplyAbilityDamage(oTarget, ABILITY_DEXTERITY, d6(1), DURATION_TYPE_TEMPORARY, FALSE, -1.0);
                        }
                        
                        //Arms                        
                        else if (nRoll > 7 && nRoll < 15)
                        {
                                if(!nSave)
                                {
                                        ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, d6(2), DURATION_TYPE_TEMPORARY, FALSE, -1.0);
                                        effect ePen = SupernaturalEffect(EffectAttackDecrease(6));
                                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePen, oTarget, RoundsToSeconds(d6(1)));
                                }
                                
                                else ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, d6(1), DURATION_TYPE_TEMPORARY, FALSE, -1.0);
                        }
                        
                        //Heart; owie
                        else
                        {
                                if(!nSave)
                                {
                                        ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, d6(2), DURATION_TYPE_TEMPORARY, FALSE, -1.0);
                                        ApplyAbilityDamage(oTarget, ABILITY_DEXTERITY, d6(2), DURATION_TYPE_TEMPORARY, FALSE, -1.0);
                                        ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, d6(2), DURATION_TYPE_TEMPORARY, FALSE, -1.0);
                                }
                                
                                else
                                {
                                         ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, d6(1), DURATION_TYPE_TEMPORARY, FALSE, -1.0);
                                         ApplyAbilityDamage(oTarget, ABILITY_DEXTERITY, d6(1), DURATION_TYPE_TEMPORARY, FALSE, -1.0);
                                }
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
                                        
                                     
                                
                                
                                        
                                        
                                
                                                      