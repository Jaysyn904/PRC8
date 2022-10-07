/*
   ----------------
   Recitation of Mindful State
   
   true_rec_mindful
   ----------------

   4/9/06 by Stratovarius
*/ /** @file

   Type of Feat: Recitation
   Prerequisite: Truespeak 9 ranks, levels in Truenamer class.
   Specifics: You gain a skill bonus equal to 1/3rd your Truenamer level on Open Lock, Disable Trap, and Craft skills. This lasts for two rounds. You must succeed on a Truespeak check of 15 + (2 * your HD) - 2.
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
        float fDur = RoundsToSeconds(2);
        int nClass = GetLevelByClass(CLASS_TYPE_TRUENAMER, oTrueSpeaker);
 	effect eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_OPEN_LOCK, nClass/3), EffectVisualEffect(VFX_DUR_HEARD));
 	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_DISABLE_TRAP, nClass/3));
 	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_CRAFT_WEAPON, nClass/3));
 	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_CRAFT_TRAP, nClass/3));
 	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_CRAFT_ARMOR, nClass/3));

        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTrueSpeaker, fDur, TRUE, PRCGetSpellId(), GetTruespeakerLevel(oTrueSpeaker));
    }// end if - Successful utterance
}
