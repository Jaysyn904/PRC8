//::///////////////////////////////////////////////
//:: Name      Luminous Armor
//:: FileName  sp_lumins_armr.nss
//:://////////////////////////////////////////////
/**@file Luminous Armor
Abjuration
Level: Sactified 2
Components: Sacrifice
Casting Time: 1 standard action
Range: Touch
Target: 1 good creature touched
Duration: 1 hour/level
Saving Throw: None
Spell Resistance: Yes (harmless)

This spell, favored among eldarins visiting the
Material Plane, envelops the target in a protective,
shimmering aura of light.  The luminous armor
resembles a suit of dazzling full plate, but it is
weightless and does not restrict the target's
movement or mobility in any way.  In addition to
imparting the benefits of a breatplate (+5 armor
bonus to AC), the luminous armor has no maximum
Dexterity restriction, no armor check penalty, and
no chance for aracane spell failure.

Luminous armor sheds light equivalent to a daylight
spell and dispells darkness spells of 2nd level or
lower with which it comes into contact.  In addition,
the armor causes opponents to take a -4 penalty on
melee attacks made against the target.  This penalty
stacks with the penalty suffered by creatures
sensitive to bright light (such as dark elves).

Sacrifice: 1d2 points of Strength damage.

//::///////////////////////////////////////////////
//:: Name      Greater Luminous Armor
//:: FileName  sp_lumins_armr.nss
//:://////////////////////////////////////////////

Luminous Armor, Greater
Abjuration
Level: Sanctified 4

This spell functions like luminous armor, except
that it imparts the benefits of full plate (+8
armor bonus to AC).

Sacrifice: 1d3 points of Strength damage.

Author:    Tenjac
Created:   6/20/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;
	
    //Declare main variables.
    int nEvent = GetRunningEvent();
    object oPC;
    switch(nEvent)
    {
        case EVENT_ONHEARTBEAT:         oPC = OBJECT_SELF;               break;

        default:
            oPC = OBJECT_SELF;
    }	

    PRCSetSchool(SPELL_SCHOOL_ABJURATION);

    if(nEvent == FALSE)
    {
		
		object oTarget = PRCGetSpellTargetObject();
		int nSpell = GetSpellId();
		int nCasterLvl = PRCGetCasterLevel(oPC);
		int nAlign = GetAlignmentGoodEvil(oTarget);
		int nMetaMagic = PRCGetMetaMagicFeat();
		float fDur = HoursToSeconds(nCasterLvl);

		if(nAlign == ALIGNMENT_GOOD)
		{
			if(nMetaMagic & METAMAGIC_EXTEND)
				fDur += fDur;

			//VFX
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUPER_HEROISM), oTarget);

			//Light as a daylight spell, AoE for attack penalty
			effect eLight = EffectLinkEffects(EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
			eLight = EffectLinkEffects(eLight, EffectAreaOfEffect(AOE_MOB_LUMINOUS_ARMOR));

			int nArmor;
			int nLevel = GetLevelByClass(CLASS_TYPE_ABJURANT_CHAMPION);


			if(nSpell == SPELL_LUMINOUS_ARMOR)
			{
				nArmor = nLevel + 5;
				DoCorruptionCost(oPC, ABILITY_STRENGTH, d2(1), 0);
			}

			else if(nSpell == SPELL_GREATER_LUMINOUS_ARMOR)
			{
				nArmor = nLevel + 8;
				DoCorruptionCost(oPC, ABILITY_STRENGTH, d3(), 0);
			}

			else
			{
				return;
			}

			PRCRemoveEffectsFromSpell(oTarget, SPELL_LUMINOUS_ARMOR);
			PRCRemoveEffectsFromSpell(oTarget, SPELL_GREATER_LUMINOUS_ARMOR);
			RemoveEventScript(oPC, EVENT_ONHEARTBEAT, "sp_lumins_armr", TRUE, FALSE);

			effect eArmor = EffectACIncrease(nArmor, AC_ARMOUR_ENCHANTMENT_BONUS, AC_VS_DAMAGE_TYPE_ALL);
				   eArmor = EffectLinkEffects(eArmor, eLight);

			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eArmor, oTarget, fDur);
			object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
			if (GetBaseAC(oArmour) > 0)
			{
				ForceUnequip(oPC, oArmour, INVENTORY_SLOT_CHEST);
				SendMessageToPC(oPC, "You cannot wear armor while under the effects of Luminous Armour");          
			}    
		}
		PRCSetSchool();
		
		AddEventScript(oPC, EVENT_ONHEARTBEAT, "sp_lumins_armr", TRUE, FALSE);
		DelayCommand(fDur, RemoveEventScript(oPC, EVENT_ONHEARTBEAT, "sp_lumins_armr", TRUE, FALSE));
		//Sanctified spells get mandatory 10 pt good adjustment, regardless of switch
		AdjustAlignment(oPC, ALIGNMENT_GOOD, 10, FALSE);
	}
	else if(nEvent == EVENT_ONHEARTBEAT)
	{
		object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
		if (GetBaseAC(oArmour) > 0)
		{
			ForceUnequip(oPC, oArmour, INVENTORY_SLOT_CHEST);
			SendMessageToPC(oPC, "You cannot wear armor while under the effects of Luminous Armour");          
		} 		
	}
}