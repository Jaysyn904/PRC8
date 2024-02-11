/*
   ----------------
   Thwart the Traveler

   true_utr_twrttrv
   ----------------

    2/9/06 by Stratovarius
*/ /** @file

    Thwart the Traveler

    Level: Perfected Map 3
    Range: 100 feet
    Area: 20' Radius
    Duration: 1 Minute
    Spell Resistance: No
    Save: None
    Metautterances: Extend

    The air grows thick and heavy, making extradimensional travel impossible.
    The area is affected as if by the Dimensional Lock spell.
*/

#include "true_inc_trufunc"
#include "true_utterhook"
//#include "prc_alterations"

void main()
{
/*
  Spellcast Hook Code
  Added 2006-7-19 by Stratovarius
  If you want to make changes to all utterances
  check true_utterhook to find out more

*/

    if (!TruePreUtterCastCode())
    {
    // If code within the PreUtterCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oTrueSpeaker = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, METAUTTERANCE_EXTEND, LEXICON_PERFECTED_MAP);

    if(utter.bCanUtter)
    {
        // This is done so Speak Unto the Masses can read it out of the structure
        utter.fDur       = RoundsToSeconds(10);
        if(utter.bExtend) utter.fDur *= 2;
        location lTarget = PRCGetSpellTargetLocation();
        
        // Spawn invisible caster object
        object oApplyObject = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lTarget);

        // Store data on it
        SetLocalObject(oApplyObject, "PRC_Spell_DimLock_Caster", oTrueSpeaker);
        SetLocalLocation(oApplyObject, "PRC_Spell_DimLock_Target", lTarget);
        SetLocalInt(oApplyObject, "PRC_Spell_DimLock_SpellPenetr", GetTrueSpeakPenetration(oTrueSpeaker));
        SetLocalFloat(oApplyObject, "PRC_Spell_DimLock_Duration", utter.fDur);

        // Assign commands
        AssignCommand(oApplyObject, DelayCommand(utter.fDur, DestroyObject(oApplyObject)));        
        
       	// Create the AoE
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(VFX_PER_20_FT_INVIS, "sp_dimens_lock_a", "sp_dimens_lock_b", "sp_dimens_lock_c"), lTarget, utter.fDur);

        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}
