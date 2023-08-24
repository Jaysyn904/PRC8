#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;
    if (3 > GetLocalInt(oPC, "StrengthFromMagic")) 
    {
    	FloatingTextStringOnCreature("Your Strength from Magic is not strong enough to be an Arcane Mastermind", oPC, FALSE);
    	return;
    }	
    if(!TakeSwiftAction(oPC)) return;
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectAttackIncrease(2)), PRCGetSpellTargetObject(), 6.0);
}