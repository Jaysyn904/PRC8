#include "inc_newspellbook"
#include "prc_inc_core"

void main()
{
    if (!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
    {
        SpeakStringByStrRef(40550);
    }
    else
    {
    SetLocalInt(OBJECT_SELF, "UsingZoneOfAnimation", TRUE);
    ActionCastSpell(SPELLABILITY_TURN_UNDEAD);
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
    DelayCommand(3.0, DeleteLocalInt(OBJECT_SELF, "UsingZoneOfAnimation"));
    }
}