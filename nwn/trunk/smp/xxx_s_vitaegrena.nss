/*:://////////////////////////////////////////////
//:: Spell Name Vitae Grenade
//:: Spell FileName XXX_S_VitaeGren
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Sor/Wiz 5
    Components: V, S, F, M
    Casting Time: 1 standard action
    Range: Medium (20M)
    Area: 6.67M-radius (20-ft) spread, centered on 1 target creature
    Duration: Instantaneous
    Saving Throw: Fortitude partial
    Spell Resistance: Yes
    Source: Various (Andvaranaut)

    Upon casting this spell, a small vial of your own blood flies throught the
    air towards a designated target, which it strikes unerringly. In flight,
    the blood crystalizes and begins to become explosively unstable due to the
    magical energies channelled into it. Upon impact, the vial and blood
    crystals detonate, dealing 1d6 points of damage per 2 levels (to a maximum
    of 10d6) to all within the area of effect. This is non-elemental damage, and
    thus not subject to damage reduction from such spells as Protection from
    Elements.

    Additionally, all those unfortunate enough to be caught in the blast are
    knocked prone and coated with a fine, dust-like coating of the blood - until
    recently - contained within the vial. Unless completely washed off, by
    resting, or after 24 hours, the blood begins to reek, and will give a -4
    penalty to hide checks until the blood is removed.

    A successful fortitude save halves the damage dealt by this spell, and
    prevents the character from falling prone.

    The focus and material component for this spell is a small vial of your own
    blood (roughly 2hp worth).
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Perfectly fine.

    Originally it was +4 to people tracking them, but I think -4 to hide checks
    are just as fine.

    That part isn't savable against. The proneness is, and the damage is.

    Need blood effects (eeewww!)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_VITAE_GRENADE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = SMP_GetCasterLevel();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nDam;
    float fDelay;

    // Duration of blood
    float fDurationBlood = HoursToSeconds(24);
    // Duration of proneness
    float fDurationProne = RoundsToSeconds(1);

    // 2 HP damage
    int nCurrentHP = GetCurrentHitPoints(oCaster);

    // Need to do damage
    if(nCurrentHP <= 2)
    {
        // Not enough HP
        FloatingTextStringOnCreature("*You cannot draw enough blood to throw*", oCaster, FALSE);
        return;
    }

    // Damage for HP
    FloatingTextStringOnCreature("*You draw blood to throw*", oCaster, FALSE);

    // Do the damage (2HP worth).
    effect eDamage = EffectDamage(2);
    SMP_ApplyInstant(oTarget, eDamage);

    // Limit dice to 10d6, per 2 caster levels
    int nDice = SMP_LimitInteger(nCasterLevel/2, 10);

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE);
    effect eKnockdown = EffectKnockdown();
    effect eHide = EffectSkillDecrease(SKILL_HIDE, 4);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(SMP_VFX_FNF_VITAE_GRENADE);
    SMP_ApplyLocationVFX(lTarget, eImpact);

    // Get all targets in a sphere, 6.67M radius, creature.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 6.67, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    // Loop targets
    while(GetIsObjectValid(oTarget))
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
        // Make sure they are not immune to spells
           !SMP_TotalSpellImmunity(oTarget))
        {
            //Fire cast spell at event for the specified target
            SMP_SignalSpellCastAt(oTarget, SMP_SPELL_VITAE_GRENADE);

            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            // Spell resistance And immunity checking.
            if(!SMP_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Remove old hide penalties
                SMP_RemoveSpecificEffectFromSpell(EFFECT_TYPE_SKILL_DECREASE, SMP_SPELL_VITAE_GRENADE, oTarget);

                // Always apply the -4 to hide
                DelayCommand(fDelay, SMP_ApplyDurationAndVFX(oTarget, eVis, eHide, fDurationBlood));

                // Roll damage for each target
                nDam = SMP_MaximizeOrEmpower(6, nDice, nMetaMagic);

                // Fortitide save
                if(SMP_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC))
                {
                    // Half damage
                    nDam /= 2;

                    // No Proneness
                }
                else
                {
                    // Proneness
                    DelayCommand(fDelay, SMP_ApplyDuration(oTarget, eKnockdown, fDurationProne));
                }

                // Apply effects to the currently selected target.
                DelayCommand(fDelay, SMP_ApplyDamageToObject(oTarget, nDam, DAMAGE_TYPE_MAGICAL));
            }
        }
        // Get Next Target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 6.67, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}
