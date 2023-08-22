/*
   ----------------
   Knock, Psionic

   psi_pow_knock
   ----------------

   7//11/04 by Stratovarius
*/ /** @file

    Knock, Psionic

    Psychoportation
    Level: Psion/wilder 2
    Manifesting Time: 1 standard action
    Area: 50m -radius burst centered on you
    Duration: Instantaneous; see text
    Saving Throw: None
    Power Resistance: No
    Power Points: 3
    Metapsionics: Widen

   When you manifest this power, you open all locks in the area.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

void main()
{
/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/

    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oManifester = OBJECT_SELF;
    struct manifestation manif =
        EvaluateManifestation(oManifester, OBJECT_INVALID,
                              PowerAugmentationProfile(),
                              METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nResistFlag;
        effect eVis      = EffectVisualEffect(VFX_IMP_KNOCK);
        float fDelay;
        float fRadius    = EvaluateWidenPower(manif, 50.0f);
        location lTarget = PRCGetSpellTargetLocation();

        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        while(GetIsObjectValid(oTarget))
        {
            // Let the AI know
            SignalEvent(oTarget, EventSpellCastAt(oManifester, SPELL_KNOCK));
            fDelay = PRCGetRandomDelay(0.5, 2.5);

            if(!GetPlotFlag(oTarget) && GetLocked(oTarget))
    	    {
    	        nResistFlag = GetDoorFlag(oTarget,DOOR_FLAG_RESIST_KNOCK);
    	        if(nResistFlag == 0)
    	        {
    	            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    	            AssignCommand(oTarget, ActionUnlockObject(oTarget));
    	        }
    	        else if(nResistFlag == 1)
    	        {
    	            FloatingTextStrRefOnCreature(83887, oManifester);  // "* Failure! - Door unaffected by magic *"
    	        }
    	    }// end if - Target is locked and not plot
    	    oTarget = MyNextObjectInShape(SHAPE_SPHERE,fRadius, lTarget, FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);

        }// end while - Target loop
    }// end if - Successfull manifestation
}
