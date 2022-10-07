/*:://////////////////////////////////////////////
//:: Spell Name Regenerate
//:: Spell FileName PHS_S_Regenerate
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Healing)
    Level: Clr 7, Drd 9, Healing 7
    Components: V, S, DF
    Casting Time: 3 full rounds
    Range: Touch
    Target: Living creature touched
    Duration: Instantaneous
    Saving Throw: Fortitude negates (harmless)
    Spell Resistance: Yes (harmless)
    DM Spell: Partial; see text

    The subject’s severed body members (fingers, toes, hands, feet, arms, legs,
    tails, or even heads of multiheaded creatures), broken bones, and ruined
    organs grow back. After the spell is cast, the physical regeneration is
    complete in 1 round if the severed members are present and touching the
    creature. It takes 2d10 rounds otherwise. This part of the spell is DM only.

    Regenerate also cures 4d8 points of damage +1 point per caster level
    (maximum +35), rids the subject of exhaustion and/or fatigue, and
    eliminates all nonlethal damage the subject has taken. It has no effect on
    nonliving creatures (including undead).
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As spell description.

    Cures 4d8 points of damage +1 point per caster level (maximum +35) damage
    to living things.

    Removes "Fatigue" :-)

    This can be RPed to regenerate fingers and so on.

    Oh, and 3 rounds full casting time!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_REGENERATE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();

    // Max extra is 35
    int nCasterBonus = PHS_LimitInteger(nCasterLevel, 35);

    // Get the damage healed
    int nHeal = PHS_MaximizeOrEmpower(8, 4, nMetaMagic, nCasterLevel);

    // Declare Effects
    effect eHeal = EffectHeal(nHeal);
    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_G); // Cure Critical wounds effect

    // Is the creature living? (It won't harm undead, however)
    if(PHS_GetIsAliveCreature(oTarget, "Regenerate doesn't affect non-living objects"))
    {
        // Signal spell cast at event
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_REGENERATE, FALSE);

        // Remove fatigue cause by spells
        PHS_RemoveFatigue(oTarget);

        // Apply healing effect and visual
        PHS_ApplyInstantAndVFX(oTarget, eVis, eHeal);
    }
}
