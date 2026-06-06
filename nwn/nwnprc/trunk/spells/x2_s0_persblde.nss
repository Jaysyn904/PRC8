//::///////////////////////////////////////////////
//:: Shelgarn's Persistent Blade
//:: x2_s0_persblde
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a dagger to battle for the caster
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 26, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller, Aug 2003
//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"
#include "inc_spirit_weapn"

//Creates the weapon that the creature will be using.
void spellsCreateItemForSummoned(object oCaster, float fDuration, int nClass)
{
    //Declare major variables
    int nStat = nClass == CLASS_TYPE_INVALID ?
                 GetAbilityModifier(ABILITY_CHARISMA, oCaster) ://if cast from items use charisma by default
                 GetDCAbilityModForClass(nClass, oCaster);
    nStat /= 2;
    // GZ: Just in case...
    if(nStat > 20)
        nStat = 20;
    else if(nStat < 1)
        nStat = 1;

    object oWeapon;
    //string sWeapon = "NW_WSWDG001";
	string sWeapon = "PRC_PERBLADE01";
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster);
    int i = 1;
    while(GetIsObjectValid(oSummon))
    {
        if(GetResRef(oSummon) == "X2_S_FAERIE001")
        {
            if(!GetIsObjectValid(GetItemPossessedBy(oSummon, sWeapon)))
            {
                //Create item on the creature, epuip it and add properties.
                oWeapon = CreateItemOnObject(sWeapon, oSummon);
                // GZ: Fix for weapon being dropped when killed
                SetDroppableFlag(oWeapon, FALSE);
                AssignCommand(oSummon, ActionEquipItem(oWeapon, INVENTORY_SLOT_RIGHTHAND));
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyAttackBonus(nStat), oWeapon, fDuration);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,IP_CONST_DAMAGESOAK_5_HP), oWeapon, fDuration);
            }
        }
        i++;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, i);
    }
}

void main()
{
//:: Check the Spellhook
    if (!X2PreSpellCastCode()) return;

//:: Set the Spell School
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
	
	int nRunEvent		= GetRunningEvent();

	if (nRunEvent == EVENT_NPC_ONSPELLCASTAT)
	{
		// Get the caster of the spell
		object oCaster = GetLastSpellCaster();
		int nCasterLevel = PRCGetCasterLevel(oCaster);

		if(DEBUG) DoDebug("x2_s0_persblde: EVENT_NPC_ONSPELLCASTAT triggered.");

		// Get the spell ID
		int nSpellId = GetLastSpell();
		if(DEBUG) DoDebug("x2_s0_persblde: Dispel spell ID: " + IntToString(nSpellId));

		// Check if the spell ID is a dispel spell
		if (nSpellId == SPELL_DISPEL_MAGIC || nSpellId == SPELL_LESSER_DISPEL || nSpellId == SPELL_GREATER_DISPELLING || nSpellId == SPELL_MORDENKAINENS_DISJUNCTION
			|| nSpellId == SPELL_SLASHING_DISPEL || nSpellId == SPELL_DISPELLING_TOUCH || nSpellId == SPELL_PIXIE_DISPEL || nSpellId == SPELL_GREAT_WALL_OF_DISPEL)
		{
			// Get the target of the spell
			object oTarget = OBJECT_SELF;
			if(DEBUG) DoDebug("x2_s0_persblde: Spell targeted at: " + GetName(oTarget));

			// Check if the target is OBJECT_SELF
			if (oTarget == OBJECT_SELF)
			{
				// Retrieve the original caster of the Persistent Blade spell from oSummon
				object oSummon = OBJECT_SELF;
				object oOriginalCaster = GetLocalObject(oSummon, "MY_CASTER");

				// Ensure oOriginalCaster is valid
				if (GetIsObjectValid(oOriginalCaster))
				{
					if(DEBUG) DoDebug("x2_s0_persblde: Original caster found. Caster level: " + IntToString(GetCasterLevel(oOriginalCaster)));

					// Determine the DC for the dispel check
					int nDispelDC = 11 + GetCasterLevel(oOriginalCaster);
					if(DEBUG) DoDebug("x2_s0_persblde: Dispel DC: " + IntToString(nDispelDC));

					// Determine the maximum cap for the dispel check
					int nDispelCap = 0;
					if (nSpellId == SPELL_LESSER_DISPEL)
						nDispelCap = 5;
					else if (nSpellId == SPELL_DISPEL_MAGIC || nSpellId == SPELL_SLASHING_DISPEL || nSpellId == SPELL_DISPELLING_TOUCH || nSpellId == SPELL_PIXIE_DISPEL || nSpellId == INVOKE_VORACIOUS_DISPELLING)
						nDispelCap = 10;
					else if (nSpellId == SPELL_GREATER_DISPELLING || nSpellId == SPELL_GREAT_WALL_OF_DISPEL)
						nDispelCap = 15;
					else if (nSpellId == SPELL_MORDENKAINENS_DISJUNCTION)
						nDispelCap = 0; // No cap for Disjunction

					// Roll for the dispel check
					int nDispelRoll = d20();
					int nCappedCasterLevel = nCasterLevel;

					if (nDispelCap > 0 && nCasterLevel > nDispelCap)
						nCappedCasterLevel = nDispelCap;

					nDispelRoll += nCappedCasterLevel;

					if(DEBUG) DoDebug("x2_s0_persblde: Dispel roll: " + IntToString(nDispelRoll) + " (Caster Level: " + IntToString(nCappedCasterLevel) + ", Cap: " + IntToString(nDispelCap) + ")");

					// Compare the dispel result to the DC
					if (nDispelRoll >= nDispelDC)
					{
						if(DEBUG) DoDebug("x2_s0_persblde: Dispel check succeeded.");

						// Dispel succeeded, destroy oSummon and the item in its right hand
						object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oSummon);

						if(DEBUG) DoDebug("x2_s0_persblde: Dispel Magic succeeded. Destroying Persistent Blade and its right hand item.");

						// Set flags and destroy objects with delays
						SetPlotFlag(oWeapon, FALSE);
						SetPlotFlag(oSummon, FALSE);
						SetImmortal(oSummon, FALSE);

						ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DISPEL), oSummon);

						// Destroy the weapon and summon with delays
						if (GetIsObjectValid(oWeapon))
						{
							DelayCommand(0.5f, DestroyObject(oWeapon));
							if(DEBUG) DoDebug("x2_s0_persblde: Persistent Blade destruction scheduled.");
						}
						else
						{
							if(DEBUG) DoDebug("x2_s0_persblde: No weapon found in right hand.");
						}

						DelayCommand(1.0f, DestroyObject(oSummon));
						if(DEBUG) DoDebug("x2_s0_persblde: Persistent Blade Summon destruction scheduled.");
					}
					else
					{
						RegisterSummonEvents(oSummon);
						if(DEBUG) DoDebug("x2_s0_persblde: Dispel check failed.");
					}
				}
				else
				{
					if(DEBUG) DoDebug("x2_s0_persblde: Original caster not found.");
				}
			}
		}
		return;
	}


    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    int nClass = PRCGetLastSpellCastClass();
    int nDuration = PRCGetCasterLevel(oCaster) / 2;
    int nSwitch = GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL);

    if(nDuration < 1)
        nDuration = 1;
    int nMetaMagic = PRCGetMetaMagicFeat();
    //Make metamagic check for extend
    if(nMetaMagic & METAMAGIC_EXTEND)
        nDuration *= 2;   //Duration is +100%
    float fDuration = nSwitch ? RoundsToSeconds(nDuration * nSwitch):
                                 TurnsToSeconds(nDuration);

    effect eSummon = EffectSummonCreature("X2_S_FAERIE001");
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);

    //Apply the VFX impact and summon effect
    MultisummonPreSummon();
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lTarget);

    DelayCommand(1.0, spellsCreateItemForSummoned(oCaster, fDuration, nClass));

    PRCSetSchool();
}