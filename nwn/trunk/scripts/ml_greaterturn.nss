#include "prc_inc_spells"

void main()
{
    ActionDoCommand(SetLocalInt(OBJECT_SELF, "UsingSunDomain", TRUE));
    ActionCastSpell(SPELLABILITY_TURN_UNDEAD);
    ActionDoCommand(DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD));
    ActionDoCommand(DeleteLocalInt(OBJECT_SELF, "UsingSunDomain"));
}