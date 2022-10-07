/*:://////////////////////////////////////////////
//:: Spell Name Dancing Lights - Heartbeat
//:: Spell FileName sp_danclightc
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Moves them to a cirtain place depending on their tag.

    Moves there. If caster gets out of 20M away, it winks out.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "prc_inc_spells"

void main()
{
    // Check if caster is valid and in range
    object oCaster = GetLocalObject(OBJECT_SELF, "Caster");
    // Check if valid & in 20M & still got spell effects
    if(!GetIsObjectValid(oCaster) || (GetDistanceToObject(oCaster) > 20.0 ||
       !GetHasSpellEffect(SPELL_DANCING_LIGHTS, oCaster) ||
       !GetHasSpellEffect(SPELL_DANCING_LIGHTS, OBJECT_SELF)))
    {
        SetPlotFlag(OBJECT_SELF, FALSE);
        MyDestroyObject(OBJECT_SELF);
    }
}
