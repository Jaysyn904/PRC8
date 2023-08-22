//::///////////////////////////////////////////////
//:: Name      Solid Fog
//:: FileName  sp_solid_fog.nss
//:://////////////////////////////////////////////
/**@file Solid Fog
Conjuration (Creation)
Level: Sor/Wiz 4, Hexblade 4
Components: V, S, M
Duration: 1 min./level
Spell Resistance: No

This spell functions like fog cloud, but in addition
to obscuring sight, the solid fog is so thick that 
any creature attempting to move through it progresses
at a speed of 5 feet, regardless of its normal speed,
and it takes a -2 penalty on all melee attack and 
melee damage rolls. The vapors prevent effective 
ranged weapon attacks (except for magic rays and the
like). A creature or object that falls into solid fog
is slowed, so that each 10 feet of vapor that it 
passes through reduces falling damage by 1d6. A 
creature can’t take a 5-foot step while in solid fog.

However, unlike normal fog, only a severe wind 
(31+ mph) disperses these vapors, and it does so in 
1 round.

Solid fog can be made permanent with a permanency 
spell. A permanent solid fog dispersed by wind 
reforms in 10 minutes.

Material Component: A pinch of dried, powdered peas 
                    combined with powdered animal hoof.
**/

///////////////////////////////////////////////////////
// Author: Tenjac
// Date:   17.9.06
//////////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    object oPC = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCasterLevel = PRCGetCasterLevel(oPC);
    float fDur = 60.0f * nCasterLevel;

    if(nMetaMagic & METAMAGIC_EXTEND)
        fDur += fDur;

    effect eAOE = EffectAreaOfEffect(AOE_PER_SOLID_FOG, "sp_solid_fogA", "", "sp_solid_fogB");

    // Duration Effects
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDur);

    object oAoE = GetAreaOfEffectObject(lTarget, "AOE_PER_SOLID_FOG");
    SetAllAoEInts(SPELL_SOLID_FOG, oAoE, 20, 0, nCasterLevel);

    PRCSetSchool();
}