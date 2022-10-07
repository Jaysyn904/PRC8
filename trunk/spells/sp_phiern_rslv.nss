//::///////////////////////////////////////////////
//:: Name      Phieran's Resolve
//:: FileName  sp_phiern_rslv.nss
//:://////////////////////////////////////////////
/**@file Phieran's Resolve
Abjuration [Good] 
Level: Sanctified 3 
Components: V, S, DF 
Casting Time: 1 standard action 
Range: 20 ft.
Targets: One good creature/level in a 20-ft. radius
burst centered on you 
Duration: 1 minute/level
Saving Throw: Will negates (harmless) 
Spell Resistance: Yes (harmless) 

Phieran's resolve (named after the exalted patron of
suffering, endurance, and perseverance) was devised
to combat wielders of vile magic. This spell grants 
targets a +4 sacred bonus on saving throws against
spells with the evil descriptor.

Sacrifice: 1d3 points of Strength damage.

Author:    Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ABJURATION);

    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDur = TurnsToSeconds(nCasterLevel);
    effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MAJOR);

    if(nMetaMagic & METAMAGIC_EXTEND)
        fDur *= 2;

    //Signal spell cast at event
    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_PHIERANS_RESOLVE, FALSE));

    //only apply vfx here to indicate that spell is active
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDur);

    DoCorruptionCost(oCaster, ABILITY_STRENGTH, d3(), 0);

    //Sanctified spells get mandatory 10 pt good adjustment, regardless of switch
    AdjustAlignment(oCaster, ALIGNMENT_GOOD, 10, FALSE);

    PRCSetSchool();
}