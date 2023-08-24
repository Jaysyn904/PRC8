/*
   ----------------
   Heavenly Entreaty
   Brimstone Speaker level 3

   true_brim_heaven
   ----------------

   4/9/06 by Stratovarius
*/ /** @file

Type of Feat: Class
Prerequisite: Brimstone Speaker 3
Specifics: The Brimstone Speaker can shout the truenames of angelic powers, being granted their services in return. There are three versions of the Heavenly Entreaty: Lesser, which summons a Bralani Eladrin with a Truespeak DC of 27, Normal, which summons a Word Archon with a Truespeak DC of 33, and Greater, which summons an Astral Deva with a Truespeak DC of 43. This ability is affected by the Law of Resistance.
Use: Selected.
*/

#include "true_inc_trufunc"
//#include "prc_alterations"

void main()
{
    object oTrueSpeaker = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    int nSpellId = PRCGetSpellId();
    int nDC;
    string sSummon;
    if (BRIMSTONE_HEAVEN_LESSER == nSpellId)      
    {
    	nDC = 27;
    	sSummon = "true_bralan";
    }
    else if (BRIMSTONE_HEAVEN_NORMAL == nSpellId)      
    {
    	nDC = 33;
    	sSummon = "true_wordarch";
    }
    else if (BRIMSTONE_HEAVEN_GREATER == nSpellId)      
    {
    	nDC = 43;
    	sSummon = "true_deva";
    }
    // Account for the law of resistance
    nDC += GetLawOfResistanceDCIncrease(oTrueSpeaker, nSpellId);

    if(GetIsSkillSuccessful(oTrueSpeaker, SKILL_TRUESPEAK, nDC))
    {
	effect eSummon = EffectSummonCreature(sSummon, VFX_FNF_SMP_GATE, 3.0);        
        // Do Multisummon
        DelayCommand(5.0, MultisummonPreSummon());
        // Bring in the creature, one minute duration
        DelayCommand(3.0, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetLocation(oTrueSpeaker), 60.0));                
        // Increases the DC of the subsequent utterances
        DoLawOfResistanceDCIncrease(oTrueSpeaker, nSpellId);
    }// end if - Successful utterance
}