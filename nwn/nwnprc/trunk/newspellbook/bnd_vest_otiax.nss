/*
12/03/21 by Stratovarius

Otiax, the Key to the Gate
  
The alien Otiax gives its summoners the power to open what is closed, to walk among the clouds, and to strike foes with fog that lands like a hammer.

Vestige Level: 5th
Binding DC: 25
Special Requirement: No

Influence: Otiax’s motives remain a mystery, but its influence is clear. When confronted with unopened doors or gates, you become agitated and nervous. This emotional 
state lasts until the door or gate is opened, or until you can no longer see it. Furthermore, Otiax cannot abide a lock remaining secured. Thus, whenever you see a 
key, Otiax requires that you use it to open the corresponding lock.

Granted Abilities: 
Otiax opens doors for you, lets you batter opponents with wind, and cloaks you in a protective fog that can actually lash out at foes.

Air Blast: You can focus the air around you into a concentrated blast that batters opponents. You can use your air blast as a melee touch attack against an adjacent 
opponent or one that is up to 10 feet away. This attack deals 2d6 points of bludgeoning damage, but you do not add your Strength bonus to the damage roll. If your 
base attack bonus is high enough, you might be entitled to additional air blast attacks each round when you make a full attack.

Concealing Mist: The mist that constantly surrounds you forms a screen that grants you concealment (foes’ melee and ranged attacks have a 20% miss chance).

Open Portal: At will as a swift action, you can open (but not close) an unlocked door, chest, box, or other object.

Unlock: As a full-round action, you can unlock a single lock that you can touch, provided that its Open Lock DC is less than or equal to twice your effective binder 
level. Once you have used this ability, you cannot do so again for 5 rounds.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_OBSCURING_MIST), EffectPact(oBinder));
    
    if (!GetIsVestigeExploited(oBinder, VESTIGE_OTIAX_AIR_BLAST)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_OTIAX_AIR_BLAST), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	if (!GetIsVestigeExploited(oBinder, VESTIGE_OTIAX_MIST))      eLink = EffectLinkEffects(eLink, EffectConcealment(20));
	if (!GetIsVestigeExploited(oBinder, VESTIGE_OTIAX_OPEN))      IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_OTIAX_OPEN),      HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	if (!GetIsVestigeExploited(oBinder, VESTIGE_OTIAX_UNLOCK))    IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_OTIAX_UNLOCK),    HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));     
}