/*:://////////////////////////////////////////////
//:: Spell Name Val Flare
//:: Spell FileName SMP_S_ValFlare
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation
    Level: Sor/Wiz 5
    Components: V, S,
    Casting Time: 1 standard action
    Range: Medium (20M)
    Area: See text
    Duration: Instantaneous
    Saving Throw: Reflex Partial/Reflex Half
    Spell Resistance: Yes
    Source: Various (UnholyDragoon)

    This spell combines the effects of Flare Arrow with that of Fireball to
    produce a targeted burst for lethal amounts of fire damage. Upon completion
    of the spell, an arrow of fire appears. This arrow will fly towards a target,
    possibly hitting them full on.

    The caster makes a ranged touch attack. On a succesful hit, the target takes
    5d6 points of fire damage. If the arrow misses, the target recieves no target
    damage. The arrow then balloons out in a 8.88M radius (25-ft) burst, dealing
    1d6 points of fire damage/caster level (to a maximum of 15d6). The target
    cannot reduce the initial fiery arrow damage, but is allowed a reflex save
    for half of the burst effect. Everyone else in the area of effect gets a
    reflex save for half as normal.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Cool fireball/flare arrow combo.

    We can do this using Biowares fire arrow visual.

    Make the saves instantly, and the area is much larger (8.33M)

    Oh, and the target only makes one SR check.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_VAL_FLARE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    object oOriginalTarget = GetSpellTargetObject();
    location lTarget = GetLocation(oOriginalTarget);// I would normally use GetSpellTargetLocation()
    int nCasterLevel = SMP_GetCasterLevel();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nTargetResist;// Only check the SR of oOriginalTarget, once.
    int nDam;
    float fDelay, fInitialDelay, fDist;

    // Limit dice to 15d6
    int nDice = SMP_LimitInteger(nCasterLevel, 15);

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eArrow = EffectVisualEffect(VFX_IMP_MIRV_FLAME);

    // We do the flame arrow first
    SMP_ApplyVFX(oOriginalTarget, eVis);

    // Get initial delay
    fDist = GetDistanceBetween(oCaster, oOriginalTarget);
    fInitialDelay = fDist/(3.0 * log(fDist) + 2.0);// Bioware caculation

    // See if we hit
    if(SMP_SpellTouchAttack(SMP_TOUCH_RANGED, oOriginalTarget))
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oOriginalTarget, oCaster) &&
        // Make sure they are not immune to spells
           !SMP_TotalSpellImmunity(oOriginalTarget))
        {
            // Spell resistance And immunity checking.
            nTargetResist = SMP_SpellResistanceCheck(oCaster, oOriginalTarget, fDelay);
            if(!nTargetResist)
            {
                // Note: No signal event. The AOE always happens, so it will do one
                // if appropriate.

                // 5d6 damage, as we hit.
                nDam = SMP_MaximizeOrEmpower(6, 5, nMetaMagic);

                // Apply the damage after X time.
                DelayCommand(fInitialDelay, SMP_ApplyDamageVFXToObject(oOriginalTarget, eVis, nDam, DAMAGE_TYPE_FIRE));
            }
        }
    }

    // Apply AOE location explosion, after the delay
    effect eImpact = EffectVisualEffect(VFX_FNF_FIREBALL);
    DelayCommand(fInitialDelay, SMP_ApplyLocationVFX(lTarget, eImpact));

    // Get all targets in a sphere, 8.33M radius, all creatures, placeables amd doors.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 8.33, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    // Loop targets
    while(GetIsObjectValid(oTarget))
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
        // Make sure they are not immune to spells
           !SMP_TotalSpellImmunity(oTarget))
        {
            //Fire cast spell at event for the specified target
            SMP_SignalSpellCastAt(oTarget, SMP_SPELL_FIREBALL);

            //Get the distance between the explosion and the target to calculate delay
            fDelay = fInitialDelay + GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            // Only check SR once for the original target, if any.
            if((oTarget == oOriginalTarget && !nTargetResist) ||
                oTarget != oOriginalTarget)
            {
                // Spell resistance And immunity checking.
                if(!SMP_SpellResistanceCheck(oCaster, oTarget, fDelay))
                {
                    // Roll damage for each target
                    nDam = SMP_MaximizeOrEmpower(6, nDice, nMetaMagic);

                    // Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                    nDam = SMP_GetAdjustedDamage(SAVING_THROW_REFLEX, nDam, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_FIRE, oCaster, fDelay);

                    // Need to do damage to apply visuals
                    if(nDam > 0)
                    {
                        // Apply effects to the currently selected target.
                        DelayCommand(fDelay, SMP_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_FIRE));
                    }
                }
            }
        }
        // Get Next Target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 8.33, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
