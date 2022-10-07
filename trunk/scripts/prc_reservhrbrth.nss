//Spell script for reserve feat Hurricane Breath
//prc_reservhrbrth
//by ebonfowl
//Dedicated to Edgar, the real Ebonfowl

#include "spinc_dimdoor"
#include "prc_inc_combmove"

void main()
{
    object oPC   = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nBonus   = GetLocalInt(oPC, "HurricaneBreathBonus");
    int nStrength = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
    int nRoll = d20() + nBonus;
    int nOpposed = d20() + nStrength;
    effect eVis = EffectVisualEffect(VFX_IMP_KNOCK);

    if (!GetLocalInt(oPC, "HurricaneBreathBonus")) 
    {
        FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
        return;
    }
    
    if (nRoll > nOpposed) 
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        _DoBullRushKnockBack(oTarget, oPC, 5.0);
    }
}