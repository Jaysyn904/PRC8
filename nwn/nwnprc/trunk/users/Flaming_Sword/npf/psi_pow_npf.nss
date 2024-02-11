/*
   ----------------
   Null Psionics Field

   psi_pow_npf
   ----------------

   6/10/05 by Stratovarius
*/ /** @file

    Null Psionics Field

    Psychokinesis
    Level: Kineticist 6
    Manifesting Time: 1 standard action
    Range: 10 ft.
    Area: 10-ft.-radius emanation centered on you
    Duration: 10 min./level(D)
    Saving Throw: None
    Power Resistance: See text
    Power Points: 11
    Metapsionics: Extend, Widen
    
    An invisible barrier surrounds you and moves with you. The space within this 
    barrier is impervious to most psionic effects, including powers, psi-like 
    abilities, and supernatural abilities. Likewise, it prevents the functioning 
    of any psionic items or powers within its confines. A null psionics field 
    negates any power or psionic effect used within, brought into, or manifested 
    into its area.
    
    Dispel psionics does not remove the field. Two or more null psionics fields 
    sharing any of the same space have no effect on each other. Certain powers 
    may be unaffected by null psionics field (see the individual power 
    descriptions).
    
    
    Implementation note: To dismiss the power, use the control feat again. If 
                         the power is active, that will end it instead of 
                         manifesting it.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

int PresenceCheck(object oManifester);

void main()
{
    object oManifester = OBJECT_SELF;
    
    // Check if NPF is already active on the manifester
    if(PresenceCheck(oManifester))
    {
        PRCRemoveSpellEffects(POWER_NULL_PSIONICS_FIELD, oManifester, oManifester);
        return;
    }

    // Psihook
    if(!PsiPrePowerCastCode()) return;

    
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(),
                              METAPSIONIC_EXTEND | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nAoEIndex   = manif.bWiden ? AOE_PER_NULL_PSIONICS_FIELD_WIDENED : AOE_PER_NULL_PSIONICS_FIELD;
        float fDuration = 600.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;
        
        // Apply the AoE effect
        effect eAOE = EffectAreaOfEffect(nAoEIndex);
        // This power is not dispellable
               eAOE = ExtraordinaryEffect(eAOE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDuration);
        /* Probably not necessary
        // Get an object reference to the newly created AoE
        location lTarget = GetLocation(oTarget);
        object oAoE = GetFirstObjectInShape(SHAPE_SPHERE, 1.0f, lTarget, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
        while(GetIsObjectValid(oAoE))
        {
            // Test if we found the correct AoE
            if(GetTag(oAoE) == Get2DACache("vfx_persistent", "LABEL", nAoEIndex) &&
               !GetLocalInt(oAoE, "PRC_NullPsionicsField_Inited")
               )
            {
                break;
            }
            // Didn't find, get next
            oAoE = GetNextObjectInShape(SHAPE_SPHERE, 1.0f, lTarget, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
        }
        SetLocalInt(oAoE, "PRC_NullPsionicsField_Inited", TRUE);
        */
    }// end if - Successfull manifestation
}

int PresenceCheck(object oManifester)
{
    effect eTest = GetFirstEffect(oManifester);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectSpellId(eTest) == POWER_NULL_PSIONICS_FIELD &&
           GetEffectType(eTest) == EFFECT_TYPE_AREA_OF_EFFECT   &&
           GetEffectCreator(eTest) == oManifester
           )
            return TRUE;
    
        eTest = GetNextEffect(oManifester);
    }
    
    return FALSE;
}
