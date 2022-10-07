/*:://////////////////////////////////////////////
//:: Spell Name Alter Self
//:: Spell FileName PHS_S_AlterSelf
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Brd 2, Sor/Wiz 2
    Components: V, S
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 10 min./level (D)

    You assume the form of a creature of the same type as your normal form. The
    new form must be within one size category of your normal size and the
    different forms are limited to those listed below. You can change into a
    member of your own kind or even into yourself.

    You only change your appearance, and have no changes to any of your ability
    scores, class, level, hit points, alignment, base attack bonus or saves.
    You can cast spells normally and keep all feats and special abilities.

    You acquire the physical qualities of the new form while retaining your own
    mind. You do not gain any extraordinary special attacks or special qualities
    such as darkvision, low-light vision, blindsense, blindsight, fast healing,
    regeneration, scent, and so forth. Your creature type and subtype (if any)
    remain the same regardless of your new form.

    You become effectively disguised as an average member of the new form’s
    race. If you use this spell to create a disguise, you get a +10 bonus on
    your Disguise check. When the change occurs, your equipment, if any, remains
    worn or held by the new form.

    The forms you can take can be; elf, human, half-elf, half-orc, halfling,
    gnome, Orc, Goblin, Bugbear or Gnoll.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This is done via. SetAppearanceType().

    I will, for now at least, use a heartbeat that is run on the creature, to
    check if it has been removed/dispelled, and thus change them back. It will
    also remove the effects of this spell if they polymorph.

    Polymorphing, because of how it will change the appearance more tempoarily,
    will be wrappered so that it'll change them back THEN apply polymorph, after
    a tiny delay.

    Valid ones (Remember: Gender stays the same):
    APPEARANCE_TYPE_BUGBEAR_A (And other bugbears?)
    APPEARANCE_TYPE_DWARF
    APPEARANCE_TYPE_ELF
    APPEARANCE_TYPE_GNOLL_WARRIOR (And the other gnoll?)
    APPEARANCE_TYPE_GNOME
    APPEARANCE_TYPE_GOBLIN_A (And other goblins?)
    APPEARANCE_TYPE_HALF_ELF
    APPEARANCE_TYPE_HALF_ORC
    APPEARANCE_TYPE_HALFLING
    APPEARANCE_TYPE_HUMAN
    APPEARANCE_TYPE_ORC_A (And other orcs?)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// If they don't have the spell's effects, or do and are polymorphed, we take
// action. Else, it is fired again.
void AlterSelfHeartbeat(object oTarget);

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_ALTER_SELF)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// Should be OBJECT_SELF
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();

    // Get what to turn into
    int nAppearance = GetLocalInt(oTarget, "PHS_ALTER_SELF_CHOICE");

    // If 0, we default to human
    if(nAppearance == 0)
    {
        nAppearance = APPEARANCE_TYPE_HUMAN;
    }

    // Duration is 10 minutes/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Delcare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Fire spell cast at event for target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_ALTER_SELF);

    // Remove previous effects
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_ALTER_SELF, oTarget);

    // Remove any polymorph
    PHS_RemoveSpecificEffect(EFFECT_TYPE_POLYMORPH, oTarget, SUBTYPE_IGNORE);

    // Set original appearance if not already set - NPC only!
    if(!GetIsPC(oTarget))
    {
        // We check the integer
        if(PHS_GetLocalConstant(oTarget, "PHS_DEFAULT_APPEARANCE") == -1)
        {
            PHS_SetLocalConstant(oTarget, "PHS_DEFAULT_APPEARANCE", GetAppearanceType(oTarget));
        }
    }
    // Apply visual. Change appearance
    PHS_ApplyDurationAndVFX(oTarget, eVis, eDur, fDuration);
    SetCreatureAppearanceType(oTarget, nAppearance);

    // New heartbeat to remove the appearance change
    DelayCommand(6.0, AlterSelfHeartbeat(oTarget));
}

// If they don't have the spell's effects, or do and are polymorphed, we take
// action. Else, it is fired again.
void AlterSelfHeartbeat(object oTarget)
{
    // Check for Polymorph (IE: New one)
    int bPolymorph = PHS_GetHasEffect(EFFECT_TYPE_POLYMORPH, oTarget);
    int bAlterSelf = GetHasSpellEffect(PHS_SPELL_ALTER_SELF, oTarget);

    // Case 1: Alter self now gone, new polymorph there.
    if(bAlterSelf == FALSE && bPolymorph == TRUE)
    {
        // Stop this heartbeat
        return;
    }
    // Case 2: New polymorph, but still got Alter Self (somehow!) we will just
    // remove Alter Self's effects.
    else if(bPolymorph == TRUE)
    {
        PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_ALTER_SELF, oTarget);
    }
    // Case 3: Not Got the effect, no new polymorph
    else if(bAlterSelf == TRUE)
    {
        // Reset apperance
        PHS_RevertAppearance(oTarget);
    }
    // Case 4: None of the above. We do another heartbeat.
    else
    {
        DelayCommand(6.0, AlterSelfHeartbeat(oTarget));
    }
}
