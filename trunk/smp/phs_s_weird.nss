/*:://////////////////////////////////////////////
//:: Spell Name Weird
//:: Spell FileName PHS_S_Weird
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Illusion (Phantasm) [Fear, Mind-Affecting]
    Level: Sor/Wiz 9
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (20M)
    Targets: All Hostile creatures in a 5M radius (15ft) sphere
    Duration: Instantaneous
    Saving Throw: Will disbelief (if interacted with), then Fortitude partial;
           see text
    Spell Resistance: Yes

    This spell functions like phantasmal killer, except it can affect more than
    one creature. You create a phantasmal image of the most fearsome creature
    imaginable to the subject's simply by forming the fears of the subject’s
    subconscious mind into something that its conscious mind can visualize: this
    most horrible beast. Only the affected creatures see the phantasmal
    creatures attacking them, though you see the attackers as shadowy shapes.

    Each target first gets a Will save to recognize the image as unreal. If that
    save fails, the phantasm touches the subject, and the subject must succeed
    on a Fortitude save or die from fear. Even if a subject’s Fortitude save
    succeeds, it still takes 3d6 points of damage and is stunned for 1 round.
    The subject also takes 1d4 points of temporary Strength damage.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As spell description.

    This is actually pretty easy. Note there are quite a few immunties :-)
    Its fear and mind affecting.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_WEIRD)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nDam, nStrDam;
    float fDelay;
    // Duration for stunning is 1 round
    float fStunDuration = PHS_GetDuration(PHS_ROUNDS, 1, nMetaMagic);
    // Duration for strength decrease will be 24 hours, a good enough "Temp" time in NwN.
    // * Ability decreases are not done "correctly" anyway
    float fStrengthDuration = PHS_GetDuration(PHS_HOURS, 24, nMetaMagic);

    // Declare effects
    effect eDamVis = EffectVisualEffect(VFX_IMP_SONIC);
    effect eDeath = EffectDeath();
    // Need to make this supernatural, so that it ignores death immunity.
    eDeath = SupernaturalEffect(eDeath);
    effect eDeathVis = EffectVisualEffect(VFX_IMP_DEATH);

    // Declare the 2 tempoary effects
    effect eStun = EffectStunned();
    effect eStunDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eStunLink = EffectLinkEffects(eStun, eStunDur);

    // Strength damage
    effect eStrength; //= EffectAbilityDecrease(ABILITY_STRENGTH, d4());
    effect eStrengthDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eStrengthLink;// = EffectLinkEffects(eStrength, eStrengthDur);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(VFX_FNF_WEIRD);
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Get the first creature, in a 30ft diameter, 15ft radius.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_15, lTarget, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        // Needs to be an enemy to kill them. Add PvP check too.
        if(GetIsReactionTypeHostile(oTarget))
        {
            // Random delay before damage or death
            fDelay = PHS_GetRandomDelay(0.1, 1.5);

            // Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_WEIRD);

            // Check spell resistance and immunity
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Make a will save against mind-affecting spells. Immune save.
                if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster, fDelay))
                {
                    // Make a fortitude save against Mind Spells again.
                    if(!PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster, fDelay))
                    {
                        // FAIL: Death!
                        DelayCommand(fDelay, PHS_ApplyInstantAndVFX(oTarget, eDeathVis, eDeath));
                    }
                    else
                    {
                        // PASS: Damage, stun and strength decrease.
                        nDam = PHS_MaximizeOrEmpower(6, 3, nMetaMagic);
                        nStrDam = PHS_MaximizeOrEmpower(4, 1, nMetaMagic);

                        // Do damage straight away, and declare strength link
                        DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eDamVis, nDam));

                        // Strength Link
                        eStrength = EffectAbilityDecrease(ABILITY_STRENGTH, nStrDam);
                        eStrengthLink = EffectLinkEffects(eStrength, eStrengthDur);
                        // Apply strength damage
                        DelayCommand(fDelay, PHS_ApplyDuration(oTarget, eStrengthLink, fStrengthDuration));

                        // Do stun
                        DelayCommand(fDelay, PHS_ApplyDuration(oTarget, eStunLink, fStunDuration));
                    }
                }
            }
        }
        // Get the next creature, in a 30ft diameter, 15ft radius.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_15, lTarget, TRUE);
    }
}
