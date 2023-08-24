//::///////////////////////////////////////////////
//:: Name      Repulsion
//:: FileName  sp_repulsion.nss
//:://////////////////////////////////////////////7
/** @file Repulsion
Abjuration
Level: 	Clr 7, Protection 7, Sor/Wiz 6
Components: 	V, S, F/DF
Casting Time: 	1 standard action
Range: 	Up to 10 ft./level
Area: 	Up to 10-ft.-radius/level emanation centered on you
Duration: 	1 round/level (D)
Saving Throw: 	Will negates
Spell Resistance: 	Yes

An invisible, mobile field surrounds you and prevents
creatures from approaching you. You decide how big 
the field is at the time of casting (to the limit 
your level allows). Any creature within or entering 
the field must attempt a save. If it fails, it becomes 
unable to move toward you for the duration of the 
spell. Repelled creatures’ actions are not otherwise 
restricted.

They can fight other creatures and can cast spells and 
attack you with ranged weapons. If you move closer to 
an affected creature, nothing happens. (The creature is
not forced back.) The creature is free to make melee 
attacks against you if you come within reach. If a 
repelled creature moves away from you and then tries to
turn back toward you, it cannot move any closer if it 
is still within the spell’s area.

Arcane Focus: A pair of small iron bars attached to two
small canine statuettes, one black and one white, the 
whole array worth 50 gp. 
**/
//////////////////////////////////////////////////////
// Author: Tenjac
// Date:   7.10.06
//////////////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ABJURATION);

    object oPC = OBJECT_SELF;
    effect eAoE = EffectAreaOfEffect(AOE_PER_REPULSION);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    float fDur = RoundsToSeconds(nCasterLvl);
    effect ePulse = EffectVisualEffect(266);

    if(nMetaMagic & METAMAGIC_EXTEND)
    {
        fDur += fDur;
    }

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, ePulse, GetLocation(OBJECT_SELF));
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAoE, oPC, fDur);

    object oAoE = GetAreaOfEffectObject(GetLocation(OBJECT_SELF), "AOE_PER_REPULSION");
    SetAllAoEInts(SPELL_REPULSION, oAoE, PRCGetSpellSaveDC(SPELL_REPULSION, SPELL_SCHOOL_ABJURATION), 0, nCasterLvl);

    PRCSetSchool();
}