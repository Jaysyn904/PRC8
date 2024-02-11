//::///////////////////////////////////////////////
//:: Name      Sleet Storm On Enter
//:: FileName  sp_sleet_stormA.nss
//:://////////////////////////////////////////////
/**@file Sleet Storm

Conjuration (Creation) [Cold]
Level: Drd 3, Sor/Wiz 3 
Components: V, S, M/DF 
Casting Time: 1 standard action 
Range: Long (400 ft. + 40 ft./level) 
Area: Cylinder (40-ft. radius, 20 ft. high) 
Duration: 1 round/level 
Saving Throw: None 
Spell Resistance: No

Driving sleet blocks all sight (even darkvision) 
within it and causes the ground in the area to be
icy. A creature can walk within or through the 
area of sleet at half normal speed with a DC 10 
Balance check. Failure means it can’t move in that
round, while failure by 5 or more means it falls 
(see the Balance skill for details).

The sleet extinguishes torches and small fires.

Arcane Material Component: A pinch of dust and a 
few drops of water.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    object oPC = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    effect eLink = EffectLinkEffects(EffectBlindness(), EffectMovementSpeedDecrease(50));

    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f, TRUE, SPELL_SLEET_STORM, nCasterLvl);

    PRCSetSchool();
}
