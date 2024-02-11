/*:://////////////////////////////////////////////
//:: Spell Name Heal, Mass
//:: Spell FileName PHS_S_HealMass
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    As heal (see below)


    All allied creatures. Removes:
    ability damage, blinded, confused, dazed, dazzled, deafened, diseased,
    exhausted, fatigued, feebleminded, insanity, nauseated, sickened, stunned,
    and poisoned. It also cures 10 hit points of damage per level of the caster,
    to a maximum of 250 points at 25th level.
    Heal does not remove negative levels, restore permanently drained levels, or
    restore permanently drained ability score points.
    If used against an undead creature, heal instead acts like harm.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the description.

    - Removes the insanity spell effect
    - As heal, but 250 HP healed, Selective targeting.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_HEAL_MASS)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nCasterLevel = PHS_GetCasterLevel();
    // Max of 250 to heal or damage
    int nMaxHealHarm = PHS_LimitInteger(nCasterLevel * 10, 250);
    int nDamage, nTargetHP;
    float fDelay;

    // Declare effects
    effect eHeal = EffectHeal(nMaxHealHarm);
    effect eHealVis = EffectVisualEffect(VFX_IMP_HEALING_G);
    effect eDamageVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Loop all targets in the 5M radius sphere - thats 15ft.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_15, lTarget, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        // Get delay
        fDelay = GetDistanceBetweenLocations(GetLocation(oTarget), lTarget)/20;

        // Check if the target is Undead for damage
        if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        {
            // Signal spell cast at
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_HEAL_MASS);

            // PvP check
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                // Spell resistance
                if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
                {
                    // - Cannot be able to kill them
                    if(nTargetHP > 1)
                    {
                        // Reset nDamage and save against will.
                        nDamage = PHS_GetAdjustedDamage(SAVING_THROW_WILL, nMaxHealHarm, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_POSITIVE, oCaster, fDelay);

                        // Get thier current HP
                        nTargetHP = GetCurrentHitPoints(oTarget);

                        // Declare damage
                        if(nDamage > nTargetHP)
                        {
                            nDamage = nTargetHP - 1;
                        }
                        // Apply damage.
                        DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eDamageVis, nDamage, DAMAGE_TYPE_POSITIVE));
                    }
                }
            }
        }
        // Must be alive to heal - and an ally
        else if(PHS_GetIsAliveCreature(oTarget) &&
               (GetFactionEqual(oTarget) || GetIsFriend(oTarget)))
        {
            // We remove all the things in a effect loop.
            PHS_HealSpellRemoval(oTarget);

            // We heal damage after
            DelayCommand(fDelay, PHS_ApplyInstantAndVFX(oTarget, eHealVis, eHeal));
        }
        // Get next target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_15, lTarget, TRUE);
    }
}
