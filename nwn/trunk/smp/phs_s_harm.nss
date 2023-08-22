/*:://////////////////////////////////////////////
//:: Spell Name Harm
//:: Spell FileName PHS_S_Harm
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy
    Level: Clr 6, Destruction 6
    Components: V, S
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: Instantaneous
    Saving Throw: Will half; see text
    Spell Resistance: Yes

    Harm charges a subject with negative energy that deals 10 points of damage
    per caster level (to a maximum of 150 points at 15th level). If the creature
    successfully saves, harm deals half this amount, but it cannot reduce the
    target’s hit points to less than 1.

    If used on an undead creature, harm acts like heal.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    3.5 rules are much fairer now.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_HARM)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nCasterLevel = PHS_GetCasterLevel();
    int nTargetHP = GetCurrentHitPoints(oTarget);
    int nMaxHealHarm = PHS_LimitInteger(nCasterLevel * 10);
    int nTouch;

    // Declare effects
    effect eHeal = EffectHeal(nMaxHealHarm);
    effect eHealVis = EffectVisualEffect(VFX_IMP_HEALING_X);

    effect eCheck;
    int nEffectType, nEffectSpellID;

    // Check if the target is alive
    if(PHS_GetIsAliveCreature(oTarget))
    {
        // Signal spell cast at
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_HEAL);

        // Touch melee attack
        nTouch = PHS_SpellTouchAttack(PHS_TOUCH_MELEE, oTarget, TRUE);

        // Visual effects hit/miss
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
                    // Check will save
                    if(PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NEGATIVE))
                    {
                        // Half damage
                        nMaxHealHarm /= 2;
                    }
                    // Declare damage
                    // - Cannot be able to kill them
                    if(nTargetHP > 1)
                    {
                        if(nMaxHealHarm > nTargetHP)
                        {
                            nMaxHealHarm = nTargetHP - 1;
                        }
                        // Apply damage
                        PHS_ApplyDamageToObject(oTarget, nMaxHealHarm, DAMAGE_TYPE_NEGATIVE);
                    }
                }
            }
        }
    }
    // Must be undead to heal
    else if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        // We remove all the things in a effect loop.

        // ability damage, blinded, confused,
        // dazed, dazzled, deafened, diseased, exhausted, fatigued, feebleminded,
        // insanity, nauseated, sickened, stunned, and poisoned.
        eCheck = GetFirstEffect(oTarget);
        // Loop effects
        while(GetIsEffectValid(eCheck))
        {
            nEffectType = GetEffectType(eCheck);
            nEffectSpellID = GetEffectSpellId(eCheck);

            // Remove cirtain spells
            switch(nEffectSpellID)
            {
                case PHS_SPELL_INSANITY:
                case PHS_SPELL_FEEBLEMIND:
                // - Dazzeled
                //case PHS_SPELL_FLARE:
                    RemoveEffect(oTarget, eCheck);
                break;
                // Other effects
                default:
                {
                    // Remove cirtain effects
                    switch(nEffectType)
                    {
                        case EFFECT_TYPE_DAZED:
                        case EFFECT_TYPE_DEAF:
                        case EFFECT_TYPE_DISEASE:
                        case EFFECT_TYPE_STUNNED:
                        case EFFECT_TYPE_POISON:
                        {
                            RemoveEffect(oTarget, eCheck);
                        }
                        break;
                    }
                }
                break;
            }
            // Get next effect
            eCheck = GetNextEffect(oTarget);
        }
        // Remove fatige
        PHS_RemoveFatigue(oTarget);

        // We heal damage after
        PHS_ApplyInstantAndVFX(oTarget, eHealVis, eHeal);
    }
}
