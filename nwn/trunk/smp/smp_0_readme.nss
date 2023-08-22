/*:://////////////////////////////////////////////
//:: Name README
//:: Script Name SMP_0_Readme
//:://////////////////////////////////////////////
    Readme File. This can be deleted, for what little space it'll save.
//:://////////////////////////////////////////////

    Spell file names (Alphabetical):

    SMP_     | Prefixes all the spells for the spellmans project. (*S*pell*M*ans *P*roject)
             |
    SMP_0_   | Readme file or information file (like this one!)
    SMP_A_   | Ability "spell" (Including monster abilties)
    SMP_AI_  | AI file for summons/monsters
    SMP_AIL_ | Ailment script (Stun, Sleep, Fear ETC)
    SMP_C_   | Class "spell" or ability. Rage etc.
    SMP_INC_ | Include file
    SMP_M_   | Misc script - such as Holy Water, other stuff
    SMP_OT_  | Other file (For spell settings, Magical Trap disarming etc)
    SMP_S_   | Spell File
             | End can be A, B or C, for AOE spells:
             | A = OnEnter, B = OnExit, C = OnHeartbeat
    SMP_T_   | Trap script

//:://////////////////////////////////////////////

    There are many, MANY new spell, all 3E, and some odd ones (mostly cantrips)
    for menal use (there is one, for example, to remove invisiblity off them-selves)

    Most spells are exactly to D&D specific. Because they all are, it may
    unbalance some things. I don't impliment the 3.5 rules - Ie I don't have them,
    and have been using the source code on the net anyway.

//:://////////////////////////////////////////////

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



//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

void main() { }
