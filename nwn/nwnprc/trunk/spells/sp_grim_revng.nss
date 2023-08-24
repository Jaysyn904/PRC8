//::///////////////////////////////////////////////
//:: Name      Grim Revenge
//:: FileName  sp_grim_revng.nss
//:://////////////////////////////////////////////
/**@file Grim Revenge
Necromancy [Evil]
Level: Sor/Wiz 4
Components: V, S, Undead
Casting Time: 1 action
Range: Medium (100 ft. + 10 ft./level)
Target: One living humanoid
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: Yes

The hand of the subject tears itself away from one
of his arms, leaving a bloody stump. This trauma
deals 6d6 points of damage. Then the hand, animated
and floating in the air, begins to attack the
subject. The hand attacks as if it were a wight
(see the Monster Manual) in terms of its statistics,
special attacks, and special qualities, except that
it is considered Tiny and gains a +4 bonus to AC
and a +4 bonus on attack rolls. The hand can be
turned or rebuked as a wight. If the hand is
defeated, only a regenerate spell can restore the
victim to normal.

Author:    Tenjac
Created:   5/20/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDC = PRCGetSaveDC(oTarget, oPC);
    int nType = MyPRCGetRacialType(oPC);
    int nModelNumber = 0;
    int bLeftHandMissing;
    int bRightHandMissing;
    int bLeftAnimated = FALSE;
    int bRightAnimated = FALSE;

    if(GetCreatureBodyPart(CREATURE_PART_LEFT_HAND, oTarget) == nModelNumber)
    {
        bLeftHandMissing = TRUE;
    }

    if(GetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, oTarget) == nModelNumber)
    {
        bRightHandMissing = TRUE;
    }

    //Spellhook
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    PRCSignalSpellEvent(oTarget, TRUE, SPELL_GRIM_REVENGE, oPC);

    //Check for undead
    if(nType == RACIAL_TYPE_UNDEAD)
    {
        //Check Spell Resistance
        if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()) && PRCGetIsAliveCreature(oTarget) && PRCAmIAHumanoid(oTarget))
        {
            //Will save
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
            {
                int nDam = d6(6);

                if(nMetaMagic & METAMAGIC_MAXIMIZE)
                {
                    nDam = 36;
                }
                if(nMetaMagic & METAMAGIC_EMPOWER)
                {
                    nDam += (nDam/2);
                }
				nDam += SpellDamagePerDice(oPC, 6);
//                SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL), oTarget);

                //Remove hand from oTarget - left hand first?
                //http://nwn.bioware.com/players/167/scripts_commandslist.html

                if(!bLeftHandMissing)
                {
                    //deal damage
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL), oTarget);

//                    SetCreatureBodyPart(CREATURE_PART_LEFT_HAND, nModelNumber, oTarget);
                    SetPersistantLocalInt(oTarget, "LEFT_HAND_USELESS", 1);

                    //Force unequip
       object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
	if (GetIsObjectValid(oLeft))
	DelayCommand(0.2f, DestroyObject(oLeft)); 

//                    ForceUnequip(oTarget, GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget), INVENTORY_SLOT_LEFTHAND);

                    bLeftAnimated = TRUE;
                }

                else if(!bRightHandMissing)
                {
                    //deal damage
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL), oTarget);

//                    SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, nModelNumber, oTarget);
                    SetPersistantLocalInt(oTarget, "RIGHT_HAND_USELESS", 1);

                    //Force unequip

       object oRight1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
	if (GetIsObjectValid(oRight1))
	DelayCommand(0.2f, DestroyObject(oRight1)); 

//                    ForceUnequip(oTarget, GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget), INVENTORY_SLOT_RIGHTHAND);

                    bRightAnimated = TRUE;
                }

                else
                {
                    SendMessageToPC(oPC, "Your target has no hands!");
                }

                //Spasm the target
                AssignCommand(oTarget, PlayAnimation(ANIMATION_LOOPING_SPASM, 1.0, 2.0));

                //Create copy of target, set all body parts null
                object oHand = CopyObject(oTarget, GetLocation(oTarget), OBJECT_INVALID);


		SetCreatureAppearanceType( oHand, APPEARANCE_TYPE_HALF_ORC ); 

                //Make invisible for a short time
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oHand, 2.1);

/*                    ForceUnequip(oHand, GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oHand), INVENTORY_SLOT_LEFTHAND);
                    ForceUnequip(oHand, GetItemInSlot(INVENTORY_SLOT_CHEST , oHand),  INVENTORY_SLOT_CHEST );
                    ForceUnequip(oHand, GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oHand),  INVENTORY_SLOT_RIGHTHAND );
                    ForceUnequip(oHand, GetItemInSlot(INVENTORY_SLOT_CLOAK, oHand),  INVENTORY_SLOT_CLOAK ); 
*/




                //Make it just a floating hand
                SetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT, nModelNumber, oHand);
                SetCreatureBodyPart(CREATURE_PART_LEFT_FOOT, nModelNumber, oHand);
                SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, nModelNumber, oHand);
                SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, nModelNumber, oHand);
                SetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH, nModelNumber, oHand);
                SetCreatureBodyPart(CREATURE_PART_LEFT_THIGH, nModelNumber, oHand);
                SetCreatureBodyPart(CREATURE_PART_PELVIS, nModelNumber, oHand);
                SetCreatureBodyPart(CREATURE_PART_TORSO, nModelNumber, oHand);
                SetCreatureBodyPart(CREATURE_PART_BELT, nModelNumber, oHand);
                SetCreatureBodyPart(CREATURE_PART_NECK, nModelNumber, oHand);


                SetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP, nModelNumber, oHand);
                SetCreatureBodyPart(CREATURE_PART_LEFT_BICEP, nModelNumber, oHand);
                SetCreatureBodyPart(CREATURE_PART_RIGHT_SHOULDER, nModelNumber, oHand);
                SetCreatureBodyPart(CREATURE_PART_LEFT_SHOULDER, nModelNumber, oHand);
                SetCreatureBodyPart(CREATURE_PART_HEAD, nModelNumber, oHand);

		SetCreatureWingType(CREATURE_WING_TYPE_NONE, oHand); 

                if(!bLeftAnimated)
                {
			// make invisible
                    SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, nModelNumber, oHand);
                    SetCreatureBodyPart(CREATURE_PART_LEFT_HAND, nModelNumber, oHand);
			// make visible
                    SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, 1, oHand);
                    SetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM, 1, oHand);


                   SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, nModelNumber, oTarget);

                    SetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM, nModelNumber, oTarget); 
                }

                if(!bRightAnimated)
                {
			// make invisible
                    SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, nModelNumber, oHand);
                    SetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM, nModelNumber, oHand);
			// make visible
                    SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, 1, oHand);
                    SetCreatureBodyPart(CREATURE_PART_LEFT_HAND, 1, oHand);

                    SetCreatureBodyPart(CREATURE_PART_LEFT_HAND, nModelNumber, oTarget);

                    SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, nModelNumber, oTarget);
                } 



                //Destroy items that shouldn't be in the hand 


       object oChest = GetItemInSlot(INVENTORY_SLOT_CHEST, oHand);
	if (GetIsObjectValid(oChest))
	DelayCommand(0.4f, DestroyObject(oChest));


       object oCLOAK = GetItemInSlot(INVENTORY_SLOT_CLOAK, oHand);
	if (GetIsObjectValid(oCLOAK))
	DelayCommand(0.6f, DestroyObject(oCLOAK));

       object oHead = GetItemInSlot( INVENTORY_SLOT_HEAD , oHand);
	if (GetIsObjectValid(oHead))
	DelayCommand(0.5f, DestroyObject(oHead));

       object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oHand);
	if (GetIsObjectValid(oRight))
	DelayCommand(0.7f, DestroyObject(oRight));


                //Set Bonuses
                effect eLink = EffectACIncrease(4, AC_DODGE_BONUS, AC_VS_DAMAGE_TYPE_ALL);
                       eLink = EffectLinkEffects(eLink, EffectAttackIncrease(4, ATTACK_BONUS_MISC));

		DelayCommand(0.8f, SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oHand));

		itemproperty iUndead = PRCItemPropertyBonusFeat(FEAT_UNDEAD);
		DelayCommand(0.8f, IPSafeAddItemProperty(GetPCSkin(oHand), iUndead));



		//Make hand hostile to target
                AssignCommand(oHand, ActionAttack(oTarget));

            }
        }
    }
    //SPEvilShift(oPC);
    PRCSetSchool();
}


