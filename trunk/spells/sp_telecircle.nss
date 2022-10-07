//:://////////////////////////////////////////////
//:: Spell: Teleportation Circle
//:: sp_telecircle
//:://////////////////////////////////////////////
/** @file

    Teleportation Circle

    Conjuration (Teleportation)
    Level: Sor/Wiz 9
    Components: V
    Casting Time: 10 minutes
    Range: 0 ft.
    Effect: 5-ft.-radius circle that teleports those who activate it
    Duration: 10 min./level
    Saving Throw: None
    Spell Resistance: Yes

    You create a circle on the floor or other horizontal surface that teleports, as greater teleport,
    any creature who stands on it to a designated spot. Once you designate the destination for the
    circle, you can’t change it. The spell fails if you attempt to set the circle to teleport
    creatures into a solid object, to a place with which you are not familiar and have no clear
    description, or to another plane.

    The circle itself is subtle and nearly impossible to notice. If you intend to keep creatures from
    activating it accidentally, you need to mark the circle in some way.

    Teleportation circle can be made permanent with a permanency spell. A permanent teleportation circle
    that is disabled becomes inactive for 10 minutes, then can be triggered again as normal.

    Note: Magic traps such as teleportation circle are hard to detect and disable. A rogue (only) can
    use the Search skill to find the circle and Disable Device to thwart it. The DC in each case is
    25 + spell level, or 34 in the case of teleportation circle.

    Material Component: Amber dust to cover the area of the circle (cost 1,000 gp).

    @author Ornedan
    @date   Created - 24.06.2005
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_telecircle"

const int ERROR_CODE_5_Fix = 1;

const int SPELLID_VISIBLE = 2878;
const int SPELLID_HIDDEN  = 2879;

//PRC_TELECIRCLE_TRIG_VISIBLE_ORIG
//PRC_TELECIRCLE_TRIG_HIDDEN_ORIG


void main()
{
    // Set the spell school
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);
    // Spellhook
    if(!X2PreSpellCastCode()) return;

    object oCaster = OBJECT_SELF;
    int nCasterLvl = PRCGetCasterLevel();
    int bVisible   = PRCGetSpellId() == SPELLID_VISIBLE;
    int bExtended  = CheckMetaMagic(PRCGetMetaMagicFeat(), METAMAGIC_EXTEND);

    TeleportationCircle(oCaster, nCasterLvl, bVisible, bExtended);

    PRCSetSchool();
}
