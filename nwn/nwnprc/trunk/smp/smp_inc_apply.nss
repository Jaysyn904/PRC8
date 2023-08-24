/*:://////////////////////////////////////////////
//:: Name Apply Include
//:: FileName SMP_INC_APPLY
//:://////////////////////////////////////////////
    This holds all applying functions - of effects, visuals and so on. Anything
    that applys using ApplyEffectToObject is put here.

    This can be used for passing damage through for shield other (low level, but
    cool spell!)

    Grenade functions are also here. They are not stolen, but borrowed from Bioware.
    If it ain't broke, why bother making new?

    Its changed enough to need to be added here, though!

    Oh, and some polymorph-applying functions - old polymorphs need to be removed
    first, incase of linked effects, anyway...good idea to do that.

    Naming conventions for effect declarations:

    eVis = Visual effect to be applied instantly to a single target
    eImpact = Visual effect to be applied instantly to a location (impact on a location)
    eDur = Visual effect to be applied on a single target for a duration
    eCessate = Special visual effect for the cessate visual (Cessate could be eDur in some scripts)
    eDam = Damage effect, to be applied instantly
    eAOE = Area of Effect, to be applied on a target or the ground (usually the ground)

//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: January 2004
//::////////////////////////////////////////////*/

#include "SMP_INC_CONSTANT"
#include "SMP_INC_REMOVE"

// SMP_INC_APPLY. Returns the first caster of nSpell on oTarget. Should really only be used
// for spells which only 1 can be applied at once.
object SMP_FirstCasterOfSpellEffect(int nSpell, object oTarget);

// SMP_INC_APPLY. This will instanlty apply EffectDamage using the parameters.
// - This is used for all applying damage effects.
// - Used for Shield Other. DO NOT USE THIS FOR NON-PLAYER-SPELLS!
// * nDamagePower - Should use DAMAGE_POWER_PLUS_TWENTY as a default. Magic penetrates all DR.
void SMP_ApplyDamageToObject(object oTarget, int nDamageAmount, int nDamageType = DAMAGE_TYPE_MAGICAL, int nDamagePower = DAMAGE_POWER_PLUS_TWENTY);

// SMP_INC_APPLY. This will instanlty apply EffectDamage using the parameters.
// - This is used for all applying damage effects.
// - Used for Shield Other. DO NOT USE THIS FOR NON-PLAYER-SPELLS!
// It also applys eVis to oTarget.
// * nDamagePower - Should use DAMAGE_POWER_PLUS_TWENTY as a default. Magic penetrates all DR.
void SMP_ApplyDamageVFXToObject(object oTarget, effect eVis, int nDamageAmount, int nDamageType = DAMAGE_TYPE_MAGICAL, int nDamagePower = DAMAGE_POWER_PLUS_TWENTY);

// SMP_INC_APPLY. Apply eVis on oTarget at once
void SMP_ApplyVFX(object oTarget, effect eVis);
// SMP_INC_APPLY. Apply both eVis and eInstant on oTarget at once
void SMP_ApplyInstantAndVFX(object oTarget, effect eVis, effect eInstant);
// SMP_INC_APPLY. Apply eInstant on oTarget at once
void SMP_ApplyInstant(object oTarget, effect eInstant);
// SMP_INC_APPLY. Apply eVis instantly, and eDur for fDuration, on oTarget
void SMP_ApplyDurationAndVFX(object oTarget, effect eVis, effect eDur, float fDuration);
// SMP_INC_APPLY. Apply eDur for fDuration, on oTarget
void SMP_ApplyDuration(object oTarget, effect eDur, float fDuration);
// SMP_INC_APPLY. Apply eVis instantly, and eDur Permanently, on oTarget
void SMP_ApplyPermanentAndVFX(object oTarget, effect eVis, effect eDur);
// SMP_INC_APPLY. Apply eDur permanently, on oTarget
void SMP_ApplyPermanent(object oTarget, effect eDur);

// SMP_INC_APPLY. We use this for any "Death" effects, such as temporal stasis, where you are
// invunrable (or worse, not) and are alone. This pops up a similar thing to
// Petrify, the death panel (with no reload) using sMessage.
// * Will use nCasterLevel to do rounds version, if it is not hardcore or higher.
void SMP_ApplyPermanentDeath(object oTarget, effect eDur, int nCasterLevel, string sMessage);

// SMP_INC_APPLY. Applies eImpact at lTarget instantly
void SMP_ApplyLocationVFX(location lTarget, effect eImpact);
// SMP_INC_APPLY. Applies eAOE at lTarget for fDuration.
void SMP_ApplyLocationDuration(location lTarget, effect eAOE, float fDuration);
// SMP_INC_APPLY. Applies eImpact instantly, and eAOE for fDuration, at lTarget.
void SMP_ApplyLocationDurationAndVFX(location lTarget, effect eImpact, effect eAOE, float fDuration);
// SMP_INC_APPLY. Applies eImpact instantly, and eAOE permanently, at lTarget.
// Rarely used.
void SMP_ApplyLocationPermanentAndVFX(location lTarget, effect eImpact, effect eAOE);

// SMP_INC_APPLY. Makes sure oTarget dies via. Magical Damage - goes through
// any spells used for the other functions.
// * Use for non-death "death" effects, such as Blight.
// * Only use Magical, possibly Divine, Negative and Posistive damage types.
void SMP_ApplyDeathByDamage(object oTarget, int nDamageType = DAMAGE_TYPE_MAGICAL);
// SMP_INC_APPLY. Makes sure oTarget dies via. Magical Damage - goes through
// any spells used for the other functions.
// * See original.
// * Also applies eVis.
void SMP_ApplyDeathByDamageAndVFX(object oTarget, effect eVis, int nDamageType = DAMAGE_TYPE_MAGICAL);

// SMP_INC_APPLY. Apply an instant visual that misses or hits oTarget, depending on nTouchResult.
void SMP_ApplyTouchVisual(object oTarget, int nVis, int nTouchResult);
// SMP_INC_APPLY. Apply an instant beam that misses or hits oTarget, depending on nTouchResult.
// * You can change fDuration. Standard duration is 1.5 seconds.
void SMP_ApplyTouchBeam(object oTarget, int nBeam, int nTouchResult, float fDuration = 1.5);

// SMP_INC_APPLY. Grenade attack
// * nDirectDam - Random Damage (Do the roll before), nSplashDam is normally 1.
// * nVisVFX - Impact VFX. nAOEVFX - must be over 0, if there is an AOE blast
// * nDamageType - Damage type of nDirectDam and nSplashDam.
// * fExplosionRadius - Radius of the blast, in meters
// * nObjectFilter - What objects are hurt by the spell. Should match the object types in spells.2da
// * nRacialType1/2 - A specific racial type to damage. Can be ALL for all.
// * nAlignment - A specific Good/Evil alignment to damage. Can be ALL for all.
void SMP_Grenade(int nDirectDam, int nSplashDam, int nVisVFX, int nAOEVFX, int nDamageType, float fExplosionRadius, int nObjectFilter, int nRacialType1 = RACIAL_TYPE_ALL, int nRacialType2 = RACIAL_TYPE_ALL, int nAlignment = ALIGNMENT_ALL);

// SMP_INC_APPLY. Polymorph version. Removes polymorph effects.
// Then, applies eVis instantly, and ePoly for fDuration, on oTarget
// * Required for Alter Self at least.
void SMP_ApplyPolymorphDurationAndVFX(object oTarget, effect eVis, effect ePoly, float fDuration);
// SMP_INC_APPLY. Polymorph version. Removes polymorph effects.
// Then, applies ePoly for fDuration, on oTarget
// * Required for Alter Self at least.
void SMP_ApplyPolymorphDuration(object oTarget, effect ePoly, float fDuration);
// SMP_INC_APPLY. Polymorph version. Removes polymorph effects.
// Then, applies eVis instantly, and ePoly for a permanent Duration, on oTarget
// * Required for Alter Self at least.
void SMP_ApplyPolymorphPermanentAndVFX(object oTarget, effect eVis, effect ePoly);

// SMP_INC_APPLY. Reverts the appearance of oCreature back to what they should
// be. Will NOT change anything if they are polymorphed. Will not change anything
// if they have got nSpellId on them, should default to Alter Self.
// * NPC's have thier original appearance set via. integer
// * PC's will be reverted to appopriate race and gender.
void SMP_RevertAppearance(object oCreature, int nSpellId = SMP_SPELL_ALTER_SELF);

// Start functions.

// Returns the first caster of nSpell on oTarget. Should really only be used
// for spells which only 1 can be applied at once.
object SMP_FirstCasterOfSpellEffect(int nSpell, object oTarget)
{
    // Need to have the spell anyway. This is better then looping.
    if(GetHasSpellEffect(nSpell, oTarget))
    {
        //Search through the valid effects on the target.
        effect eCheck = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eCheck))
        {
            if(GetEffectSpellId(eCheck) == nSpell)
            {
                return GetEffectCreator(eCheck);
            }
            //Get next effect on the target
            eCheck = GetNextEffect(oTarget);
        }
    }
    return OBJECT_INVALID;
}
// This will instanlty apply EffectDamage using the parameters.
// - This is used for all applying damage effects.
// - Used for Shield Other.
void SMP_ApplyDamageToObject(object oTarget, int nDamageAmount, int nDamageType = DAMAGE_TYPE_MAGICAL, int nDamagePower = DAMAGE_POWER_PLUS_TWENTY)
{
    if(nDamageAmount <= 0) return;
    // Define damage + type + power
    effect eDamage = EffectDamage(nDamageAmount, nDamageType, nDamagePower);
    if(nDamageAmount > 0 && GetHasSpellEffect(SMP_SPELL_SHIELD_OTHER, oTarget))
    {
        object oCaster = SMP_FirstCasterOfSpellEffect(SMP_SPELL_SHIELD_OTHER, oTarget);
        if(GetIsObjectValid(oCaster) && !GetIsDead(oCaster))
        {
            // Half damage to each
            eDamage = EffectDamage(nDamageAmount/2, nDamageType, nDamagePower);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oCaster);
        }
        else
        {
            SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_SHIELD_OTHER, oTarget);
        }
    }
    // Damage applied (weather it is half or not)
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
}
// This will instanlty apply EffectDamage using the parameters.
// - This is used for all applying damage effects.
// - Used for Shield Other.
// It also applys eVis to oTarget.
void SMP_ApplyDamageVFXToObject(object oTarget, effect eVis, int nDamageAmount, int nDamageType = DAMAGE_TYPE_MAGICAL, int nDamagePower = DAMAGE_POWER_PLUS_TWENTY)
{
    if(nDamageAmount <= 0) return;
    // Visual then damage
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    SMP_ApplyDamageToObject(oTarget, nDamageAmount, nDamageType, nDamagePower);
}

// Apply eVis on oTarget at once
void SMP_ApplyVFX(object oTarget, effect eVis)
{
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
// Apply both eVis and eInstant on oTarget at once
void SMP_ApplyInstantAndVFX(object oTarget, effect eVis, effect eInstant)
{
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eInstant, oTarget);
}
// Apply eInstant on oTarget at once
void SMP_ApplyInstant(object oTarget, effect eInstant)
{
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eInstant, oTarget);
}
// Apply eVis instantly, and eDur for fDuration, on oTarget
void SMP_ApplyDurationAndVFX(object oTarget, effect eVis, effect eDur, float fDuration)
{
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration);
}
// Apply eDur for fDuration, on oTarget
void SMP_ApplyDuration(object oTarget, effect eDur, float fDuration)
{
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration);
}
// Apply eVis instantly, and eDur Permanently, on oTarget
void SMP_ApplyPermanentAndVFX(object oTarget, effect eVis, effect eDur)
{
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDur, oTarget);
}
// Apply eDur permanently, on oTarget
void SMP_ApplyPermanent(object oTarget, effect eDur)
{
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDur, oTarget);
}
// We use this for any "Death" effects, such as temporal stasis, where you are
// invunrable (or worse, not) and are alone. This pops up a similar thing to
// Petrify, the death panel (with no reload) using sMessage.
// * Will use nCasterLevel to do rounds version, if it is not hardcore or higher.
void SMP_ApplyPermanentDeath(object oTarget, effect eDur, int nCasterLevel, string sMessage)
{
    // * The duration is permanent against NPCs but only temporary against PCs
    //   unless the PC's are playing core rules or higher.
    if(GetIsPC(oTarget))
    {
        // * Under hardcore rules or higher, this is an instant death
        if(GetGameDifficulty() >= GAME_DIFFICULTY_CORE_RULES)
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDur, oTarget);
            // Death panel
            DelayCommand(2.75, PopUpDeathGUIPanel(oTarget, FALSE, TRUE, 0, sMessage));
        }
        else
        {
            // Apply for nCasterLevel rounds.
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(nCasterLevel));
        }
    }
    else
    // * NPCs get full effect. No death panel.
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDur, oTarget);
    }
    // April 2003: Clearing actions to kick them out of conversation when petrified
    AssignCommand(oTarget, ClearAllActions());
}
// Applies eImpact at lTarget instantly
void SMP_ApplyLocationVFX(location lTarget, effect eImpact)
{
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
}
// Applies eAOE at lTarget for fDuration.
void SMP_ApplyLocationDuration(location lTarget, effect eAOE, float fDuration)
{
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);
}

// Applies eImpact instantly, and eAOE for fDuration, at lTarget.
void SMP_ApplyLocationDurationAndVFX(location lTarget, effect eImpact, effect eAOE, float fDuration)
{
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);
}
// Applies eImpact instantly, and eAOE permanently, at lTarget.
// Rarely used.
void SMP_ApplyLocationPermanentAndVFX(location lTarget, effect eImpact, effect eAOE)
{
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
    ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eAOE, lTarget);
}


// Makes sure oTarget dies via. Magical Damage - goes through any spells used
// for the other functions.
// * Use for non-death "death" effects, such as Blight.
// * Only use Magical, possibly Divine, Negative and Posistive damage types.
void SMP_ApplyDeathByDamage(object oTarget, int nDamageType = DAMAGE_TYPE_MAGICAL)
{
    // This should always kill any PC or NPC
    int nDam = GetMaxHitPoints(oTarget) + 10;

    // Damage effect
    effect eDam = EffectDamage(nDam, nDamageType, DAMAGE_POWER_PLUS_TWENTY);

    // Apply it
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
}
// Makes sure oTarget dies via. Magical Damage - goes through any spells used
// for the other functions.
// * See original.
// * Also applies eVis.
void SMP_ApplyDeathByDamageAndVFX(object oTarget, effect eVis, int nDamageType = DAMAGE_TYPE_MAGICAL)
{
    // Do VFX
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

    // Do original function
    SMP_ApplyDeathByDamage(oTarget, nDamageType);
}
// Apply an instant visual that misses or hits oTarget, depending on nTouchResult.
void SMP_ApplyTouchVisual(object oTarget, int nVis, int nTouchResult)
{
    effect eVis = EffectVisualEffect(nVis, (nTouchResult == FALSE));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
// Apply an instant beam that misses or hits oTarget, depending on nTouchResult.
// * You can change fDuration. Standard duration is 1.5 seconds.
void SMP_ApplyTouchBeam(object oTarget, int nBeam, int nTouchResult, float fDuration = 1.5)
{
    effect eBeam = EffectBeam(nBeam, OBJECT_SELF, BODY_NODE_HAND, (nTouchResult == FALSE));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, fDuration);
}

// Grenade attack
// * nDirectDam - Random Damage (Do the roll before), nSplashDam is normally 1.
// * nVisVFX - Impact VFX. nAOEVFX - must be over 0, if there is an AOE blast
// * nDamageType - Damage type of nDirectDam and nSplashDam.
// * fExplosionRadius - Radius of the blast, in meters
// * nObjectFilter - What objects are hurt by the spell. Should match the object types in spells.2da
// * nRacialType1/2 - A specific racial type to damage. Can be ALL for all.
// * nAlignment - A specific Good/Evil alignment to damage. Can be ALL for all.
void SMP_Grenade(int nDirectDam, int nSplashDam, int nVisVFX, int nAOEVFX, int nDamageType, float fExplosionRadius, int nObjectFilter, int nRacialType1 = RACIAL_TYPE_ALL, int nRacialType2 = RACIAL_TYPE_ALL, int nAlignment = ALIGNMENT_ALL)
{
    // Declare major variables
    object oTarget = GetSpellTargetObject();
    object oDoNotDam;
    location lTarget = GetSpellTargetLocation();
    int nTouch, nDam;
    int nSpellId = GetSpellId();
    effect eVis = EffectVisualEffect(nVisVFX);
    effect eAOE = EffectVisualEffect(nAOEVFX);
    effect eDam;

    // We use nTouch as a result for if we do damage to oTarget. If oTarget
    // is valid, nTouch is a ranged touch attack, else it is false anyway.
    if(GetIsObjectValid(oTarget))
    {
        nTouch = TouchAttackRanged(oTarget);
    }
    // Check if we hit, or even have anything to hit!
    if(nTouch >= 1)
    {
        // Get direct damage to do
        nDam = nDirectDam;
        // Critical hit?
        if(nTouch == 2)
        {
            nDam *= 2;
        }
        // Set damage effect
        eDam = EffectDamage(nDam, nDamageType);

        // Check reaction type
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Check racial type and alignment
            // * No need for object type check - that will be in the
            //   actual spells.2da information bit for target type.
            if((nRacialType1 == RACIAL_TYPE_ALL ||
                GetRacialType(oTarget) == nRacialType1 ||
                GetRacialType(oTarget) == nRacialType2) &&
               (nAlignment == ALIGNMENT_ALL ||
                GetAlignmentGoodEvil(oTarget) == nAlignment))
            {
                // Apply damage and VFX
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                // Signal event spell cast at
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellId));
            }
        }
        // We set to not damage oTarget now, because we directly hit them!
        oDoNotDam = oTarget;
    }

    // Stop if no AOE blast
    if(nAOEVFX <= FALSE) return;

    // Even if we miss, it's going to end up near the persons feat, we can't
    // be that bad a shot. So, we do AOE damage to everyone but oDoNotDam, which,
    // if we hit them, will be oTarget.

    // Apply AOE VFX
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eAOE, lTarget);

    //Set the damage effect
    eDam = EffectDamage(nSplashDam, nDamageType);

    // Cycle through the targets within the spell shape until an invalid object is captured.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fExplosionRadius, lTarget, TRUE, nObjectFilter);
    while(GetIsObjectValid(oTarget))
    {
        // Check PvP and make sure it isn't the target
        if(!GetIsReactionTypeFriendly(oTarget) &&
            oDoNotDam != oTarget)
        {
            // Get short delay as fireball
            float fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            // Check racial type and alignment
            if((nRacialType1 == RACIAL_TYPE_ALL ||
                GetRacialType(oTarget) == nRacialType1 ||
                GetRacialType(oTarget) == nRacialType2) &&
               (nAlignment == ALIGNMENT_ALL ||
                GetAlignmentGoodEvil(oTarget) == nAlignment))
            {
                // Apply effects to the currently selected target.
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellId));

                // Delay the damage and visual effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }
        // Get the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fExplosionRadius, lTarget, TRUE, nObjectFilter);
    }
}

// Polymorph version. Removes polymorph effects.
// Then, applies eVis instantly, and ePoly for fDuration, on oTarget
// * Required for Alter Self at least.
void SMP_ApplyPolymorphDurationAndVFX(object oTarget, effect eVis, effect ePoly, float fDuration)
{
    // Apply VFX
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

    // This will remove previous polymorphs.
    SMP_ApplyPolymorphDuration(oTarget, ePoly, fDuration);
}
// Polymorph version. Removes polymorph effects.
// Then, applies eVis instantly, and ePoly for a permanent Duration, on oTarget
// * Required for Alter Self at least.
void SMP_ApplyPolymorphPermanentAndVFX(object oTarget, effect eVis, effect ePoly)
{
    // Apply VFX
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

    // Remove previous polymorph.
    SMP_RemoveSpecificEffect(EFFECT_TYPE_POLYMORPH, oTarget, SUBTYPE_IGNORE);

    // Remove any Alter Self's
    SMP_RevertAppearance(oTarget, SPELL_INVALID);

    // Remove alter self spell
    SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_ALTER_SELF, oTarget);

    // Apply the new one after the old has been removed.
    // - Short delay!
    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oTarget));
}
// Polymorph version. Removes polymorph effects.
// Then, applies ePoly for fDuration, on oTarget
// * Required for Alter Self at least.
void SMP_ApplyPolymorphDuration(object oTarget, effect ePoly, float fDuration)
{
    // Remove previous polymorph.
    SMP_RemoveSpecificEffect(EFFECT_TYPE_POLYMORPH, oTarget, SUBTYPE_IGNORE);

    // Remove any Alter Self's
    SMP_RevertAppearance(oTarget, SPELL_INVALID);

    // Remove alter self spell
    SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_ALTER_SELF, oTarget);

    // Apply the new one after the old has been removed.
    // - Short delay!
    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oTarget, fDuration));
}

// SMP_INC_APPLY. Reverts the appearance of oCreature back to what they should
// be. Will NOT change anything if they are polymorphed. Will not change anything
// if they have got nSpellId on them, should default to Alter Self.
// * NPC's have thier original appearance set via. integer
// * PC's will be reverted to appopriate race and gender.
void SMP_RevertAppearance(object oCreature, int nSpellId = SMP_SPELL_ALTER_SELF)
{
    // First, check for nSpellId OR Polymorph. If they have it, all is well,
    if(SMP_GetHasEffect(EFFECT_TYPE_POLYMORPH, oCreature) ||
       GetHasSpellEffect(nSpellId, oCreature))
    {
        // Get appearance to set
        int nAppearance = APPEARANCE_TYPE_HUMAN;

        // Check if NPC or PC
        if(GetIsPC(oCreature))
        {
            // PC's revert as to thier default race. The race will be thier
            // own (note: will default to human) as they are not polymorphed.
            switch(GetRacialType(oCreature))
            {
                case RACIAL_TYPE_DWARF: { nAppearance = APPEARANCE_TYPE_DWARF; } break;
                case RACIAL_TYPE_ELF: { nAppearance = APPEARANCE_TYPE_ELF; } break;
                case RACIAL_TYPE_HALFELF: { nAppearance = APPEARANCE_TYPE_HALF_ELF; } break;
                case RACIAL_TYPE_HALFLING: { nAppearance = APPEARANCE_TYPE_HALFLING; } break;
                case RACIAL_TYPE_HALFORC: { nAppearance = APPEARANCE_TYPE_HALF_ORC; } break;
                case RACIAL_TYPE_HUMAN: { nAppearance = APPEARANCE_TYPE_HUMAN; } break;
                case RACIAL_TYPE_GNOME: { nAppearance = APPEARANCE_TYPE_GNOME; } break;
                // Default to human
                default: { nAppearance = APPEARANCE_TYPE_HUMAN; } break;
            }
        }
        else
        {
            // Else, use stored constant
            nAppearance = SMP_GetLocalConstant(oCreature, "SMP_DEFAULT_APPEARANCE");

            // On Error: Oh no. Stop.
            if(nAppearance == -1) return;
        }
        // Why do it twice?
        if(nAppearance != GetAppearanceType(oCreature))
        {
            // Set appearance
            SetCreatureAppearanceType(oCreature, nAppearance);
        }
    }
}


// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
