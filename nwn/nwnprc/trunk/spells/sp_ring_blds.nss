//::///////////////////////////////////////////////
//:: Name      Ring of Blades
//:: FileName  sp_ring_blds.nss
//:://////////////////////////////////////////////
/**@file Ring of Blades
Conjuration (Creation)
Level: Cleric 3, warmage 3
Components: V,S, M
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 min./level

This spell conjures a horizontal ring
of swirling metal blades around you.
The ring extends 5 feet from you, into
all squares adjacent to your space, and
it moves with you as you move. Each
round on your turn, starting when
you cast the spell, the blades deal 1d6
points of damage +1 point per caster
level (maximum +10) to all creatures
in the affected area.

The blades conjured by a lawful-aligned
cleric are cold iron, those conjured by
a chaotic-aligned cleric are silver, and
those conjured by a cleric who is neither
lawful nor chaotic are steel.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    object oPC = OBJECT_SELF;
    effect eAoE = EffectAreaOfEffect(VFX_MOB_RING_OF_BLADES);
    int nDur = PRCGetCasterLevel(oPC);
    int nMetaMagic = PRCGetMetaMagicFeat();

    if(nMetaMagic & METAMAGIC_EXTEND) nDur = nDur * 2;

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAoE, oPC, RoundsToSeconds(nDur));

    PRCSetSchool();
}