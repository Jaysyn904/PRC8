/*:://////////////////////////////////////////////
//:: Spell Name Chill Touch
//:: Spell FileName PHS_S_ChillTouch
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy
    Level: Sor/Wiz 1
    Components: V, S
    Casting Time: 1 standard action
    Range: Touch
    Targets: Creature or creatures touched (up to one/level)
    Duration: Instantaneous
    Saving Throw: Fortitude partial or Will negates; see text
    Spell Resistance: Yes

    A touch from your hand, which glows with blue energy, disrupts the life
    force of living creatures. Each touch channels negative energy that deals
    1d6 points of damage. The touched creature also takes 1 point of Strength
    damage unless it makes a successful Fortitude saving throw. You can use this
    melee touch attack up to one time per level.

    An undead creature you touch takes no damage of either sort, but it must
    make a successful Will saving throw or flee as if panicked for 1d4 rounds
    +1 round per caster level.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As spell description.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck()) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();

    // Check if it was caster item etc.
    if(!PHS_CheckChargesForSpell(PHS_SPELL_CHILL_TOUCH, TRUE, oCaster)) return;

    // Do touch attack
    int nTouch = PHS_SpellTouchAttack(PHS_TOUCH_MELEE, oTarget, TRUE);

    // Duration of the fear is random - 1d4 + 1 round/level.
    float fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 4, 1, nMetaMagic, nCasterLevel);

    // Get damage
    int nDam = PHS_MaximizeOrEmpower(6, 1, nMetaMagic, 0, nTouch);

    // Delcare Effects
    effect eStrength = EffectAbilityDecrease(ABILITY_STRENGTH, 1);
    effect eFear = EffectFrightened();
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Link effects for fear
    effect eLink = EffectLinkEffects(eFear, eDur);
    eLink = EffectLinkEffects(eLink, eCessate);
    effect eStrengthLink = EffectLinkEffects(eStrength, eCessate);

    // Signal spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_CHILL_TOUCH);

    // Do hit or miss visual effect
    PHS_ApplyTouchVisual(oTarget, VFX_IMP_NEGATIVE_ENERGY, nTouch);

    // Melee Touch attack
    if(nTouch)
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Spell resistance and immunity check
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Check if undead or not
                if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
                {
                    // Undead, so apply fear against a will save
                    if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NEGATIVE))
                    {
                        // Fear applied.
                        PHS_ApplyDuration(oTarget, eLink, fDuration);
                    }
                }
                else
                {
                    // Non-undead, Damage + Strength damage.
                    PHS_ApplyDamageToObject(oTarget, nDam, DAMAGE_TYPE_NEGATIVE);

                    // Save - fortitude
                    if(!PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NEGATIVE))
                    {
                        // Apply strength damage - permament
                        PHS_ApplyPermanent(oTarget, eStrengthLink);
                    }
                }
            }
        }
    }
}
