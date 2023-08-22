/*:://////////////////////////////////////////////
//:: Spell Name Fight Theme - On Heartbeat
//:: Spell FileName XXX_S_FightThemeC
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    How is "one fight" determined? Well, to be exact, it is until an AOE
    placed on each person decides the person it is on is dead, or not in
    combat (!GetIsInCombat()) for whatever reason (might be moved, away, killed
    everyone ETC).

    Heartbeat script checks the above.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Define ourselves.
    object oSelf = OBJECT_SELF;

    // Check for combat, or deadness
    if(GetIsDead(oSelf) || !GetIsInCombat(oSelf))
    {
        // Remove previous effects of any type form this spell - including this VFX
        SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_FIGHT_THEME, oSelf);
    }
}
