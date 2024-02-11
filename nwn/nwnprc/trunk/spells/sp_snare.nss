//::///////////////////////////////////////////////
//:: Name      Snare
//:: FileName  sp_snare.nss
//:://////////////////////////////////////////////
/**@file Snare
Transmutation
Level:   Rgr 2, Drd 3
Components:       V, S, DF
Range:            Touch
Target:           Area with a 2 ft. diameter + 2 ft./level
Duration:         Until triggered or broken
Saving Throw:     None
Spell Resistance: No

This spell enables you to make a snare that functions
as a magic trap. When you cast this spell, 
a cordlike object blends with its surroundings 
(Search DC 23 for a character with the trapfinding 
ability to locate). One end of the snare is tied in a
loop that contracts around one or more of the limbs of
any creature stepping inside the circle.

When triggered, the cordlike object tightens around 
the creature, dealing no damage but causing it to
be entangled.

The snare is magical. To escape, a trapped creature must 
make a DC 23 Strength check that is a full-round action. 
A successful escape from the snare breaks the loop
and ends the spell. 

Author:    Tenjac
Created:   8/9/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    object oPC = OBJECT_SELF;
    effect eAOE = EffectAreaOfEffect(VFX_PER_SNARE);
    location lLoc = PRCGetSpellTargetLocation();

    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 1.0));
    ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eAOE, lLoc);
    DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_AC_BONUS), lLoc));

    PRCSetSchool();
}