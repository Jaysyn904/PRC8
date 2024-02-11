/*
   ----------------
   Fan the Flames

   tob_dw_fnflms
   ----------------

   15/07/07 by Stratovarius
*/ /** @file

    Fan the Flames

    Desert Wind (Strike) [Fire]
    Level: Swordsage 3
    Prerequisite: One Desert Wind maneuver
    Initiation Action: 1 Standard Action
    Range: 30'
    Target: One Creature

    Flickering flames dance along your blade, then springs
    toward your target as you sweep your sword through the air.
    
    If successful on a ranged touch attack, you deal 6d6 fire damage.
    This maneuver is a supernatural maneuver.
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
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));
        effect eRay = EffectBeam(VFX_BEAM_FIRE, OBJECT_SELF, BODY_NODE_HAND);
        effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
        
        int iAttackRoll = PRCDoRangedTouchAttack(oTarget);;
        if(iAttackRoll > 0)
        {            
                 // perform ranged touch attack and apply sneak attack if any exists
                 int nDamage = d6(6);
                 if (GetLocalInt(oInitiator, "DesertFire")) nDamage += d6();
                 ApplyTouchAttackDamage(OBJECT_SELF, oTarget, iAttackRoll, nDamage, DAMAGE_TYPE_FIRE);
   
                 //Apply the VFX impact and damage effect
                 SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                 SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7,FALSE);
        }
    }
}