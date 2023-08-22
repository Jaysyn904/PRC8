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
    
    object oTarget = PRCGetSpellTargetObject();

    effect eLink = EffectLinkEffects(EffectHeal(nBurn*2), EffectVisualEffect(VFX_IMP_HEALING_M));
    eLink = SupernaturalEffect(eLink);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
}