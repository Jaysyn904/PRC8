/*
   ----------------
   Child of Night Blur

   shd_child_blur.nss
   ----------------

   You blur (20% concealment)
   
   27.02.19 by Stratovarius
*/

#include "shd_inc_shdfunc"

void main()
{
        // Set up some data
        object oShadow = OBJECT_SELF;
        int nChild = GetLevelByClass(CLASS_TYPE_CHILD_OF_NIGHT);
        int nBlur = 20;
        float fDuration = TurnsToSeconds(nChild);
        if (nChild >= 10)
        {
            nBlur = 50;
            fDuration = 60.0; 
        }    
        effect eDur = SupernaturalEffect(EffectLinkEffects(EffectVisualEffect(PSI_DUR_SHADOW_BODY), EffectConcealment(nBlur)));
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oShadow, fDuration, FALSE);
}