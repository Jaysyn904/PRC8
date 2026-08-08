/*
3/1/20 by Stratovarius

Dread Carapace

Descriptors: None 
Classes: Totemist 
Chakra: Arms, feet, heart (totem)
Saving Throw: See text

Incarnum forms into a heavy, caramel-brown carapace covering your back. Short spines protrude from this shell, and light gleams from its surface. 
Though it has no actual protective value (unless you bind it to your heart chakra), the carapace fills you with the destructive power of the tarrasque.

While your dread carapace is shaped, you gain a +2 bonus on damage rolls when you are using a bite attack, or a +1 bonus when you are using a claw or other natural attack. 
In exchange, you take a –1 penalty on attack rolls with natural weapons. 

Essentia: Every point of essentia you invest in your dread carapace increases your attack penalty by 1 and your damage bonus by 2 (for bite attacks) or 1 (for other natural weapons). 

Chakra Bind (Arms) 

While the appearance of your dread carapace is unchanged, your upper arms manifest scaly plates, while spikes emerge from your elbows. At the same time, any natural weapons you possess become 
more deadly—sharper, longer, better able to slice through skin and armor to tear at vulnerable flesh.

The threat range of any natural attacks you possess (either naturally or as a result of another soulmeld) is doubled.

Chakra Bind (Feet)

While the appearance of your dread carapace is unchanged, your legs become increasingly muscular, and their shape alters slightly so that you more naturally move on just your toes and the balls of your feet.

Once per minute, you can add an enhancement bonus of +60 feet to your speed for 1 round.

Chakra Bind (Heart) 

Your dread carapace takes on a highly reflective sheen, suggesting the tarrasque’s ability to reflect spells back on their casters. Spells have a hard time reaching through your carapace to affect you.

You gain spell resistance equal to 5 + 4 per point of essentia you invest in your dread carapace.

Chakra Bind (Totem) 

Two mighty horns jut from your head. Though they are useless in combat, they alter your appearance, making your countenance quite fearsome. 
When you charge, your visage suggests something utterly inhuman, striking fear into the hearts of your foes.

When you charge, all enemies within 60 feet who can see you become shaken for 1 round (Will negates).
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-21 00:30:44
//::
//:: Double Totem Bind support added
//:: Double Chakra Bind support added here and in
//:: moi_events, prcsp_engine & prc_inc_combmove
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"
void main()  
{  
    object oMeldshaper = PRCGetSpellTargetObject();   
    int nMeldId        = PRCGetSpellId();  
    int nEssentia      = GetEssentiaInvested(oMeldshaper);  
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_DREAD_CARAPACE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);

    // Feet bind (speed boost) — check regular or double Feet  
    int nBoundToFeet = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_FEET)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_FEET)) == nMeldId)  
        nBoundToFeet = TRUE;  
  
    if (nBoundToFeet)  
    {  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_DREAD_CARAPACE_FEET), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
    }  
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_DREAD_CARAPACE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_FEET) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_DREAD_CARAPACE_FEET), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
} */