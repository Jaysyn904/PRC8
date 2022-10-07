/*
   ----------------
   Recitation of the Fortified State
   
   true_rec_fort
   ----------------

   4/9/06 by Stratovarius
*/ /** @file

   Type of Feat: Recitation
   Prerequisite: Truespeak 9 ranks, levels in Truenamer class.
   Specifics: You gain a natural armour bonus equal to 1/3rd your Truenamer level. This lasts for one round. You must succeed on a Truespeak check of 15 + (2 * your HD) - 2.
   Use: Selected.
*/

#include "true_inc_trufunc"
#include "true_utterhook"
//#include "prc_alterations"

void main()
{
    object oTrueSpeaker = OBJECT_SELF;
    int nDC = GetRecitationDC(oTrueSpeaker);

    if(GetIsSkillSuccessful(oTrueSpeaker, SKILL_TRUESPEAK, nDC))
    {
        // Effects
        float fDur = RoundsToSeconds(1);
        int nClass = GetLevelByClass(CLASS_TYPE_TRUENAMER, oTrueSpeaker);
 	effect eLink = EffectLinkEffects(EffectACIncrease(nClass/3, AC_NATURAL_BONUS), EffectVisualEffect(VFX_DUR_SHIELD_OF_FAITH));

        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTrueSpeaker, fDur, TRUE, PRCGetSpellId(), GetTruespeakerLevel(oTrueSpeaker));
    }// end if - Successful utterance
}
