//::///////////////////////////////////////////////
//:: Name      Sunmantle
//:: FileName  sp_sunmantle.nss
//:://////////////////////////////////////////////
/**@file Sunmantle
Abjuration
Level: Sanctified 4
Components: S, Sacrifice
Casting Time: 1 standard action
Range: Touch
Target: One creature touched
Duration: 1 round/level
Saving Throw: None
Spell Resistance: Yes

This spell cloaks the target in a wavering cloak of
light that illuminates an area around the target
(and dispels darkness) as a daylight spell. However,
its ability to generate bright light is not the
spell's primary function.

The sunmantle grants the target damage reduction
5/-. Furthermore, if the target is struck by a melee
attack that deals hit point damage, a tendril of
light lashes out at the attacker, striking
unerringly and dealing 5 points of damage.

Because of the brilliance of the sunmantle,
creatures sensitive to bright light (such as dark
elves) take the usual attack penalties when in the
light radius of the sunmantle.

Sacrifice: 1d4 points of Strength damage.

Author:    Tenjac
Created:   6/20/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ABJURATION);

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    float fDur = RoundsToSeconds(nCasterLvl);
    int nMetaMagic = PRCGetMetaMagicFeat();

    if(nMetaMagic & METAMAGIC_EXTEND)
    {
        fDur += fDur;
    }

    //Darkness dispelling

    //DR
    effect eLink = EffectLinkEffects(EffectDamageShield(4, DAMAGE_BONUS_1, DAMAGE_TYPE_MAGICAL), EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 5, 0));
           eLink = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_PIERCING, 5, 0), eLink);
           eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SLASHING, 5, 0));

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);

    DoCorruptionCost(oPC, ABILITY_STRENGTH, d4(1), 0);

    //Sanctified spells get mandatory 10 pt good adjustment, regardless of switch
    AdjustAlignment(oPC, ALIGNMENT_GOOD, 10, FALSE);

    //SPGoodShift(oPC);
    PRCSetSchool();
}


