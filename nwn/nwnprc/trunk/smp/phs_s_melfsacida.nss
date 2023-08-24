/*:://////////////////////////////////////////////
//:: Spell Name Melf's Acid Arrow
//:: Spell FileName PHS_S_MelfsAcidA
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Creation) [Acid]
    Level: Sor/Wiz 2
    Components: V, S, M, F
    Casting Time: 1 standard action
    Range: Long (40M)
    Effect: One arrow of acid
    Duration: 1 round + 1 round per three levels
    Saving Throw: None
    Spell Resistance: No

    A magical arrow of acid springs from your hand and speeds to its target. You
    must succeed on a ranged touch attack to hit your target. The arrow deals 2d4
    points of acid damage with no splash damage. For every three caster levels
    (to a maximum of 18th), the acid, unless somehow neutralized, lasts for
    another round, dealing another 2d4 points of damage in that round.

    Material Component: Powdered rhubarb leaf and an adder’s stomach.

    Focus: A dart.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Jasperre
    I've changed it to the right duration, and damage - it now does 2d4 any time
    damage should be inflicted.

    Also made the impact thing work better (6 second delay commands, not each
    one second).

    Metamagic also works - extend.

    Touch attack - no spell turning.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Delayed for 6 seconds, this runs itself until oTarget is dead,
// or they don't have the spell's effect anymore.
void PHS_RunMelfAcidImpact(int nMetaMagic, object oTarget, object oCaster);

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_MELFS_ACID_ARROW)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();
    int nTouch = PHS_SpellTouchAttack(PHS_TOUCH_RANGED, oTarget, TRUE);
    int nDam;

    // Projectile timing.
    float fDelay = GetDistanceToObject(oTarget)/25.0;

    // Duration can be up to 7 rounds.
    float fDuration = 0.5 + PHS_GetDuration(PHS_MINUTES, PHS_LimitInteger(nCasterLevel/3, 7, 1), nMetaMagic);

    // Delcare Effects
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);

    // Apply arrow visual
    PHS_ApplyTouchVisual(oTarget, VFX_DUR_MIRV_ACID, nTouch);

    // Does this hit?
    if(nTouch)
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget) &&
        // Make sure they are not immune to spells
           !PHS_TotalSpellImmunity(oTarget))
        {
            //Fire spell cast at event for target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_MELFS_ACID_ARROW);

            // Make an SR check - No turning, as it is a touch attack.
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Roll initial damage (this is the only part which uses nTouch)
                nDam = PHS_MaximizeOrEmpower(4, 2, nMetaMagic, FALSE, nTouch);

                // Do damage
                DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_ACID));

                // Duration effect. Cannot stack
                if(!PHS_GetHasSpellEffectFromCaster(PHS_SPELL_MELFS_ACID_ARROW, oTarget, oCaster))
                {
                    // Apply new one
                    PHS_ApplyDuration(oTarget, eDur, fDuration);

                    // Apply the bonus damage - each 6 seconds, for nDurationRounds rounds.
                    DelayCommand(6.0, PHS_RunMelfAcidImpact(nMetaMagic, oTarget, oCaster));
                }
                else
                {
                    // Cannot affect again. Only imact is done.
                    FloatingTextStringOnCreature("*You cannot use more then one acidic arrow on a target at once*", oTarget, FALSE);
                    return;
                }
            }
        }
    }
}

// Delayed for 6 seconds, this runs itself until oTarget is dead,
// or they don't have the spell's effect anymore.
void PHS_RunMelfAcidImpact(int nMetaMagic, object oTarget, object oCaster)
{
    // Check if dead or validity of oTarget.
    if(!GetIsDead(oTarget) && GetIsObjectValid(oTarget))
    {
        // Check the caster.
        if(GetIsObjectValid(oCaster))
        {
            // Check if they have the effect
            if(PHS_GetHasSpellEffectFromCaster(PHS_SPELL_MELFS_ACID_ARROW, oTarget, oCaster))
            {
                // Fire spell cast at event for target
                PHS_SignalSpellCastAt(oTarget, PHS_SPELL_MELFS_ACID_ARROW);

                // Roll damage
                int nDamage = PHS_MaximizeOrEmpower(4, 2, nMetaMagic);

                // Visual
                effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);

                PHS_ApplyDamageVFXToObject(oTarget, eVis, nDamage, DAMAGE_TYPE_ACID);

                // Run it again
                DelayCommand(6.0, PHS_RunMelfAcidImpact(nMetaMagic, oTarget, oCaster));
            }
        }
        else
        {
            // Remove the spells effects
            PHS_RemoveSpellEffects(PHS_SPELL_MELFS_ACID_ARROW, oCaster, oTarget);
        }
    }
}
