//::////////////////////////////////////////////////////////  
//::	Name	Allegro  
//::	FileName	sp_allegro.nss  
//::////////////////////////////////////////////////////////  
/**@file Allegro  
Transmutation  
Level: Bard 3  
Components: V, S, M  
Casting Time: 1 swift action  
Range: 20 ft.  
Area: 20-ft.-radius burst centered on you  
Duration: 1 minute/level  
Saving Throw: Fortitude negates (harmless)  
Spell Resistance: Yes (harmless)  
  
With a quick wiggle of your fingers and a few arcane words,  
you release the feather in your hand to complete the spell.  
Suddenly, translucent blue motes burst outward from you  
and collect on yourself and your nearby allies before  
fading away.  
  
Each creature within the spell's area gains a 30-foot  
enhancement bonus to its land speed, up to a maximum of  
double the creature's land speed. Affected creatures  
retain these effects for the duration of the spell,  
even if they leave the original area.  
  
Material Component: A tail feather from a bird of prey.  
*/  
//::////////////////////////////////////////////////////////  
//::	Created by: Jaysyn  
//::	Date:	2026-11-05 10:07:38  
//::////////////////////////////////////////////////////////  
#include "prc_inc_spells"  
  
void main()  
{  
    if (!X2PreSpellCastCode()) return;  
  
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);  
  
    object oCaster      = OBJECT_SELF;  
    int    nCasterLvl   = PRCGetCasterLevel(oCaster);  
    int    nMetaMagic   = PRCGetMetaMagicFeat();  
    float  fDur         = MinutesToSeconds(nCasterLvl);  
    location lLoc       = GetLocation(oCaster);  
  
    if (nMetaMagic & METAMAGIC_EXTEND)  
        fDur += fDur;  
  
    // +30 ft enhancement to land speed, capped at double base speed.  
    // NWN models this as a 100% movement speed increase.  
    effect eSpeed = EffectMovementSpeedIncrease(100);  
    effect eVis   = EffectVisualEffect(VFX_IMP_HASTE);  
  
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lLoc, TRUE, OBJECT_TYPE_CREATURE);  
  
    while (GetIsObjectValid(oTarget))  
    {  
        if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))  
        {  
            // Harmless: no save/SR enforcement needed for allies  
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpeed, oTarget, fDur, TRUE, PRCGetSpellId(), nCasterLvl);  
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);  
        }  
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lLoc, TRUE, OBJECT_TYPE_CREATURE);  
    }  
  
    PRCSetSchool();  
}


