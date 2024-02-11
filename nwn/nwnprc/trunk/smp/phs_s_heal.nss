/*:://////////////////////////////////////////////
//:: Spell Name Heal
//:: Spell FileName PHS_S_Heal
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Healing)
    Level: Clr 6, Drd 7, Healing 6
    Components: V, S
    Casting Time: 1 standard action
    Range: Touch
    Target: Living Creature or Undead touched
    Duration: Instantaneous
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    Heal enables you to channel positive energy into a creature to wipe away
    injury and afflictions. It immediately ends any and all of the following
    adverse conditions affecting the Living Target: ability damage, blinded,
    confused, dazed, dazzled, deafened, diseased, exhausted, fatigued,
    feebleminded, insanity, nauseated, sickened, stunned, and poisoned. It
    also cures 10 hit points of damage per level of the caster, to a maximum
    of 150 points at 15th level.

    Heal does not remove negative levels, restore permanently drained levels,
    or restore permanently drained ability score points.

    If used against an undead creature, heal instead acts like harm.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the description.

    - Removes the insanity spell effect
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_HEAL)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nCasterLevel = PHS_GetCasterLevel();
    int nTargetHP = GetCurrentHitPoints(oTarget);
    // Max to heal is 150
    int nMaxHealHarm = PHS_LimitInteger(nCasterLevel * 10, 150);
    int nTouch;

    // Declare effects
    effect eHeal = EffectHeal(nMaxHealHarm);
    effect eHealVis = EffectVisualEffect(VFX_IMP_HEALING_X);
    effect eDamageVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_HEAL);

    // Check if the target is Undead for damage
    if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {

        // Touch melee attack
        nTouch = PHS_SpellTouchAttack(PHS_TOUCH_MELEE, oTarget, TRUE);

        // Hit/miss visual effect
        PHS_ApplyTouchVisual(oTarget, VFX_IMP_SUNSTRIKE, nTouch);

        // Does it hit?
        if(nTouch)
        {
            // Double damage on critical!
            if(nTouch == 2)
            {
                nMaxHealHarm *= 2;
            }
            // PvP check
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                // Spell resistance
                if(!PHS_SpellResistanceCheck(oCaster, oTarget))
                {
                    // Will Save for half damage
                    nMaxHealHarm = PHS_GetAdjustedDamage(SAVING_THROW_WILL, nMaxHealHarm, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_POSITIVE);

                    // Declare damage
                    // - Cannot be able to kill them
                    if(nTargetHP > 1)
                    {
                        if(nMaxHealHarm > nTargetHP)
                        {
                            nMaxHealHarm = nTargetHP - 1;
                        }
                        // Apply damage.
                        PHS_ApplyDamageToObject(oTarget, nMaxHealHarm, DAMAGE_TYPE_POSITIVE);
                    }
                }
            }
        }
    }
    // Must be alive to heal
    else if(PHS_GetIsAliveCreature(oTarget))
    {
        // We remove all the things in a effect loop.
        PHS_HealSpellRemoval(oTarget);

        // Remove fatige
        PHS_RemoveFatigue(oTarget);

        // We heal damage after
        PHS_ApplyInstantAndVFX(oTarget, eHealVis, eHeal);
    }
}
