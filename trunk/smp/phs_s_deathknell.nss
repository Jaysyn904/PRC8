/*:://////////////////////////////////////////////
//:: Spell Name Death Knell
//:: Spell FileName PHS_S_DeathKnell
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Death Knell
    Necromancy [Death, Evil]
    Level: Clr 2, Death 2
    Components: V, S
    Casting Time: 1 standard action
    Range: Touch
    Target: Living creature touched
    Duration: Instantaneous/10 minutes per HD of subject; see text
    Saving Throw: Will negates
    Spell Resistance: Yes

    You draw forth the ebbing life force of a creature and use it to fuel your
    own power. Upon casting this spell, you touch a living creature that has -1
    or fewer hit points. If the subject fails its saving throw, it dies, and
    you gain 1d8 temporary hit points and a +2 bonus to Strength. Additionally,
    your effective caster level goes up by +1, improving spell effects dependent
    on caster level. (This increase in effective caster level does not grant
    you access to more spells.) These effects last for 10 minutes per HD of the
    subject creature.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the spell states. Of course, only PC's will be affected by this.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_DEATH_KNELL)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCurrentHP = GetCurrentHitPoints(oTarget);
    int nHitDice = GetHitDice(oTarget);
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Touch melee attack
    int nTouch = PHS_SpellTouchAttack(PHS_TOUCH_MELEE, oTarget, TRUE);

    // +1d8 tempoary hit points (Double for critical hit)
    int nTempHP = PHS_MaximizeOrEmpower(8, 1, nMetaMagic, FALSE, nTouch);

    // Duration is 10 minutes per HD of target
    float fDuration = PHS_GetDuration(PHS_MINUTES, nHitDice * 10, nMetaMagic);

    // Delcare effects
    effect eVis;
    effect eDeath = EffectDeath();
    effect eHP = EffectTemporaryHitpoints(nTempHP);
    effect eStrength = EffectAbilityIncrease(ABILITY_STRENGTH, 2);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eHP, eStrength);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Singal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DEATH_KNELL);

    // Touch visual effect
    PHS_ApplyTouchVisual(oTarget, VFX_IMP_NEGATIVE_ENERGY, nTouch);

    // Touch attack results
    if(nTouch)
    {
        // Check reaction type
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Check thier actual current hit points
            if(nCurrentHP <= -1 && nCurrentHP >= -10)
            {
                // Check spell resistance and immunties
                if(!PHS_SpellResistanceCheck(oCaster, oTarget) &&
                   !PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_DEATH))
                {
                    // Check will (Death) save
                    if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_DEATH))
                    {
                        // Remove previous effecs
                        PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_DEATH_KNELL, oCaster);

                        // Apply effects
                        PHS_ApplyInstant(oTarget, eDeath);
                        PHS_ApplyDuration(oCaster, eLink, fDuration);
                    }
                }
            }
        }
    }
}
