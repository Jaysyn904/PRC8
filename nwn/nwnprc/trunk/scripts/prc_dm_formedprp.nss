#include "prc_inc_clsfunc"

void main()
{
    // Check for alcohol:
    if(!UseAlcohol())
    {
        if(GetIsDrunk())
            // PC has no drinks left, remove Drunken Rage effects for For Medicinal Purposes:
            RemoveAlcoholEffects();
        else
        {
            // PC has no alcohol in inventory or in system, exit:
            FloatingTextStringOnCreature("For Medicinal Purposes not possible", OBJECT_SELF);
            SendMessageToPC(OBJECT_SELF, "For Medicinal Purposes not possible: You don't have any alcohol in your system or in your inventory.");
            return;
        }
    }

    int nHeal = d12(4) + GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER);
    effect eHeal = EffectHeal(nHeal);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_L), OBJECT_SELF);
}