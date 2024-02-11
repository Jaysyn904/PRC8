/*
1/03/21 by Stratovarius

Savnok, the Instigator
  
Once a servant of gods, Savnok now grants his summoners the ability to wear heavy armor, to draw arrows from thin air, to take the place of allies in combat, and to cause wounds that do not heal.

Vestige Level: 2nd
Binding DC: 20
Special Requirement: No

Influence: Savnok’s influence makes you headstrong and recalcitrant. Once you make up your mind about a particular issue, very little can change your thoughts on the matter. 
In addition, whenever you don armor, employ a shield, or wear any other item that improves your AC, Savnok requires that you not remove that protection for any reason.

Granted Abilities: 
Savnok grants you abilities associated with his death and the command of allies’ positions.

Call Armor: At will as a full-round action, you can summon a suit of full plate armor, which appears about your body. As you attain higher effective binder levels, the armor’s
quality improves, as given on the following table. At 5th level, it becomes +1. At 9th level, +2. At 13th level, it grants immunity to sneak attacks. At 17th level, +4. 
At 20th level, immunity to critical hits. You can dismiss the armor with another full-round action.

Heavy Armor Proficiency: You are proficient with heavy armor.

Move Ally: You can instantly swap positions with any visible willing ally within 5 feet per two effective binder levels of your position. Using this ability is a standard action
at first, though at 13th level you can use it as a swift action. Once you have used this ability, you cannot do so again for 5 rounds.

Savnok’s Armor: While wearing your called armor, you can ignore some of the damage from attacks by nonpiercing weapons. When you first gain the ability to summon Savnok, 
this ability gives you damage reduction 1/piercing, and the value improves by +1 for every four effective binder levels you possess.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_SAVNOK);
    
    // If she gets influence, you can't unequip armor and shields
    if (!GetLocalInt(oBinder, "PactQuality"+IntToString(VESTIGE_SAVNOK))) FloatingTextStringOnCreature("You have made a poor pact, and Savnok enjoins you from removing armor!", oBinder, FALSE);        

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_PROT_IRON_SKIN), EffectPact(oBinder));
    if (!GetIsVestigeExploited(oBinder, VESTIGE_SAVNOK_CALL_ARMOR)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_SAVNOK_CALL), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    
    // We get this with the Practiced Binder feat
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder) || GetHasFeat(FEAT_PRACTICED_BINDER, oBinder))
    {
        //eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SLASHING,    1+(nBinderLevel/4)));
        //eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 1+(nBinderLevel/4)));		
    }	
	
    // Binders only down here
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder)) 
    {
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_SAVNOK_HEAVY_ARMOR_PROF)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_ARMOR_PROF_HEAVY), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_SAVNOK_MOVE_ALLY)) 
    	{
    		if (nBinderLevel >= 13) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_SAVNOK_MOVE_SW), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    		else                    IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_SAVNOK_MOVE_ST), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    	
    	}	
    }	
    
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}