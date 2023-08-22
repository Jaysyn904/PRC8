/*
sp_sequester

Sequester

Abjuration
Level: Sor/Wiz 7 
Components: V, S, M 
Casting Time: 1 standard action 
Range: Touch 
Target: One willing creature or object (up to a 2-ft. cube/level) touched 
Duration: One day/level (D) 
Saving Throw: None or Will negates (object) 
Spell Resistance: No or Yes (object)

When cast, this spell not only prevents divination spells from working to detect or 
locate the creature or object affected by sequester, it also renders the affected 
creature or object invisible to any form of sight or seeing (as the invisibility spell). 
The spell does not prevent the subject from being discovered through tactile means or 
through the use of devices. Creatures affected by sequester become comatose and are effectively 
in a state of suspended animation until the spell wears off or is dispelled.

Note: The Will save prevents an attended or magical object from being sequestered. 
There is no save to see the sequestered creature or object or to detect it with a divination spell.

Material Component: A basilisk eyelash, gum arabic, and a dram of whitewash.

Stratovarius
*/

#include "prc_sp_func"

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nSpellID = PRCGetSpellId();
    PRCSetSchool(GetSpellSchool(nSpellID));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nMetaMagic = PRCGetMetaMagicFeat();
    // Effects (Invis)
    effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_IMPROVED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eCover = EffectConcealment(50);
    effect eLink = EffectLinkEffects(eDur, eCover);
    eLink = EffectLinkEffects(eLink, eVis);    
    eLink = EffectLinkEffects(eLink, eInvis);
    // Target also is in suspended animation
    eLink = EffectLinkEffects(eLink, EffectCutsceneParalyze());
    // 24 hours per caster level
    float fDuration = HoursToSeconds(24) * nCasterLevel;
    if(PRCGetMetaMagicFeat() & METAMAGIC_EXTEND)
        fDuration *= 2.0;
    // Make sure the target is friendly
    if (GetIsFriend(oTarget))
    {
    	//apply the effect
    	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
    }

    PRCSetSchool();
}