/*:://////////////////////////////////////////////
//:: Spell Name Chill of the Void
//:: Spell FileName XXX_S_ChillOfVoi
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromany [Cold]
    Level: Sor/Wiz 4
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: Ray
    Duration: Instantaneous
    Saving Throw: Instantaneous
    Spell Resistance: Yes
    Source: Various (Law)

    A purple ray springs from your hand. You draw power from the void giving you
    the power to chill more then just one part of the flesh but all the flesh of
    the target. You must succeed at a ranged touch attack to strike the target.
    The target takes 1d4 points of cold  damage per caster level (maximum 10d4)
    there is no save for this part of the spell. The target creature also takes
    2 points of Constitution damage unless it makes a successful Fortitude
    saving throw.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Simple, and effective.

    The consitution damage is made supernatural, it has no duration and cannot
    be dispelled because of it, and so may last forever.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_CHILL_OF_THE_VOID)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nCasterLevel = SMP_GetCasterLevel();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    // Ranged touch attack
    int nTouch = SMP_SpellTouchAttack(SMP_TOUCH_RAY, oTarget, TRUE);

    // Dice
    int nDice = SMP_LimitInteger(nCasterLevel, 10);

    // Damage is 1d4/level - cold damage
    int nDam = SMP_MaximizeOrEmpower(4, nDice, nMetaMagic, FALSE, nTouch);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eCon = EffectAbilityDecrease(ABILITY_CONSTITUTION, 2);
    effect eLink = EffectLinkEffects(eDur, eCon);

    // Supernatural
    eLink = SupernaturalEffect(eLink);

    // Signal event
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_CHILL_OF_THE_VOID);

    // Do hit/miss ray - Purple Odd beam.
    SMP_ApplyTouchBeam(oTarget, VFX_BEAM_ODD, nTouch);

    // Touch attack
    if(nTouch)
    {
        // PvP check
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Resistance
            if(!SMP_SpellResistanceCheck(oCaster, oTarget))
            {
                // Apply effects
                SMP_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_COLD);

                // Fortitude save for no con damage
                if(!SMP_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_COLD))
                {
                    SMP_ApplyPermanent(oTarget, eLink);
                }
            }
        }
    }
}
