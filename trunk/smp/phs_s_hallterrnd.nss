/*:://////////////////////////////////////////////
//:: Spell Name Hallucinatory Terrain: On Heartbeat (Placeable)
//:: Spell FileName PHS_S_HallTerrnD
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This is the hidden placeable.

    If we don't have the spell's effects, we destroy ourselves.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // If not got the spells effects at all, or not got the AOE from the spell,
    // we destroy ourselves.
    if(!GetHasSpellEffect(PHS_SPELL_HALLUCINATORY_TERRAIN, OBJECT_SELF) ||
       !PHS_GetHasEffect(EFFECT_TYPE_AREA_OF_EFFECT, OBJECT_SELF))
    {
        // Remove all effects
        effect eRemove = GetFirstEffect(OBJECT_SELF);
        while(GetIsEffectValid(eRemove))
        {
            RemoveEffect(OBJECT_SELF, eRemove);
            eRemove = GetNextEffect(OBJECT_SELF);
        }
        // Destroy self
        SetPlotFlag(OBJECT_SELF, FALSE);
        DestroyObject(OBJECT_SELF);
        return;
    }
}
