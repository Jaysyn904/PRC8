/*
   ----------------
   Syllable of Dissolution
   Bereft level 4

   true_bft_dissol
   ----------------

   19/7/06 by Stratovarius
*/ /** @file

Type of Feat: Class
Prerequisite: Bereft 4
Specifics: When the Bereft successfully speak this syllable, the target takes 8d6 damage.
Use: Selected.
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
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, 
                                               oTarget, 
                                               METAUTTERANCE_NONE/* Use METAUTTERANCE_NONE if it has no Metautterance usable*/, 
                                               LEXICON_EVOLVING_MIND /* Uses the same DC formula*/);

    if(utter.bCanUtter)
    {
        // This is done so Speak Unto the Masses can read it out of the structure
        utter.nPen       = GetTrueSpeakPenetration(oTrueSpeaker);

	// If the Spell Penetration fails, don't apply any effects
        if (!PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen))
        {
       		// Damage
       		utter.eLink = EffectLinkEffects(EffectDamage(d6(8)), EffectVisualEffect(VFX_IMP_SHILLELAGH));
        }
        // If either of these ApplyEffect isn't needed, delete it.
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, utter.eLink, oTarget);

        // Mark for the Law of Sequence. This only happens if the power succeeds, which is why its down here.
        DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}
