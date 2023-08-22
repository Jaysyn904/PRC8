/*
   ----------------
   Castigating Strike

   tob_dvsp_ctgstrk
   ----------------

    19/09/07 by Stratovarius
*/ /** @file

    Castigating Strike

    Devoted Spirit (Strike)
    Level: Crusader 7
    Prerequisite: Two Devoted Spirit maneuvers.
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    With a howling battle cry, your weapon crackles with energy. As you strike your foe
    that energy detonates in a burst that scythes through those who stand against your cause.
    
    You make a single attack against an enemy who's alignment has at least one component
    different from yours. If you hit, you deal an extra 8d6 damage. All enemies within 30 feet
    take 5d6 damage. Any creature that fails a saving throw against 17 + your charisma modifier
    takes a -2 penalty to attacks for 1 minute.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
    effect eNone;
    if(GetAlignmentGoodEvil(oInitiator) != GetAlignmentGoodEvil(oTarget)
    || GetAlignmentLawChaos(oInitiator) != GetAlignmentLawChaos(oTarget))
    {
        PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, d6(8), 0, "Castigating Strike Hit", "Castigating Strike Miss");
        if(GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
        {
            // Saving Throw for the primary target
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (17 + GetAbilityModifier(ABILITY_CHARISMA, oInitiator))))
            {
                effect eLink = ExtraordinaryEffect(EffectVisualEffect(VFX_IMP_HEAD_EVIL));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
                effect eLink2 = EffectAttackDecrease(2);
                       eLink2 = EffectLinkEffects(eLink2, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
                       eLink2 = EffectLinkEffects(eLink2, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, 60.0);
            }

            //Get the first target in the radius around the caster
            object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), GetLocation(oTarget), TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oAreaTarget))
            {
                if(oAreaTarget != oInitiator && oAreaTarget != oTarget)
                {
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));
                    if(GetIsEnemy(oAreaTarget, oInitiator))
                    {
                        int nDam = d6(5);
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam), oAreaTarget);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M_PURPLE), oAreaTarget);

                        // Saving Throw for the secondary targets
                        if(!PRCMySavingThrow(SAVING_THROW_FORT, oAreaTarget, (17 + GetAbilityModifier(ABILITY_CHARISMA, oInitiator))))
                        {
                            effect eLink = ExtraordinaryEffect(EffectVisualEffect(VFX_IMP_HEAD_EVIL));
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oAreaTarget);
                            effect eLink2 = EffectAttackDecrease(2);
                                eLink2 = EffectLinkEffects(eLink2, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
                                eLink2 = EffectLinkEffects(eLink2, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));             
                            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oAreaTarget, 60.0);
                        }
                    }
                }
                //Get the next target in the specified area around the caster
                oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), GetLocation(oTarget), TRUE, OBJECT_TYPE_CREATURE);
            }
        }
    }
    else    // No alignment different
        PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Hit", "Miss");
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