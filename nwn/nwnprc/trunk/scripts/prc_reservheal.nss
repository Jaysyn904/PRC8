//Spell script for reserve feat touch of healing
//prc_reservheal
//by ebonfowl
//Dedicated to Edgar, the real Ebonfowl

#include "prc_sp_func"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    int nSpellID = PRCGetSpellId();
    int nHealing = GetLocalInt(oPC, "TouchOfHealingBonus")*3;
    int nMaxHP = GetMaxHitPoints(oTarget)/2;
    int nCurrentHP = GetCurrentHitPoints(oTarget);
    int nMaxHealing;

    effect eEffect;
    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_S);

    if (nHealing == 0) 
    {
        FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
        return;
    }

    if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        if (nCurrentHP < nMaxHP)
        {
            //Get max healing amount
            nMaxHealing = nMaxHP - nCurrentHP;
            if (nHealing > nMaxHealing) nHealing = nMaxHealing;
            eEffect = EffectHeal(nHealing);
            eEffect = SupernaturalEffect(eEffect);
            //Heal and apply vfx
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oTarget);
        }
        else
        {
            SendMessageToPC(oPC, "This creature has more than half hit points");
            return;
        }
    }
}