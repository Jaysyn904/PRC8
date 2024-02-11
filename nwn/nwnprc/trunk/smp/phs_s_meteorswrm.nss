/*:://////////////////////////////////////////////
//:: Spell Name Meteor Swarm
//:: Spell FileName PHS_S_MeteorSwrm
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Fire]
    Level: Sor/Wiz 9
    Components: V, S
    Casting Time: 1 standard action
    Range: Long (40M)
    Area: Four 13.33-M.-radius spreads; see text
    Duration: Instantaneous
    Saving Throw: None or Reflex half; see text
    Spell Resistance: Yes

    Meteor swarm is a very powerful and spectacular spell that is similar to
    fireball in many aspects. When you cast it, four flaming spheres spring from
    your outstretched hand and streak in straight lines to the spots you select.
    The meteor spheres leave a fiery trail of sparks.

    Once cast, the other flaming spheres will be targeted at 3 different targets
    other then the target selected (if one is valid), in a 10-M radius sphere.

    If you aim a sphere at a specific creature, you may make a ranged touch
    attack to strike the target with the meteor. Any creature struck by one of
    these spheres takes 2d6 points of bludgeoning damage (no save) and receives
    no saving throw against the sphere’s fire damage (see below). If a targeted
    sphere misses its target, it simply explodes at the location of the target.

    Once a sphere reaches its destination, it explodes in a 13.33-meter-radius
    spread, dealing 6d6 points of fire damage to each creature in the area. If
    a creature is within the area of more than one sphere, it must save
    separately against each. (Fire resistance applies to each sphere’s damage
    individually.)
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Ok:

    - We target one, and it explodes as normal, if a target is selected,
      it won't be targeted by another.
    - Then, 3 other "missiles" may be fired, up to 3, as long as it isn't us,
      or the target just targeted.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Constant used just in this spell
const string PHS_METEOR_SWARM_ONLY_BLAST = "PHS_METEOR_SWARM_ONLY_BLAST";

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_METEOR_SWARM)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oSpellTarget = GetSpellTargetObject();
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nSpellSaveDC = PHS_GetSpellSaveDC(); // Special - see below
    int nDam;
    float fDelay;
    // Compared to those in loop. If any == oTargetHit, no save!
    object oTargetHit;

    // The old (and proper) stored DC is used if nOnlyBlast is > 0
    // It is stored to it (onyl one variable needed then)
    int nOnlyBlast = GetLocalInt(oCaster, PHS_METEOR_SWARM_ONLY_BLAST);
    if(nOnlyBlast > 0)
    {
        nSpellSaveDC = nOnlyBlast;
    }

    // Declare effects
    effect eImpact = EffectVisualEffect(PHS_VFX_FNF_METEOR_SWARM);

    // Apply AOE visual
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // If oTarget is valid, we check if we hit them for extra damage
    if(GetIsObjectValid(oSpellTarget))
    {
        // Make a touch attack
        if(PHS_SpellTouchAttack(PHS_TOUCH_RANGED, oSpellTarget))
        {
            // Do some bludgeoning damage to this target
            nDam = PHS_MaximizeOrEmpower(6, 2, FALSE);
            // No delay to this damage as it should be the impact of the spell!
            PHS_ApplyDamageToObject(oSpellTarget, nDam, DAMAGE_TYPE_BLUDGEONING);
            // This target now gets no save against this blast!
            oTargetHit = oSpellTarget;
        }
    }

    // Always do damage for this script - the integer below specifices if we
    // do more targets with it. Target all objects that can be damaged in 40ft radius.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 13.33, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oTarget))
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster))
        {
            //Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_METEOR_SWARM);

            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            // Spell resistance And immunity checking.
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Roll damage for each target - 6d6
                nDam = PHS_MaximizeOrEmpower(6, 6, FALSE);

                // Only do reflex save if not hit
                if(oTarget != oTargetHit)
                {
                    // Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                    nDam = PHS_GetAdjustedDamage(SAVING_THROW_REFLEX, nDam, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_FIRE);
                }
                // Need to do damage to apply visuals
                if(nDam > 0)
                {
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, PHS_ApplyDamageToObject(oTarget, nDam, DAMAGE_TYPE_FIRE));
                }
            }
        }
        // Get next target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 13.33, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }

    // Check if we do more blasts
    if(!nOnlyBlast) // PHS_METEOR_SWARM_ONLY_BLAST
    {
        // Stop what we are doing
        ClearAllActions();
        // Set so that the next 3 will only do damage, thats it.
        SetLocalInt(OBJECT_SELF, PHS_METEOR_SWARM_ONLY_BLAST, nSpellSaveDC);
        DelayCommand(2.5, DeleteLocalInt(OBJECT_SELF, PHS_METEOR_SWARM_ONLY_BLAST));

        // Get the targets
        int nCnt = 0;
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 10.0, lTarget, TRUE);
        // Max of 3 more, up to 10M from original location.
        while(GetIsObjectValid(oTarget) && nCnt <= 3)
        {
            if(oTarget != OBJECT_SELF && oTarget != oSpellTarget)
            {
                nCnt++;
                ActionCastSpellAtObject(PHS_SPELL_METEOR_SWARM, oTarget, METAMAGIC_NONE, TRUE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, 10.0, lTarget, TRUE);
        }
    }
}
