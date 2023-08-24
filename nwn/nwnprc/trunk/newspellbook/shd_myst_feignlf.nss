/*
16/02/19 by Stratovarius

Feign Life

Initiate, Dark Reflections 
Level/School: 5th/Transmutation 
Range: Medium (100 ft. + 10 ft./level) 
Target: One Huge or Gargantaun object 
Duration: 1 round/level 

You infuse an object with shadowstuff, causing it to animate at your command.

This mystery summons a huge animated object, increasing to garguantuan at 16th caster level. The item summoned grows dark and warped, becoming more sharp-edged and appearing 
slightly worn or decayed for the duration of the effect. In addition, an object animated by this mystery benefit from concealment.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_EXTEND);

    if(myst.bCanMyst)
    {
        location lTarget = PRCGetSpellTargetLocation();
        myst.fDur = RoundsToSeconds(myst.nShadowcasterLevel);
        if(myst.bExtend) myst.fDur *= 2;
        
        string sResRef = "prc_shd_animhuge";
        if (myst.nShadowcasterLevel >= 16)
            sResRef = "prc_shd_animgarg";  
            
        MultisummonPreSummon();            

        // Create Summon
        myst.eLink = EffectSummonCreature(sResRef, VFX_FNF_SUMMON_NATURES_ALLY_1);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, myst.eLink, lTarget, myst.fDur);
    }
}