/*:://////////////////////////////////////////////
//:: Spell Name Telekinesis
//:: Spell FileName PHS_S_Telekinesi
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Sor/Wiz 5
    Components: V, S
    Casting Time: 1 standard action
    Range: Long (40M)
    Target or Targets: See text
    Duration: Concentration (up to 1 round/ level) or instantaneous; see text
    Saving Throw: Will negates (object) or None; see text
    Spell Resistance: Yes (object); see text

    You move objects or creatures by concentrating on them. Depending on the
    version selected, the spell can provide a gentle, sustained force, perform
    a variety of combat maneuvers, or exert a single short, violent thrust.

    Sustained Force: A sustained force moves a creauture weighing no more than
    25 pounds per caster level (maximum 375 pounds at 15th level, target
    includes equipment weight) up to 6M (20 feet) per round. A creature can
    negate the effect with a successful Will save or with spell resistance on
    inpact.

    This version of the spell can last 1 round per caster level, but it ends if
    you cease concentration. The weight is moved away from you directly. An
    object cannot be moved beyond your range. The spell ends if the object is
    forced beyond the range. If you cease concentration for any reason, the
    object stops.

    An object can be telekinetically manipulated as if with one hand. For
    example, a lever or rope can be pulled, a door can be opened, and so on, if
    the force required is within the weight limitation. This activates the
    target exactly the same as if you tried to. Any special effects will not
    happen if it requires anything more then direct movement.

    Combat Maneuver: Alternatively, once per round, you can use telekinesis to
    perform a bull rush, disarm, or knockdown. Resolve these attempts as normal,
    except that they don’t provoke attacks of opportunity, you use your caster
    level in place of your base attack bonus (for disarm and grapple), you use
    your Intelligence modifier (if a wizard) or Charisma modifier (if a sorcerer)
    in place of your Strength or Dexterity modifier. No save is allowed against
    these attempts, but spell resistance applies normally. This version of the
    spell can last 1 round per caster level, but it ends if you cease
    concentration, or if the target cannot be bull rushed, disarmed or knocked
    down as appropriate.

    Violent Thrust: Alternatively, the spell energy can be spent in a single
    round. You can hurl one enemy creature per caster level (maximum 15) that
    are within a 5M-radius sphere at the target location, backwards up to
    1.33M/caster level, to the maxium range of the spell, directly away from
    the caster. You can hurl up to a total weight of 25 pounds per caster level
    (maximum 375 pounds at 15th level), which must be distributed among all the
    targets, the lowest weight enemy creatures are targeted first.

    Creatures who fall within the weight capacity of the spell can be hurled,
    but they are allowed Will saves (and spell resistance) to negate the effect.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Ok, 5 sub-dial spells.

    4 are concentration based, all use this script.

    ---------
    Effect 1: Force each round. Each round, they are forced back (with a
    SR and save check in the first round) for a number of rounds equal to
    concentration. Might need to make the save each round (I'm not sure how
    its how it'd work compared to the 3.5E rules version however, that seems
    to be on impact over)

    Uses the "1" AOE to concentrate with.

    Effect 2: Bull rush each round. Normal rules for hiting ETC apply. Can use
    functions for this. Then pushes them back as a bull rush does.

    Effect 3: Disarm. A disarm attempt is made, as par the rules, and as if
    a medium weapon. Disarms via. CopyObject() and DestroyObject().

    Effect 4: Knockdown. as the NwN feat, not a proper trip (but in this case,
    probably approprate) using the casters size bonus and so on.

    Those all use 2-4 concentration AOE's. Only impact will use SR, as this
    is how SR works.

    Effect 5: Violent thrust. This is NOT a concentration thing. It does it
    instantly - is basically a "sleep" AOE, and pushes back those under the
    weight limit (and caster limit, which will probably never be reached).
    -------------

    Weights are as par the creatures weight, and the size of the creature.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_CONCENTR"

// Forces back oTarget if they are within weight restrictions (using nCasterLevel)
// and are under 19.5M away.
void Effect1SustainedForce(object oTarget, int nCasterLevel, object oCaster = OBJECT_SELF);

// Effect 2: Bull rush each round. Normal rules for hiting ETC apply. Can use
// functions for this. Then pushes them back as a bull rush does.
// * Uses normal bull rush things for this.
// * Uses nCasterLevel as the BAB.
// * Uses nModifier as the ability bonus to strength, and thus to hit and the checks.
// * Removes effects of spells if it be out of range, 40M, or they cannot be bull rushed.
// *** Note for all: Do Spell Resistance checks, and any saves, before this is called!
void Effect2BullRush(object oTarget, int nCasterLevel, int nModifier, object oCaster = OBJECT_SELF);

// Effect 3: Disarm. A disarm attempt is made, as par the rules, and as if
// a medium weapon. Disarms via. CopyObject() and DestroyObject().
// * Uses CopyObject() and DestroyObject() as above.
// * Uses nCasterLevel as the BAB.
// * Uses nModifier as the ability bonus to strength, and thus to hit and the checks.
// * Removes effects of spells if it be out of range, 40M, or they cannot be disarmed
// *** Note for all: Do Spell Resistance checks, and any saves, before this is called!
void Effect3Disarm(object oTarget, int nCasterLevel, int nModifier, object oCaster = OBJECT_SELF);

// Effect 4: Knockdown. as the NwN feat, not a proper trip (but in this case,
// probably approprate) using the casters size bonus and so on.
// * Uses EffectKnockdown(), noting to use size bonuses as normal, using special function.
// * Uses nCasterLevel as the BAB.
// * Uses nModifier as the ability bonus to strength, and thus to hit and the checks.
// * Removes effects of spells if it be out of range, 40M, or they cannot be knocked down
// *** Note for all: Do Spell Resistance checks, and any saves, before this is called!
void Effect4Knockdown(object oTarget, int nCasterLevel, int nModifier, object oCaster = OBJECT_SELF);

// Effect 5: Violent thrust. This is NOT a concentration thing. It does it
// instantly - is basically a "sleep" AOE, and pushes back those under the
// weight limit (and caster limit, which will probably never be reached).
// * Uses the similar thing to continual force, moves people away from the caster in one go.
// * Acts as a "sleep" thing with relation to the weight.
// *** Note for all: Do Spell Resistance checks, and any saves, before this is called!
void Effect5ViolentThrust(object oTarget, object oCaster = OBJECT_SELF);

// Get oWeapon's size.
// - 1 = Small, (Tiny weapons)
// - 2 = Medium (Small weapons)
// - 3 = Large (Medium weapons)
// - 4 = Huge (Large weapons)
int GetWeaponSize(object oWeapon);

void main()
{
    // If we are concentrating, because it is specifically against one target,
    // we use new spells for the concentration effects, and the actual ones do
    // impact effects, and start new concentrations.
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellId = GetSpellId();
    string sIdString = "PHS_CONCENTRATION_ROUNDS" + IntToString(nSpellId);
    int nConcentrationRoundsLeft;

    // * Invalid spell script use if it is the master spell.
    if(nSpellId == PHS_SPELL_TELEKINESIS) return;

    // Might just be sustaining it...
    switch(nSpellId)
    {
        case PHS_SPELL_TELEKINESIS_CON_SUSTAINED:
        {
            // Must be within range (40M) else it fails
            if(GetDistanceToObject(oTarget) <= 40.0)
            {
                // Force back
                int nSustainedCasterLevel = GetLocalInt(oCaster, "PHS_TELEKINESIS_SUSTAINED_CASTERLEVEL");
                Effect1SustainedForce(oTarget, nSustainedCasterLevel, oCaster);

                // Take one off the times we can do this
                nConcentrationRoundsLeft = PHS_IncreaseStoredInteger(oCaster, sIdString, -1);

                // Need 1+
                if(nConcentrationRoundsLeft > 0)
                {
                    // Cast again
                    ClearAllActions();
                    ActionCastSpellAtObject(nSpellId, oTarget, METAMAGIC_NONE, TRUE);
                    // Stop
                    return;
                }
                else
                {
                    // Cannot concentrate any more
                    FloatingTextStringOnCreature("*You cannot concentrate on Telekinesis anymore*", oCaster, FALSE);
                    return;
                }
            }
            else
            {
                // Cannot concentrate any more
                FloatingTextStringOnCreature("*Concentration to force " + GetName(oTarget) + " back failed, they are too far away*", oCaster, FALSE);
                return;
            }
            return;
        }
        break;

        case PHS_SPELL_TELEKINESIS_CON_BULLRUSH:
        {
            // Must be within range (40M) else it fails
            if(GetDistanceToObject(oTarget) <= 40.0)
            {
                // Bullrush back
                int nBullrushCasterLevel = GetLocalInt(oCaster, "PHS_TELEKINESIS_BULLRUSH_CASTERLEVEL");
                int nBullrushModifier = GetLocalInt(oCaster, "PHS_TELEKINESIS_BULLRUSH_MODIFIER");
                Effect2BullRush(oTarget, nBullrushCasterLevel, nBullrushModifier, oCaster);

                // Take one off the times we can do this
                nConcentrationRoundsLeft = PHS_IncreaseStoredInteger(oCaster, sIdString, -1);

                // Need 1+
                if(nConcentrationRoundsLeft > 0)
                {
                    // Cast again
                    ClearAllActions();
                    ActionCastSpellAtObject(nSpellId, oTarget, METAMAGIC_NONE, TRUE);
                    // Stop
                    return;
                }
                else
                {
                    // Cannot concentrate any more
                    FloatingTextStringOnCreature("*You cannot concentrate on Telekinesis anymore*", oCaster, FALSE);
                    return;
                }
            }
            else
            {
                // Cannot concentrate any more
                FloatingTextStringOnCreature("*Concentration to bullrush " + GetName(oTarget) + " failed, they are too far away*", oCaster, FALSE);
                return;
            }
            return;
        }
        break;

        case PHS_SPELL_TELEKINESIS_CON_DISARM:
        {
            // Must be within range (40M) else it fails
            if(GetDistanceToObject(oTarget) <= 40.0)
            {
                // Disarm them
                int nDisarmCasterLevel = GetLocalInt(oCaster, "PHS_TELEKINESIS_DISARM_CASTERLEVEL");
                int nDisarmModifier = GetLocalInt(oCaster, "PHS_TELEKINESIS_DISARM_MODIFIER");
                Effect3Disarm(oTarget, nDisarmCasterLevel, nDisarmModifier, oCaster);

                // Take one off the times we can do this
                nConcentrationRoundsLeft = PHS_IncreaseStoredInteger(oCaster, sIdString, -1);

                // Need 1+
                if(nConcentrationRoundsLeft > 0)
                {
                    // Cast again
                    ClearAllActions();
                    ActionCastSpellAtObject(nSpellId, oTarget, METAMAGIC_NONE, TRUE);
                    // Stop
                    return;
                }
                else
                {
                    // Cannot concentrate any more
                    FloatingTextStringOnCreature("*You cannot concentrate on Telekinesis anymore*", oCaster, FALSE);
                    return;
                }
            }
            else
            {
                // Cannot concentrate any more
                FloatingTextStringOnCreature("*Concentration to disarm " + GetName(oTarget) + " failed, they are too far away*", oCaster, FALSE);
                return;
            }
            return;
        }
        break;

        case PHS_SPELL_TELEKINESIS_CON_KNOCKDOWN:
        {
            // Must be within range (40M) else it fails
            if(GetDistanceToObject(oTarget) <= 40.0)
            {
                // Knock them down
                int nKnockdownCasterLevel = GetLocalInt(oCaster, "PHS_TELEKINESIS_KNOCKDOWN_CASTERLEVEL");
                int nKnockdownModifier = GetLocalInt(oCaster, "PHS_TELEKINESIS_KNOCKDOWN_MODIFIER");
                Effect4Knockdown(oTarget, nKnockdownCasterLevel, nKnockdownModifier, oCaster);

                // Take one off the times we can do this
                nConcentrationRoundsLeft = PHS_IncreaseStoredInteger(oCaster, sIdString, -1);

                // Need 1+
                if(nConcentrationRoundsLeft > 0)
                {
                    // Cast again
                    ClearAllActions();
                    ActionCastSpellAtObject(nSpellId, oTarget, METAMAGIC_NONE, TRUE);
                    // Stop
                    return;
                }
                else
                {
                    // Cannot concentrate any more
                    FloatingTextStringOnCreature("*You cannot concentrate on Telekinesis anymore*", oCaster, FALSE);
                    return;
                }
            }
            else
            {
                // Cannot concentrate any more
                FloatingTextStringOnCreature("*Concentration to knockdown " + GetName(oTarget) + " failed, they are too far away*", oCaster, FALSE);
                return;
            }
            return;
        }
        break;
    }

    // Anything else is a new spell...

    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_TELEKINESIS)) return;

    // Declare major variables
    int nCasterLevel = PHS_GetCasterLevel();
    int nAbilityModifier = PHS_GetAppropriateAbilityBonus();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    // Only valid for the Violent Thrust!
    location lTarget = GetSpellTargetLocation();

    // note:
    // you use your caster level in place of your base attack bonus (for disarm and
    // grapple), you use your Intelligence modifier (if a wizard) or Charisma modifier (if a sorcerer)
    // in place of your Strength or Dexterity modifier.

    // What spell is it? each uses different things (Especially violent thrust)

    // Violent thrust is AOE
    if(nSpellId != PHS_SPELL_TELEKINESIS_VIOLENT_THRUST)
    {
        // PvP Reaction check
        if(GetIsReactionTypeFriendly(oTarget)) return;

        // Spell resistance check applies for all 5 seperate effects
        if(PHS_SpellResistanceCheck(oCaster, oTarget)) return;
    }

    // Check each spell Id, now. Some have will saves, some don't.
    switch(nSpellId)
    {
        case PHS_SPELL_TELEKINESIS_SUSTAINED:
        {
            // Sustained force. Requires a will saving throw check
            if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC))
            {
                // Force back
                SetLocalInt(oCaster, "PHS_TELEKINESIS_SUSTAINED_CASTERLEVEL", nCasterLevel);
                Effect1SustainedForce(oTarget, nCasterLevel, oCaster);

                // Set how many rounds we can concentrate for
                SetLocalInt(oCaster, "PHS_CONCENTRATION_ROUNDS" + IntToString(PHS_SPELL_TELEKINESIS_CON_SUSTAINED), nCasterLevel);

                // "Cast" again
                ClearAllActions();
                ActionCastSpellAtObject(PHS_SPELL_TELEKINESIS_CON_SUSTAINED, oTarget, METAMAGIC_NONE, TRUE);
                // Stop
                return;
            }
            return;
        }
        break;

        case PHS_SPELL_TELEKINESIS_BULLRUSH:
        {
            // Bullrush as normal.
            SetLocalInt(oCaster, "PHS_TELEKINESIS_BULLRUSH_CASTERLEVEL", nCasterLevel);
            SetLocalInt(oCaster, "PHS_TELEKINESIS_BULLRUSH_MODIFIER", nAbilityModifier);

            // Bullrush back
            Effect2BullRush(oTarget, nCasterLevel, nAbilityModifier, oCaster);

            // Take one off the times we can do this
            nConcentrationRoundsLeft = PHS_IncreaseStoredInteger(oCaster, sIdString, -1);

            // Set how many rounds we can concentrate for
            SetLocalInt(oCaster, "PHS_CONCENTRATION_ROUNDS" + IntToString(PHS_SPELL_TELEKINESIS_CON_BULLRUSH), nCasterLevel);

            // "Cast" again
            ClearAllActions();
            ActionCastSpellAtObject(PHS_SPELL_TELEKINESIS_CON_BULLRUSH, oTarget, METAMAGIC_NONE, TRUE);
            // Stop
            return;
        }
        break;

        case PHS_SPELL_TELEKINESIS_DISARM:
        {
            // Disarm them
            SetLocalInt(oCaster, "PHS_TELEKINESIS_DISARM_CASTERLEVEL", nCasterLevel);
            SetLocalInt(oCaster, "PHS_TELEKINESIS_DISARM_MODIFIER", nAbilityModifier);

            // Disarm them
            Effect3Disarm(oTarget, nCasterLevel, nAbilityModifier, oCaster);

            // Set how many rounds we can concentrate for
            SetLocalInt(oCaster, "PHS_CONCENTRATION_ROUNDS" + IntToString(PHS_SPELL_TELEKINESIS_CON_DISARM), nCasterLevel);

            // "Cast" again
            ClearAllActions();
            ActionCastSpellAtObject(PHS_SPELL_TELEKINESIS_CON_DISARM, oTarget, METAMAGIC_NONE, TRUE);
            // Stop
            return;
        }
        break;

        case PHS_SPELL_TELEKINESIS_KNOCKDOWN:
        {
            // Knock them down
            SetLocalInt(oCaster, "PHS_TELEKINESIS_KNOCKDOWN_CASTERLEVEL", nCasterLevel);
            SetLocalInt(oCaster, "PHS_TELEKINESIS_KNOCKDOWN_MODIFIER", nAbilityModifier);
            Effect4Knockdown(oTarget, nCasterLevel, nAbilityModifier, oCaster);

            // Set how many rounds we can concentrate for
            SetLocalInt(oCaster, "PHS_CONCENTRATION_ROUNDS" + IntToString(PHS_SPELL_TELEKINESIS_CON_KNOCKDOWN), nCasterLevel);

            // "Cast" again
            ClearAllActions();
            ActionCastSpellAtObject(PHS_SPELL_TELEKINESIS_CON_KNOCKDOWN, oTarget, METAMAGIC_NONE, TRUE);
            // Stop
            return;
        }
        break;

        case PHS_SPELL_TELEKINESIS_VIOLENT_THRUST:
        {
            // Max caster level is 15 in this case
            nCasterLevel = PHS_LimitInteger(nCasterLevel, 15);

            // Loop all those in the AOE.
            string sSpellLocal = "PHS_SPELL_TELEKINESIS" + ObjectToString(OBJECT_SELF);
            // 25(0) lbs/caster level to affect with this spell
            int nWeight = 250 * nCasterLevel;// 250 because of how GetWeight works in 10ths of pounds
            float fMaxRepel = 1.33 * nCasterLevel;// 1.33M/level.
            float fDistance;
            int bContinueLoop, nCurrentWeight, nLow, nAffected;
            object oLowest;

            // Impact VFX
            effect eVis = EffectVisualEffect(VFX_IMP_BIGBYS_FORCEFUL_HAND);

            // Apply AOE visual
            effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_10);
            PHS_ApplyLocationVFX(lTarget, eImpact);

            // Get the first target in the spell area
            oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 3.33, lTarget, TRUE);
            // If no valid targets exists ignore the loop
            if(GetIsObjectValid(oTarget))
            {
                bContinueLoop = TRUE;
            }
            // The above checks to see if there is at least one valid target.
            while((nWeight > 0) && (bContinueLoop))
            {
                nLow = 10000;
                bContinueLoop = FALSE;
                //Get the first creature in the spell area
                oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 3.33, lTarget, TRUE);
                while(GetIsObjectValid(oTarget))
                {
                    // Already affected check
                    if(!GetLocalInt(oTarget, sSpellLocal))
                    {
                        // Make faction check to ignore allies
                        if(!GetIsReactionTypeFriendly(oTarget) &&
                        // Make sure they are not immune to spells
                           !PHS_TotalSpellImmunity(oTarget) &&
                        // Must be alive
                            PHS_GetIsAliveCreature(oTarget) &&
                        // Cannot be immune to this
                           !PHS_GetIsImmuneToRepel(oTarget) &&
                        // Oh, must be within 40M to be repelled at all
                            GetDistanceBetween(oCaster, oTarget) <= 40.0)
                        {
                            // Get the current weight of the target creature
                            nCurrentWeight = GetWeight(oTarget) + PHS_GetCreatureWeight(oTarget);

                            // Check to see if the HD are lower than the current Lowest HD stored and that the
                            // HD of the monster are lower than the number of HD left to use up.
                            if(nCurrentWeight <= nWeight && ((nCurrentWeight < nLow) ||
                              (nCurrentWeight <= nLow &&
                               GetDistanceBetweenLocations(lTarget, GetLocation(oTarget)) <= fDistance)))
                            {
                                nLow = nCurrentWeight;
                                fDistance = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget));
                                oLowest = oTarget;
                                bContinueLoop = TRUE;
                            }
                        }
                        else
                        {
                            // Immune to it in some way, ignore on next pass
                            SetLocalInt(oTarget, sSpellLocal, TRUE);
                            DelayCommand(0.1, DeleteLocalInt(oTarget, sSpellLocal));
                        }
                    }
                    // Get the next target in the shape
                    oTarget = GetNextObjectInShape(SHAPE_SPHERE, 3.33, lTarget, TRUE);
                }
                // Check to see if oLowest returned a valid object
                if(GetIsObjectValid(oLowest))
                {
                    // Set a local int to make sure the creature is not used twice in the
                    // pass.  Destroy that variable in 0.1 seconds to remove it from
                    // the creature
                    SetLocalInt(oLowest, sSpellLocal, TRUE);
                    DelayCommand(0.1, DeleteLocalInt(oLowest, sSpellLocal));

                    // Make SR check
                    if(!PHS_SpellResistanceCheck(oCaster, oLowest))
                    {
                        // Will saving throw
                        if(!PHS_SavingThrow(SAVING_THROW_WILL, oLowest, nSpellSaveDC))
                        {
                            // Do the force away
                            fDistance = fMaxRepel;

                            if(fMaxRepel + GetDistanceBetween(oLowest, oCaster) >= 40.0)
                            {
                                fDistance = 40.0 - GetDistanceBetween(oLowest, oCaster);
                            }
                            // Apply impact VFX
                            PHS_ApplyVFX(oLowest, eVis);

                            // Repel them to go fDistance away
                            AssignCommand(oLowest, PHS_ActionRepel(fDistance, oCaster));
                        }
                    }
                }
                // Remove the HD of the creature from the total
                nWeight -= nLow;
                nAffected++;
                if(nAffected >= nCasterLevel)
                {
                    bContinueLoop = FALSE;
                }
                oLowest = OBJECT_INVALID;
            }
        }
        break;
    }
}

// Forces back oTarget if they are within weight restrictions (using nCasterLevel)
// and are under 39.5M away.
void Effect1SustainedForce(object oTarget, int nCasterLevel, object oCaster = OBJECT_SELF)
{
    // So, we force them back some distance - 6M at most, up to 40M
    float fDistance = GetDistanceBetween(oTarget, oCaster);
    if(fDistance <= 39.5)
    {
        // Weight restrictions
        int nLimit = PHS_LimitInteger(nCasterLevel);
        int nWeight = 250 * nLimit;
        if(GetWeight(oTarget) + PHS_GetCreatureWeight(oTarget) <= nWeight)
        {
            // In the right weight so we force them back 6.0M
            float fDistanceToGo = 6.0;
            if(fDistanceToGo + fDistance > 40.0)
            {
                fDistanceToGo = 40.0 - fDistance;
            }
            AssignCommand(oTarget, PHS_ActionRepel(fDistance, oCaster));
        }
    }
}

// Effect 2: Bull rush each round. Normal rules for hiting ETC apply. Can use
// functions for this. Then pushes them back as a bull rush does.
// * Uses normal bull rush things for this.
// * Uses nCasterLevel as the BAB.
// * Uses nModifier as the ability bonus to strength, and thus to hit and the checks.
// * Removes effects of spells if it be out of range, 40M, or they cannot be bull rushed.
// *** Note for all: Do Spell Resistance checks, and any saves, before this is called!
void Effect2BullRush(object oTarget, int nCasterLevel, int nModifier, object oCaster = OBJECT_SELF)
{
    // Do a bull rush check
    if(PHS_Bullrush(oTarget, nCasterLevel + nModifier, oCaster))
    {
        // Apply new VFX
        PHS_ApplyVFX(oTarget, EffectVisualEffect(VFX_IMP_BIGBYS_FORCEFUL_HAND));

        // Move them back 2M
        AssignCommand(oTarget, PHS_ActionRepel(2.0, oCaster));
    }
}

// Effect 3: Disarm. A disarm attempt is made, as par the rules, and as if
// a medium weapon. Disarms via. CopyObject() and DestroyObject().
// * Uses CopyObject() and DestroyObject() as above.
// * Uses nCasterLevel as the BAB.
// * Uses nModifier as the ability bonus to strength, and thus to hit and the checks.
// * Removes effects of spells if it be out of range, 40M, or they cannot be disarmed
// *** Note for all: Do Spell Resistance checks, and any saves, before this is called!
void Effect3Disarm(object oTarget, int nCasterLevel, int nModifier, object oCaster = OBJECT_SELF)
{
    // Are they disarmable?
    if(GetIsCreatureDisarmable(oTarget))
    {
        // Get item in right hand
        object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);

        // Check size of weapon
        int nSize = GetWeaponSize(oWeapon);

        // Error check
        if(nSize == FALSE) return;

        // Plot check
        if(PHS_TotalSpellImmunity(oWeapon)) return;

        // Our size is weapon size medium, 2.
        // Get difference
        int nDifference = 2 - nSize;

        // If nDifference is +ve, we have a bigger weapon, -ve is smaller.
        // 0 = same
        // * Bonus is therefore 4 * nDifference.
        int nBonus = 4 * nDifference;

        // Must hit
        int nAttack = PHS_AttackCheck(oTarget, nCasterLevel, nModifier, nBonus, GetAC(oTarget), oCaster);
        if(nAttack)
        {
            // Disipline check (from NwN)
            if(!GetIsSkillSuccessful(oTarget, SKILL_DISCIPLINE, nAttack))
            {
                // Disarm them
                FloatingTextStringOnCreature("*You manage to disarm " + GetName(oTarget) + "'s weapon telekinetically*", oCaster, FALSE);
                FloatingTextStringOnCreature("*You feel your weapon being disarmed telekinetically!*", oTarget, FALSE);

                // Copy it
                CopyObject(oWeapon, GetLocation(oTarget));
                // Destroy original
                DestroyObject(oWeapon);
            }
        }
    }
}

// Effect 4: Knockdown. as the NwN feat, not a proper trip (but in this case,
// probably approprate) using the casters size bonus and so on.
// * Uses EffectKnockdown(), noting to use size bonuses as normal, using special function.
// * Uses nCasterLevel as the BAB.
// * Uses nModifier as the ability bonus to strength, and thus to hit and the checks.
// * Removes effects of spells if it be out of range, 40M, or they cannot be knocked down
// *** Note for all: Do Spell Resistance checks, and any saves, before this is called!
void Effect4Knockdown(object oTarget, int nCasterLevel, int nModifier, object oCaster = OBJECT_SELF)
{
    // Immunity check
    if(!PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_KNOCKDOWN, 0.0, oCaster))
    {
        // Get creature sizes
        int nOurSize = GetCreatureSize(oCaster);
        int nThierSize = GetCreatureSize(oTarget);

        // Cannot knockdown anyone with more then 1 category larger
        if(nThierSize - nOurSize >= 2) return;

        // Plot check
        if(PHS_TotalSpellImmunity(oTarget)) return;

        // Get difference
        int nDifference = nOurSize - nThierSize;

        // If nDifference is +ve, we are bigger, -ve is smaller.
        // 0 = same
        // * Bonus is therefore 4 * nDifference.
        int nBonus = 4 * nDifference;

        // Must hit
        int nAttack = PHS_AttackCheck(oTarget, nCasterLevel, nModifier, nBonus, GetAC(oTarget), oCaster);
        if(nAttack)
        {
            // Disipline check (from NwN)
            if(!GetIsSkillSuccessful(oTarget, SKILL_DISCIPLINE, nAttack))
            {
                // Disarm them
                FloatingTextStringOnCreature("*You manage to knockdown " + GetName(oTarget) + " telekinetically*", oCaster, FALSE);
                FloatingTextStringOnCreature("*You are knocked down telekinetically!*", oTarget, FALSE);

                // Declare effects
                effect eKnockdown = EffectKnockdown();
                // Not dispellable/ignored by dispel attempts
                eKnockdown = SupernaturalEffect(eKnockdown);

                // Apply it
                PHS_ApplyDuration(oTarget, eKnockdown, 5.0);
            }
        }
    }
}

// Get oWeapon's size.
// - 1 = Small, (Tiny weapons)
// - 2 = Medium (Small weapons)
// - 3 = Large (Medium weapons)
// - 4 = Huge (Large weapons)
int GetWeaponSize(object oWeapon)
{
    int nSize;

    switch(GetBaseItemType(oWeapon))
    {
        // Small (Tiny) weapons: 1
        case BASE_ITEM_DAGGER:
        case BASE_ITEM_KAMA:
        case BASE_ITEM_SHURIKEN:
        {
            nSize = 1;
        }
        // Medium (Small) weapons: 2
        case BASE_ITEM_THROWINGAXE:
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_DART:
        case BASE_ITEM_LIGHTHAMMER:
        case BASE_ITEM_HANDAXE:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_SICKLE:
        case BASE_ITEM_SHORTSPEAR:
        case BASE_ITEM_SLING:
        case BASE_ITEM_SHORTSWORD:
        {
            nSize = 2;
        }
        // Large (Medium) weapons: 3
        case BASE_ITEM_BATTLEAXE:
        case BASE_ITEM_DWARVENWARAXE:
        case BASE_ITEM_CLUB:
        case BASE_ITEM_HEAVYCROSSBOW:
        case BASE_ITEM_LIGHTFLAIL:
        case BASE_ITEM_KATANA:
        case BASE_ITEM_LONGSWORD:
        case BASE_ITEM_MORNINGSTAR:
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_RAPIER:
        case BASE_ITEM_SCIMITAR:
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_WARHAMMER:
        {
            nSize = 3;
        }
        // Huge (Large) weapons: 4
        case BASE_ITEM_BASTARDSWORD:
        case BASE_ITEM_DIREMACE:
        case BASE_ITEM_TWOBLADEDSWORD:
        case BASE_ITEM_DOUBLEAXE:
        case BASE_ITEM_HEAVYFLAIL:
        case BASE_ITEM_GREATAXE:
        case BASE_ITEM_GREATSWORD:
        case BASE_ITEM_HALBERD:
        case BASE_ITEM_LONGBOW:
        case BASE_ITEM_SCYTHE:
        {
            nSize = 4;
        }
    }
    return nSize;
}
