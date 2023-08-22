/*
01/03/19 by Stratovarius

Innate Counterspell

Starting at 2nd level, you can attempt to counter a spell without using a readied action. Once per day, you can counter a spell as an immediate action by expending a spell slot (if you prepare spells), 
or a spell use (if you are a spontaneous caster) as long as the spell expended is of the same level as the spell to be countered.
At 7th level, when you successfully counter a spell using this ability, you retain some of the magical essence of the countered dweomer. 
You gain one additional use of a mystery. The level of the mystery you gain is equal to one-half the level of the spell you countered (rounded down, minimum 1). 
You can use innate counterspell once per day at 2nd level, two times at 5th, and three times at 8th. 
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject(); 
    SetLocalInt(oTarget, "InnateCounterspell", TRUE);
    SetLocalObject(oTarget, "InnateCounterspell", oShadow);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(PSI_IMP_CONCUSSION_BLAST), oTarget);
}