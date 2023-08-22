#include "prc_inc_clsfunc"
#include "prc_inc_breath"

void main()
{
    // Check for alcohol:
    if(!UseAlcohol())
    {
        if(GetIsDrunk())
            // PC has no drinks left, remove Drunken Rage effects for Breath of Flame:
            RemoveAlcoholEffects();
        else
        {
            // PC has no alcohol in inventory or in system, exit:
            FloatingTextStringOnCreature("Breath of Flame not possible", OBJECT_SELF);
            SendMessageToPC(OBJECT_SELF, "You don't have any alcohol in your system or in your inventory.");
            return;
        }
    }

    // Breath of Flame:
    struct breath FlameBreath = CreateBreath(OBJECT_SELF, FALSE, 20.0, DAMAGE_TYPE_FIRE, 12, 3, ABILITY_CONSTITUTION, GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER), BREATH_NORMAL, 0);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(494), GetSpellTargetLocation());
    ApplyBreath(FlameBreath, GetSpellTargetLocation());
}