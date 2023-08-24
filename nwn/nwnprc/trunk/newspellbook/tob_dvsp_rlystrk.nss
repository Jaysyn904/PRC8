/*
   ----------------
   Rallying Strike

   tob_dvsp_rlystrk
   ----------------

    19/09/07 by Stratovarius
*/ /** @file

    Rallying Strike

    Devoted Spirit (Strike)
    Level: Crusader 6
    Prerequisite: Two Devoted Spirit maneuvers.
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    Your weapon blazes with divine energy as you smite your enemy.
    The energy discharges in a great pulse, sweeping over your allies
    and mending their wounds.
    
    You make a single attack against an enemy who's alignment has at least one component
    different from yours. If you hit, you and all allies within 30 feet is healed 3d6 + 1 per
    initiator level (max of +15).
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator, struct maneuver move)
{
        effect eNone;
    PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Rallying Strike Hit", "Rallying Strike Miss");
    if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    {
        if (GetAlignmentGoodEvil(oInitiator) != GetAlignmentGoodEvil(oTarget) || 
            GetAlignmentLawChaos(oInitiator) != GetAlignmentLawChaos(oTarget))
        {
            //Get the first target in the radius around the caster
            oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), GetLocation(oInitiator), TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oTarget))
            {
                if(GetIsFriend(oTarget, oInitiator))
                {
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));
                    int nHeal = d6(3) + min(move.nInitiatorLevel, 50);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_L_LAW), oTarget);
                }
                //Get the next target in the specified area around the caster
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), GetLocation(oInitiator), TRUE, OBJECT_TYPE_CREATURE);
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
        DelayCommand(0.0, TOBAttack(oTarget, oInitiator, move));
    }
}