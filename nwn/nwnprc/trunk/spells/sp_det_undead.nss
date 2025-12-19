/*
    sp_det_undead

    Divination
    Level: Clr 1, Pal 1, Sor/Wiz 1
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: 60 ft.
    Area: Cone-shaped emanation
    Duration: Concentration, up to 1 minute/ level (D)
    Saving Throw: None
    Spell Resistance: No
    You can detect the aura that surrounds undead creatures. The amount of information revealed depends on how long you study a particular area.
    1st Round: Presence or absence of undead auras.
    2nd Round: Number of undead auras in the area and the strength of the strongest undead aura present. If you are of good alignment, and the strongest undead aura’s strength is overwhelming (see below), and the creature has HD of at least twice your character level, you are stunned for 1 round and the spell ends.
    3rd Round: The strength and location of each undead aura. If an aura is outside your line of sight, then you discern its direction but not its exact location.
    Aura Strength: The strength of an undead aura is determined by the HD of the undead creature, as given on the following table:

    HD  Strength
    1 or lower  Faint
    2–4 Moderate
    5–10    Strong
    11 or higher    Overwhelming
    Lingering Aura: An undead aura lingers after its original source is destroyed. If detect undead is cast and directed at such a location, the spell indicates an aura strength of dim (even weaker than a faint aura). How long the aura lingers at this dim level depends on its original power:

    Original Strength   Duration of Lingering Aura
    Faint   1d6 rounds
    Moderate    1d6 minutes
    Strong  1d6x10 minutes
    Overwhelming    1d6 days
    Each round, you can turn to detect undead in a new area. The spell can penetrate barriers, but 1 foot of stone, 1 inch of common metal, a thin sheet of lead, or 3 feet of wood or dirt blocks it.
    Arcane Material Component: A bit of earth from a grave.

    By: Flaming_Sword
    Created: Oct 1, 2006
    Modified: Oct 5, 2006
*/

#include "prc_inc_s_det"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_DIVINATION);

    object oCaster = OBJECT_SELF;
    int nLevel = PRCGetCasterLevel(oCaster);
    float fDuration = TurnsToSeconds(nLevel);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_DETECT), oCaster, 3.0f);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_IOUN_STONE_RED), oCaster, fDuration);

    DetectRaceAura(0, RACIAL_TYPE_UNDEAD, GetLocation(oCaster), VFX_BEAM_ODD, FeetToMeters(60.0));

    PRCSetSchool();
}