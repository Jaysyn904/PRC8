/*
   ----------------
   Recitation of Meditative State
   
   true_rec_meditat
   ----------------

   4/9/06 by Stratovarius
*/ /** @file

   Type of Feat: Recitation
   Prerequisite: Truespeak 9 ranks, levels in Truenamer class.
   Specifics: Use of this Recitation dispels most negative mental effects. You must succeed on a Truespeak check of 15 + (2 * your HD) - 2.
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
            if (GetEffectType(eFear) == EFFECT_TYPE_DAZED ||
                GetEffectType(eFear) == EFFECT_TYPE_FRIGHTENED ||
                GetEffectType(eFear) == EFFECT_TYPE_CONFUSED ||
                GetEffectType(eFear) == EFFECT_TYPE_STUNNED)
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
