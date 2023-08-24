///////////////////////////////////////////////////////
// Nature's Draught
// sp_natdraught.nss
///////////////////////////////////////////////////////

/*
Nature’s Draught: This substance is a murky, pungent
liquid. When consumed, nature’s draught causes subtle
changes in the user’s scent. Animals respond well to a
character who has consumed nature’s draught, finding
her less threatening and easier to trust. Drinking a vial
of nature’s draught provides a +1 alchemical bonus on
Handle Animal and wild empathy checks made during
the next 12 hours.
*/

#include "prc_inc_spells"

void main()
{
        object oTarget = OBJECT_SELF;
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_ANIMAL_EMPATHY,1), oTarget, HoursToSeconds(12));
        SendMessageToPC(oTarget, "Your scent changes subtley");
}