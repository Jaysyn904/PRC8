//::///////////////////////////////////////////////
//:: Soul Eater: Energy Drain
//:: prc_sleat_edrain
//:://////////////////////////////////////////////
/** @file
    Implements all of the Soul Eater's Energy Drain
    -related abilities.

    Energy Drain (Su): A soul eater gains the ability to drain energy, bestowing
     negative levels upon it's victims. Beginning at 1st level, the touch of a
     soul eater bestows one negative level on it's target. At 7th level, the
     soul eater bestows two negative levels with a touch.

    Soul Strength (Su): When a 2nd-level soul eater uses it's energy drain
     ability, it gains a +4 bonus to Strenth for 24 hours.

    Soul Enhancement (Su): When a 4th-level soul eater uses it's energy drain
     ability, it gains a +2 enhancement bonus on all saving throws and skill
     checks for 24 hours.

    Soul Endurance (Su): When a 5nd-level soul eater uses it's energy drain
     ability, it gains a +4 bonus to Constitution for 24 hours.

    Soul Radiance (Su): If a 6th-level soul eater completely drains a creature
     of energy, it may adopt the creature's soul radiance, taking the victim's
     form, appearance, and abilities for 24 hours.

    Soul Agility (Su): When a 8th-level soul eater uses it's energy drain
     ability, it gains a +4 bonus to Dexterity for 24 hours.

    Soul Slave (Su): If a 9th-level soul eater completely drains a creature of
     energy, the victim becomes a wight under the command of the soul eater.

    Soul Power (Su): After a 10th-level soul eater has drained energy, all
     spell-like and supernatural abilities gain a +2 profane bonus to their
     saving throw DC for 24 hours. Further, it may use it's Soul Blast ability
     up to two times instead of one during that 24-hour period.

    @date   Modified - 04.12.2006
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_sp_tch"
#include "prc_inc_shifting"
#include "prc_spell_const"


//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

void DoEnergyDrain(object oEater, object oTarget, int nDamage);
void DoDeathDependent(object oEater, object oTarget, string sResRef, string sName);
void LevelUpWight(int nTargetLevel, object oCreature);
void IncrementMarker(object oEater);
void DecrementMarker(object oEater);


//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

void main()
{
    object oEater  = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    object oItem   = PRCGetSpellCastItem();
    effect eImpact = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    int nDrain     = GetLevelByClass(CLASS_TYPE_SOUL_EATER, oEater) < 7 ? 1 : 2;

    // Sanity check - can't affect self or dead stuff. Also, check PvP limits
    if(oTarget == oEater  ||
       GetIsDead(oTarget) ||
       !spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oEater)
       )
        return;

    // Let the target's AI know about hostile action
    SignalEvent(oTarget, EventSpellCastAt(oEater, PRCGetSpellId(), TRUE));

    int bHit = FALSE;
    if (GetIsObjectValid(oItem))
    {
        //If happening due to an On Hit Cast Spell: skip the touch attack (we've already touched when we hit)
        //Have to use local variable on the item because GetSpellCastItem() can return valid object from
        //previously cast spells that are not this spell at all.
        //TODO: Is there a better way to do this?
        bHit = GetLocalInt(oItem, "PRC_SOULEATER_ONHIT_ENERGYDRAIN");
    }
    else
    {
        // Melee touch attack to actually do anything       
        bHit = PRCDoMeleeTouchAttack(oTarget, TRUE, oEater);
    }
    
    if(bHit)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
        DoEnergyDrain(oEater, oTarget, nDrain);
    }
}

void DoEnergyDrain(object oEater, object oTarget,int nDamage)
{
    // Immunity prevents anything from actually happening
    if(!GetIsImmune(oTarget, IMMUNITY_TYPE_NEGATIVE_LEVEL))
    {
        // Apply the actual drain
        effect eDrain = SupernaturalEffect(EffectNegativeLevel(nDamage));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDrain, oTarget);

        // Update marker
        IncrementMarker(oEater);
        DelayCommand(HoursToSeconds(24), DecrementMarker(oEater));


        /// Soul X side effects
        // Clear out old effects
        PRCRemoveSpellEffects(PRCGetSpellId(), oEater, oEater);

        // Generate new effects
        int nClassLevel    = GetLevelByClass(CLASS_TYPE_SOUL_EATER, oEater);
        effect eSideEffect = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

        // Soul Strength
        if(nClassLevel >= 2)
        {
            eSideEffect = EffectLinkEffects(eSideEffect, EffectAbilityIncrease(ABILITY_STRENGTH, 4));
        }

        // Soul Enchancement
        if(nClassLevel >= 4)
        {
            eSideEffect = EffectLinkEffects(eSideEffect, EffectSavingThrowIncrease(SAVING_THROW_TYPE_ALL, 2));
            eSideEffect = EffectLinkEffects(eSideEffect, EffectSkillIncrease(SKILL_ALL_SKILLS, 2));
        }

        // Soul Endurance
        if(nClassLevel >= 5)
        {
            eSideEffect = EffectLinkEffects(eSideEffect, EffectAbilityIncrease(ABILITY_CONSTITUTION, 4));
        }

        // Soul Agility
        if(nClassLevel >= 8)
        {
            eSideEffect = EffectLinkEffects(eSideEffect, EffectAbilityIncrease(ABILITY_DEXTERITY, 4));
        }

        // Apply the gathered side effects. All the abilities are supernatural and last 24h
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            SupernaturalEffect(eSideEffect),
                            oEater,
                            HoursToSeconds(24)
                            );


        // Soul Power
        // Rebalanced to give +2 to all DCs and just double Soul Blast uses, due to it not being sanely
        // possible to find out all use-limited abilities one may have
        if(nClassLevel >= 10)
        {
            // +2 DCs
            // Handled based on "PRC_SoulEater_HasDrained" and class level in the relevant places

            // 2x special abilities uses
            //IncrementRemainingFeatUses(oEater, FEAT_SLEAT_SBLAST); // Handled via 2da instead
        }



        // Soul Radiance and Soul Slave work only if the target was killed.
        // And death by level loss only gets calculated once the script has terminated.
        // Therefore, delay by 0.0
        DelayCommand(0.0f, DoDeathDependent(oEater, oTarget, GetResRef(oTarget), GetName(oTarget)));
    }
    else
        FloatingTextStrRefOnCreature(16832115, oEater, FALSE); // "Target is immune to negative levels"
}

void DoDeathDependent(object oEater, object oTarget, string sResRef, string sName)
{
    // For anything to happen here, the target needs to be dead. And if it is, due to having only been delayed by 0
    // we know that the only reason for it's death can have been level drain
    if(GetIsDead(oTarget))
    {
        // Soul Radiance
        if(GetLevelByClass(CLASS_TYPE_SOUL_EATER, oEater) >= 6)
        {
            // If the user has toggled Soul Radiance active, use the shifting code to turn into the target
            if(GetLocalInt(oEater, "PRC_SoulEater_SoulRadianceActive"))
            {
                StoreCurrentAppearanceAsTrueAppearance(oEater, TRUE);
                ShiftIntoCreature(oEater, SHIFTER_TYPE_SOULEATER, oTarget, TRUE); // Gain special abilities
                    //TODO: only if there are uses left
            }
        }


        // Soul Slave
        if(GetLevelByClass(CLASS_TYPE_SOUL_EATER, oEater) >= 9)
        {
            int nMaxHenchmen = GetMaxHenchmen();
            int nNumSlaves   = 0;
            int nMaxSlaves   = GetPRCSwitch(PRC_SOUL_EATER_MAX_SLAVES);
            effect eSummon   = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);

            // Special switch values handling
            if(nMaxSlaves == 0 ) nMaxSlaves = 4;
            if(nMaxSlaves == -1) nMaxSlaves = 0;

            // Determine current number of slaves
            int i = 1;
            object oHench;
            do {
                oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oEater, i++);
                if(GetResRef(oHench) == "soul_wight_test")
                    nNumSlaves++;
            } while(GetIsObjectValid(oHench));

            // If we can add more wights, do so. Spawn the wight with some VFX at the corpse's location
            if(nNumSlaves < nMaxSlaves)
            {
                location lSpawn = GetLocation(oTarget);

                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSummon, lSpawn);

                object oSlave = CreateObject(OBJECT_TYPE_CREATURE, "soul_wight_test", lSpawn);
                if(GetIsObjectValid(oSlave))
                {
                    SetMaxHenchmen(PRCMax(nMaxHenchmen, i)); // Temporarily set the number of max henchmen high enough that we can add another
                    AddHenchman(oEater, oSlave);
                    SetMaxHenchmen(nMaxHenchmen);

                    // Level up the wight a bit to make it usefull. Needs to be delayed a bit to let the object creation routines happen first
                    DelayCommand(3.0f, LevelUpWight(GetHitDice(oEater) - 3, oSlave));
                }
                else if(DEBUG)
                    DoDebug("prc_sleat_edrain: ERROR: Failed to create wight at location " + DebugLocation2Str(lSpawn));
            }
        }
    }
}

void LevelUpWight(int nTargetLevel, object oCreature)
{
    int n;
    for(n = 1; n < nTargetLevel; n++)
        LevelUpHenchman(oCreature, CLASS_TYPE_INVALID, TRUE);
}

void IncrementMarker(object oEater)
{
    SetLocalInt(oEater, "PRC_SoulEater_HasDrained", GetLocalInt(oEater, "PRC_SoulEater_HasDrained") + 1);
}

void DecrementMarker(object oEater)
{
    SetLocalInt(oEater, "PRC_SoulEater_HasDrained", GetLocalInt(oEater, "PRC_SoulEater_HasDrained") - 1);
}
