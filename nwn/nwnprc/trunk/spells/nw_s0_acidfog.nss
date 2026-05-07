//::///////////////////////////////////////////////
//:: Acid Fog
//:: NW_S0_AcidFog.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Acid Fog
Conjuration (Creation) [Acid]
Level:            Sor/Wiz 6, Water 7
Components:       V, S, M/DF
Casting Time:     1 standard action
Range:            Medium (100 ft. + 10 ft./level)
Effect:           Fog spreads in 20-ft. radius, 20 ft. high
Duration:         1 round/level
Saving Throw:     None
Spell Resistance: No

Acid fog creates a billowing mass of misty vapors
similar to that produced by a solid fog spell. In
addition to slowing creatures down and obscuring
sight, this spell’s vapors are highly acidic. Each
round on your turn, starting when you cast the
spell, the fog deals 2d6 points of acid damage to
each creature and object within it.

Arcane Material Component
A pinch of dried, powdered peas combined with
powdered animal hoof.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 20, 2001

//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables including Area of Effect Object
    location lTarget = PRCGetSpellTargetLocation();
    int CasterLvl = PRCGetCasterLevel();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDuration = CasterLvl / 2;
    if(nDuration < 1) nDuration = 1;
    if(nMetaMagic & METAMAGIC_EXTEND)
       nDuration *= 2;
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGACID);
    effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_ACID);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));

    object oAoE = GetAreaOfEffectObject(lTarget, "VFX_PER_FOGACID");
    SetAllAoEInts(SPELL_ACID_FOG, oAoE, PRCGetSpellSaveDC(SPELL_ACID_FOG, SPELL_SCHOOL_CONJURATION), 0, CasterLvl);
    SetLocalInt(oAoE, "Acid_Fog_Damage", ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_ACID));
	SetLocalObject(oAoE, "ExtraordinarySpellAim_Caster", OBJECT_SELF);

    PRCSetSchool();
}