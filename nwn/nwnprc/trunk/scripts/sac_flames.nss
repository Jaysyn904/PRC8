#include "prc_x2_itemprop"
#include "prc_class_const"

void main()
{
    object oPC = OBJECT_SELF;
    int nWis = GetAbilityModifier(ABILITY_WISDOM, oPC);
    int nLvl = GetLevelByClass(CLASS_TYPE_SACREDFIST, oPC);
    int totDamage = nWis ? nWis + nLvl : 1 + nLvl;
    int iDivDmg = totDamage / 2; // round down
    int iFlmDmg = totDamage - iDivDmg; // round up

    iDivDmg = IPGetDamageBonusConstantFromNumber(iDivDmg);
    iFlmDmg = IPGetDamageBonusConstantFromNumber(iFlmDmg);

    effect eDmg = EffectDamageIncrease(iFlmDmg, DAMAGE_TYPE_FIRE);
           eDmg = EffectLinkEffects(eDmg, EffectDamageIncrease(iDivDmg, DAMAGE_TYPE_DIVINE));
           eDmg = EffectLinkEffects(eDmg, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
           eDmg = SupernaturalEffect(eDmg);

    effect eVFX = EffectVisualEffect(VFX_IMP_HOLY_AID);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDmg, oPC, TurnsToSeconds(1));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oPC);
}