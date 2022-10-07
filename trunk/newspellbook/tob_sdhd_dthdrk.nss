//////////////////////////////////////////////////
// Death in the Dark
// tob_sdhd_dthdrk.nss
// Tenjac   12/12/07
//////////////////////////////////////////////////
/** @file Shadow Hand (Strike)
Level: Swordsage 7
Initiation Action: 1 standard action
Range: Melee attack
Target: One creature
Saving Throw: Fortitude partial

You catch your foe unaware, allowing you to deal a single, deadly strike that slays her instantly.

This maneuver functions only against a flat-footed opponent. As part of this maneuver, make a single
melee attack. If this attack hits, you deal normal damage and the target must make a Fortitude save 
(DC 17 + your Wis modifier). If the target fails this save, she takes an extra 15d6 points of damage.
If her save succeeds, she takes an extra 5d6 points of damage. This maneuver functions only against 
opponents who are vulnerable to critical hits.

*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
		effect eNone;
		PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Death in the Dark Hit", "Death in the Dark Miss");
                if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
                {
                        int nDam = d6(15);
                        
                        if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (15 + GetAbilityModifier(ABILITY_WISDOM, oInitiator)))) nDam = d6(5);
                        
                        if(!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
                        {
                                if(GetIsDeniedDexBonusToAC(oTarget, oInitiator)) 
                                {
                                        int nType = GetWeaponDamageType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator));
                                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, nType), oTarget);
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