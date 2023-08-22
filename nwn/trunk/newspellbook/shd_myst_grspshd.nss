/*
12/12/19 by Stratovarius

Grasping Shadows

Master, Shadowscape
Level/School: 7th/Conjuration (Creation)
Range: Medium (100 ft. + 10 ft./level)
Area/Target: 20-ft.-radius spread
Duration: 1 round/level
Saving Throw: Will partial
Spell Resistance: See text

Stalks of shadows burst from the ground, as though desperate to escape the bonds of the earth, and immediately flail at everyone nearby.

This mystery creates an area of grasping tendrils that function as the spell Evard's black tentacles (PH 228), with one additional hazard: 
Anyone successfully grappled by a tentacle must attempt a Will save or go blind. A successful save means the individual is safe from blinding
during that particular grapple, but if she escapes and is then regrappled, she must make another saving throw. The blindness is permanent until magically cured.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, (METASHADOW_EXTEND | METASHADOW_EMPOWER | METASHADOW_MAXIMIZE));

    if(myst.bCanMyst)
    {
        location lTarget = PRCGetSpellTargetLocation();
        myst.fDur = 6.0 * myst.nShadowcasterLevel;
        if(myst.bExtend) myst.fDur *= 2;   
        
        // Create AoE
        myst.eLink = EffectAreaOfEffect(AOE_PER_EVARDS_BLACK_TENTACLES, "shd_myst_grpshda", "shd_myst_grpshdc", "shd_myst_grpshdb");
        if (myst.bIgnoreSR) myst.eLink = SupernaturalEffect(myst.eLink);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, myst.eLink, lTarget, myst.fDur);                
    }
}