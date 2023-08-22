//::///////////////////////////////////////////////
//:: Name      Divine Inspiration
//:: FileName  sp_divine_insp.nss
//:://////////////////////////////////////////////
/**@file Divine Inspiration
Divination
Level: Sanctified 1
Components: Sacrifice
Casting Time: 1 standard action
Range: Touch
Target: One creature touched
Duration: 1d4 rounds
Saving Throw: None
Spell Resistance: Yes (harmless)

This spell helps to tip the momentum of combat in
the favor of good, granting limited precognitive
ability that enables the spell's recipient to
circumvent the defenses of evil opponents. The
target of the spell gains a +3 sacred bonus on all
attack rolls made against evil creatures. This
bonus does not apply to attacks made against
non-evil creatures.

Sacrifice: 1d2 points of Strength damage.

Author:    Tenjac
Created:   6/9/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nMetaMagic = PRCGetMetaMagicFeat();
    effect eAttack = EffectAttackIncrease(3);
    // vs eeeevil
    eAttack = VersusAlignmentEffect(eAttack, ALIGNMENT_ALL, ALIGNMENT_EVIL);
    float fDur = RoundsToSeconds(d4(1));

    if(nMetaMagic & METAMAGIC_EXTEND)
    {
        fDur *= 2;
    }

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttack, oTarget, fDur);

    DoCorruptionCost(oPC, ABILITY_STRENGTH, d2(), 0);

    //Sanctified spells get mandatory 10 pt good adjustment, regardless of switch
    AdjustAlignment(oPC, ALIGNMENT_GOOD, 10, FALSE);

    //Adding a good shift even though the spell has no [Good] descriptor; need to check source
    //SPGoodShift(oPC);
}
