/*
   ----------------
   Flame's Blessing

   tob_dw_flmblssng.nss
   ----------------

    28/03/07 by Stratovarius
*/ /** @file

    Flame's Blessing

    Desert Wind (Stance) [Fire]
    Level: Swordsage 1
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You
    Duration: Stance.

    Fire is not your enemy, and it does not harm you.
    
    You gain fire resistance depending on your tumble ranks.
    Tumble 4-8  : Fire Resist 5.
    Tumble 9-13 : Fire Resist 10.
    Tumble 14-18: Fire Resist 20.
    Tumble 19   : Fire Immunity.
    This is a supernatural maneuver.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void main()
{
    if(!PreManeuverCastCode()) return;

    object oInitiator = OBJECT_SELF;
    struct maneuver move = EvaluateManeuver(oInitiator, oInitiator);

    if(move.bCanManeuver)
    {
        int nSkill = GetSkillRank(SKILL_TUMBLE, oInitiator);
        effect eLink = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);
        if (nSkill >= 4 && nSkill <= 8) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_FIRE, 5));
        else if (nSkill >= 9 && nSkill <= 13) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_FIRE, 10));
        else if (nSkill >= 14 && nSkill <= 18) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_FIRE, 20));
        else if (nSkill >= 19) eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 100));
        if(GetHasDefensiveStance(oInitiator, DISCIPLINE_DESERT_WIND))
            eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));
        eLink = SupernaturalEffect(eLink);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oInitiator);
    }
}