#include "prc_inc_burn"

void main()
{
    object oPC = OBJECT_SELF;
	if(!TakeSwiftAction(oPC)) return;    
    int nBurn = BurnSpell(oPC);
    int nRounds = 1; //Arcane Boost is a one round effect
    int nReduction = nBurn * 5;
    if(!nBurn)
    {
        //FloatingTextStringOnCreature("You do not have a spell of that level to burn", oPC, FALSE);
        return;
    }

    effect eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID, nReduction, 0);
    effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, nReduction, 0);
    effect eElectric = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nReduction, 0);
    effect eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, nReduction, 0);
    effect eSonic = EffectDamageResistance(DAMAGE_TYPE_SONIC, nReduction, 0);

    effect eLink = EffectLinkEffects(eAcid, eCold);
    eLink = EffectLinkEffects(eElectric, eLink);
    eLink = EffectLinkEffects(eFire, eLink);
    eLink = EffectLinkEffects(eSonic, eLink);
    eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

    eLink = SupernaturalEffect(eLink);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(nRounds));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION), oPC);

}