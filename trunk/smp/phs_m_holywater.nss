/*:://////////////////////////////////////////////
//:: Spell Name Holy Water
//:: Spell FileName PHS_M_HolyWater
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Holy Water: Holy water damages undead creatures and evil outsiders almost as
    if it were acid. A flask of holy water can be thrown as a splash weapon.

    Treat this attack as a ranged touch attack, with a maximum range of 8M. A
    direct hit by a flask of holy water deals 2d4 points of damage to an undead
    creature or an evil outsider. Each such creature within 1.67M (5 feet) of
    the point where the flask hits takes 1 point of damage from the splash.

    Temples to good deities sell holy water at cost (making no profit).
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As above.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Use the function to do the hit, blast ETC
    PHS_Grenade(d4(2), 1, VFX_IMP_HEAD_HOLY, VFX_IMP_PULSE_HOLY, DAMAGE_TYPE_DIVINE, RADIUS_SIZE_FEET_5, OBJECT_TYPE_CREATURE, RACIAL_TYPE_UNDEAD, RACIAL_TYPE_OUTSIDER, ALIGNMENT_EVIL);
}
