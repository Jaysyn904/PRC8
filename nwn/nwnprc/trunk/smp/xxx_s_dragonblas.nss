/*:://////////////////////////////////////////////
//:: Spell Name Dragonblast
//:: Spell FileName XXX_S_Dragonblast
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [See Text]
    Level: Sor/Wiz 5
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Medium (20M)
    Target: One creature or object
    Duration: Instantaneous
    Saving Throw: Reflex Partial (see text)
    Spell Resistance: Yes
    Source: Various (IceFractal)

    A glowing, somewhat blurred image of dragon flies from your outstretched
    hand, attacking the creature or object targeted with two claws (1d6 slashing
    damage each), a bite (2d6 piercing damage), two wings (1d6 bludgeoning
    damage each), a tail slap (2d6 bludgeoning damage), and a breath weapon
    (1d6 + 1d6/caster level above 10th, maximum 10d6 at level 20) energy damage,
    type of damage is chosen by caster. The damage type chosen by the caster
    makes the spell a spell of that element, eg. fire damage makes it a [Fire]
    spell. The breath weapon does normal energy damage and allows a reflex save
    for half. All of the attacks hit automatically, there is no attack roll by
    the caster required.

    Arcane Material Component: A dragon scale.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Although it is easy to script, the VFX might be harder - although it would
    be insannneeellyyy cool to have! A projectile and a proper impact probably.

    It is quite a hard spell to work out, but does:
    x2 1d6 slashing
    2d6 Piercing
    2x 1d6 bludgeoning
    2d6 bludgeoning

    And the breath weapon, at 1d6+.

    Meaning 9d6 minimum, 19d6 maximum.

    Is this unbalanced? its easily changed!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_DRAGONBLAST)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = SMP_GetCasterLevel();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nDam;
    float fDelay;

    // Get breath weapon damage, and thusly the save type
    int nBreathWeaponDamage = GetLocalInt(oCaster, "SMP_SPELL_DRAGONBLAST_TYPE");

    // Default to fire
    int nDamageType = DAMAGE_TYPE_FIRE;
    int nSaveType = SAVING_THROW_TYPE_FIRE;

    // Fire
    if(nBreathWeaponDamage == 0)
    {
        nDamageType = DAMAGE_TYPE_FIRE;
        nSaveType = SAVING_THROW_TYPE_FIRE;
    }
    // Cold
    else if(nBreathWeaponDamage == 1)
    {
        nDamageType = DAMAGE_TYPE_COLD;
        nSaveType = SAVING_THROW_TYPE_COLD;
    }
    // Sonic
    else if(nBreathWeaponDamage == 2)
    {
        nDamageType = DAMAGE_TYPE_SONIC;
        nSaveType = SAVING_THROW_TYPE_SONIC;
    }
    // Acid
    else if(nBreathWeaponDamage == 3)
    {
        nDamageType = DAMAGE_TYPE_ACID;
        nSaveType = SAVING_THROW_TYPE_ACID;
    }
    // Electrical
    else if(nBreathWeaponDamage == 4)
    {
        nDamageType = DAMAGE_TYPE_ELECTRICAL;
        nSaveType = SAVING_THROW_TYPE_ELECTRICITY;
    }

    // Get the amount of d6's for the breath weapon
    int nBreathDice = SMP_LimitInteger(nCasterLevel - 10, 10);

    // Delcare effects
    effect eVis = EffectVisualEffect(SMP_VFX_IMP_DRAGONBLAST);


    // PvP check
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Signal event
        SMP_SignalSpellCastAt(oTarget, SMP_SPELL_DRAGONBLAST);


        // SR Resistance
        if(!SMP_SpellResistanceCheck(oCaster, oTarget))
        {
            // Do two claws (1d6 slashing damage each)
            nDam = SMP_MaximizeOrEmpower(6, 1, nMetaMagic);
            SMP_ApplyDamageToObject(oTarget, nDam, DAMAGE_TYPE_SLASHING);
            nDam = SMP_MaximizeOrEmpower(6, 1, nMetaMagic);
            SMP_ApplyDamageToObject(oTarget, nDam, DAMAGE_TYPE_SLASHING);

            // a bite (2d6 piercing damage)
            nDam = SMP_MaximizeOrEmpower(6, 2, nMetaMagic);
            DelayCommand(0.1, SMP_ApplyDamageToObject(oTarget, nDam, DAMAGE_TYPE_PIERCING));

            // two wings (1d6 bludgeoning damage each)
            nDam = SMP_MaximizeOrEmpower(6, 1, nMetaMagic);
            DelayCommand(0.2, SMP_ApplyDamageToObject(oTarget, nDam, DAMAGE_TYPE_BLUDGEONING));
            nDam = SMP_MaximizeOrEmpower(6, 1, nMetaMagic);
            DelayCommand(0.2, SMP_ApplyDamageToObject(oTarget, nDam, DAMAGE_TYPE_BLUDGEONING));

            // a tail slap (2d6 bludgeoning damage)
            nDam = SMP_MaximizeOrEmpower(6, 2, nMetaMagic);
            DelayCommand(0.3, SMP_ApplyDamageToObject(oTarget, nDam, DAMAGE_TYPE_BLUDGEONING));

            // and a breath weapon (1d6 + 1d6/caster level above 10th,
            // maximum 10d6 at level 20) energy damage
            nDam = SMP_MaximizeOrEmpower(6, nBreathDice, nMetaMagic);

            // Reflex save
            nDam = SMP_GetAdjustedDamage( SAVING_THROW_REFLEX, nDam, oTarget, nSpellSaveDC, nSaveType, oCaster, 0.4);

            if(nDam > 0)
            {
                DelayCommand(0.4, SMP_ApplyDamageToObject(oTarget, nDam, nDamageType));
            }
        }
    }
}
