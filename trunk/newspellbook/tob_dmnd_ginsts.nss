//////////////////////////////////////////////////
//  Greater Insightful Strike
//  tob_dmnd_ginsts.nss
//  Tenjac 
//////////////////////////////////////////////////
/** @file Greater Insightful Strike
Diamond Mind (Strike)
Level: Swordsage 6, warblade 6
Prerequisite: Two Diamond Mind maneuvers
Initiation Action: 1 standard action
Range: Melee attack
Target: One creature

Your keen eye picks out the slightest imperfection in your opponent's defenses.
Your weapon becomes a tool of your mind.

This maneuver functions like insightful strike, except that you deal damage
equal to 2x your Concentration check result.
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
                
                effect eNone;
                object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
                int nAB = 0;
    			if (GetLocalInt(oInitiator, "SupernalAttack")) nAB += 1;
                if (GetAttackRoll(oTarget, oInitiator, oWeap, 0, nAB) > 0)
                {
                        int nDam = (GetSkillRank(SKILL_CONCENTRATION, oInitiator) + d20());
                        int nDamType = GetWeaponDamageType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator));
                        
                        effect eLink = EffectLinkEffects(EffectDamage((nDam*2), nDamType), EffectVisualEffect(VFX_COM_HIT_POSITIVE));
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
                }
        }
}               