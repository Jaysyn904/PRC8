/*
10/1/20 by Stratovarius

Planar Ward

Descriptors: None  
Classes: Incarnate 
Chakra: Throat 
Saving Throw: See text

You shape incarnum into an amulet bound tight to your throat by a slender blue chain. The amulet itself resembles a large blue sapphire carved into the shape of a scarab beetle holding a solar disk between its front legs.

You become immune to charm and compulsion spells.

Essentia: The planar ward provides a morale bonus on saves made to resist extraplanar creatures. The bonus is equal to the number of points of essentia invested in the soulmeld.

Chakra Bind (Throat) 

Your planar ward takes the form of a glowing blue orb embedded in the base of your throat. When an extraplanar creature strikes you, the orb flares with blue light, enveloping the attacker for an instant.

Whenever you are struck by an extraplanar creature, the attacking creature must succeed on a Will save or be driven back to its home plane. The creature adds its Hit Dice as a bonus on its saving throw, and you add your meldshaper level to the planar ward’s save DC. A successful save renders the creature immune to this effect. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    
    if (nEssentia) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(VersusRacialTypeEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, nEssentia), RACIAL_TYPE_OUTSIDER)), oMeldshaper, 9999.0);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_PLANAR_WARD), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
}