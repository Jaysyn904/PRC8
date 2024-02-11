/*
   ----------------
   Claws of the Beast

   psi_pow_clwbeast
   ----------------

   29/10/05 by Stratovarius
*/ /** @file

    Claws of the Beast

    Psychometabolism
    Level: Psychic warrior 1
    Manifesting Time: 1 swift action
    Range: Personal
    Target: You
    Duration: 1 hour/level
    Power Points: see text
    Metapsionics: Extend

    You call forth the aggressive nature of the beast inherent in yourself,
    psionically transforming your hands into deadly claws. You gain two natural
    attacks with your claws, each dealing 1d4 points of damage (1d6 if you are
    Large or larger, or 1d3 if you are Small or smaller) plus your Strength
    bonus.

    Your claws are natural weapons, so you are considered armed when attacking
    with them, and they can be affected by powers, spells, and effects that
    enhance or improve natural.

    Your claws work just like the natural weapons of many monsters. You can make
    an attack with one claw or a full attack with two claws at your normal
    attack bonus, replacing your normal attack routine. You take no penalties
    for two-weapon fighting, and neither attack is a secondary attack. If your
    base attack bonus is +6 or higher, you do not gain any additional attacks -
    you simply have two claw attacks at your normal attack bonus.

    You can manifest this power with an instant thought, quickly enough to gain
    the benefit of the power on your turn before you attack. Manifesting this
    power is a swift action, like manifesting a quickened power, and it counts
    toward the normal limit of one quickened power per round.

    You can still hold and manipulate items with your claws or cast spells just
    as well as you could with your hands.

    Augment: If you spend additional power points, you can create larger,
             sharper, and more deadly claws, as shown on the table below.

    Power Points    Claw Damage
                    Small   Medium  Large
    1               1d3     1d4     1d6
    3               1d4     1d6     1d8
    5               1d6     1d8     2d6
    7               1d8     2d6     3d6
    11              2d6     3d6     4d6
    15              3d6     4d6     5d6
    19              4d6     5d6     6d6

    This augmentation is implemented as the following two augmentation options:
    1. For every 2 power points spent, the size of the claws increases by one
       step on the table above. This increase may be used up to 3 times.
    2. For every 4 power points spent, the size of the claws increases by one
       step on the table above. This increase may be used up to 3 times.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_natweap"


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
                                                       2, 3,
                                                       4, 3
                                                       ),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        // {0, 1, 2}, depending on the size of the creature
        int nEffectiveSize        = max(min(PRCGetCreatureSize(oTarget), CREATURE_SIZE_LARGE), CREATURE_SIZE_SMALL) - CREATURE_SIZE_SMALL;
        int nClawSize             = nEffectiveSize + manif.nTimesAugOptUsed_1 + manif.nTimesAugOptUsed_2;
        int nBaseDamage;
        effect eVis               = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
        effect eDur               = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        object oLClaw, oRClaw;
        float fDuration           = HoursToSeconds(manif.nManifesterLevel);
        if(manif.bExtend) fDuration *= 2;

        // Determine base damage
        switch(nClawSize)
        {
            case 0: nBaseDamage = IP_CONST_MONSTERDAMAGE_1d3; break;
            case 1: nBaseDamage = IP_CONST_MONSTERDAMAGE_1d4; break;
            case 2: nBaseDamage = IP_CONST_MONSTERDAMAGE_1d6; break;
            case 3: nBaseDamage = IP_CONST_MONSTERDAMAGE_1d8; break;
            case 4: nBaseDamage = IP_CONST_MONSTERDAMAGE_2d6; break;
            case 5: nBaseDamage = IP_CONST_MONSTERDAMAGE_3d6; break;
            case 6: nBaseDamage = IP_CONST_MONSTERDAMAGE_4d6; break;
            case 7: nBaseDamage = IP_CONST_MONSTERDAMAGE_6d6; break;

            /*default:{
                string sErr = "psi_pow_clwbeast: ERROR: Unknown nClawSize value: " + IntToString(nClawSize);
                if(DEBUG) DoDebug(sErr);
                else      WriteTimestampedLogEntry(sErr);
            }*/
        }
        // Catch exceptions here
        if (nClawSize < 0) nBaseDamage = IP_CONST_MONSTERDAMAGE_1d3;
        else if (nClawSize > 7) nBaseDamage = IP_CONST_MONSTERDAMAGE_6d6;

        // Create the creature weapon
        oLClaw = GetPsionicCreatureWeapon(oTarget, "PRC_UNARMED_SP", INVENTORY_SLOT_CWEAPON_L, fDuration);
        oRClaw = GetPsionicCreatureWeapon(oTarget, "PRC_UNARMED_SP", INVENTORY_SLOT_CWEAPON_R, fDuration);

        // Add the base damage
        AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyMonsterDamage(nBaseDamage), oLClaw, fDuration);
        AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyMonsterDamage(nBaseDamage), oRClaw, fDuration);

        // Do VFX
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        DelayCommand(2.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration, FALSE);
        
        string sResRef;        
        switch(nClawSize)
        {
            case 0: sResRef = "prc_claw_1d6l_"; break;
            case 1: sResRef = "prc_claw_1d6m_"; break;
            case 2: sResRef = "prc_claw_1d8m_"; break;
            case 3: sResRef = "prc_claw_2d6m_"; break;
            case 4: sResRef = "prc_claw_3d6m_"; break;
            case 5: sResRef = "prc_claw_4d6m_"; break;
            case 6: sResRef = "prc_claw_5d6m_"; break;
            case 7: sResRef = "prc_claw_6d6m_"; break;        
        }
        sResRef += GetAffixForSize(PRCGetCreatureSize(oTarget));
        
        AddNaturalPrimaryWeapon(oTarget, sResRef, 2, TRUE);
        DelayCommand(6.0f, 
            NaturalPrimaryWeaponTempCheck(oManifester, oTarget, manif.nSpellID, FloatToInt(fDuration) / 6, sResRef));
            
        
    }// end if - Successfull manifestation
}