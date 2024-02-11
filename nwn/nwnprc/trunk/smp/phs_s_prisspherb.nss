/*:://////////////////////////////////////////////
//:: Spell Name Prismatic Sphere: Normal On Exit
//:: Spell FileName PHS_S_PrisSpherB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Changes include the fact it won't do all 7 effects, it is affected by dispel
    magic normally, it has a duration (might extend it higher, its a level 7
    spell).

    It still is immobile, and does blindness normally too (a second AOE)

    How does the spell stopping work?

    Well, it will add a new check into the spell hook. If we cast a spell
    into the AOE's location (can use GetNearestObjectByTag() and distance check)
    but we are not ourselves in it, it will fail.

    Ranged weapons have 100% miss chance from both inside and outside (100%
    concealment + 100% miss chance applied on enter, whatever).

    (Normal on exit removes only the consealment effects)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Exit - remove effects
    PHS_AOE_OnExitEffects(PHS_SPELL_PRISMATIC_SPHERE);
}
