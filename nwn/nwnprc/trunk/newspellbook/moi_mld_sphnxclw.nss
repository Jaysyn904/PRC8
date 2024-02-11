/*
11/1/20 by Stratovarius

Sphinx Claws

Descriptors: Mind-Affecting  
Classes: Totemist 
Chakra: Hands (totem) 
Saving Throw: None

A powerful set of retractable, catlike claws forms over your hands. These magical claws seem almost alive, and they perfectly follow every move of your own hands and fingers.

While wearing sphinx claws, you gain a +1 competence bonus on Strength checks and Strength-based skill checks, such as Climb and Jump checks and checks made to bull rush an opponent. 

Essentia: Every point of essentia you invest in your sphinx claws increases the competence bonus by 1. 

Chakra Bind (Hands) 

Your hands become one with the claws that surround them, overlarge for your size. The most profound change, however, is in your proficiency in combat—a powerful urge grows within you to leap at your foes, tearing with claws and teeth until your prey lies motionless in your savage grip.

When you use the charge action, at the end of your charge you can make a full attack using any natural weapons you possess.

Chakra Bind (Totem)

Your hands become one with the claws that surround them, overlarge for your size. You find you can use them to tear at your foes, and with that ability comes a powerful desire to put these tools to use. Will you temper that bloodlust with the wisdom of the gynosphinx or the nobility of the androsphinx? Or will you give in to it completely, rampaging like a hieracosphinx?

You can use your sphinx claws as natural weapons that deal 1d8 points of damage plus your Strength modifier. For every point of essentia you invest in your sphinx claws, you gain a +1 enhancement bonus on your attack rolls and damage rolls with the claws. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
	int nBonus         = 1+nEssentia;
    effect eLink       = EffectLinkEffects(EffectSkillIncrease(SKILL_CLIMB, nBonus), EffectSkillIncrease(SKILL_JUMP, nBonus));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_SPHINX_CLAWS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) 
    {
        string sResRef = "prc_claw_1d8m_";
        int nSize = PRCGetCreatureSize(oMeldshaper);
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oMeldshaper, sResRef, 2); 
        SetLocalString(oMeldshaper, "IncarnumPrimaryAttackL", sResRef);
        
        // All natural attacks end up here
        if (nEssentia)
        {        
	        DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper), ItemPropertyEnhancementBonus(nEssentia), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
	        DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oMeldshaper), ItemPropertyEnhancementBonus(nEssentia), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
	    }    
    }
}