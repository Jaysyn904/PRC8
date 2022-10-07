/*:://////////////////////////////////////////////
//:: Spell Name Suggestion
//:: Spell FileName PHS_S_Suggest
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Compulsion) [Language-Dependent, Mind-Affecting]
    Level: Brd 2, Sor/Wiz 3
    Components: V, M
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One living creature
    Duration: 1 hour/level or until completed
    Saving Throw: Will negates
    Spell Resistance: Yes

    You influence the actions of the target creature by suggesting a course of
    activity to undertake.

    The suggestion is worded in such a manner as to make the activity sound
    reasonable. You cannot ask the creature to do some obviously harmful act,
    and most activities are cancled if the target is attacked. Activities you
    can cause the target to do are:

    • Put your weapon and shield on the ground
    • Run away from the nearest hostile creature until none are seen
    • Move towards me until you are close
    • Move away from me until you are futher away
    • Sit down for a few minutes

    The suggested course of activity can continue for the entire duration. If
    the suggested activity can be completed in a shorter time, the spell ends
    when the subject finishes what it was asked to do.

    If the enemy is not a similar speaking race to the caster, there is a
    variable penalty to the save DC.

    Material Component: A snake’s tongue and either a bit of honeycomb or a
    drop of sweet oil.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Adds a confusion effect to them.

    If they are attacked (or rather, damaged) the effect wears off (by damage
    resistance added linked to the confusion).

    There are very simple commands for now. I cannot be bothered to add
    more complicated ones! It'll be a sub-dial of 5 only, thats for sure.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Get a penalised save (or return nSpellSaveDC) depending on the different
// races. Non-alive races don't work with this spell, however.
int GetSuggestSave(int nSpellSaveDC, int nCasterRace, int nTargetRace);
// Returns the type of race:
// HUMANOID - 1 - humans and common-speaking things
// ANIMAL - 2 - Beasts, animals, vermin, who do roars/no talking
// OOZE - 3 - how can it understand anything? Very hard!
// SPECIAL_ALL - 4 - Can interpret many languages, no penalties for listen nor speaking
//                   to others.
int GetTypeOfRace(int nRace);

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SUGGESTION)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterRace = GetRacialType(oCaster);
    int nTargetRace = GetRacialType(oTarget);
    int nSuggestSave;

    // Duration - 1 hour/level
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel, nMetaMagic);

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
    effect eConfuse = EffectConfused();
    effect eDR = PHS_Create1DRLink();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eConfuse, eDR);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Fails if they cannot hear the caster
    if(!PHS_GetCanHear(oTarget) &&
    // Must be alive
        PHS_GetIsAliveCreature(oTarget))
    {
        // Faction check
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Spell resistance check
            if(!PHS_SpellResistanceCheck(oCaster, oTarget) &&
               !PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_CONFUSED) &&
               !PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
            {
                // Get a different save based on the targets race compared to ours
                nSuggestSave = GetSuggestSave(nSpellSaveDC, nCasterRace, nTargetRace);

                // Will saving throw
                if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSuggestSave, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    // Apply effects
                    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
                }
            }
        }
    }
}

// Get a penalised save (or return nSpellSaveDC) depending on the different
// races. Non-alive races don't work with this spell, however.
int GetSuggestSave(int nSpellSaveDC, int nCasterRace, int nTargetRace)
{
    // Check our race compared to theirs
    // Note that non-alive races are never counted

    // Get the type of thing we are...
    int nWeAre = GetTypeOfRace(nCasterRace);
    int nTheyAre = GetTypeOfRace(nTargetRace);

    // Either are Special, or Ooze casting it on others...
    if(nWeAre == 4 || nWeAre == 3 || nTheyAre == 4)
    {
        // ignore thier race, return nSpellSaveDc
        return nSpellSaveDC;
    }
    else if(nTheyAre == 3)
    {
        // If they are an ooze - urg, put a -20 penalty on save DC
        return nSpellSaveDC - 20;
    }
    else if(nWeAre == 2)
    {
        // Animals like talking to other animals
        if(nTheyAre == 2)
        {
            return nSpellSaveDC;
        }
        else
        {
            // Else, if they are human, we put a -10 on it
            return nSpellSaveDC - 10;
        }
    }
    else if(nWeAre == 1)
    {
        // Humans get various penalties
        if(nTheyAre == 1)
        {
            // Talking to other humanoids?
        }
        else
        {
            // Animals get a -12 penalty
            return nSpellSaveDC - 12;
        }
    }
    // Return default
    return nSpellSaveDC;
}

// Returns the type of race:
// HUMANOID - 1 - humans and common-speaking things
// ANIMAL - 2 - Beasts, animals, vermin, who do roars/no talking
// OOZE - 3 - how can it understand anything? Very hard!
// SPECIAL_ALL - 4 - Can interpret many languages, no penalties for listen nor speaking
//                   to others.
int GetTypeOfRace(int nRace)
{
    switch(nRace)
    {
        case RACIAL_TYPE_DWARF:
        case RACIAL_TYPE_ELF:
        case RACIAL_TYPE_FEY:
        case RACIAL_TYPE_GIANT:
        case RACIAL_TYPE_GNOME:
        case RACIAL_TYPE_HALFELF:
        case RACIAL_TYPE_HALFLING:
        case RACIAL_TYPE_HALFORC:
        case RACIAL_TYPE_HUMAN:
        case RACIAL_TYPE_HUMANOID_GOBLINOID:
        case RACIAL_TYPE_HUMANOID_MONSTROUS:
        case RACIAL_TYPE_HUMANOID_REPTILIAN:
        case RACIAL_TYPE_HUMANOID_ORC:
        {
            return 1;
        }
        break;
        case RACIAL_TYPE_ABERRATION:
        case RACIAL_TYPE_ANIMAL:
        case RACIAL_TYPE_BEAST:
        case RACIAL_TYPE_ELEMENTAL:
        case RACIAL_TYPE_MAGICAL_BEAST:
        case RACIAL_TYPE_VERMIN:
        {
            return 2;
        }
        break;
        case RACIAL_TYPE_OOZE:
        {
            return 3;
        }
        break;
        case RACIAL_TYPE_DRAGON:
        case RACIAL_TYPE_OUTSIDER:
        case RACIAL_TYPE_SHAPECHANGER:
        {
            return 4;
        }
        break;
    }
    return 0;
}
