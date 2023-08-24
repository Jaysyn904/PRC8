//::///////////////////////////////////////////////
//:: Name      Ring of Blades OnEnter
//:: FileName  sp_ring_bldsa.nss
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

Fixed so it finally worked
Strat, Mar 7th, 2019

Yeah, it's been totally non-functional for 12 years. 
Yay for not testing your shit.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    object oTarget = GetEnteringObject();
    object oPC = GetAreaOfEffectCreator();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    if(nCasterLvl > 10) nCasterLvl = 10;
    int nDam = d6(1) + nCasterLvl;
	nDam += SpellDamagePerDice(oPC, 1);
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC) && oTarget != oPC)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, DAMAGE_TYPE_SLASHING, nDam), oTarget);
    }
}