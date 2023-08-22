//::///////////////////////////////////////////////
//:: Tensor's Transformation
//:: NW_S0_TensTrans.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the caster the following bonuses:
        +1 Attack per 2 levels
        +4 Natural AC
        20 STR and DEX and CON
        1d6 Bonus HP per level
        +5 on Fortitude Saves
        -10 Intelligence
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 26, 2001
//:://////////////////////////////////////////////
//: Sep2002: losing hit-points won't get rid of the rest of the bonuses

//:: modified by mr_bumpkin  Dec 4, 2003
//:: modified by motu99 Apr 3, 2007

/*
PnP TT:
Tenser's Transformation
Transmutation
Level: Sor/Wiz 6
Components: V, S, M
Casting Time: 1 action
Range: Personal
Target: You
Duration: 1 round/level
You become a virtual fighting machine—
stronger, tougher, faster, and more skilled
in combat. Your mind-set changes so that
you relish combat and you can’t cast spells,
even from magic items.
You gain 1d6 temporary hit points per
caster level, a +4 natural armor bonus to
AC, a +2d4 Strength enhancement bonus,
a +2d4 Dexterity enhancement bonus, a +1
base attack bonus per two caster levels
(which may give you an extra attack), a +5
competence bonus on Fortitude saves, and
proficiency with all simple and martial
weapons. You attack opponents with
melee or ranged weapons if you can, even
resorting to unarmed attacks if that’s all
you can do.
Material Component: A potion of bull’s
strength, which you drink (and whose
effects are subsumed by the spell effects).
*/
#include "prc_inc_spells"  



#include "prc_alterations"
#include "x2_inc_shifter"

#include "pnp_shft_poly"
#include "prc_inc_combat"


/*
int CalculateAttackBonus(object oPC)
{
   int iBAB = GetBaseAttackBonus(oPC);
   int iHD = GetHitDice(oPC);
   int iBonus = (iHD > 20) ? ((20 + (iHD - 19) / 2) - iBAB) : (iHD - iBAB); // most confusing line ever. :)

   return (iBonus > 0) ? iBonus : 0;
}
*/

// this is used for PnP Tenser's in order to ensure that we attack anything in our sight
// and to turn off that behavior (and restore # attacks), when spell has ended
void PnPTensTransPseudoHB()
{
//	object oPC = OBJECT_SELF;
	if (DEBUG) DoDebug("entered PnPTensTransPseudoHB");

	// if we don't have the spell effect any more, do clean up
    if(!GetHasSpellEffect(SPELL_TENSERS_TRANSFORMATION))
    {
        //remove IPs for simple + martial weapon prof
        object oSkin = GetPCSkin(OBJECT_SELF);
        int nSimple;
        int nMartial;
        itemproperty ipTest = GetFirstItemProperty(oSkin);
        while(GetIsItemPropertyValid(ipTest))
        {
            if(!nSimple
                && GetItemPropertyType(ipTest) == ITEM_PROPERTY_BONUS_FEAT
                && GetItemPropertyDurationType(ipTest) == DURATION_TYPE_TEMPORARY
                && GetItemPropertyCostTableValue(ipTest) == IP_CONST_FEAT_WEAPON_PROF_SIMPLE)
            {
                RemoveItemProperty(oSkin, ipTest);
                nSimple = TRUE;
            }
            if(!nMartial
                && GetItemPropertyType(ipTest) == ITEM_PROPERTY_BONUS_FEAT
                && GetItemPropertyDurationType(ipTest) == DURATION_TYPE_TEMPORARY
                && GetItemPropertyCostTableValue(ipTest) == IP_CONST_FEAT_WEAPON_PROF_MARTIAL)
            {
                RemoveItemProperty(oSkin, ipTest);
                nMartial = TRUE;
            }
            ipTest = GetNextItemProperty(oSkin);
        }
		// motu99: added this, to facilitate logic in prc_bab_caller
//		DeleteLocalInt(OBJECT_SELF, "AttackCount_TensersTrans");
		DeleteLocalInt(OBJECT_SELF, "CasterLvl_TensersTrans");
		
		// now execute prc_bab_caller to set the base attack count to normal again
		ExecuteScript("prc_bab_caller", OBJECT_SELF);

        //end the pseudoHB
        return;
    }

	// the spell is still active: make sure that we attack everything in sight
    if(GetCurrentAction() != ACTION_ATTACKOBJECT)
    {
//DoDebug("PnPTensTransPseudoHB: not attacking, look for enemies to attack");
		// look for any living enemies
        object oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
            REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1,
                CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN_AND_HEARD,
                    CREATURE_TYPE_IS_ALIVE, TRUE);

		// if we find a living enemy, we will attack it, otherwise don't bother
		if (GetIsObjectValid(oTarget) && !GetIsDead(oTarget))
		{
//DoDebug("PnPTensTransPseudoHB: found living enemy - clear all actions and attack it");
			// stop anything we have been doing
			ClearAllActions();

			// if we don't yet have a weapon equipped (unless we are unarmed with a creature weapon equipped or a monk)
			// we equip the most damaging ranged or melee weapon, depending on the distance to our enemies
			object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
			if(	(	!GetIsObjectValid(oWeapon) && !GetIsUnarmedFighter(OBJECT_SELF) )
				||	GetBaseItemType(oWeapon) == BASE_ITEM_TORCH)
			{
//DoDebug("PnPTensTransPseudoHB: no weapon equipped, equip most damaging weapon");
				if(GetDistanceToObject(oTarget) > 10.0)
				{
					ActionEquipMostDamagingRanged(oTarget);
				}
				else
				{
					int nTwoWeapon;
					if(GetHasFeat(FEAT_AMBIDEXTERITY))
						nTwoWeapon++;
					if(GetHasFeat(FEAT_TWO_WEAPON_FIGHTING))
						nTwoWeapon++;
					if(GetHasFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING))
						nTwoWeapon++;
					ActionEquipMostDamagingMelee(oTarget, nTwoWeapon);
				}
			}
			// now attack the enemy
			ActionAttack(oTarget);
		}
    }
    // do the pseudo heart beat again in 6 seconds, continue as long as spell lasts
	DelayCommand(6.0, PnPTensTransPseudoHB());
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

	// check if we should the PnP version
    if(GetPRCSwitch(PRC_PNP_TENSERS_TRANSFORMATION))
    {
		// motu99: shouldn't this already have been checked before?
		// in any case it will prevent casting a second tenser's while the first is still running
		// (because no spell casting at all is allowed for a creature who has PnP tenser's on it)
        if (!X2PreSpellCastCode())
        {
            return;
        }

        //Declare major variables
		object oTarget = PRCGetSpellTargetObject();
		object oSkin = GetPCSkin(oTarget);

        int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
//DoDebug("nw_s0_tensTrans: "+GetName(OBJECT_SELF) +" casts level " + IntToString(nCasterLvl)+ " TensersTrans on " + GetName(oTarget));
        float fDuration = RoundsToSeconds(nCasterLvl);
        int nMeta = PRCGetMetaMagicFeat();

		// Attack Bonus Increase
        int nAB = nCasterLvl / 2;

		int nHP;
        int nStr;
        int nDex;
        int nCon;

		// find out the number of attacks with the bonus (can be higher than 4)
		// motu99: commented this out, because it is done in prc_bab_caller
//		int nTotalAttacks = GetMainHandAttacks(oTarget, nAB);

        //Determine bonus HP and Ability adjustments
		//Metamagic
		if(nMeta & METAMAGIC_MAXIMIZE)
		{
			nHP = nCasterLvl * 6;
			nStr = 8;
			nDex = 8;
			nCon = 8;
		}
		else
		{
			nHP = d6(nCasterLvl);
			nStr = d4(2);
			nDex = d4(2);
			nCon = d4(2);
		}

		if(nMeta & METAMAGIC_EMPOWER)
		{
			nHP += nHP/2;
			nStr += nStr/2;
			nDex += nDex/2;
			nCon += nCon/2;
		}

		if(nMeta & METAMAGIC_EXTEND)
		{
			fDuration += fDuration;
		}

		effect eEffect = EffectAbilityIncrease(ABILITY_STRENGTH, nStr);
		eEffect = EffectLinkEffects(eEffect, EffectAbilityIncrease(ABILITY_DEXTERITY, nDex));
		eEffect = EffectLinkEffects(eEffect, EffectAbilityIncrease(ABILITY_CONSTITUTION, nCon));
		eEffect = EffectLinkEffects(eEffect, EffectAttackIncrease(nAB));
		eEffect = EffectLinkEffects(eEffect, EffectSavingThrowIncrease(SAVING_THROW_FORT, 5));
		//accounted for in prc_bab_caller
		// eEffect = EffectLinkEffects(eEffect, EffectModifyAttacks(nAttacks));

		//apply separately (so that we don't loose any other boni when we loose the temporary HP)
		effect eHP = EffectTemporaryHitpoints(nHP); 

		effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);

		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, fDuration, TRUE, -1, nCasterLvl);
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration, TRUE, -1, nCasterLvl);

		itemproperty ipSimple = PRCItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_SIMPLE);
		itemproperty ipMartial = PRCItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_MARTIAL);
		//AddItemProperty(DURATION_TYPE_TEMPORARY, ipSimple, oSkin, fDuration);
		//AddItemProperty(DURATION_TYPE_TEMPORARY, ipMartial, oSkin, fDuration);
		IPSafeAddItemProperty(oSkin, ipSimple,  fDuration);
		IPSafeAddItemProperty(oSkin, ipMartial, fDuration);

		// remember the caster level in order to properly calculate the number of attacks in prc_bab_caller
		SetLocalInt(oTarget, "CasterLvl_TensersTrans", nCasterLvl);
//		SetLocalInt(oTarget, "AttackCount_TensersTrans", nTotalAttacks);
		// prc_bab_caller must be executed *after* the spell effects have been applied to the target (otherwise it won't detect Tenser's on the target)
		ExecuteScript("prc_bab_caller", oTarget);
		
		//motu99: why don't we signal the spell event, as in Bioware tenser's? 
		// SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_TENSERS_TRANSFORMATION, FALSE));

		// put the pseudo heart beat on the target of the spell
		DelayCommand(6.0, AssignCommand(oTarget,PnPTensTransPseudoHB()));

		DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
		// Getting rid of the integer used to hold the spells spell school
		
		// finished with PnP version
		return;
	}



  //----------------------------------------------------------------------------
  // GZ, Nov 3, 2003
  // There is a serious problems with creatures turning into unstoppable killer
  // machines when affected by tensors transformation. NPC AI can't handle that
  // spell anyway, so I added this code to disable the use of Tensors by any
  // NPC.
  //----------------------------------------------------------------------------
  if (!GetIsPC(OBJECT_SELF))
  {
      WriteTimestampedLogEntry(GetName(OBJECT_SELF) + "[" + GetTag (OBJECT_SELF) +"] tried to cast Tensors Transformation. Bad! Remove that spell from the creature");
      return;
  }

  /*
    Spellcast Hook Code
      Added 2003-06-23 by GeorgZ
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more
    */

    if (!X2PreSpellCastCode())
    {
        return;
    }

    // End of Spell Cast Hook

    //Declare major variables
	object oTarget = PRCGetSpellTargetObject();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = CasterLvl;
    int nMeta = PRCGetMetaMagicFeat();
    int nHP, nAB, nCnt;

 /*
	//Determine bonus HP
	for(nCnt; nCnt <= CasterLvl; nCnt++)
	{
		nHP += d6();
	}
*/
    //Metamagic
	//Determine bonus HP and Ability adjustments
	//Metamagic
	if(nMeta & METAMAGIC_MAXIMIZE)
		nHP = CasterLvl * 6;
	else
		nHP = d6(CasterLvl);

	if(nMeta & METAMAGIC_EMPOWER)
		nHP += nHP/2;

	if(nMeta & METAMAGIC_EXTEND)
		nDuration += nDuration;

	// attack bonus
	nAB = CasterLvl / 2;

    // Get The PC's Equipment
    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
    object oArmorOld  = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD, oTarget);
    object oShieldOld = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);

    if (GetBaseItemType(oShieldOld) != BASE_ITEM_SMALLSHIELD &&
        GetBaseItemType(oShieldOld) != BASE_ITEM_LARGESHIELD &&
        GetBaseItemType(oShieldOld) != BASE_ITEM_TOWERSHIELD)
    {
        oShieldOld = OBJECT_INVALID;
    }

    //Declare effects
    effect eAttack = EffectAttackIncrease(nAB);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_FORT, 5);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

	// motu99: This could be calculated better (see below), but I left it at 2 extra attacks, because this is bioware's strange implementation
//	effect eSwing = EffectModifyAttacks(GetMainHandAttacks(oTarget, nAB)-GetMainHandAttacks(oTarget));
    effect eSwing = EffectModifyAttacks(2);

    effect ePoly = EffectPolymorph(28);
    effect eHP = EffectTemporaryHitpoints(nHP);
    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);

    //Link effects
    effect eLink = EffectLinkEffects(eAttack, eSave);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eSwing);
    eLink = EffectLinkEffects(eLink, ePoly);

    //Signal Spell Event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_TENSERS_TRANSFORMATION, FALSE));

    // abort if mounted
    if (!GetLocalInt(GetModule(),"X3_NO_SHAPESHIFT_SPELL_CHECK"))
    { // check to see if abort due to being mounted
        if (PRCHorseGetIsMounted(oTarget))
        { // abort
            if (GetIsPC(oTarget)) FloatingTextStrRefOnCreature(111982,oTarget,FALSE);
              return;
        } // abort
    } // check to see if abort due to being mounted
    
    //this command will make shore that polymorph plays nice with the shifter
    ShifterCheck(oTarget);

    AssignCommand(oTarget, ClearAllActions()); // prevents an exploit

    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, RoundsToSeconds(nDuration), TRUE, -1, CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration), TRUE, -1, CasterLvl);

    // Get the Polymorphed form's stuff
    object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget);
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oTarget);

    // Tenser's Sword is overpowerful with equipment merging -- no longer do you
    // need a +3 flaming longsword if you have reasonably good equipment.
    itemproperty ip = GetFirstItemProperty(oWeaponNew);
    while (GetIsItemPropertyValid(ip))
    {
        RemoveItemProperty(oWeaponNew, ip);
        ip = GetNextItemProperty(oWeaponNew);
    }

    // I like that nice flaming effect though.
    itemproperty ipFlaming = ItemPropertyVisualEffect(ITEM_VISUAL_FIRE);
    IPSafeAddItemProperty(oWeaponNew, ipFlaming);

    // Merges in your stuff so that you're not weakened by the morph.
    IPWildShapeCopyItemProperties(oWeaponOld, oWeaponNew, TRUE);
    IPWildShapeCopyItemProperties(oArmorOld, oArmorNew, TRUE);
    IPWildShapeCopyItemProperties(oHelmetOld, oArmorNew, TRUE);
    IPWildShapeCopyItemProperties(oShieldOld, oArmorNew, TRUE);

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
