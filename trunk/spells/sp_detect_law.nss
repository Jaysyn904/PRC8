/*
Detect Law

Divination
Level: Clr 1, Rgr 2
Components: V, S, DF
Casting Time: 1 action
Range: 60 ft.
Area: Quarter circle emanating from you
to the extreme of the range
Duration: Concentration, up to 10
minutes/level (D)
Saving Throw: None
Spell Resistance: No

You can sense the presence of law. The amount of information revealed depends
on how long you study a particular area or subject:
1st Round: Presence or absence of law.
2nd Round: Number of lawful auras (creatures, objects, or spells) in the area and
the strength of the strongest lawful aura present. If you are of chaotic alignment, the strongest lawful aura’s strength is
"overwhelming" (see below), and the strength is at least twice your character
level, you are stunned for 1 round and the spell ends. While you are stunned, you
can’t act, you lose any Dexterity bonus to AC, and attackers gain +2 bonuses to attack
you.
3rd Round: The strength and location of each aura. If an aura is outside your line of
sight, then you discern its direction but not its exact location.

Aura Strength: An aura’s lawful power and strength depend on the type of lawful
creature or object that you’re detecting and its HD, caster level, or (in the case of a
cleric) class level.

Creature/Object     Lawful Power
Lawful creature       HD / 5
Lawful elemental      HD / 2
Lawful outsider       HD
Cleric of a lawful deity     Caster Level

Evil Power      Aura Strength
Lingering       Dim
1 or less       Faint
2–4         Moderate
5–10        Strong
11+         Overwhelming
If an aura falls into more than one strength category, the spell indicates the stronger of
the two.

Remember that animals, traps, poisons, and other potential perils are not evil; this
spell does not detect them.

Note: Each round, you can turn to detect things in a new area but if you move
more than 2 meters the spell ends. The spell can penetrate barriers, but 1 foot
of stone, 1 inch of common metal, a thin sheet of lead, or 3 feet of wood or dirt
blocks it.

*/

#include "prc_inc_s_det"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_DIVINATION);

    object oCaster = OBJECT_SELF;
    int nLevel = PRCGetCasterLevel(oCaster);
    float fDuration = TurnsToSeconds(nLevel) * 10;

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_DETECT), oCaster, fDuration);

    DetectAlignmentRound(0, GetLocation(oCaster), -1, ALIGNMENT_LAWFUL, GetStringByStrRef(4954)/*"lawful"*/, VFX_BEAM_MIND);

    PRCSetSchool();
}