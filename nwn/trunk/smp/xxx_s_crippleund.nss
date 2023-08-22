/*:://////////////////////////////////////////////
//:: Spell Name Cripple Undead
//:: Spell FileName XXX_S_CrippleUnd
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy
    Level: Sor/Wiz 2
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: One orb of Positive Energy; see text
    Duration: see text
    Saving Throw: Depends; see text
    Spell Resistance: Yes
    Source: Various (schulerta)

    An orb of pulsating positive energy springs from your hand and speeds to its
    target. The caster has two options for this spell, either affect 1 undead
    target, or multiple undead targets in a 6.67M-radius (20').

    To affect one target, the caster must make a ranged touch attack to hit, and
    if the orb hits an undead creature it deals 2d6 points of damage initially.
    Once the orb strikes its target it latches on and pulses positive energy for
    an additional 2d6 points of damage to the target once every round for the
    duration. This use of the spell lasts one additional round for every two
    caster levels, up to a maximum of 5 additional rounds.

    The caster may choose to have the orb explode in a in a 6.67M-radius (20')
    burst of positive energy that causes 1d6 points of damage per caster level
    (max 10d6) to undead caught in the area of effect. This use of the spell
    allows the target(s) a reflex save for half damage.

    This spell cannot be used to heal living creatures.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Aim at the ground to hit a burst.

    Aim at a undead to range touch attack it.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

// Delayed for 6 seconds, this runs itself until oTarget is dead,
// or they don't have the spell's effect anymore.
void SMP_RunCrippleImpact(int nMetaMagic, object oTarget, object oCaster);

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_CRIPPLE_UNDEAD)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = SMP_GetCasterLevel();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nDam;
    float fDelay;

    // Limit dice to 10d6 for burst.
    int nDice = SMP_LimitInteger(nCasterLevel, 10);

    // Duration effect.
    float fDuration = SMP_GetDuration(SMP_MINUTES, nCasterLevel/2, nMetaMagic) + 0.5;

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);

    // Are we targeting one, or more then one, person?
    if(GetIsObjectValid(oTarget))
    {
        // Fire cast spell at event for the specified target
        SMP_SignalSpellCastAt(oTarget, SMP_SPELL_CRIPPLE_UNDEAD);

        // Targeting one thing - ranged touch attack.
        if(SMP_SpellTouchAttack(SMP_TOUCH_RANGED, oTarget))
        {
            // We check if they are undead!
            if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
            {
                // We hit, thus we do damage, and "latch on"
                effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

                // Get damage
                nDam = SMP_MaximizeOrEmpower(6, 2, nMetaMagic);

                // Hit, damage, and duration
                SMP_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_POSITIVE);

                // Duration effect. Cannot stack
                if(!SMP_GetHasSpellEffectFromCaster(SMP_SPELL_CRIPPLE_UNDEAD, oTarget, oCaster))
                {
                    // Apply new one
                    SMP_ApplyDuration(oTarget, eDur, fDuration);

                    // Delay latching
                    DelayCommand(6.0, SMP_RunCrippleImpact(nMetaMagic, oTarget, oCaster));
                }
                else
                {
                    // Cannot affect again. Only imact is done.
                    FloatingTextStringOnCreature("*You cannot pulse an undead target twice*", oTarget, FALSE);
                    return;
                }
            }
        }
    }
    else
    {
        // Apply AOE visual
        effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_20);
        SMP_ApplyLocationVFX(lTarget, eImpact);

        // Get all targets in a sphere, 6.67M radius, creatures
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 6.67, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        // Loop targets
        while(GetIsObjectValid(oTarget))
        {
            // PvP Check
            if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
            // Make sure they are not immune to spells
               !SMP_TotalSpellImmunity(oTarget))
            {
                // Check racial type
                if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
                {
                    // Fire cast spell at event for the specified target
                    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_CRIPPLE_UNDEAD);

                    //Get the distance between the explosion and the target to calculate delay
                    fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

                    // Spell resistance And immunity checking.
                    if(!SMP_SpellResistanceCheck(oCaster, oTarget, fDelay))
                    {
                        // Roll damage for each target
                        nDam = SMP_MaximizeOrEmpower(6, nDice, nMetaMagic);

                        // Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                        nDam = SMP_GetAdjustedDamage(SAVING_THROW_REFLEX, nDam, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_POSITIVE, oCaster, fDelay);

                        // Need to do damage to apply visuals
                        if(nDam > 0)
                        {
                            // Apply effects to the currently selected target.
                            DelayCommand(fDelay, SMP_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_POSITIVE));
                        }
                    }
                }
            }
            // Get Next Target
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, 6.67, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }
    }
}

// Delayed for 6 seconds, this runs itself until oTarget is dead,
// or they don't have the spell's effect anymore.
void SMP_RunCrippleImpact(int nMetaMagic, object oTarget, object oCaster)
{
    // Check if dead or validity of oTarget.
    if(!GetIsDead(oTarget) && GetIsObjectValid(oTarget))
    {
        // Check the caster.
        if(GetIsObjectValid(oCaster))
        {
            // Check if they have the effect
            if(SMP_GetHasSpellEffectFromCaster(SMP_SPELL_CRIPPLE_UNDEAD, oTarget, oCaster))
            {
                // Fire spell cast at event for target
                SMP_SignalSpellCastAt(oTarget, SMP_SPELL_CRIPPLE_UNDEAD);

                // Roll damage
                int nDamage = SMP_MaximizeOrEmpower(6, 2, nMetaMagic);

                // Visual
                effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);

                SMP_ApplyDamageVFXToObject(oTarget, eVis, nDamage, DAMAGE_TYPE_POSITIVE);

                // Run it again
                DelayCommand(6.0, SMP_RunCrippleImpact(nMetaMagic, oTarget, oCaster));
            }
        }
        else
        {
            // Remove the spells effects
            SMP_PRCRemoveSpellEffects(SMP_SPELL_CRIPPLE_UNDEAD, oCaster, oTarget);
        }
    }
}
