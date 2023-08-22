/*
04/02/21 by Stratovarius

Naberius, the Grinning Hound
  
A cunning and mysterious vestige, Naberius can make his summoners adept with all manner of arts and sciences, disguise them, and make them cogent speakers.

Vestige Level: 1st
Binding DC: 15
Special Requirement: Naberius values knowledge, industry, and the willingness to deceive. He manifests only for a summoner with at least 4 ranks in Bluff or in Lore.

Influence: While you are influenced by Naberius, you love the sound of your own voice and are constantly pleased by your cleverness. 
Whenever you are presented with a pulpit, a stage, a talking stick, or any other place or object designed to give a speaker the floor, 
Naberius requires that you immediately seize the opportunity to speak. Any topic will do, but since Naberius resents others taking control 
of the discourse, he requires that you either shout them down or mock them. 

Granted Abilities: 
Naberius grants you the power to wear any face, swiftly regain lost ability points, use skills of which you have no knowledge, and talk your way through danger.

Disguise Self: You can alter the appearance of your form as a standard action. This effect works like the disguise self spell.

Faster Ability Healing: You heal 1 point in each damaged ability score every round, and 1 point in all drained ability scores every hour.

Naberius’s Skills: At the time you make your pact, you can choose a number of skills equal to your Constitution bonus (if any). 
Your choices must be skills in which you have no ranks. For the duration of the binding, you can make skill checks with your chosen 
skills even though you are untrained. If your Constitution modifier decreases after you make the pact, you lose the ability to make 
untrained checks with an equal number of the chosen skills. Lost skills are chosen randomly, and they remain inaccessible to you until you make another pact with Naberius.

Persuasive Words: You can direct a verbal command at a single living target within 30 feet as if using the command spell. 
A successful Will save negates the effect. When your effective binder level reaches 14th, your words become even more persuasive and this ability functions like the suggestion spell. Once you have used this ability, you cannot do so again for 5 rounds.

Silver Tongue: You can take 10 on Diplomacy and Bluff checks even if distracted or threatened. In addition, you can 
make a rushed Diplomacy check as a standard action and take no penalty. (Normally, a rushed Diplomacy check requires a full-round action and imposes a –10 penalty on the check.)
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE_SILENT), EffectPact(oBinder));
    
    if (!GetIsVestigeExploited(oBinder, VESTIGE_NABERIUS_SKILLS))
    {
		// Naberius's Skills
    	int i;
    	for(i = 0; i < 40 ; i++)
    	{
    	    if(GetLocalInt(oBinder, "NaberiusSkill"+IntToString(i))) 
    	    {
				eLink = EffectLinkEffects(eLink, EffectSkillIncrease(i, 4));
				FloatingTextStringOnCreature("Naberius's Skill is "+IntToString(i), oBinder, FALSE);
    	    }
    	}     
    }	
    
    // We get this with the Practiced Binder feat
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder) || GetHasFeat(FEAT_PRACTICED_BINDER, oBinder))
    {
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_NABERIUS_SILVER_TONGUE))
    	{
			eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_BLUFF, 4));
			eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_PERSUADE, 4));
		}	
    }	
	
    // Binders only down here
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder)) 
    {
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_NABERIUS_DISGUISE_SELF)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_NABERIUS_DISGUISE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_NABERIUS_PERSUASIVE)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_NABERIUS_COMMAND), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }	
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}