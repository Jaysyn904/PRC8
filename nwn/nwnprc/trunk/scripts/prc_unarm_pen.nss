// Basically what this does is add the weapon finesse calculated in prc_intuiatk and an offsetting
// penalty to compensate for attack bonuses on the creature weapon.  If the character is attacking
// with gloves that give an attack bonus, the offset penalty may not exist.

#include "prc_inc_spells"

void main ()
{
    object oPC = PRCGetSpellTargetObject();
    
    int iPen = GetLocalInt(oPC, "UnarmedEnhancement") - GetLocalInt(oPC, "UnarmedEnhancementGlove");
    int iFin = GetLocalInt(oPC, "UnarmedWeaponFinesseBonus");

    if (iPen < 0) iPen = 0;

    effect ePen = EffectAttackDecrease(iPen);    // offset penalty
    ePen = EffectLinkEffects(ePen, EffectAttackIncrease(iFin)); // weapon finesse bonus
    ePen = SupernaturalEffect(ePen);

    PRCRemoveEffectsFromSpell(oPC, GetSpellId());
    
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePen, oPC);
    
    DeleteLocalInt(oPC, "UnarmedEnhancement");
    DeleteLocalInt(oPC, "UnarmedEnhancementGlove");
    DeleteLocalInt(oPC, "UnarmedWeaponFinesseBonus");
}
