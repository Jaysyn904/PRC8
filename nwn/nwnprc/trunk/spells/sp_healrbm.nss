/////////////////////////////////////////////////////////
// Healer's Balm
// sp_healrbm.nss
/////////////////////////////////////////////////////////
/*Healer’s Balm: This smooth, sweet-smelling balm
allows a healer to better soothe the effects of wounds, disease,
and poison. Healer’s balm provides a +1 alchemical
bonus on Heal checks made to help an affected creature.
The effects of healer’s balm last for 1 minute.
One dose of healer’s balm is enough to coat one
Medium creature. Applying healer’s balm is a standard
action that provokes attacks of opportunity. It can be
applied as part of a standard action made to administer
first aid, treat a wound, or treat poison. */

void main()
{
        object oPC = OBJECT_SELF;
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_HEAL, 1), oPC, TurnsToSeconds(1));
        SendMessageToPC(oPC, "You coat your hands in Healer's Balm.");
}