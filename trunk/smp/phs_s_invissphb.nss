/*:://////////////////////////////////////////////
//:: Spell Name Invisibility Sphere: On Exit
//:: Spell FileName PHS_S_InvisSphB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This will apply the invisiblity and AOE as one link - so that when the
    person attacks, the entire AOE gets removed :-)

    Also note that the effects for invsibility are only applied for the first
    1.0 seconds, and only applied OnEnter if this is set.

    On Exit:
    - Remove all effects
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Exit - remove effects
    PHS_AOE_OnExitEffects(PHS_SPELL_INVISIBILITY_SPHERE);
}
