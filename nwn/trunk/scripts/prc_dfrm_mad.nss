/*Deformity (Madness) [Vile, Deformity]
You revel in madness, embracing your hallucinations, erratic
behavior, and deviant cravings. Your mind cannot be touched by outside influences.
Prerequisite: Willing Deformity.
Benefit: You take a permanent -4 profane penalty to your
Wisdom score to become immune to all mind-affecting spells
and abilities.

As an immediate action, you can derive clarity from your
madness to add a bonus equal to one-half your character level
to a single Will save. Make this decision before determining
the results of the saving throw. You must wait 1 minute before
you can take this action again.*/

#include "prc_inc_spells"

void main()
{
        object oPC = OBJECT_SELF;
        int nBonus = GetHitDice(oPC) / 2;
        int bTimer = GetLocalInt(oPC, "PRC_DEFORM_MADNESS_TIMER");
        
        if(!bTimer)
        {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowIncrease(SAVING_THROW_WILL, nBonus, SAVING_THROW_TYPE_ALL), oPC, 6.0f);
                SetLocalInt(oPC, "PRC_DEFORM_MADNESS_TIMER", TRUE);
                DelayCommand(TurnsToSeconds(1), DeleteLocalInt(oPC, "PRC_DEFORM_MADNESS_TIMER"));
        }
        
        else
        {
                FloatingTextStringOnCreature("You must 1 minute between uses of Deformity(Madness).", oPC, FALSE);
                return;
        }
}