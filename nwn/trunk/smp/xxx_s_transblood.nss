/*:://////////////////////////////////////////////
//:: Spell Name Transmute Blood to Water
//:: Spell FileName XXX_S_TransBlood
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Sor/Wiz 7
    Components: V, S
    Casting Time: 1 standard action
    Range: Touch
    Target: 1 living creature
    Duration: Instantaneous
    Saving Throw: Fortitude partial
    Spell Resistance: Yes
    Source: Various (Andvaranaut)

    An adaptation of Finger of Death, this diabolical spell actually transforms
    the very  life-blood of a victim into ordinary water, causing them to
    collapse in a lifeless heap. If you succeed at a melee touch attack, the
    intended victim is slain. However, if they make a  successful Fortitude
    saving throw, they somehow managed to survive the transformation, and
    instead suffer 5d6 points of damage and are dazed for one round.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This is an adaptation:

    Its Transmutation (not necromancy) and doesn't have the [Death] Descriptor.
    Means many spells which protect against Instant Death will not help here!
    Note: The death will be made in damage (HP * 2 + 20)

    BUT: It adds a touch attack, at touch range (the most dangerous for a caster)
    and still has the fortitude save and SR applied.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_TRANSMUTE_BLOOD_TO_WATER)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = SMP_GetCasterLevel();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    // Touch attack
    int nTouch = SMP_SpellTouchAttack(SMP_TOUCH_MELEE, oTarget);

    // Damage is 5d6.
    int nDamage = SMP_MaximizeOrEmpower(6, 5, nMetaMagic);

    // Delcare effects
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

    // Dazed for one round
    effect eDaze = EffectDazed();
    float fDuration = 6.0;

    // Signal Spell cast at
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_TRANSMUTE_BLOOD_TO_WATER);

    // PvP Check and touch check. Must also be living!
    if(!GetIsReactionTypeFriendly(oTarget) && nTouch &&
        SMP_GetIsAliveCreature(oTarget, "*Non-alive creatures have no blood*"))
    {
        // Spell Resistance + Immunity check
        if(!SMP_SpellResistanceCheck(oCaster, oTarget))
        {
            // Fortitude Saving throw
            if(!SMP_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC))
            {
                // Fail and we apply death
                SMP_ApplyDeathByDamageAndVFX(oTarget, eVis);
            }
            else
            {
                // Even if they pass, we do damage.
                SMP_ApplyDamageVFXToObject(oTarget, eVis, nDamage);
                // And daze for one round
                SMP_ApplyDuration(oTarget, eDaze, fDuration);
            }
        }
    }
}
