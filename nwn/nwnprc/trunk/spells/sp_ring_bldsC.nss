//::///////////////////////////////////////////////
//:: Name      Ring of Blades HB
//:: FileName  sp_ring_bldsc.nss
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
    if (!GetIsObjectValid(GetAreaOfEffectCreator()))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    //Declare major variables
    object oShadow = GetAreaOfEffectCreator();
    int nCasterLvl = PRCGetCasterLevel(oShadow);

    //Capture the first target object in the shape.
    object oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oTarget))
    {    
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oShadow))
        {
            int nDamage = d6() + PRCMin(10, nCasterLvl);
            nDamage += SpellDamagePerDice(oShadow, 1);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, DAMAGE_TYPE_SLASHING, nDamage), oTarget);
        }
        //Select the next target within the spell shape.
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }    
}
