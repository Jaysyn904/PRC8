/*:://////////////////////////////////////////////
//:: Spell Name Cursed Water
//:: Spell FileName PHS_M_CurseWater
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Cursed Water: Cursed water damages good outsiders almost as if it were acid.
    A flask of cursed water can be thrown as a splash weapon.

    Treat this attack as a ranged touch attack, with a maximum range of 8M. A
    direct hit by a flask of holy water deals 2d4 points of damage to a good
    outsider. Each such creature within 1.67M (5 feet) of the point where the
    flask hits takes 1 point of damage from the splash.

    Temples to evil deities sell cursed water at cost (making no profit).
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As above, damage similar to Biowares.

    This is required for the Curse Water spell.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Use the function to do the hit, blast ETC
    PHS_Grenade(d4(2), 1, VFX_IMP_HEAD_EVIL, VFX_IMP_PULSE_NEGATIVE, DAMAGE_TYPE_NEGATIVE, RADIUS_SIZE_FEET_5, OBJECT_TYPE_CREATURE, RACIAL_TYPE_OUTSIDER, RACIAL_TYPE_ALL, ALIGNMENT_GOOD);
}
