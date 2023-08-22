/** @file psi_pow_astseed

    Astral Seed

    Metacreativity
    Level: Shaper 8
    Manifesting Time: 10 minutes
    Range: 0 ft.
    Effect: One storage crystal
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 15
    Metapsionics: None

    This power weaves strands of ectoplasm into a crystal containing the seed of your living mind. You may have only one seed in
    existence at any one time. Until such time as you perish, the astral seed is totally inert. Upon dying, you are transported
    to the location of your astral seed, where you will spend a day regrowing a body. Respawning in this manner will cost a level.
    If your astral seed is destroyed, the power will fail.

    @author Stratovarius
    @date   Created: Apr 9, 2005
    @date   Modified: Jul 3, 2006
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_sp_func"

int DoPower(object oManifester, object oTarget, struct manifestation manif)
{
    // Destroy old seed, if any
    object oSeed = GetLocalObject(oManifester, "PRC_AstralSeed_SeedObject");
    if(GetIsObjectValid(oSeed))
        MyDestroyObject(oSeed);

    // Retrieve Module string for Seed ResRef
    string sResRef = GetLocalString(GetModule(), PRC_PSI_ASTRAL_SEED_RESREF);
    // If no Module Seed ResRef value is set, use the default
    if (sResRef == "")
        sResRef = "x2_plc_phylact";

    // Create new seed
    oSeed = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, PRCGetSpellTargetLocation());

    // If the provided ResRef fails to generate a valid item, retry with the default phylactery
    if (!GetIsObjectValid(oSeed))
        oSeed = CreateObject(OBJECT_TYPE_PLACEABLE, "x2_plc_phylact", PRCGetSpellTargetLocation());

    // Perform VFX
    effect eVis = EffectVisualEffect(PSI_FNF_ASTRAL_SEED);
    DelayCommand(0.5, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oSeed));
    // Store a reference to the seed on the manifester
    SetLocalObject(oManifester, "PRC_AstralSeed_SeedObject", oSeed);
    // Add a hook to OnDeath event for the manifester
    AddEventScript(oManifester, EVENT_ONPLAYERDEATH, "psi_astseed_resp", FALSE, FALSE);

    return TRUE;    //Held charge is used if at least 1 touch from twinned power hits
}

void main()
{
    if(!PsiPrePowerCastCode()) return;
    object oManifester = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif;
    int nEvent = GetLocalInt(oManifester, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        manif =
        EvaluateManifestation(oManifester, OBJECT_INVALID,
                              PowerAugmentationProfile(),
                              METAPSIONIC_NONE
                              );

        if(manif.bCanManifest)
        {
            if(GetLocalInt(oManifester, PRC_SPELL_HOLD) && oManifester == oTarget)
            {   //holding the charge, manifesting power on self
                SetLocalSpellVariables(oManifester, 1);   //change 1 to number of charges
                SetLocalManifestation(oManifester, PRC_POWER_HOLD_MANIFESTATION, manif);
                return;
            }
            DoPower(oManifester, oTarget, manif);
        }
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            manif = GetLocalManifestation(oManifester, PRC_POWER_HOLD_MANIFESTATION);
            if(DoPower(oManifester, oTarget, manif))
                DecrementSpellCharges(oManifester);
        }
    }
}