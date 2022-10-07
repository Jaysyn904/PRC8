//::///////////////////////////////////////////////
//:: Name      Blood of the Martyr
//:: FileName  sp_blood_martyr.nss
//:://////////////////////////////////////////////
/**@file Blood of the Martyr
Necromancy
Level: Cleric 4, Paladin 4
Components: V, S
Casting Time: 1 action
Range: Medium (100 ft. + 10 ft/level)
Targets: 1 willing creature
Duration: Instantaneous
Saving Throw: None
Spell Resistance: No

You may transfer your own hitpoints to a target creature within range. You must transfer at least 20 points.
Transferred hitpoints are damage to you. The creature takes your transferred hitpoints as if recieving a
cure wounds spell and cannot gain more than hit points than its maximum allows; any excess hitpoints are lost.
This spell transfers only actual hitpoints, not temporary hit points.

Author:    Stratovarius
Created:   26/2/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "inc_dynconv"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    // Run the spellhook.
    if (!X2PreSpellCastCode()) return;

    //Define vars
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    if (GetIsFriend(oTarget, oPC)) // Only works on allies
    {
        SetLocalObject(oPC, "BloodMartyrTarget", oTarget);
        StartDynamicConversation("sp_cnv_bldmartyr", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);
    }

    PRCSetSchool();
}

