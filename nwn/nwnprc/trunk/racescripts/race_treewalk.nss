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
    /* Main spellscript */
    object oCaster   = OBJECT_SELF;

    // Only proceed if the area is outdoors and natural
    object oArea = GetArea(oCaster);
    if (GetIsAreaInterior(oArea) || !GetIsAreaNatural(oArea))
    {
        // Optional: feedback to player
        SendMessageToPC(oCaster, "This spell can only be used outdoors in natural environments.");
        return;
    }

    int nCasterLvl   = GetHitDice(oCaster);
    int nSpellID     = PRCGetSpellId();
    int bUseDirDist  = nSpellID == SPELL_FORESTLORD_TREEWALK_DIRDIST;
    SetLocalInt(oCaster, "Treewalk", TRUE);

    DimensionDoor(oCaster, nCasterLvl, nSpellID, "", DIMENSIONDOOR_SELF);

    DelayCommand(10.1, DeleteLocalInt(oCaster, "Treewalk"));
}


/* void main()
{

    //:: Main spellscript
    object oCaster   = OBJECT_SELF;
    int nCasterLvl   = GetHitDice(oCaster);
    int nSpellID     = PRCGetSpellId();
    int bUseDirDist  = nSpellID == SPELL_FORESTLORD_TREEWALK_DIRDIST;
    SetLocalInt(oCaster, "Treewalk", TRUE);

    DimensionDoor(oCaster, nCasterLvl, nSpellID, "", DIMENSIONDOOR_SELF);

    DelayCommand(10.1, DeleteLocalInt(oCaster, "Treewalk"));

} */


