//Spell script for reserve feat Borne Aloft
//prc_reservbnalft
//by ebonfowl
//Dedicated to Edgar, the real Ebonfowl

#include "prc_inc_skills"

void main()
{
    object oPC    = OBJECT_SELF;

    if (!GetLocalInt(oPC, "BorneAloftBonus"))
    {
        FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
        return;
    }

    // Make the Jump skill real high temporarily
    effect eJump = EffectSkillIncrease(SKILL_JUMP, 99);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eJump, oPC, 1.0f);

    //Make the character temporarily able to fly for good measure
    SetLocalInt(oPC, "BorneAloft", TRUE);

    //Jump time
	PerformJump(oPC, PRCGetSpellTargetLocation(), FALSE);

    DelayCommand(1.0f, DeleteLocalInt(oPC, "BorneAloft"));
}