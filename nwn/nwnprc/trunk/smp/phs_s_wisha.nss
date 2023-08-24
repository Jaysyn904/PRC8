/*:://////////////////////////////////////////////
//:: Spell Name Wish - On Spawn of Djinni
//:: Spell FileName PHS_S_WishA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Spawn in of the Djinni. This is just to start the time stop, relay some info,
    and set listening patterns.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_WISH"

void main()
{
    // Get the caster and us
    object oSelf = OBJECT_SELF;
    object oCaster = GetLocalObject(oSelf, "PHS_WISHER");

    // Set up listening patterns
    SetListening(oSelf, TRUE);

    // We set up specific ones for each event for Wish.


    SetListenPattern(oSelf, "**", 0);

    // Apply appear effects
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
    PHS_ApplyLocationVFX(GetLocation(oSelf), eVis);

    // Set facing point to the caster of the spell
    SetFacingPoint(GetPosition(oCaster));
    // Relay a message of instructions
    SendMessageToPC(oCaster, "You have summoned a Djinni to grant your wish. You must say aloud what you request (to the limits of the spell) or 'I wish for nothing'");

    // Apply timestop so no one can do anything during the time. Only the Djinni
    // can move (if he needs to).
    effect eTime = EffectTimeStop();

    // 4 seconds too long
    // 1 second too little, by a small margin.
    // 1.5 should be fine
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTime, oSelf));
    // Allows heartbeat to check for timestop
    DelayCommand(2.0, SetLocalInt(oSelf, "PHS_HEARTBEAT_VALID", TRUE));
}
