/*
31/12/19 by Stratovarius

Bloodtalons

Descriptors: None 
Classes: Totemist 
Chakra: Hands (totem)
Saving Throw: None

Incarnum forms a pair of eagle talons around your hands. They are ghostly and insubstantial, almost like a violet mist surrounding your hands, but the three-toed shape is as clear as the sharp claws in their outline.

Totemists who shape bloodtalons hope to emulate the ferocious tenacity, keen eyesight, and sheer savagery of these creatures. You gain the Diehard feat.

Essentia: Every point of essentia invested increases your Spot skill by 2 points. 

Chakra Bind (Hands) 

Rather than being surrounded by violet mist, your hands themselves turn a deep shade of violet, like the blue of incarnum mixed with rich blood red. Somehow, your hands feel eager to grasp and tear, to speed past your opponents’ defenses and tear at their eyes.

You gain the benefit of the Weapon Finesse feat.

Chakra Bind (Totem) 

The skin of your hands becomes red-orange and scaly like the talons of a blood hawk, your fingers grow knobby and strong, and your nails lengthen into fierce talons with sharp points and edges.

You can make two claw attacks that each deal 1d4 points of damage plus your Strength modifier. On the round after you hit with a claw attack, the wounds bleed for an additional 1 point of damage per point of essentia you had invested in your bloodtalons when you made the attack. Nonliving creatures are immune to this blood loss effect. Every point of essentia invested in the bloodtalons grants a +1 enhancement bonus on attack rolls made with the claw attacks.
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 13:51:40
//::
//:: Double Chakra Bind support added
//:: Double Totem bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"

void BloodtalonsTotem(object oMeldshaper, int nEssentia)
{
	IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper), ItemPropertyAttackBonus(nEssentia), 99999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
	IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper), ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	AddEventScript(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper), EVENT_ITEM_ONHIT, "moi_events", TRUE, FALSE);
	IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oMeldshaper), ItemPropertyAttackBonus(nEssentia), 99999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
	IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oMeldshaper), ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	AddEventScript(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oMeldshaper), EVENT_ITEM_ONHIT, "moi_events", TRUE, FALSE);
}

void main()  
{  
    object oMeldshaper = PRCGetSpellTargetObject();   
    int nMeldId        = PRCGetSpellId();  
    int nEssentia      = GetEssentiaInvested(oMeldshaper);  
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);  
  
    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SPOT, nEssentia*2));  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BLOODTALONS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_DIEHARD), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
      
    // Hands bind (Weapon Finesse) — check regular or double Hands  
    int nBoundToHands = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_HANDS)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_HANDS)) == nMeldId)  
        nBoundToHands = TRUE;  
  
    if (nBoundToHands)  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FINESSE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
      
    // Totem bind (claws) — check regular or double Totem  
    int nBoundToTotem = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_TOTEM)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_TOTEM)) == nMeldId)  
        nBoundToTotem = TRUE;  
  
    if (nBoundToTotem)  
    {  
        string sResRef = "prc_claw_1d6l_";  
        int nSize = PRCGetCreatureSize(oMeldshaper);  
        sResRef += GetAffixForSize(nSize);  
        AddNaturalPrimaryWeapon(oMeldshaper, sResRef, 2);   
        SetLocalString(oMeldshaper, "IncarnumPrimaryAttackL", sResRef);  
        SetLocalInt(oMeldshaper, "ClearEventTotem", TRUE);  
          
        // All natural attacks end up here  
        DelayCommand(3.0, BloodtalonsTotem(oMeldshaper, nEssentia));  
    }  
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SPOT, nEssentia*2));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BLOODTALONS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_DIEHARD), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_HANDS) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FINESSE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) 
    {
        string sResRef = "prc_claw_1d6l_";
        int nSize = PRCGetCreatureSize(oMeldshaper);
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oMeldshaper, sResRef, 2); 
        SetLocalString(oMeldshaper, "IncarnumPrimaryAttackL", sResRef);
        SetLocalInt(oMeldshaper, "ClearEventTotem", TRUE);
        
        // All natural attacks end up here
        DelayCommand(3.0, BloodtalonsTotem(oMeldshaper, nEssentia));
    }
} */