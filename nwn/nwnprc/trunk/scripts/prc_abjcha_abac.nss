#include "prc_inc_burn"

void main()
{
    object oPC = OBJECT_SELF;
    if(!TakeSwiftAction(oPC)) return;   
    int nBurn = BurnSpell(oPC);
    int nRounds = 1; //Arcane Boost is a one round effect

    if(!nBurn)
    {
        //FloatingTextStringOnCreature("You do not have a spell of that level to burn", oPC, FALSE);
        return;
    }

    effect eLink =  EffectLinkEffects(EffectACIncrease(nBurn, AC_DODGE_BONUS, AC_VS_DAMAGE_TYPE_ALL), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
    eLink = SupernaturalEffect(eLink);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(nRounds));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_AC_BONUS), oPC);

}