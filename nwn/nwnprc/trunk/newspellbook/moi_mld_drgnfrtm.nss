/*
1/2/21 by Stratovarius

Dragonfire Mask

Descriptors: Draconic, Fire
Classes: Totemist
Chakra: Brow, throat (totem)
Saving Throw: See text

Chakra Bind (Totem)

The dragon head becomes a solid blue mask, forming a hollow shape that completely encloses your head at a distance. Fire still trails from its eyes and open mouth.

You can emanate an aura of frightful presence once per round as a swift action. All creatures within 10 feet with fewer Hit Dice than you become shaken for 1 round. 
A successful Will save negates the effect and renders the creature immune to the frightful presence of this soulmeld for 24 hours. For every point of essentia you 
have invested in your dragonfire mask, the radius of the frightful presence increases by 10 feet, and its duration increases by 1 round. 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 23:42:43
//::
//:: Double Totem Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"

void main()  
{  
    object oMeldshaper = OBJECT_SELF;  
    int nMeldId = MELD_DRAGONFIRE_MASK;  
  
    // Check if bound to Totem chakra (regular or double)  
    int nBoundToTotem = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_TOTEM)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_TOTEM)) == nMeldId)  
        nBoundToTotem = TRUE;  
  
    if (!nBoundToTotem) return;  
  
    if(!TakeSwiftAction(oMeldshaper)) return;  
  
    // Do Frightful Presence  
    effect eShaken   = SupernaturalEffect(EffectShaken());  
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_DRAGONFIRE_MASK);  
      
    float nDist     = 10.0 + (10.0 * nEssentia);  
    float fRadius   = FeetToMeters(nDist);  
    float fDuration = RoundsToSeconds(1+nEssentia);  
  
    int nPCHitDice   = GetHitDice(oMeldshaper);	  
    int nDC = GetMeldshaperDC(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_DRAGONFIRE_MASK);  
    int nTargetHitDice;  
    int bDoVFX = FALSE;  
      
    // The object ID for enforcing the 24h rule  
    string sPCOid = ObjectToString(oMeldshaper);  
      
    // Loop over creatures in range  
    location lTarget = GetLocation(oMeldshaper);  
    object oTarget   = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE);  
    while (GetIsObjectValid(oTarget))  
    {  
        // Target validity check  
        if(oTarget != oMeldshaper                                     && // Can't affect self  
           !GetLocalInt(oTarget, "DragonfireMask_SavedVs" + sPCOid)   && // Hasn't saved successfully against this samurai's Frightful Presence in the last 24h  
           spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oMeldshaper) && // Only hostiles  
           nPCHitDice > GetHitDice(oTarget)) // Must have greater hit dice to affect the creature  
        {  
            // Set the marker that tells we tried to affect someone  
            bDoVFX = TRUE;  
      
            // Let the target know something hostile happened  
            SignalEvent(oTarget, EventSpellCastAt(oMeldshaper, -1, TRUE));  
      
            // Will save  
            if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR, oMeldshaper) &&  
               !GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR, oMeldshaper))  // Explicit immunity check, because of the fucking stupid BW immunity handling  
            {  
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShaken, oTarget, fDuration);  
            }  
            // Successfull save, set marker and queue marker deletion  
            else  
            {  
                SetLocalInt(oTarget, "DragonfireMask_SavedVs" + sPCOid, TRUE);  
      
                // Add variable deletion to the target's queue. That way, if the samurai logs out, it will still get cleared  
                AssignCommand(oTarget, DelayCommand(HoursToSeconds(24), DeleteLocalInt(oTarget, "DragonfireMask_SavedVs" + sPCOid)));  
            }  
        }// end if - Target validity check  
      
        // Get next target in area  
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE);  
    }// end while - Loop over creatures in 30ft area  
  
    // If we tried to affect someone, do war cry VFX  
    if(bDoVFX)  
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(GetGender(oMeldshaper) == GENDER_FEMALE ? VFX_FNF_HOWL_WAR_CRY_FEMALE : VFX_FNF_HOWL_WAR_CRY), oMeldshaper);  
}


/* void main()
{
	object oMeldshaper = OBJECT_SELF;
	if(!TakeSwiftAction(oMeldshaper)) return;

    // Do Frightful Presence
	effect eShaken   = SupernaturalEffect(EffectShaken());
	int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_DRAGONFIRE_MASK);
	
	float nDist     = 10.0 + (10.0 * nEssentia);
	float fRadius   = FeetToMeters(nDist);
	float fDuration = RoundsToSeconds(1+nEssentia);

	int nPCHitDice   = GetHitDice(oMeldshaper);	
	int nDC = GetMeldshaperDC(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_DRAGONFIRE_MASK);
	int nTargetHitDice;
	int bDoVFX = FALSE;
	
	// The object ID for enforcing the 24h rule
	string sPCOid = ObjectToString(oMeldshaper);
	
	// Loop over creatures in range
	location lTarget = GetLocation(oMeldshaper);
	object oTarget   = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE);
	while (GetIsObjectValid(oTarget))
	{
	    // Target validity check
	    if(oTarget != oMeldshaper                                     && // Can't affect self
	       !GetLocalInt(oTarget, "DragonfireMask_SavedVs" + sPCOid)   && // Hasn't saved successfully against this samurai's Frightful Presence in the last 24h
	       spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oMeldshaper) && // Only hostiles
	       nPCHitDice > GetHitDice(oTarget)) // Must have greater hit dice to affect the creature
	    {
	        // Set the marker that tells we tried to affect someone
	        bDoVFX = TRUE;
	
	        // Let the target know something hostile happened
	        SignalEvent(oTarget, EventSpellCastAt(oMeldshaper, -1, TRUE));
	
	        // Will save
	        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR, oMeldshaper) &&
	           !GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR, oMeldshaper))  // Explicit immunity check, because of the fucking stupid BW immunity handling
	        {
	            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShaken, oTarget, fDuration);
	        }
	        // Successfull save, set marker and queue marker deletion
	        else
	        {
	            SetLocalInt(oTarget, "DragonfireMask_SavedVs" + sPCOid, TRUE);
	
	            // Add variable deletion to the target's queue. That way, if the samurai logs out, it will still get cleared
	            AssignCommand(oTarget, DelayCommand(HoursToSeconds(24), DeleteLocalInt(oTarget, "DragonfireMask_SavedVs" + sPCOid)));
	        }
	    }// end if - Target validity check
	
	    // Get next target in area
	    oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE);
	}// end while - Loop over creatures in 30ft area

	// If we tried to affect someone, do war cry VFX
	if(bDoVFX)
	    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(GetGender(oMeldshaper) == GENDER_FEMALE ? VFX_FNF_HOWL_WAR_CRY_FEMALE : VFX_FNF_HOWL_WAR_CRY), oMeldshaper);
}


 */