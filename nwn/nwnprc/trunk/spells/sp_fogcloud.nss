//////////////////////////////////////////////////////////////////
//  Fog Cloud
//  sp_fogcloud
//////////////////////////////////////////////////////////////////
/** @file Conjuration (Creation)
Level:  Drd 2, Sor/Wiz 2, Water 2
Components:     V, S
Casting Time:   1 standard action
Range:  Medium (100 ft. + 10 ft. level)
Effect:         Fog spreads in 20-ft. radius, 20 ft. high
Duration:       10 min./level
Saving Throw:   None
Spell Resistance:       No

A bank of fog billows out from the point you designate. The fog obscures all sight, 
including darkvision, beyond 5 feet. A creature within 5 feet has concealment 
(attacks have a 20% miss chance). Creatures farther away have total concealment 
(50% miss chance, and the attacker can’t use sight to locate the target). 
*/
////////////////////////////////////////////////////////////////////

#include "prc_inc_spells"
#include "true_utter_const"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    object oPC = OBJECT_SELF;
    location lLoc = PRCGetSpellTargetLocation();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDur = TurnsToSeconds(nCasterLvl) * 10;
    //Enter Metamagic conditions
    if (nMetaMagic & METAMAGIC_EXTEND)
    {
       fDur = fDur *2; //Duration is +100%
    }

    effect eAoE = EffectAreaOfEffect(AOE_PER_FOG_VOID_CLOUD);

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAoE, lLoc, fDur);

    PRCSetSchool();
}