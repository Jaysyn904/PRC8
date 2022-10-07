/*:://////////////////////////////////////////////
//:: Name Spell Confusion Heartbeat script
//:: FileName SMP_ail_confuse
//:://////////////////////////////////////////////
    This runs on a creature when they have the effect:

    // Create a Confuse effect
    effect EffectConfused()

    On them.

    This will randomly do an action according to the 3.5 rules:

    - Taken from the Confusion Spell description.

    This spell causes the targets to become confused, making them unable to
    independently determine what they will do.

    Roll on the following table at the beginning of each subject’s turn each
    round to see what the subject does in that round.

    d%      Behavior
    01-10   Attack caster with melee or ranged weapons (or close with caster if
            attack is not possible).
    11-20   Act normally.
    21-50   Do nothing but babble incoherently.
    51-70   Flee away from caster at top possible speed.
    71-100  Attack nearest creature (for this purpose, a familiar counts as part
            of the subject’s self).

    A confused character who can’t carry out the indicated action does nothing
    but babble incoherently. Attackers are not at any special advantage when
    attacking a confused character. Any confused character who is attacked
    automatically attacks its attackers on its next turn, as long as it is still
    confused when its turn comes. Note that a confused character will not make
    attacks of opportunity against any creature that it is not already devoted
    to attacking (either because of its most recent action or because it has just
    been attacked).

    NOTE:

    "Insanity" is mearly considered a permament version of Confusion, and
    should be permament and made SupernaturalEffect().

    NOTE:

    If they ONLY have Song Of Discord's effects, this means we have a 50% chance
    of attacking the nearest alive creature (who is not dying) with the most
    powerful thing.

    NOTE:

    If they have Hypontism's spell effects, and are not naturally confused, they
    will just stop and face the creator of the effect (if not valid, it depissitates)

    NOTE:

    If they have Rainbow Patters spell effects, they will face a location set
    on them, and will override Song of discords effects.

    NOTE:

    If they have the effects from Suggestion (or Mass Suggestion) then they
    will take that action, unless they are confused or have any of the above
    effects.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_AILMENT"

// Returns the nearest seen or heard caster of confusion (if a valid creature object)
object GetConfusionCreator(object oSelf, int nSpellId = SPELL_INVALID);
// Babble incoherantly!
void Babble();
// Does an action based on nSpellId, returns FALSE if they have not completed
// it yet, or TRUE if they should be released.
int SuggestionResult(int nSpellId);

void main()
{
    // Declare everything
    object oSelf = OBJECT_SELF;
    object oTarget, oFamiliar, oCreator;
    // If any of these are TRUE, we have a confusion effect of that spell.
    int bHypnotism, bSongOfDiscord, bConfusionNormal, bIrresistibleDance,
        bRainbowPattern, bSuggestion, nSuggestionSpell, nSpellId;

    // We need to check Calm Emotions
    // - If TRUE, surpress
    if(SMP_AilmentCheckCalmEmotions())
    {
        SendMessageToPC(OBJECT_SELF, "Your calm emotions blocks confusion.");
        DelayCommand(0.0, SetCommandable(TRUE, oSelf));
        return;
    }

    // Get all effects
    effect eCheck = GetFirstEffect(oSelf);
    while(GetIsEffectValid(eCheck))
    {
        // Only check confusion effects
        if(GetEffectType(eCheck) == EFFECT_TYPE_CONFUSED)
        {
            nSpellId = GetEffectSpellId(eCheck);
            switch(nSpellId)
            {
                case SMP_SPELL_SONG_OF_DISCORD:
                {
                    // Song of Discords spell effects.
                    bSongOfDiscord = TRUE;
                }
                break;
                case SMP_SPELL_HYPNOTISM:
                case SMP_SPELLABILITY_BABBLE: // (Allip babble causes this too)
                {
                    // Hypnotism's spell effects
                    bHypnotism = TRUE;
                }
                break;
                case SMP_SPELL_IRRESISTIBLE_DANCE:
                {
                    // Irresistible Dance's spell effects
                    bIrresistibleDance = TRUE;
                }
                break;
                case SMP_SPELL_RAINBOW_PATTERN:
                {
                    // Rainbow Pattern's spell effects
                    bRainbowPattern = TRUE;
                }
                break;
                case SMP_SPELL_SUGGESTION:
                case SMP_SPELL_SUGGESTION_PUT_WEAPON_DOWN:
                case SMP_SPELL_SUGGESTION_RUN_FROM_HOSTILE:
                case SMP_SPELL_SUGGESTION_MOVE_TOWARDS_ME:
                case SMP_SPELL_SUGGESTION_MOVE_AWAY_FROM_ME:
                case SMP_SPELL_SUGGESTION_SIT_DOWN:
                case SMP_SPELL_SUGGESTION_MASS:
                case SMP_SPELL_SUGGESTION_MASS_PUT_WEAPON_DOWN:
                case SMP_SPELL_SUGGESTION_MASS_RUN_FROM_HOSTILE:
                case SMP_SPELL_SUGGESTION_MASS_MOVE_TOWARDS_ME:
                case SMP_SPELL_SUGGESTION_MASS_MOVE_AWAY_FROM_ME:
                case SMP_SPELL_SUGGESTION_MASS_SIT_DOWN:
                {
                    // Got any of the suggestion spells (or sub-dial) effects.
                    bSuggestion = TRUE;
                    nSuggestionSpell = nSpellId;
                }
                break;
                default:
                {
                    // We have another confusion effect
                    bConfusionNormal = TRUE;
                }
                break;
            }
        }
        eCheck = GetNextEffect(oSelf);
    }

    // Order of priority:
    // 1 - If we have confusion from a normal source, we do random babblings
    // 2 - If we are under the effect of Hypnotism, we look at the Hypnotism creator.
    // 3 - If we are dancing, we dance (Irresistible Dance)
    // 4 - If we are under the effect of a Rainbow Pattern, we face a cirtain location.
    // 5 - If we are Discorded, we will 50% of the time attack the nearest creature

    // Are we affected by any Non-other-spell-created Confusion?
    // - Top priority
    if(bConfusionNormal == TRUE)
    {
        // Table roll is a d100
        int nRandom = d100();
        int nCnt;

        // What do we do?

        // 01-10 Attack caster with melee or ranged weapons (or close with caster if
        // attack is not possible).
        if(nRandom <= 10)
        {
            // Make sure the creature is commandable for the round
            SetCommandable(TRUE);
            // Clear all previous actions.
            ClearAllActions();
            // Get our confusion creator!
            oTarget = GetConfusionCreator(oSelf);
            if(GetIsObjectValid(oTarget))
            {
                // Range check to use bow
                if(GetDistanceToObject(oTarget) >= 5.0)
                {
                    // Equip a ranged weapon
                    ActionEquipMostDamagingRanged();
                }
                else
                {
                    // Equip a melee weapon
                    ActionEquipMostDamagingMelee();
                }
                ActionAttack(oTarget);
            }
            else
            // A confused character who can’t carry out the indicated action does nothing
            // but babble incoherently.
            {
                Babble();
            }
            // Stop the confused person changing this action
            SetCommandable(FALSE);
        }
        // 11-20   Act normally.
        // We let them act normally
        else if(nRandom <= 20)
        {
            SendMessageToPC(OBJECT_SELF, "You suddenly feel a short amount of freedom from your confusion!");
            DelayCommand(0.0, SetCommandable(TRUE, oSelf));
            return;
        }
        // 21-50 Do nothing but babble incoherently.
        else if(nRandom <= 50)
        {
            // Make sure the creature is commandable for the round
            SetCommandable(TRUE);
            // Clear all previous actions.
            ClearAllActions();
            Babble();
            // Stop the confused person changing this action
            SetCommandable(FALSE);
        }
        // 51-70 Flee away from caster at top possible speed.
        else if(nRandom <= 70)
        {
            // Make sure the creature is commandable for the round
            SetCommandable(TRUE);
            // Clear all previous actions.
            ClearAllActions();
            // Get our confusion creator!
            oTarget = GetConfusionCreator(OBJECT_SELF);
            if(GetIsObjectValid(oTarget))
            {
                // Run from them
                ActionMoveAwayFromObject(oTarget, TRUE, 100.0);
            }
            else
            // A confused character who can’t carry out the indicated action does nothing
            // but babble incoherently.
            {
                Babble();
            }
            // Stop the confused person changing this action
            SetCommandable(FALSE);
        }
        // 71-100 Attack nearest creature (for this purpose, a familiar counts as part
        //        of the subject’s self).
        else
        {
            // Make sure the creature is commandable for the round
            SetCommandable(TRUE);
            // Clear all previous actions.
            ClearAllActions();

            nCnt = 1;
            // We don't ever attack familiars, ourself
            oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, OBJECT_SELF);
            oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, OBJECT_SELF, nCnt);
            while(GetIsObjectValid(oTarget))
            {
                // Stop if it is not a familiar (our own)
                if(oTarget != oFamiliar)
                {
                    break;
                }
                nCnt++;
                oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE);
            }
            // Check target validness
            if(GetIsObjectValid(oTarget) && oTarget != oFamiliar)
            {
                // Range check to use bow
                if(GetDistanceToObject(oTarget) >= 5.0)
                {
                    // Equip a ranged weapon
                    ActionEquipMostDamagingRanged();
                }
                else
                {
                    // Equip a melee weapon
                    ActionEquipMostDamagingMelee();
                }
                ActionAttack(oTarget);
            }
            else
            // A confused character who can’t carry out the indicated action does nothing
            // but babble incoherently.
            {
                Babble();
            }
            // Stop the confused person changing this action
            SetCommandable(FALSE);
        }
        // End confusion
        return;
    }
    // Hypnotism effects
    else if(bHypnotism == TRUE)
    {
        // Stare at the creator of the hypnotism - if valid. If not, we definatly
        // remove it
        oCreator = GetConfusionCreator(oSelf, SMP_SPELL_HYPNOTISM);
        if(GetIsObjectValid(oCreator))
        {
            // Make sure the creature is commandable for the round
            SetCommandable(TRUE);
            // Clear all previous actions.
            ClearAllActions();
            // Set facing
            SetFacingPoint(GetPosition(oCreator));
            // Stop the confused person changing this action
            SetCommandable(FALSE);
        }
        else
        {
            // Invalid, remove the effects
            SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_HYPNOTISM, oSelf);
        }
        // End Hypnotism
        return;
    }
    // Are we affected by Irresistible Dance?
    else if(bIrresistibleDance == TRUE)
    {
        // Make sure the creature is commandable for the round
        SetCommandable(TRUE);
        // Clear all previous actions.
        ClearAllActions();

        // Do a random Speakstring to show we are dancing
        if(!GetHasSpellEffect(SMP_SPELL_SILENCE, oSelf))
        {
            switch(GetRacialType(OBJECT_SELF))
            {
                case RACIAL_TYPE_DWARF:
                case RACIAL_TYPE_HALFELF:
                case RACIAL_TYPE_HALFORC:
                case RACIAL_TYPE_ELF:
                case RACIAL_TYPE_GNOME:
                case RACIAL_TYPE_HUMANOID_GOBLINOID:
                case RACIAL_TYPE_HALFLING:
                case RACIAL_TYPE_HUMAN:
                case RACIAL_TYPE_HUMANOID_MONSTROUS:
                case RACIAL_TYPE_HUMANOID_ORC:
                case RACIAL_TYPE_HUMANOID_REPTILIAN:
                {
                    // Some nice random speak :-)
                    switch (d20())
                    {
                        case(1):{ SpeakString("Cha-cha-cha...");} break;
                        case(2):{ SpeakString("Ooooohhh, yeah...");} break;
                        case(3):{ SpeakString("Dancin' baby...");} break;
                        case(4):{ SpeakString("Tonight I'll be singin'...");} break;
                        case(5):{ SpeakString("What a good beat...");} break;
                        case(6):{ SpeakString("Toe tapping...");} break;
                        case(7):{ SpeakString("Foot movin'...");} break;
                        case(8):{ SpeakString("I feel the pulse...");} break;
                        case(9):{ SpeakString("Give me space! Give me room!");} break;
                        case(10):{ SpeakString("You can't stop me!");} break;
                        default:{ SpeakString("*Dances*");} break;
                    }
                }
                break;
                default:
                {
                    // Show we are dancing
                    SpeakString("*Dances*");
                }
                break;
            }
        }
        else
        {
            // Show we are dancing
            SpeakString("*Dances*");
        }
        // Unequip our right and left hand things
        object oEquipped = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oSelf);
        if(GetIsObjectValid(oEquipped))
        {
            ActionUnequipItem(oEquipped);
        }
        oEquipped = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oSelf);
        if(GetIsObjectValid(oEquipped))
        {
            ActionUnequipItem(oEquipped);
        }

        // We dance baby, yeah!
        // Randomly play a few animations
        // Some nice random speak :-)
        switch (d6())
        {
            case(1):{ ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0, 3.0); } break;
            case(2):{ ActionPlayAnimation(ANIMATION_LOOPING_CONJURE2, 1.0, 3.0); } break;
            case(3):{ ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 3.0); } break;
            case(4):{ ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 3.0); } break;
            case(5):{ ActionPlayAnimation(ANIMATION_LOOPING_LISTEN, 1.0, 3.0); } break;
            case(6):{ ActionPlayAnimation(ANIMATION_LOOPING_LOOK_FAR, 1.0, 3.0); } break;
        }

        switch (d10())
        {
            case(1):{ ActionPlayAnimation(ANIMATION_FIREFORGET_BOW); } break;
            case(2):{ ActionPlayAnimation(ANIMATION_FIREFORGET_DODGE_DUCK); } break;
            case(3):{ ActionPlayAnimation(ANIMATION_FIREFORGET_DODGE_SIDE); } break;
            case(4):{ ActionPlayAnimation(ANIMATION_FIREFORGET_GREETING); } break;
            case(5):{ ActionPlayAnimation(ANIMATION_FIREFORGET_SALUTE); } break;
            case(6):{ ActionPlayAnimation(ANIMATION_FIREFORGET_STEAL); } break;
            case(7):{ ActionPlayAnimation(ANIMATION_FIREFORGET_TAUNT); } break;
            case(8):{ ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1); } break;
            case(9):{ ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2); } break;
            case(10):{ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY3); } break;
        }

        // Stop the confused person changing this action
        SetCommandable(FALSE);
    }
    // Are we affected by Rainbow Pattern?
    else if(bRainbowPattern == TRUE)
    {
        // Make sure the creature is commandable for the round
        SetCommandable(TRUE);
        // Clear all previous actions.
        ClearAllActions();

        // Face a pre-set location
        location lFace = GetLocalLocation(OBJECT_SELF, "SMP_SPELL_RAINBOW_LOCATION");

        // Set facing point
        SetFacingPoint(GetPositionFromLocation(lFace));

        // Stop the confused person changing this action
        SetCommandable(FALSE);

        // End Rainbow Pattern
        return;
    }
    // Suggestion?
    else if(bSuggestion == TRUE)
    {
        // Do the different actions

        // Make sure the creature is commandable for the round
        SetCommandable(TRUE);

        // If they have not got out of it...
        if(!SuggestionResult(nSuggestionSpell))
        {
            // ...Stop the confused person changing this action
            SetCommandable(FALSE);
        }
        // End Suggestion
        return;
    }
    // Are we affected by Song of Discord?
    else //if(bSongOfDiscord == TRUE)
    {
        // Make sure the creature is commandable for the round
        SetCommandable(TRUE);

        // 50% chance of normal actions
        if(d2() == 1)
        {
            // Can do things normally
            FloatingTextStringOnCreature("Your mind returns to normal temporarily from the song of discord", oSelf, FALSE);
        }
        else
        {
            // Must attack nearest creature, whoever it is
            FloatingTextStringOnCreature("Your mind is discorded! You attack the nearest person!", oSelf, FALSE);

            // Stop what we were doing.
            ClearAllActions();

            // Do a new action using this script - all it does is do a
            // maximum of 2 actions
            ExecuteScript("SMP_AIL_SongDisc", oSelf);

            // Stop the confused person changing this action
            SetCommandable(FALSE);
        }
        // End Song of Discord
        return;
    }
}

// Returns the nearest seen or heard caster of confusion (if a valid creature object)
object GetConfusionCreator(object oSelf, int nSpellId = SPELL_INVALID)
{
    object oCasterReturn, oCreator;
    object oArea = GetArea(oSelf);
    effect eCheck = GetFirstEffect(oSelf);
    float fLowestDistance = 300.0;
    float fDistance;
    while(GetIsEffectValid(eCheck))
    {
        // Only check confusion effects and the right nSpellId
        if(GetEffectType(eCheck) == EFFECT_TYPE_CONFUSED &&
          (nSpellId == SPELL_INVALID || GetEffectSpellId(eCheck) == nSpellId))
        {
            // Get the creator
            oCreator = GetEffectCreator(eCheck);
            // Check if valid, and same area, and they are seen or heard
            if(GetIsObjectValid(oCreator) && GetArea(oCreator) == oArea &&
               GetObjectType(oCreator) == OBJECT_TYPE_CREATURE &&
              (GetObjectSeen(oCreator, oSelf) || GetObjectHeard(oCreator, oSelf)))
            {
                // Get distance to them
                fDistance = GetDistanceBetween(oCreator, oSelf);
                if(fDistance < fLowestDistance)
                {
                    // Now this is the one we fear most
                    oCasterReturn = oCreator;
                    fLowestDistance = fDistance;
                }
            }
        }
    }
    return oCasterReturn;
}

// Babble incoherantly!
void Babble()
{
    // Do we do babbling? Only humanoid + PC races will, other will not.
    int nRacial = GetRacialType(OBJECT_SELF);
    // Check race
    switch(nRacial)
    {
        case RACIAL_TYPE_DWARF:
        case RACIAL_TYPE_HALFELF:
        case RACIAL_TYPE_HALFORC:
        case RACIAL_TYPE_ELF:
        case RACIAL_TYPE_GNOME:
        case RACIAL_TYPE_HUMANOID_GOBLINOID:
        case RACIAL_TYPE_HALFLING:
        case RACIAL_TYPE_HUMAN:
        case RACIAL_TYPE_HUMANOID_MONSTROUS:
        case RACIAL_TYPE_HUMANOID_ORC:
        case RACIAL_TYPE_HUMANOID_REPTILIAN:
        {
            // Some nice random speak :-)
            switch (d20())
            {
                case(1):{ SpeakString("*blurbleyla!*");} break;
                case(2):{ SpeakString("*Jiapa!*");} break;
                case(3):{ SpeakString("*Duhhhhhh*");} break;
                case(4):{ SpeakString("*Weeeeee!*");} break;
                case(5):{ SpeakString("*oopsalbongo!*");} break;
                case(6):{ SpeakString("*yeee!*");} break;
                case(7):{ SpeakString("*...*");} break;
                case(8):{ SpeakString("*paaannnddaaaa*");} break;
                case(9):{ SpeakString("*Whatcadomatey?*");} break;
                case(10):{ SpeakString("*Memememe!*");} break;
                default:{ SpeakString("*babbles incoherently*");} break;
            }
        }
        default:
        {
            SpeakString("*babbles incoherently*");
        }
        break;
    }
}

// Does an action based on nSpellId, returns FALSE if they have not completed
// it yet, or TRUE if they should be released.
int SuggestionResult(int nSpellId)
{
    // Creator of the confusion (or suggestion in this case)
    object oCreator;
    switch(nSpellId)
    {
        // Default (First) case, put down weapons.
        case SMP_SPELL_SUGGESTION:
        case SMP_SPELL_SUGGESTION_MASS:
        case SMP_SPELL_SUGGESTION_PUT_WEAPON_DOWN:
        case SMP_SPELL_SUGGESTION_MASS_PUT_WEAPON_DOWN:
        {
            // Got any?
            object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
            if(GetIsObjectValid(oWeapon))
            {
                // Clear all previous actions.
                ClearAllActions();

                // Remove it
                ActionWait(2.0);
                ActionUnequipItem(oWeapon);

                // Check lefthand
                oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
                if(GetIsObjectValid(oWeapon))
                {
                    // Remove it
                    ActionWait(2.0);
                    ActionUnequipItem(oWeapon);
                }
                // Returns FALSE, cannot cancel this suggestion this turn
                return FALSE;
            }
        }
        break;
        // Second case: Run from hostiles.
        case SMP_SPELL_SUGGESTION_RUN_FROM_HOSTILE:
        case SMP_SPELL_SUGGESTION_MASS_RUN_FROM_HOSTILE:
        {
            // Get nearest enemy
            // * Alive, Seen, Enemy
            object oEnemy = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, OBJECT_SELF, 1, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, CREATURE_TYPE_IS_ALIVE, TRUE);
            if(GetIsObjectValid(oEnemy))
            {
                // Clear all previous actions.
                ClearAllActions();

                // Move away
                ActionMoveAwayFromObject(oEnemy, TRUE, 60.0);
                // Returns FALSE, cannot cancel this suggestion this turn
                return FALSE;
            }
        }
        break;
        // Third case: Move towards the creator
        case SMP_SPELL_SUGGESTION_MOVE_TOWARDS_ME:
        case SMP_SPELL_SUGGESTION_MASS_MOVE_TOWARDS_ME:
        {
            // Move towards the creator until we are close
            oCreator = GetConfusionCreator(OBJECT_SELF, nSpellId);

            // Same area, and seen or heard
            if((GetObjectSeen(oCreator) || GetObjectHeard(oCreator)) &&
                GetArea(oCreator) == GetArea(OBJECT_SELF))
            {
                // Must be >= 3M away
                if(GetDistanceToObject(oCreator) > 3.0)
                {
                    // Clear all previous actions.
                    ClearAllActions();

                    // Move
                    ActionForceMoveToObject(oCreator, TRUE, 1.0, 6.0);
                    // Returns FALSE, cannot cancel this suggestion this turn
                    return FALSE;
                }
            }
        }
        break;
        // Fourth Case: Move away from the caster
        case SMP_SPELL_SUGGESTION_MOVE_AWAY_FROM_ME:
        case SMP_SPELL_SUGGESTION_MASS_MOVE_AWAY_FROM_ME:
        {
            // Move towards the creator until we are close
            oCreator = GetConfusionCreator(OBJECT_SELF, nSpellId);

            // Same area, and seen or heard
            if((GetObjectSeen(oCreator) || GetObjectHeard(oCreator)) &&
                GetArea(oCreator) == GetArea(OBJECT_SELF))
            {
                // Must be <= 50.0M away
                if(GetDistanceToObject(oCreator) <= 50.0)
                {
                    // Clear all previous actions.
                    ClearAllActions();

                    // Move
                    ActionMoveAwayFromObject(oCreator, TRUE, 51.0);

                    // Returns FALSE, cannot cancel this suggestion this turn
                    return FALSE;
                }
            }
        }
        break;
        // Last (Fifth) cast: Sit down for a while.
        case SMP_SPELL_SUGGESTION_SIT_DOWN:
        case SMP_SPELL_SUGGESTION_MASS_SIT_DOWN:
        {
            // Sitting already?
            int nSitting = GetLocalInt(OBJECT_SELF, "SMP_SUGGESTION_TEMP_SITTING");
            if(nSitting == 0)
            {
                // Clear all previous actions.
                ClearAllActions();
                // Set counter back to 6
                SetLocalInt(OBJECT_SELF, "SMP_SUGGESTION_TEMP_SITTING", 6);
            }
            else
            {
                // Take one off until we reset the sitting
                SetLocalInt(OBJECT_SELF, "SMP_SUGGESTION_TEMP_SITTING", --nSitting);
            }
            // Sit down, simple as that, until the duration runs out. We of
            // course get it canceled when damaged...
            ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS);
        }
        break;
    }
    // Now, it seems it is complete, so return TRUE - do not stop them
    // from moving, and remove the effect from this spell, from us.
    SMP_RemoveSpellEffectsFromTarget(nSpellId);
    return TRUE;
}
