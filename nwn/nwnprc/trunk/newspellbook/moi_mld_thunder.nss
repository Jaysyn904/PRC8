/*
12/1/20 by Stratovarius

Thunderstep Boots

Descriptors: Sonic 
Classes: Soulborn 
Chakra: Feet
Saving Throw: See text

You shape incarnum into a pair of heavy boots that fit over your feet and any other boots you might wear. Cobalt steel forms rings around your calves and reinforces the toes of the boots.

When you charge, your thunderstep boots channel sonic energy into your attack. If you hit with a melee attack at the end of a charge, the target takes an additional 1d4 points of sonic damage. 

Essentia: Every point of essentia you invest in your thunderstep boots increases the damage dealt by 1d4 points. 

Chakra Bind (Feet)

Your thunderstep boots bind themselves to your feet.

Any creature taking damage from your thunderstep boots is also stunned for 1 round. A successful Fortitude save negates this effect. 
*/
#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_THUNDERSTEP_BOOTS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
}