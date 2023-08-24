/*:://////////////////////////////////////////////
//:: Spell Name Holy Water
//:: Spell FileName SP_HolyWater
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
Holy Water: Holy water damages undead creatures and evil outsiders almost as if it were acid. A flask of holy water can be thrown as a splash weapon.

Treat this attack as a ranged touch attack, with a maximum range of 8M. A direct hit by a flask of holy water deals 2d4 points of damage to an undead creature or an evil outsider. Each such creature within 1.67M (5 feet) of the point where the flask hits takes 1 point of damage from the splash.

Temples to good deities sell holy water at cost (making no profit).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "prc_inc_spells"

// Grenade attack
// * nDirectDam - Random Damage (Do the roll before), nSplashDam is normally 1.
// * nVisVFX - Impact VFX. nAOEVFX - must be over 0, if there is an AOE blast
// * nDamageType - Damage type of nDirectDam and nSplashDam.
// * fExplosionRadius - Radius of the blast, in meters
// * nObjectFilter - What objects are hurt by the spell. Should match the object types in spells.2da
// * nRacialType1/2 - A specific racial type to damage. Can be ALL for all.
// * nAlignment - A specific Good/Evil alignment to damage. Can be ALL for all.
void PRCDoGrenade(int nDirectDam, int nSplashDam, int nVisVFX, int nAOEVFX, int nDamageType, float fExplosionRadius, int nObjectFilter, int nRacialType1 = RACIAL_TYPE_ALL, int nRacialType2 = RACIAL_TYPE_ALL, int nAlignment = ALIGNMENT_ALL)
{
    // Declare major variables
    object oTarget = GetSpellTargetObject();
    object oDoNotDam;
    location lTarget = PRCGetSpellTargetLocation();
    int nTouch, nDam;
    int nSpellId = PRCGetSpellId();
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

void main()
{
    // Use the function to do the hit, blast ETC
    PRCDoGrenade(d4(2), 1, VFX_IMP_HEAD_HOLY, VFX_IMP_PULSE_HOLY, DAMAGE_TYPE_DIVINE, RADIUS_SIZE_HUGE, OBJECT_TYPE_CREATURE, RACIAL_TYPE_UNDEAD, RACIAL_TYPE_OUTSIDER, ALIGNMENT_EVIL);
}