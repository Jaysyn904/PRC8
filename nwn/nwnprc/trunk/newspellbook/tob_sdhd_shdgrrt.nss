/*
   ----------------
   Shadow Garrote

   tob_sdhd_shdgrrt
   ----------------

   15/07/07 by Stratovarius
*/ /** @file

    Shadow Garrote

    Shadow Hand (Strike) 
    Level: Swordsage 3
    Prerequisite: One Shadow Hand maneuver
    Initiation Action: 1 Standard Action
    Range: 60'
    Target: One Living Creature
    Duration: See text.
    Save: Fortitude partial.

    With a subtle gesture, you carve a slice of shadow and cast it towards your foe.
    It wraps around the creature's neck and squeeze the life from it.
    
    If successful on a ranged touch attack, you deal 5d6 damage. It must make a Fortitude save or be flat-footed for one round.
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
        SignalEvent(oTarget, EventSpellCastAt(oInitiator, PRCGetSpellId()));
        effect eRay = EffectBeam(VFX_BEAM_EVIL, oInitiator, BODY_NODE_HAND);
        
        int iAttackRoll = PRCDoRangedTouchAttack(oTarget);;
        if(iAttackRoll > 0)
        {        
                //Apply the VFX impact
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7,FALSE);

                if(PRCGetIsAliveCreature(oTarget))
                {    
                    // perform ranged touch attack and apply sneak attack if any exists
                    ApplyTouchAttackDamage(oInitiator, oTarget, iAttackRoll, d6(5), DAMAGE_TYPE_MAGICAL);
   
                    //Apply the flat-footed effect
                    int nDC = 13 + GetAbilityModifier(ABILITY_WISDOM, oInitiator);
                    if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                    {
                        AssignCommand(oTarget, ClearAllActions(TRUE));
                    }
                }
        }
    }
}