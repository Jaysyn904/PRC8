/*
1/03/21 by Stratovarius

Haagenti, Mother of Minotaurs
  
Haagenti tricked the god of frost giants and paid a terrible price for that deed. She girds her summoners for battle and gives them the power to confuse foes.

Vestige Level: 2nd
Binding DC: 17
Special Requirement: To summon Haagenti, you must be Large.

Influence: You feel ashamed and occasionally bashful in the presence of beautiful creatures. In addition, Haagenti requires that you give deference to any 
creature you perceive as more attractive or charismatic than yourself. This deference might take the form of a bow, a salute, opening a door for the creature
in question, not speaking until spoken to, or any other gesture that acknowledges the creature as superior to you. In any case, you must constantly treat any 
such creature with respect or suffer the penalty for defying Haagenti’s influence.

Granted Abilities: 
Haagenti grants you some of Thrym’s skill with arms and armor, plus her own aversion to transformation and the ability to inflict a state of confusion upon others.

Confusing Touch: You can confuse by touch. The target of your touch attack must succeed on a Will save or become confused for 1 round per three effective binder 
levels you possess. When you attain an effective binder level of 19th, this ability functions as a maze spell. Once you have used this ability, 
you cannot do so again for 5 rounds.

Immunity to Transformation: No mortal magic can permanently affect your form while you are bound to Haagenti. You are immune to polymorph and petrification effects.

Shield Proficiency: You are proficient with shields, including tower shields.

Weapon Proficiency: You are proficient with the battleaxe, greataxe, handaxe, and throwing axe.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CHILL_SHIELD), EffectPact(oBinder));
    
    // We get this with the Practiced Binder feat
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder) || GetHasFeat(FEAT_PRACTICED_BINDER, oBinder))
    {
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_HAAGENTI_WEAPON_PROF)) 
    	{
			IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_BATTLEAXE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
			IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_GREATAXE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
			IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_HANDAXE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
			IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_THROWING_AXE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		}	
    }	
	
    // Binders only down here
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder)) 
    {
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_HAAGENTI_SHIELD_PROF)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_SHIELD_PROFICIENCY), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_HAAGENTI_CONFUSE)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_HAAGENTI_TOUCH), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }	
    
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}