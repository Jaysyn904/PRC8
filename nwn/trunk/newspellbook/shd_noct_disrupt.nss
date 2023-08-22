/*
01/03/19 by Stratovarius

Eldritch Disruption

At 6th level, you can use a standard action to disrupt the magical energies of a single target within 60 feet. 
That target must make a Will saving throw (DC 10 + your noctumancer level + your Cha modifier) or take a –4 penalty to its caster level for any mysteries or spells it casts for 1 minute. 
You can use eldritch disruption three times per day
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    int nDC = 10 + GetLevelByClass(CLASS_TYPE_NOCTUMANCER) + GetAbilityModifier(ABILITY_CHARISMA, oShadow);
    if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
    {    
        SetLocalInt(oTarget, "EldritchDisrupt", TRUE);
        DelayCommand(60.0, DeleteLocalInt(oTarget, "EldritchDisrupt"));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(PSI_IMP_CONCUSSION_BLAST), oTarget);
    }    
}