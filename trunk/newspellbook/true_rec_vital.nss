/*
   ----------------
   Recitation of Vital State
   
   true_rec_vital
   ----------------

   4/9/06 by Stratovarius
*/ /** @file

   Type of Feat: Recitation
   Prerequisite: Truespeak 9 ranks, levels in Truenamer class.
   Specifics: Use of this Recitation cleanses your body of Disease. You must succeed on a Truespeak check of 15 + (2 * your HD) - 2.
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
	effect eFear = GetFirstEffect(oTrueSpeaker);
        //Get the first effect on the current target
        while(GetIsEffectValid(eFear))
        {
            if (GetEffectType(eFear) == EFFECT_TYPE_DISEASE)
            {
                //Remove any fear effects and apply the VFX impact
                RemoveEffect(oTrueSpeaker, eFear);
            }
            //Get the next effect on the target
            eFear = GetNextEffect(oTrueSpeaker);
        }
        
        effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTrueSpeaker);
    }// end if - Successful utterance
}
