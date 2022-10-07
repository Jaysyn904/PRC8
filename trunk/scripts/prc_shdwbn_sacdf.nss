#include "prc_inc_burn"

void main()
{
    object oPC = OBJECT_SELF;
    int nBurn = BurnSpell(oPC);

    if(!nBurn)
    {
        //FloatingTextStringOnCreature("You do not have a spell of that level to burn", oPC, FALSE);
        return;
    }

    effect eLink = EffectLinkEffects(EffectACIncrease(4, AC_DEFLECTION_BONUS), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
    eLink = SupernaturalEffect(eLink);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(nBurn));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_AC_BONUS), oPC);
}