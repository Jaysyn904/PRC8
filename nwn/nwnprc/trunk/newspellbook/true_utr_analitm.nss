/*
    ----------------
    Analyze Item

    true_utr_analitm
    ----------------

    5/8/06 by Stratovarius
*/ /** @file

    Analyze Item

    Level: Crafted Tool 2
    Range: Touch
    Target: One Object
    Duration: Instantaneous
    Spell Resistance: No
    Metautterances: No

    By studying an item, you can determine a great deal about it, including its magical properties, if any.
    You identify the target object.
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
    oTarget             = CraftedToolTarget(oTrueSpeaker, oTarget);
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, METAUTTERANCE_NONE, LEXICON_CRAFTED_TOOL);

    if(utter.bCanUtter)
    {
        SetIdentified(oTarget, TRUE);
        // eLink2 is used for Impact Effects (Damage)
        utter.eLink2 = EffectVisualEffect(VFX_IMP_FAERIE_FIRE);

        // Impact Effects
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, utter.eLink2, oTarget);

    }// end if - Successful utterance
}
