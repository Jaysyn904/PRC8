//::///////////////////////////////////////////////
//:: Power: Astral Construct
//:: psi_ast_con_man
//:://////////////////////////////////////////////
/** @file
    Creates an astral construct as specified by the
    contents of a set of local variables set by
    the Astral Contruct Options conversation.

    @author Ornedan
    @date   Created  - 2005.01.26
    @date   Modified - 2006.01.31
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "psi_inc_ac_manif"
#include "psi_spellhook"


//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int AC_SLOT_1        = 14036;
const int AC_SLOT_2        = 14037;
const int AC_SLOT_3        = 14038;
const int AC_SLOT_4        = 14039;


//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

/**
 * Determines which slot was used for this manifestation.
 *
 * @param nSpellID The spellID of this particular manifestation
 * @return         The number of the slot used
 */
int GetACSlotUsed(int nSpellID);

//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void main()
{
if (!PsiPrePowerCastCode()){ return; }
// End of Spell Cast Hook

        object oManifester = OBJECT_SELF;
        string sSlot = IntToString(GetACSlotUsed(PRCGetSpellId()));

        int nACLevel = GetLocalInt(oManifester, ASTRAL_CONSTRUCT_LEVEL + sSlot);

        if(nACLevel < 1 || nACLevel > 9)
        {
                SendMessageToPCByStrRef(oManifester, STRREF_INVALID_CONSTRUCT_IN_SLOT);
                return;
        }


        // Check if the manifester can. Since AC is sort of a special case in the augmenting
        // scheme, we need to temporarily change the value of augmentation

        // Do the augmentation override
        struct user_augment_profile uapOverride;
        uapOverride.nOption_1 = nACLevel - 1; // The other options are left auto-initialised to 0

        SetAugmentationOverride(oManifester, uapOverride);

        // Determine manifestation
        struct manifestation manif;
        manif = EvaluateManifestation(oManifester, OBJECT_INVALID,
                                  PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                           2, PRC_UNLIMITED_AUGMENTATION
                                                           ),
                                  METAPSIONIC_EXTEND /*| METAPSIONIC_TWIN  Can't be used as long as the effect is a real summon and not a henchmand*/
                                  );
        if(!manif.bCanManifest)
            return;


        int nOptionFlags   = GetLocalInt(oManifester, ASTRAL_CONSTRUCT_OPTION_FLAGS       + sSlot);
        int nResElemFlags  = GetLocalInt(oManifester, ASTRAL_CONSTRUCT_RESISTANCE_FLAGS   + sSlot);
        int nETchElemFlags = GetLocalInt(oManifester, ASTRAL_CONSTRUCT_ENERGY_TOUCH_FLAGS + sSlot);
        int nEBltElemFlags = GetLocalInt(oManifester, ASTRAL_CONSTRUCT_ENERGY_BOLT_FLAGS  + sSlot);

        DoAstralConstructCreation(manif, GetSpellTargetLocation(), nACLevel,
                                  nOptionFlags, nResElemFlags, nETchElemFlags, nEBltElemFlags);

        // Mark the slot manifested out of on the manifester
        SetLocalString(oManifester, MANIFESTED_SLOT, sSlot);
}

int GetACSlotUsed(int nSpellID)
{
    int nRet;

    switch(nSpellID)
    {
        case AC_SLOT_1: nRet = 1; break;
        case AC_SLOT_2: nRet = 2; break;
        case AC_SLOT_3: nRet = 3; break;
        case AC_SLOT_4: nRet = 4; break;

        default: nRet = -1;
    }

    if(DEBUG) DoDebug("GetACSlotUsed():\n"
                    + "nSpellID = " + IntToString(nSpellID) + "\n"
                    + "nRet = " + IntToString(nRet) + "\n"
                      );

    return nRet;
}
