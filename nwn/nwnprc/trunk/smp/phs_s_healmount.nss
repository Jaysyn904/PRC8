/*:://////////////////////////////////////////////
//:: Spell Name Heal Mount
//:: Spell FileName PHS_S_HealMount
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Healing)
    Level: Pal 3
    Components: V, S
    Casting Time: 1 standard action
    Range: Touch
    Target: Your mount touched
    Duration: Instantaneous
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    This spell functions like heal, but it affects only the paladin’s special
    mount (typically a warhorse).
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Acts as heal, only if the mount if selected.

    A special integer makes this possible. Must also be in the party.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_HEAL_MOUNT)) return;

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

    // Must be the paladin's mount
    if(GetMaster(oTarget) == oCaster &&
       GetLocalInt(oTarget, "PHS_HORSE") == TRUE)
    {
        // Signal spell cast at
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_HEAL_MOUNT);

        // We remove all the things in a effect loop.
        PHS_HealSpellRemoval(oTarget);

        // Remove fatige
        PHS_RemoveFatigue(oTarget);

        // We heal damage after
        PHS_ApplyInstantAndVFX(oTarget, eHealVis, eHeal);
    }
}
