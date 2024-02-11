/** @file psi_pow_hammer

    Hammer

    Psychometabolism
    Level: Psion/wilder 1, psychic warrior 1
    Manifesting Time: 1 swift action
    Range: Touch
    Target: One creature or object
    Duration: Instantenous
    Saving Throw: None
    Power Resistance: Yes
    Power Points: 1
    Metapsionics: Empower, Maximize, Twin

    This power charges your touch with the force of a sledgehammer. A successful
    melee touch attack deals 1d8 points of bludgeoning damage. This damage is
    not increased or decreased by your Strength modifier.

    Manifesting this power is a swift action, like manifesting a quickened
    power, and it counts toward the normal limit of one quickened power per
    round. You cannot manifest this power when it isn't your turn.

    Augment: For every additional power point spent, this power's damage
             increases by 1d8.

    @author Stratovarius
    @date   Created: Oct 31, 2004
    @date   Modified: Jul 3, 2006
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_sp_func"
#include "prc_inc_sp_tch"

int DoPower(object oManifester, object oTarget, struct manifestation manif)
{
    int nPen          = GetPsiPenetration(oManifester);
    int nNumberOfDice = 1 + manif.nTimesAugOptUsed_1;
    int nDieSize      = 8;
    int nDamage, nTouchAttack, bHit = 0;
    effect eVis       = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
    effect eDamage;

    PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

    int nRepeats = manif.bTwin ? 2 : 1;
    for(; nRepeats > 0; nRepeats--)
    {
        nTouchAttack = PRCDoMeleeTouchAttack(oTarget);
        if(nTouchAttack > 0)
        {
            bHit = 1;
            if(PRCMyResistPower(oManifester, oTarget, nPen) == POWER_RESIST_FAIL)
            {
                // Roll damage
                nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, FALSE);
                // Target-specific stuff
                nDamage = GetTargetSpecificChangesToDamage(oTarget, oManifester, nDamage, TRUE, FALSE);

                // Apply the damage and VFX
                ApplyTouchAttackDamage(oManifester, oTarget, nTouchAttack, nDamage, DAMAGE_TYPE_BLUDGEONING);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }

    return bHit;    //Held charge is used if at least 1 touch from twinned power hits
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
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
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