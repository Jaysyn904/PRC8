//::///////////////////////////////////////////////
//:: Name:          Saint template maintain script
//:: FileName:		tmp_m_saint.nss
//:: 
//:: Created By: 	Jaysyn & Ebonfowl
//:: Created On: 	22/06/04
//:://////////////////////////////////////////////
/*CREATING A SAINT
"Saint" is an acquired template that can be added to any living creature of good alignment that is not an outsider or an elemental (referred to hereafter as the "base creature").

Size and Type: The creature's type changes to "outsider." The saint has the native subtype. Size is unchanged.

Armor Class: A saint gains an insight bonus to AC equal to the character's Wisdom bonus.

Special Attacks: A saint retains all the character's special attacks and gains those listed below.

Holy Power (Su): The save DCs of any and all of the saint's special attacks, including spells as well as spell-like, supernatural, and extraordinary abilities, increase by +2.

Holy Touch (Su): A saint's entire being is suffused with holy power, which likewise flows into any weapon the saint wields. A saint's melee attacks with any weapon (or unarmed) deal an additional 1d6 points of holy damage against evil creatures, and 1d8 points against evil undead and evil outsiders. Any evil creature that strikes a saint with a natural weapon takes holy damage as if hit by the saint's attack.

Spell-Like Abilities: At will - guidance, resistance, virtue, and bless. A saint's caster level is equal to its Hit Die total. The save DCs are Charisma-based.

Special Qualities: A saint retains all the character's special qualities and gains those listed below, as well as the outsider type.

Damage Reduction (Ex): Saints gain damage reduction according to their Hit Dice (including character level).
HD		Damage Reduction
1-3		-
4-7		5/magic
8-11	5/evil
12+		10/evil

If the base creature already has damage reduction, use the better value.

Fast Healing (Ex): Each round, a saint heals damage equal to half of its Hit Dice (including character levels, to a maximum of 10 points healed). If the base creature already has fast healing, use the better value.

Immunities (Ex): A saint is immune to acid, cold, electricity, and petrification attacks.

Keen Vision (Ex): Saints have low-light vision and 60-foot darkvision.

Protective Aura (Su): As a free action, a saint can surround herself with a nimbus of light having a radius of 20 feet. This acts as a double-strength magic circle against evil and as a lesser globe of invulnerability both as cast by a cleric whose level equal to the saint's Hit Dice.

Resistances (Ex): Saints have resistance to fire 10 and receive a +4 racial bonus on Fortitude saves against poison.

Tongues (Su): A saint can speak with any creature that has a language, as though using a tongues spell cast by a 14th-level cleric. This ability is always active.

Abilities: Modify the base creature as follows: Con +2, Wis +2, Cha +4.

Alignment: Saints are always good-aligned.

Level Adjustment: Same as base creature +2.
*/
//:://////////////////////////////////////////////

#include "prc_inc_template"
#include "prc_inc_natweap"
#include "prc_inc_combat"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("tmp_m_saint running, event: " + IntToString(nEvent));

//:: Get the PC. This is event-dependent
    object oPC;
    switch(nEvent)
    {
		case EVENT_ONHIT:          		oPC = OBJECT_SELF;               break;
        //case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;
        //case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;

        default:
            oPC = OBJECT_SELF;
    }

//:: Declare major variables
    int iHD = GetHitDice(oPC);
	int iWISb = GetAbilityModifier(4, oPC);
	object oItem;
	object oSkin = GetPCSkin(oPC);
	itemproperty ipIP;

//:: Not being called from an event but from EvalPRCFeats.  No non-good Saints.
    if(nEvent == FALSE && GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
    {
	//:: Any living creature of good alignment that is not an or an elemental (removed outsider check as Saints are outsiders)
		int nRace = MyPRCGetRacialType(oPC);
		if(!(nRace == RACIAL_TYPE_CONSTRUCT ||
			   nRace == RACIAL_TYPE_ELEMENTAL ||
			   nRace == RACIAL_TYPE_OOZE ||
			   nRace == RACIAL_TYPE_UNDEAD))
		{
		//:: Add Darkvision
			ipIP = ItemPropertyDarkvision();
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
		
		//:: Add Low-Light Vision
			ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_LOWLIGHT_VISION);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);		
		
		//:: Wisdom based AC bonus
			SetCompositeBonus(oSkin, "Template_Saint_AC", iWISb, ITEM_PROPERTY_AC_BONUS);

		//:: Hit Die based Damage Reduction
			if (iHD >= 12) 
			{
				ipIP = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5, IP_CONST_DAMAGESOAK_10_HP);
				IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);		
			}
		
			else if (iHD >= 8) 
			{
				ipIP = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5, IP_CONST_DAMAGESOAK_5_HP);
				IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);		
			}
	
			else if (iHD >= 4) 
			{
				ipIP = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_5_HP);
				IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
			}
	
			else if (iHD <= 3) {/*:: you get nothing! */}			
		
		//:: Set HD based Fast Healing
		//ebonfowl: I think this is supposed to be HD/2 to a max of 10
			int nFastHealing = iHD/2;
			if (nFastHealing > 10) {nFastHealing == 10;}	
			SetCompositeBonus(oSkin, "Template_Saint_FastHealing", nFastHealing, ITEM_PROPERTY_REGENERATION);		
		
		//:: Set racial type to Outsider (Native)
			ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_OUTSIDER_RACIAL_TYPE);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
			SetSubRace(oPC, "Outsider (Native)");

		//:: Set Acid Immunity	
			ipIP = ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_ACID,IP_CONST_DAMAGEIMMUNITY_100_PERCENT);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

		
		//:: Set Cold Immunity	
			ipIP = ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEIMMUNITY_100_PERCENT);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

		
		//:: Set Electrical Immunity		
			ipIP = ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGEIMMUNITY_100_PERCENT);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
		
		
		//:: +4 Save vs. Poison
			ipIP = ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_POISON, 4);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);


		//:: Resistance to Fire 10
			ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_10);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);		

		
		//:: Set Petrification Immunity (has to be done per spell, thanks Bioware!)
			ipIP = ItemPropertySpellImmunitySpecific(216);  //:: Flesh to Stone		
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
			ipIP = ItemPropertySpellImmunitySpecific(218);  //:: Breath, Petrify		
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);	
			ipIP = ItemPropertySpellImmunitySpecific(219);  //:: Touch, Petrify		
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
			ipIP = ItemPropertySpellImmunitySpecific(220);  //:: Gaze, Petrify		
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);	
			ipIP = ItemPropertySpellImmunitySpecific(235);  //:: Stonehold		
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);			
			ipIP = ItemPropertySpellImmunitySpecific(244);  //:: Audience of Stone		
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
			ipIP = ItemPropertySpellImmunitySpecific(245);  //:: Crystalize		
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
			ipIP = ItemPropertySpellImmunitySpecific(246);  //:: Basilisk Mask		
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
			ipIP = ItemPropertySpellImmunitySpecific(247);	//:: Gorgon Mask		
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);	

		//:: Set Immunity to Petrification (maybe this will work?)
			effect ePetrificationImmunity = EffectBonusFeat(FEAT_IMMUNE_PETRIFICATION);
			
			ipIP = PRCItemPropertyBonusFeat(FEAT_IMMUNE_PETRIFICATION);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);			
	
		//:: Set Ability Score Bonuses
			SetCompositeBonus(oSkin, "Template_Saint_con", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON);
			SetCompositeBonus(oSkin, "Template_Saint_int", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_INT);
			SetCompositeBonus(oSkin, "Template_Saint_wis", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_WIS);
			SetCompositeBonus(oSkin, "Template_Saint_cha", 4, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);		
		
		//:: Setup Spell-like abilities & Holy Power marker feat
			ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_SAINT_SLA_BLESS);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

			//ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_SAINT_SLA_GUIDANCE);
			//IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);		

			ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_SAINT_SLA_RESISTANCE);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

			ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_SAINT_SLA_VIRTUE);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);	

			ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_SAINT_PROTECTIVE_AURA);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
			
			ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_SAINT_HOLY_POWER);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

		//:: Setup Holy Touch anti-evil damage shield.		
			itemproperty iHolyTouch = (ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1));
			object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
			if (GetIsObjectValid(oArmor))
			{
				//:: Add item prop with DURATION_TYPE_PERMANENT
				IPSafeAddItemProperty(oArmor, iHolyTouch, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
			}
			else
			{
				IPSafeAddItemProperty(oSkin, iHolyTouch, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
			}

		//:: Keep property on current armor or hide
			ExecuteScript ("prc_keep_onhit_a", oPC);		

		//:: Setup Holy Touch extra damage vs evil
			object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
			
			effect eEffect1 = VersusAlignmentEffect(EffectDamageIncrease(7, DAMAGE_TYPE_DIVINE), 0, ALIGNMENT_EVIL);
			effect eEffect2 = VersusAlignmentEffect(EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE), 0, ALIGNMENT_EVIL);
				   eEffect2 = VersusRacialTypeEffect(eEffect2, RACIAL_TYPE_OUTSIDER);
			effect eEffect3 = VersusAlignmentEffect(EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE), 0, ALIGNMENT_EVIL);
				   eEffect3 = VersusRacialTypeEffect(eEffect3, RACIAL_TYPE_UNDEAD);
			effect eLink = EffectLinkEffects(eEffect1, eEffect2);
				   eLink = EffectLinkEffects(eLink, eEffect3);
				   eLink = EffectLinkEffects(eLink, ePetrificationImmunity);
				   eLink = SupernaturalEffect(eLink);
				   eLink = TagEffect(eLink, "EffectHolyTouch");

		//:: Clear the effect to be safe and prevent stacking
			effect eCheckEffect = GetFirstEffect(oPC);
				
			while (GetIsEffectValid(eCheckEffect))
			{
				if (GetEffectTag(eCheckEffect) == "EffectHolyTouch")
				{
					RemoveEffect(oPC, eCheckEffect);
				
				}
				
			eCheckEffect = GetNextEffect(oPC);
			
			}

		//ebonfowl: this needed to be moved outside the while loop
		//:: check if equipped with a ranged weapon and apply effect again if not
			if (!GetWeaponRanged(oItem))
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
		
	
		//:: Hook in the events for Holy Touch
			if(DEBUG) DoDebug("tmp_m_saint: Adding eventhooks");
			//AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,	"tmp_m_saint", TRUE, FALSE);
			//AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM,	"tmp_m_saint", TRUE, FALSE);
			AddEventScript(oPC, EVENT_ONHIT,				"tmp_m_saint", TRUE, FALSE);
		
		}
	}
	
//:: We're being called from the OnHit eventhook
    else if(nEvent == EVENT_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("tmp_m_saint: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );
		effect eDam;
        
		//:: If enemy is evil
		if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
		{
			//:: And unarmed
			if (!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget)) &&
                !GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget)))
			{
				//:: And outsider or undead
				if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER ||
					MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
				{
					eDam = EffectDamage(d8(1), DAMAGE_TYPE_DIVINE);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
				}
				else
				{
					eDam = EffectDamage(d6(1), DAMAGE_TYPE_DIVINE);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
				}
			}
		}
    }
//:: END IF - Running OnHit event	
}