/*
    Implacable Foe - Warpriest Spell
*/
#include "prc_alterations"
void main()
{
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAreaOfEffect(AOE_MOB_CIRCGOOD,"codi_s0_implcfo1","codi_s0_implcfo2","codi_s0_implcfo3"), OBJECT_SELF);
    FloatingTextStringOnCreature("You begin to concentrate.", OBJECT_SELF,FALSE);
    ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 9999999.99);
}

