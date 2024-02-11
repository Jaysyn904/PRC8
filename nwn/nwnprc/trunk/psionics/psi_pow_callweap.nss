/*
   ----------------
   Call Weaponry

   psi_pow_callweap
   ----------------

   29/10/05 by Stratovarius
*/ /** @file

    Call Weaponry

    Psychoportation (Teleportation)
    Level: Psychic warrior 1
    Manifesting Time: 1 round
    Range: 0 ft.
    Effect: One weapon; see text
    Duration: 1 min./level; see text
    Saving Throw: None
    Power Resistance: No
    Power Points: 1
    Metapsionics: Extend

    You call a weapon “from thin air” into your waiting hand (actually, it is a
    real weapon hailing from another location in space and time). You don’t have
    to see or know of a weapon to call it-in fact, you can’t call a specific
    weapon; you just specify the kind. If you call a projectile weapon, it comes
    with 3d6 bolts, arrows, or sling bullets, as appropriate. The weapon is made
    of ordinary materials as appropriate for its kind.

    Weapons gained by call weaponry are distinctive due to their astral glimmer.
    They are considered magic weapons and thus are effective against damage
    reduction that requires a magic weapon to overcome.

    Augment: For every 4 additional power points you spend, this power improves
             the weapon’s enhancement bonus on attack rolls and damage rolls by 1.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"
#include "prc_inc_teleport"

void main()
{
/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/

    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oManifester = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       4, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        SetLocalInt(oManifester, "PRC_Power_CallWeapon_Augment", manif.nTimesAugOptUsed_1);
        SetLocalFloat(oManifester, "PRC_Power_CallWeapon_Duration", fDuration);

        // Dimensional travel prevention check
        if(GetCanTeleport(oManifester, GetLocation(oManifester), FALSE, TRUE))
            StartDynamicConversation("psi_callweapon", oManifester, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oManifester);
    }
}