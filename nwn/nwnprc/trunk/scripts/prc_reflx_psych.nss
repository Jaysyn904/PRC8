/*Reflexive Psychosis [Vile, Deformity]
In the face of adversity, you withdraw into the haunted corridors
of your mind.
Prerequisite: Deformity (Madness).
Benefit: As an immediate action, you can gain damage
reduction 5/- for 1 round. After using this ability, you are
confused until the end of your next turn.*/

#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageReduction(5, DAMAGE_POWER_PLUS_FIVE, 0), oPC, RoundsToSeconds(1));
    DelayCommand(RoundsToSeconds(1), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(PRCEffectConfused(), EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED)), oPC, TurnsToSeconds(1)));
}