/*:://////////////////////////////////////////////
//:: Name Use Magical Device functions
//:: FileName SMP_INC_UMDCHECK
//:://////////////////////////////////////////////
    Contains:

    Use Magical Device
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: October
//::////////////////////////////////////////////*/

// SMP_INC_UMDCHECK. This is the Use Magical Device - implimented for the use
// of scrolls by casters of too low a level, or a Bard/Thief using a scroll.
// Impliemnted and checked within SpellItemValid.
// Returns TRUE if they pass the test. FALSE if they fail.
// - Sends a message of results, and may destroy the scroll
// * iSpellLevel - the level of the spell being cast.
// * iSpellID - The spell ID of the spell
// * sName - The name of the spell
int SMP_UMDCheck(string sName, int iSpellLevel, int iSpellID);


/*
    Use Magic Device (CHA; TRAINED ONLY; BARD, ROGUE ONLY)

    Check: The character can use this skill to read a spell or to activate a
    magic item. This skill lets the character use a magic item as if the
    character had the spell ability or class features of another class, as if
    the character were a different race, or as if the character were a different
    alignment.

    Use Magic Device Task       DC
    ---------------------       --
    Decipher a written spell    25 + Spell Level
    Emulate spell ability       20
    Emulate class feature       20
    Emulate ability score       See Text
    Emulate race                25
    Emulate alignment           30
    Activate blindly            25

    When the character is attempting to activate a magic item using this skill,
    the character does so as a standard action. However, the checks the
    character makes to determine whether the character is successful at
    emulating the desired factors to successfully perform the activation are
    instant. They take no time by themselves and are included in the activate
    magic item standard action.

    The character make emulation checks each time the character activates a
    device such as a wand. If the character is using the check to emulate an
    alignment or some other quality in an ongoing manner, the character needs
    to make the relevant emulation checks once per hour.

    The character must consciously choose what to emulate. That is, the
    character has to know what the character is trying to emulate when the
    character makes an emulation check.

    Decipher a Written Spell: This works just like deciphering a written spell
    with the Spellcraft skill, except that the DC is 5 points higher.

    If the character fails by 10 or more, the character suffers a mishap. A
    mishap means that magical energy gets released but it doesn't do what the
    character wanted it to do. The DM determines the result of a mishap, as
    with scroll mishaps. The default mishaps are that the item affects the
    wrong target or that uncontrolled magical energy gets released, dealing
    2d6 points of damage to the character. Note: This mishap is in addition
    to the chance for a mishap that the character normally runs when the
    character casts a spell from a scroll and the spell's caster level is
    higher than the character's level.

    Retry: Yes, but if the character ever rolls a natural 1 while attempting
    to activate an item and the character fails, then the character can't try
    to activate it again for a day.

    Special: The character cannot take 10 with this skill. Magic is too
    unpredictable for the character to use this skill reliably.

    If the character has 5 or more ranks in Spellcraft, the character gets a
    +2 synergy bonus on Use Magic Device checks related to scrolls. If the
    character has 5 or more ranks in Decipher Script, the character gets a +2
    synergy bonus on Use Magic Device checks related to scrolls. These bonuses
    stack.

    Spellcraft (INT; TRAINED ONLY)
    Check: The character can identify spells and magic effects.
    DC                  Task
    --                  ----
    13                  When using read magic, identify a glyph of warding.
    15 + spell level    Identify a spell being cast. (The character must see or
                        hear the spell's verbal or somatic components.) No retry.
    15 + spell level    Learn a spell from a spellbook or scroll. (Wizard only.)
                        No retry for that spell until the character gain at
                        least 1 rank in Spellcraft (even if the character
                        find another source to try to learn the spell from).
    15 + spell level    Prepare a spell from a borrowed spellbook. (Wizard
                        only.) One try per day.
    15 + spell level    When casting detect magic, determine the school of
                        magic involved in the aura of a single item or creature
                        the character can see. (If the aura is not a spell
                        effect, the DC is 15 + half caster level.)
    19                  When using read magic, identify a symbol.
    20 + spell level    Identify a spell that's already in place and in effect.
                        (the character must be able to see or detect the
                        effects of the spell.) No retry.
    20 + spell level    Identify materials created or shaped by magic, such as
                        noting that an iron wall is the result of a wall of
                        iron spell. No retry.
    20 + spell level    Decipher a written spell (such as a scroll) without
                        using read magic. One try per day.
    2                   Draw a diagram to augment casting dimensional anchor
                        on a summoned creature. Takes 10 minutes. No retry.
                        The DM makes this check.
    30 or higher        Understand a strange or unique magical effect, such
                        as the effects of a magic stream. No retry.

    Additionally, certain spells allow the character to gain information about
    magic provided that the character makes a Spellcraft check as detailed in
    the spell description.

    Retry: See above.

    If the character has 5 or more ranks of Use Magic Device, the character
    gets a +2 synergy bonus to Spellcraft checks to decipher spells on scrolls.
*/
int SMP_UMDCheck(string sName, int iSpellLevel, int iSpellID)
{
    // TRUE means we pass
    int iReturn = TRUE;

    return iReturn;
}


// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
