//::///////////////////////////////////////////////
//:: Spell: Transport via Plants
//:: sp_transviaplants.nss
//:://////////////////////////////////////////////
/** @file
    Transport via Plants

    Conjuration (Teleportation)
    Level: Drd 6
    Components: V, S
    Casting Time: 1 standard action
    Range: Unlimited
    Target: You and touched objects or other touched willing creatures
    Duration: 1 round
    Saving Throw: None
    Spell Resistance: No

    You can enter any normal plant (Medium or larger)
    and pass any distance to a plant of the same kind
    in a single round, regardless of the distance
    separating the two. The entry plant must be alive.
    The destination plant need not be familiar to you,
    but it also must be alive. If you are uncertain of
    the location of a particular kind of destination
    plant, you need merely designate direction and
    distance and the transport via plants spell moves
    you as close as possible to the desired location.
    If a particular destination plant is desired but
    the plant is not living, the spell fails and you
    are ejected from the entry plant.

    You can bring along objects as long as their
    weight doesn't exceed your maximum load. You may
    also bring one additional willing Medium or
    smaller creature (carrying gear or objects up to
    its maximum load) or its equivalent per three
    caster levels. Use the following equivalents to
    determine the maximum number of larger creatures
    you can bring along: A Large creature counts as
    two Medium creatures, a Huge creature counts as
    two Large creatures, and so forth. All creatures
    to be transported must be in contact with one
    another, and at least one of those creatures must
    be in contact with you.

    You can't use this spell to travel through plant
    creatures.

    Notes: This spell can only be used in natural,
    exterior areas.

    @author xwarren
    @date   Created 2010.10.15
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_teleport"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    object oCaster = OBJECT_SELF;
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nSpellID   = PRCGetSpellId();
    object oArea = GetArea(oCaster);

    if(!GetIsAreaNatural(oArea) || GetIsAreaInterior(oArea))
    {
        FloatingTextStrRefOnCreature(16789928, oCaster);
    }
    else
    {
        SetLocalInt(oCaster, "PRC_TransportViaPlants", TRUE);
        Teleport(oCaster, nCasterLvl, nSpellID == SPELL_TRANSPORT_VIA_PLANTS_PARTY, TRUE, "");
    }

    PRCSetSchool();
}
