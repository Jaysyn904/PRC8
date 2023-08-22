/*:://////////////////////////////////////////////
//:: Spell Name Fire Seeds: Acorns
//:: Spell FileName PHS_S_FireSeeds1
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    OK, simply put:

    - We use Acorns (A misc. Small item), and add a new item property which
      will cast a spell as if it was a grenade, and acts like one. Reflex saves
      are put as a DC on the item when the property is added, along with the
      caster level. SCRIPT: PHS_S_FIRESEEDS1

    So, this is the impact script for the acorns.

//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Based on the grenade thing.

    // Declare major variables
    object oTarget = GetSpellTargetObject();
    object oDoNotDam;
    object oItem = GetSpellCastItem();
    location lTarget = GetSpellTargetLocation();
    int nTouch, nDam;
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    effect eImpact = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
    effect eDam;
    float fDelay;
    float fExplosionRadius = 1.67;

    // Get the random dice and spell saves from the item directly.
    int nSpellSaveDC = GetLocalInt(oItem, "PHS_SPELL_FIRESEEDS_SAVEDC");
    int nDice = GetLocalInt(oItem, "PHS_SPELL_FIRESEEDS_DICE");

    // We do direct damage of d6 per nDice.
    int nDirectDam = PHS_MaximizeOrEmpower(6, nDice, FALSE);

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
        eDam = EffectDamage(nDam, DAMAGE_TYPE_FIRE);

        // Check reaction type
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Apply damage and VFX
            PHS_ApplyInstantAndVFX(oTarget, eVis, eDam);

            // Signal event spell cast at
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FIRE_SEEDS);
        }
        // We set to not damage oTarget now, because we directly hit them!
        oDoNotDam = oTarget;
    }

    // Even if we miss, it's going to end up near the persons feat, we can't
    // be that bad a shot. So, we do AOE damage to everyone but oDoNotDam, which,
    // if we hit them, will be oTarget.

    // Apply AOE visual
    PHS_ApplyLocationVFX(lTarget, eImpact);


    // Cycle through the targets within the spell shape until an invalid object is captured.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fExplosionRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        // Check PvP and make sure it isn't the target
        if(!GetIsReactionTypeFriendly(oTarget) &&
            oDoNotDam != oTarget)
        {
            // Get short delay as fireball
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            // Apply effects to the currently selected target.
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FIRE_SEEDS);

            // Get reflex adjusted damage
            nDam = GetReflexAdjustedDamage(nDice, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_FIRE);

            if(nDam > 0)
            {
                // Set the damage effect. It is now 1 per dice used.
                eDam = EffectDamage(nDam, DAMAGE_TYPE_FIRE);

                // Delay the damage and visual effects
                DelayCommand(fDelay, PHS_ApplyInstantAndVFX(oTarget, eVis, eDam));
            }
        }
        // Get the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fExplosionRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}
