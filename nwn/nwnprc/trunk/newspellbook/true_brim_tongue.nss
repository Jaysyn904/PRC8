/*
   ----------------
   Tongue of Fire
   Brimstone Speaker level 1

   true_brim_tongue
   ----------------

   19/7/06 by Stratovarius
*/ /** @file

Type of Feat: Class
Prerequisite: Brimstone Speaker 1
Specifics: The Brimstone Speaker can speak a truename that translates as "tongue of fire". This ability allows them to create a line of fire 20 feet long. Those hit by the fire have a DC vs 10 + Class levels + Con modifier. There are three versions of the Tongue of Fire: 3d6 with a Truespeak DC of 25, 5d6 with a DC of 30, and 8d6 with a DC of 35. This ability is affected by the Law of Resistance.
Use: Selected.
*/

#include "true_inc_trufunc"
//#include "prc_alterations"

float GetVFXLength(location lTrueSpeaker, float fLength, float fAngle);

void main()
{
    object oTrueSpeaker = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    int nSpellId = PRCGetSpellId();
    int nDC;
    int nDamage;
    if (BRIMSTONE_FIRE_3D6 == nSpellId)      
    {
    	nDC = 25;
    	nDamage = d6(3);
    }
    else if (BRIMSTONE_FIRE_5D6 == nSpellId)      
    {
    	nDC = 30;
    	nDamage = d6(5);
    }
    else if (BRIMSTONE_FIRE_8D6 == nSpellId)      
    {
    	nDC = 35;
    	nDamage = d6(8);
    }
    
    //Account for Energy Draconic Aura
    if (GetLocalInt(oTrueSpeaker, "FireEnergyAura") > 0)
    {
        nDC += GetLocalInt(oTrueSpeaker, "FireEnergyAura");
    }
    
    // Account for the law of resistance
    nDC += GetLawOfResistanceDCIncrease(oTrueSpeaker, nSpellId);

    if(GetIsSkillSuccessful(oTrueSpeaker, SKILL_TRUESPEAK, nDC))
    {
        int nSaveDC = 10 + GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER, oTrueSpeaker) + GetAbilityModifier(ABILITY_CONSTITUTION, oTrueSpeaker);
        // Increases the DC of the subsequent utterances
        DoLawOfResistanceDCIncrease(oTrueSpeaker, nSpellId);
        
	location lTrueSpeaker = GetLocation(oTrueSpeaker);
        location lTarget     = PRCGetSpellTargetLocation();
        vector vOrigin       = GetPosition(oTrueSpeaker);
        float fLength        = FeetToMeters(20.0f);
        float fDelay;

        // Do VFX. This is moderately heavy, so it isn't duplicated by Twin Power
        float fAngle             = GetRelativeAngleBetweenLocations(lTrueSpeaker, lTarget);
        float fSpiralStartRadius = FeetToMeters(1.0f);
        float fRadius            = FeetToMeters(5.0f);
        float fDuration          = 4.5f;
        float fVFXLength         = GetVFXLength(lTrueSpeaker, fLength, GetRelativeAngleBetweenLocations(lTrueSpeaker, lTarget));
        // A tube of beams, radius 5ft, starting 1m from TrueSpeaker and running for the length of the line
        BeamGengon(DURATION_TYPE_TEMPORARY, VFX_BEAM_FIRE, lTrueSpeaker, fRadius, fRadius,
                   1.0f, fVFXLength, // Start 1m from the TrueSpeaker, end at LOS end
                   8, // 8 sides
                   fDuration, "prc_invisobj",
                   0.0f, // Drawn instantly
                   0.0f, 0.0f, 45.0f, "y", fAngle, 0.0f,
                   -1, -1, 0.0f, 1.0f, // No secondary VFX
                   fDuration
                   );
        // A spiral inside the tube, starting from the TrueSpeaker with with radius 1ft and ending with radius 5ft at the end of the line
        BeamPolygonalSpring(DURATION_TYPE_TEMPORARY, VFX_BEAM_FIRE, lTrueSpeaker, fSpiralStartRadius, fRadius,
                            0.0f, fVFXLength, // Start at the TrueSpeaker, end at LOS end
                            5, // 5 sides per revolution
                            fDuration, "prc_invisobj",
                            fVFXLength / 5, // Revolution per 5 meters
                            0.0f, // Drawn instantly
                            0.0f, "y", fAngle, 0.0f,
                            -1, -1, 0.0f, 1.0f, // No secondary VFX
                            fDuration
                            ); 
                            
	    oTarget = MyFirstObjectInShape(SHAPE_SPELLCYLINDER, fLength, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
            while(GetIsObjectValid(oTarget))
            {
                if(oTarget != oTrueSpeaker &&
                   spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oTrueSpeaker)
                   )
                {
                    // Let the AI know
                    SignalEvent(oTarget, EventSpellCastAt(oTrueSpeaker, nSpellId));
                    
			nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nSaveDC, SAVING_THROW_TYPE_FIRE);
			if(nDamage > 0)
			{
			    float fDelay = GetDistanceBetweenLocations(lTrueSpeaker, GetLocation(oTarget)) / 20.0f;
			    effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
			    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
			    DelayCommand(1.0f + fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
			    DelayCommand(1.0f + fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        		}
                }// end if - Target validity check

               // Get next target
                oTarget = MyNextObjectInShape(SHAPE_SPELLCYLINDER, fLength, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
            }                            
    }// end if - Successful utterance
}

float GetVFXLength(location lTrueSpeaker, float fLength, float fAngle)
{
    float fLowerBound = 0.0f;
    float fUpperBound = fLength;
    float fVFXLength  = fLength / 2;
    vector vVFXOrigin = GetPositionFromLocation(lTrueSpeaker);
    vector vAngle     = AngleToVector(fAngle);
    vector vVFXEnd;
    int bConverged    = FALSE;
    while(!bConverged)
    {
        // Create the test vector for this loop
        vVFXEnd = vVFXOrigin + (fVFXLength * vAngle);

        // Determine which bound to move.
        if(LineOfSightVector(vVFXOrigin, vVFXEnd))
            fLowerBound = fVFXLength;
        else
            fUpperBound = fVFXLength;

        // Get the new middle point
        fVFXLength = (fUpperBound + fLowerBound) / 2;

        // Check if the locations have converged
        if(fabs(fUpperBound - fLowerBound) < 2.5f)
            bConverged = TRUE;
    }

    return fVFXLength;
}