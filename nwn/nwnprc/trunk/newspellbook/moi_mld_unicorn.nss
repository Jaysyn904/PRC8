/*
12/1/20 by Stratovarius

Unicorn Horn

Descriptors: None  
Classes: Totemist 
Chakra: Brow (totem) 
Saving Throw: None

You shape the pure soul energy of a unicorn into an ivory-colored horn that seems to sprout from your forehead. Its color is an unblemished white, and it seems to glow with a soft blue-white radiance. Its purity flows into you, and it is difficult to conceive of an evil thought with the horn so close to your mind.

You gain a +2 competence bonus on Animal Empathy and Move Silently checks. 

Essentia: Your bonus on Animal Empathy and Move Silently checks increases by 2 for every point of invested essentia. 

Chakra Bind (Brow) 

A streak of white appears in your hair near the unicorn horn, and your eyes change color—becoming deep sea-blue, violet, or fiery gold.

You gain the ability to detect evil once per round as a standard action. 

Chakra Bind (Totem)

A tuft of white hair hangs down from your forehead around your unicorn horn, while your forehead itself thickens somewhat to support the horn it bears. All of your hair transforms into a cascading white mane, and if you are male a white beard sprouts from your chin. You can feel purity and energy flowing into your body through your horn.

You can gore with the unicorn horn as a natural weapon that deals 1d6 points of damage. You gain an enhancement bonus on attack rolls and damage rolls with your horn equal to the number of points of essentia you invest in it. If you hit an undead creature with your horn attack, you deal an extra 1d6 points of damage. 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 23:20:37
//::
//:: Double Totem Bind support added
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"

void main()  
{  
    object oMeldshaper = PRCGetSpellTargetObject();   
    int nMeldId        = PRCGetSpellId();  
    int nEssentia      = GetEssentiaInvested(oMeldshaper);  
    int nBonus         = 2 + (nEssentia * 2);  
    effect eLink       = EffectLinkEffects(EffectSkillIncrease(SKILL_ANIMAL_EMPATHY, nBonus), EffectSkillIncrease(SKILL_MOVE_SILENTLY, nBonus));  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_UNICORN_HORN), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
  
    // Brow bind (detect evil) — check regular or double Brow  
    int nBoundToBrow = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_BROW)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_BROW)) == nMeldId)  
        nBoundToBrow = TRUE;  
  
    if (nBoundToBrow)  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_UNICORN_HORN_BROW), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
  
    // Totem bind (gore attack) — check regular or double Totem  
    int nBoundToTotem = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_TOTEM)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_TOTEM)) == nMeldId)  
        nBoundToTotem = TRUE;  
  
    if (nBoundToTotem)  
    {  
        string sResRef = "prc_mino_gore_";  
        int nSize = PRCGetCreatureSize(oMeldshaper);  
        sResRef += GetAffixForSize(nSize);  
        AddNaturalPrimaryWeapon(oMeldshaper, sResRef);   
        SetLocalString(oMeldshaper, "IncarnumPrimaryAttackB", sResRef);  
          
        // All natural attacks end up here  
        if (nEssentia)  
        {  
            DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper), ItemPropertyEnhancementBonus(nEssentia), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));  
            DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper), ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_1d6), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));  
        }      
    }  
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
	int nBonus         = 2+(nEssentia*2);
    effect eLink       = EffectLinkEffects(EffectSkillIncrease(SKILL_ANIMAL_EMPATHY, nBonus), EffectSkillIncrease(SKILL_MOVE_SILENTLY, nBonus));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_UNICORN_HORN), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_BROW) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_UNICORN_HORN_BROW), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) 
    {
        string sResRef = "prc_mino_gore_";
        int nSize = PRCGetCreatureSize(oMeldshaper);
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oMeldshaper, sResRef); 
        SetLocalString(oMeldshaper, "IncarnumPrimaryAttackB", sResRef);
        
        // All natural attacks end up here
        if (nEssentia)
        {
	        DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper), ItemPropertyEnhancementBonus(nEssentia), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
	        DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper), ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_1d6), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
	    }    
    }
} */