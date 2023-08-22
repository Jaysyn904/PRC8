/*:://////////////////////////////////////////////
//:: Name Readme
//:: FileName SMP_0_readme2
//:://////////////////////////////////////////////
    Readme. You have a list of...
    - Local integers to set things
    - Informaiton about spells
    - A list of DM spells (DM run ones)
    - Spell formats
    - Explaining :-P

    This can be deleted if needed.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: July Onwards
//::////////////////////////////////////////////*/
/*
    There are many, MANY new spell, all 3E, and some odd ones (mostly cantrips)
    for menal use (there is one, for example, to remove invisiblity off them-selves)

    Most spells are exactly to D&D specific. Because they all are, it may
    unbalance some things. I don't impliment the 3.5 rules - Ie I don't have them,
    and have been using the source code on the net anyway.

    Layout of files:
    ////////////////////////////////
    - Title (Name)
    - File Name
    ////////////////////////////////
    - "Description" - The actual dialog.tlk entry.
    - "3E Description" - Exact 3E description, for reference
    - More information and changes from 3.5E and limitations and notes.
    ////////////////////////////////
    - Creator/Modifier
    - Creation/Update date
    ////////////////////////////////

    - Include files

    - Unique File Function Headers (EG acid arrow applying)

    - Spell Effect applying (void main)

    - Unique File Functions (EG acid arrow applying)

    End.

    Notes on Unique Fire Functions
    ------------------------------
    Some of these actually make the caster csat the spell again. Special AI
    supports NPC's casting these, and PC's must not cancle thier spell
    cycle. Things like "call lightning" is an example, where the caster
    must concentrate for extra rounds.

    Note, in these spells, there are toggles :-) you can turn of specific ones
    (module wide, single person), or all of them (Evil!).

    Note: I have not supported Null Magic areas. There is an effect,
    EffectSpellFailure, which is better.

    List of constants, variables and markers for areas:

    - Sample Name -    - Type -         - Description -
    J_S_1              Local Integer    If there is a local integer, on the module
                                        or player, of "J_S_" + Spell Number, it
                                        will stop it working.

    J_PLA_INDOORS      Placeable object These toggle settings. They are, if used,
                                        DM run things. If they are placed, they
                                        make the area X, or Y.
                                        DM's can talk to them, to remove them.
                                        They are otherwise plot. Best kept out of sight of PC's.
    J_PLA_INDOORS       " "             - Makes the area outdoors.
    J_PLA_OUTDOORS      " "             - Makes the area outdoors.





SPELL FORMAT (3rd Edtion snippit. Its the same in NwN)

Each spell description follows the same format. This section discusses that
format and some of the fine points of how spells work.

Name: This is the name by which the spell is generally known.

School, Subschool, and Descriptors: This is the school to which the spell
        belongs. "Universal" refers to a spell that belongs to no school. If the spell
        is a subtype within a school, the subschool is given here (in parentheses).

Any descriptors that apply are given here [in brackets].

Schools: Abjuration, Conjuration, Divination, Enchantment, Evocation, Illusion,
        Necromancy, and Transmutation.

Subschools: Conjuration: creation, healing, and summoning; Enchantment: charm
        and compulsion; Illusion: figment, glamer, pattern, phantasm, and shadow.

Descriptors: Acid, chaotic, cold, darkness, death, electricity, evil, fear,
        fire, force, good, language-dependent, lawful, light, mind-affecting,
        sonic, and teleportation.

Level: This is the relative power level of the spell. This entry includes an
        abbreviation for each class that can cast this spell. The "Level" entry
        also indicates if a spell is a domain spell and, if so, what its level is.

Class Abbreviations: Brd (bard), Clr (cleric), Drd (druid), Pal (paladin), Rgr
        (ranger), Sor (sorcerer), Wiz (wizard).

Domains: Air, Animal, Chaos, Death, Destruction, Earth, Evil, Fire, Good,
        Healing, Knowledge, Law, Luck, Magic, Plant, Protection, Strength, Sun,
        Travel, Trickery, War, and Water.

Components: This entry indicates what the character must have or do to cast the
        spell. If the necessary components are not present, the casting fails.
        Spells can have verbal (V), somatic (S), material (M), focus (F),
        divine focus (DF), or experience point cost (XP) components, or any
        combination thereof.

If the material component, focus or define focus has an GP cost, the cost is
        listed; otherwise the character can assume that the actual materials
        involved are at the discretion of the caster and have no significant
        monetary value.

Material components are always consumed during the casting of a spell; a focus
        or divine focus is not. If a special focus or divine focus is required,
        it will be unique to the spell and cannot be used as the focus for other
        spells.

Casting Time: The time required to cast a spell.

Range: The maximum distance from the character at which the spell can affect a target.

Target or Targets/Effect/Area: This entry lists the number of creatures,
        dimensions, volume, weight, and so on, that the spell affects. The entry
        starts with one of three headings: "Target," "Effect," or "Area." If the
        target of a spell is "the character," the character does not receive a
        saving throw, and spell resistance does not apply. The saving throw and
        spell resistance headings are omitted from such spells.

Duration: How long the spell lasts.

Saving Throw: Whether a spell allows a saving throw, what type of saving throw
        it is, and the effect of a successful save.

Spell Resistance: Whether spell resistance (SR), a special defensive ability,
        resists this spell.

Descriptive Text: This portion of the spell description details what the spell
        does and how it works.
*/

// Used to stop "No file found" import errors.
void main(){}
