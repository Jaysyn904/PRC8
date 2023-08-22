//::///////////////////////////////////////////////
//:: Spell: Dimension Door
//:: sp_dimens_door
//::///////////////////////////////////////////////
/** @ file
    Dimension Door

    Conjuration (Teleportation)
    Level: Brd 4, Sor/Wiz 4, Travel 4
    Components: V
    Casting Time: 1 standard action
    Range: Long (400 ft. + 40 ft./level)
    Target: You and other touched willing creatures (ie. party members within 10ft of you)
    Duration: Instantaneous
    Saving Throw: None
    Spell Resistance: No

    You instantly transfer yourself from your current location to any other spot within range.
    You always arrive at exactly the spot desired—whether by simply visualizing the area or by
    stating direction**. You may also bring one additional willing Medium or smaller creature
    or its equivalent per three caster levels. A Large creature counts as two Medium creatures,
    a Huge creature counts as two Large creatures, and so forth. All creatures to be
    transported must be in contact with you. *

    Notes:
    * Implemented as within 10ft of you due to the lovely quality of NWN location tracking code.
    ** The direction is the same as the direction of where you target the spell relative to you.
       A listener will be created so you can say the distance.

    @author Ornedan
    @date   Created  - 2005.07.04
    @date   Modified - 2005.10.12
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_dimdoor"


void main()
{
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);
    // Spellhook
    if(!X2PreSpellCastCode()) return;

    /* Main spellscript */
    object oCaster   = OBJECT_SELF;
    int nCasterLvl   = PRCGetCasterLevel();
    int nSpellID     = PRCGetSpellId();
    int bSelfOrParty = ( (nSpellID == SPELL_DIMENSION_DOOR_PARTY) ||
                         (nSpellID == SPELL_DIMENSION_DOOR_DIRDIST_PARTY) )
                       ? DIMENSIONDOOR_PARTY
                       : DIMENSIONDOOR_SELF;
    int bUseDirDist  = (nSpellID == SPELL_DIMENSION_DOOR_DIRDIST_SELF) ||
                       (nSpellID == SPELL_DIMENSION_DOOR_DIRDIST_PARTY);

    DimensionDoor(oCaster, nCasterLvl, nSpellID, "", bSelfOrParty, bUseDirDist);


    // Cleanup
    PRCSetSchool();
}


