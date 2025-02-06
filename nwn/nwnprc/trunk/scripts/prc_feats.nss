/*
    prc_feats

    This is the point all feat checks are routed through
    from EvalPRCFeats() in prc_inc_function.

    Done so that if anything applies custom feats as
    itemproperties (i.e. templates) the bonuses run

    Otherwise, the if() checks before the feat is applied
*/
//////////////////////////////////////////////////////////

#include "moi_inc_moifunc"
#include "prc_inc_clsfunc"
#include "psi_inc_core"

void DisablePowerAttack(object oPC);
void PRCFeat_AddMagicalBonuses(object oPC, object oSkin);
void PRCFeat_AddCompositeBonuses(object oPC, object oSkin);
void PRCFeat_AddBonusFeats(object oPC, object oSkin);
void PRCFeat_AddEventHooks(object oPC, object oSkin);
void PRCFeat_AddMisc(object oPC, object oSkin);
void PRCFeat_Equip(object oPC, object oSkin, int iEquip);

    //--------------------------------------------------------------------------
    //
    //--------------------------------------------------------------------------
    
void DisablePowerAttack(object oPC)
{
	SetActionMode(oPC, ACTION_MODE_POWER_ATTACK, FALSE);
	SetActionMode(oPC, ACTION_MODE_IMPROVED_POWER_ATTACK, FALSE);
	
	DelayCommand(0.25, DisablePowerAttack(oPC));
}
 
void PRCFeat_Equip(object oPC, object oSkin, int iEquip)
{
    object oItem;
    int nType;

    // Unequip event (iEquip == 1)
    if(iEquip == 1)
    {
        oItem = GetItemLastUnequipped();
        nType = GetBaseItemType(oItem);

        // Bow Mastery - Reset bonus on unequip
        if(GetHasFeat(FEAT_BOWMASTERY, oPC))
        {
            if(nType == BASE_ITEM_LONGBOW || nType == BASE_ITEM_SHORTBOW)
                SetCompositeAttackBonus(oPC, "WeaponMasteryBow", 0);
        }

        // Crossbow Mastery - Reset bonus on unequip
        if(GetHasFeat(FEAT_XBOWMASTERY, oPC))
        {
            if(nType == BASE_ITEM_LIGHTCROSSBOW || nType == BASE_ITEM_HEAVYCROSSBOW)
                SetCompositeAttackBonus(oPC, "WeaponMasteryXBow", 0);
        }

        // Shuriken Mastery - Reset bonus on unequip
        if(GetHasFeat(FEAT_SHURIKENMASTERY, oPC))
        {
            if(nType == BASE_ITEM_SHURIKEN)
                SetCompositeAttackBonus(oPC, "WeaponMasteryShur", 0);
        }

        // Brutal Throw - Reset bonus on unequip for throwing weapons
        if(GetHasFeat(FEAT_BRUTAL_THROW, oPC))
        {
            if(nType == BASE_ITEM_THROWINGAXE || nType == BASE_ITEM_SHURIKEN || nType == BASE_ITEM_DART)
                SetCompositeAttackBonus(oPC, "BrutalThrow", 0);
        }
    }
    // Equip event (iEquip == 2)
    else if(iEquip == 2)
    {
        oItem = GetItemLastEquipped();
        nType = GetBaseItemType(oItem);

        // Bow Mastery - Apply bonus on equip
        if(GetHasFeat(FEAT_BOWMASTERY, oPC))
        {
            if(nType == BASE_ITEM_LONGBOW || nType == BASE_ITEM_SHORTBOW)
                SetCompositeAttackBonus(oPC, "WeaponMasteryBow", 1);
        }

        // Crossbow Mastery - Apply bonus on equip
        if(GetHasFeat(FEAT_XBOWMASTERY, oPC))
        {
            if(nType == BASE_ITEM_LIGHTCROSSBOW || nType == BASE_ITEM_HEAVYCROSSBOW)
                SetCompositeAttackBonus(oPC, "WeaponMasteryXBow", 1);
        }

        // Shuriken Mastery - Apply bonus on equip
        if(GetHasFeat(FEAT_SHURIKENMASTERY, oPC))
        {
            if(nType == BASE_ITEM_SHURIKEN)
                SetCompositeAttackBonus(oPC, "WeaponMasteryShur", 1);
        }

        // Brutal Throw - Apply bonus if Strength > Dexterity for throwing weapons
        if(GetHasFeat(FEAT_BRUTAL_THROW, oPC))
        {
            if(nType == BASE_ITEM_THROWINGAXE || nType == BASE_ITEM_SHURIKEN || nType == BASE_ITEM_DART)
            {
                int nStrMod = GetAbilityModifier(ABILITY_STRENGTH, oPC);
                int nDexMod = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
            
                if (nStrMod > nDexMod)
                    SetCompositeAttackBonus(oPC, "BrutalThrow", (nStrMod - nDexMod));
				else
					SetCompositeAttackBonus(oPC, "BrutalThrow", 0);
            }
        }
	//:: Charming the Arrow - Apply bonus if Charisma > Dexterity for bows & crossbows
		if (GetHasFeat(FEAT_CHARMING_THE_ARROW, oPC))
		{
			if (nType == BASE_ITEM_HEAVYCROSSBOW || nType == BASE_ITEM_LIGHTCROSSBOW || nType == BASE_ITEM_LONGBOW || nType == BASE_ITEM_SHORTBOW)
			{
				int nChaMod = GetAbilityModifier(ABILITY_CHARISMA, oPC);
				int nDexMod = GetAbilityModifier(ABILITY_DEXTERITY, oPC);

				// Apply Charisma modifier as composite attack bonus if greater than Dexterity modifier
				if (nChaMod > nDexMod)
				{
					SetCompositeAttackBonus(oPC, "CharmingTheArrow", nChaMod - nDexMod);
				}
				else
				{
					// Remove the bonus if Charisma is not greater
					SetCompositeAttackBonus(oPC, "CharmingTheArrow", 0);
				}
			}
		}		
    }
}

 
/* void PRCFeat_Equip(object oPC, object oSkin, int iEquip)
{
    //on unequip
    if(iEquip == 1)
    {
        object oItem = GetItemLastUnequipped();
        int nType = GetBaseItemType(oItem);

        if(GetHasFeat(FEAT_BOWMASTERY, oPC))
        {
            if(nType == BASE_ITEM_LONGBOW
            || nType == BASE_ITEM_SHORTBOW)
                SetCompositeAttackBonus(oPC, "WeaponMasteryBow", 0);
        }
        if(GetHasFeat(FEAT_XBOWMASTERY, oPC))
        {
            if(nType == BASE_ITEM_LIGHTCROSSBOW
            || nType == BASE_ITEM_HEAVYCROSSBOW)
                SetCompositeAttackBonus(oPC, "WeaponMasteryXBow", 0);
        }
        if(GetHasFeat(FEAT_SHURIKENMASTERY, oPC))
        {
            if(nType == BASE_ITEM_SHURIKEN)
                SetCompositeAttackBonus(oPC, "WeaponMasteryShur", 0);
        }
        // Brutal Throw
        if(GetHasFeat(FEAT_BRUTAL_THROW, oPC))
        {   // Make sure it's a throwing weapon
            if (nType ==  BASE_ITEM_THROWINGAXE || nType ==  BASE_ITEM_SHURIKEN || nType ==  BASE_ITEM_DART)
            {
                SetCompositeAttackBonus(oPC, "BrutalThrow", 0);
            }    
        }         
    }
    //on equip
    else if(iEquip == 2)
    {
        object oItem = GetItemLastEquipped();
        int nType = GetBaseItemType(oItem);

        if(GetHasFeat(FEAT_BOWMASTERY, oPC))
        {
            if(nType == BASE_ITEM_LONGBOW
            || nType == BASE_ITEM_SHORTBOW)
                SetCompositeAttackBonus(oPC, "WeaponMasteryBow", 1);
        }
        if(GetHasFeat(FEAT_XBOWMASTERY, oPC))
        {
            if(nType == BASE_ITEM_LIGHTCROSSBOW
            || nType == BASE_ITEM_HEAVYCROSSBOW)
                SetCompositeAttackBonus(oPC, "WeaponMasteryXBow", 1);
        }
        if(GetHasFeat(FEAT_SHURIKENMASTERY, oPC))
        {
            if(nType == BASE_ITEM_SHURIKEN)
                SetCompositeAttackBonus(oPC, "WeaponMasteryShur", 1);
        }
        // Brutal Throw
        if(GetHasFeat(FEAT_BRUTAL_THROW, oPC))
        {   // Make sure it's a throwing weapon
            if (nType ==  BASE_ITEM_THROWINGAXE || nType ==  BASE_ITEM_SHURIKEN || nType ==  BASE_ITEM_DART)
            {
                int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
                int nDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
            
                if (nStr > nDex)
                    SetCompositeAttackBonus(oPC, "BrutalThrow", (nStr - nDex));
            }    
        }        
    }
} */

/*
/// +2 on Intimidate and Persuade /////////
void BrandApply(object oPC ,object oSkin ,int iLevel)
{
    if(GetLocalInt(oSkin, "EvilbrandPe") == iLevel)
        return;
    SetCompositeBonus(oSkin, "EvilbrandPe", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERSUADE);
    SetCompositeBonus(oSkin, "EvilbrandI", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);
}

void EvilBrand(object oPC, object oSkin, int iEquip)
{
    //Check alignment and check what bonus applies
    int nAlign = GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL

    if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
    {
        if((GetHasFeat(FEAT_EB_HAND, oPC) && GetItemInSlot(INVENTORY_SLOT_ARMS, oPC) == OBJECT_INVALID)
        || (GetHasFeat(FEAT_EB_HEAD, oPC) && GetItemInSlot(INVENTORY_SLOT_HEAD, oPC) == OBJECT_INVALID)
        || (GetHasFeat(FEAT_EB_CHEST, oPC) && GetItemInSlot(INVENTORY_SLOT_CHEST, oPC) == OBJECT_INVALID)
        || (GetHasFeat(FEAT_EB_NECK, oPC) && GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC) == OBJECT_INVALID)
        || (GetHasFeat(FEAT_EB_ARM, oPC)

    else
        BrandApply(oPC, oSkin, 0);
}
*/
void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int iEquip = GetLocalInt(oPC, "ONEQUIP");
    
    if (GetPRCSwitch(PRC_POWER_ATTACK) == PRC_POWER_ATTACK_FULL_PNP) DisablePowerAttack(oPC);

    AssignCommand(oSkin, PRCFeat_AddMagicalBonuses(oPC, oSkin));
    PRCFeat_AddCompositeBonuses(oPC, oSkin);
    PRCFeat_AddBonusFeats(oPC, oSkin);
    PRCFeat_AddEventHooks(oPC, oSkin);
    PRCFeat_AddMisc(oPC, oSkin);
    if(iEquip)
        PRCFeat_Equip(oPC, oSkin, iEquip);

	//Checking VoP feats
	int nTotalRows = Get2DARowCount("prc_vop_feats");
	int nRow;
	effect eCheckEffect = GetFirstEffect(oPC);
	while (GetIsEffectValid(eCheckEffect))
	{
		for(nRow=0; nRow <= nTotalRows; nRow++)
		{
			string nFeat = Get2DAString("prc_vop_feats","FeatIndex",nRow);
			if(GetEffectTag(eCheckEffect) == "VoPFeat"+nFeat)   SetLocalInt(oPC,"VoPFeat"+nFeat,1);
		}
		eCheckEffect = GetNextEffect(oPC);
	}

    // Feats are checked here
	
    //if(GetHasFeat(FEAT_SAC_VOW, oPC))                         ExecuteScript("prc_vows", oPC);
    //if(GetHasFeat(FEAT_LICHLOVED, oPC))                       ExecuteScript("prc_lichloved", oPC);
    if(GetHasFeat(FEAT_EB_HAND, oPC)  ||
       GetHasFeat(FEAT_EB_HEAD, oPC)  ||
       GetHasFeat(FEAT_EB_CHEST, oPC) ||
       GetHasFeat(FEAT_EB_ARM, oPC)   ||
       GetHasFeat(FEAT_EB_NECK, oPC)    )                        ExecuteScript("prc_evilbrand", oPC);
    //if(GetHasFeat(FEAT_VILE_WILL_DEFORM, oPC) ||
    //   GetHasFeat(FEAT_VILE_DEFORM_GAUNT, oPC)||
    //   GetHasFeat(FEAT_VILE_DEFORM_OBESE, oPC)  )                ExecuteScript("prc_vilefeats", oPC);
    //if(GetHasFeat(FEAT_BOWMASTERY, oPC)  ||
    //   GetHasFeat(FEAT_XBOWMASTERY, oPC) ||
    //   GetHasFeat(FEAT_SHURIKENMASTERY, oPC))                    ExecuteScript("prc_weapmas", oPC);

    //Delays for item bonuses
    //if(GetHasFeat(FEAT_FORCE_PERSONALITY, oPC) ||
    //   GetHasFeat(FEAT_INSIGHTFUL_REFLEXES, oPC) ||
       //GetHasFeat(FEAT_RAVAGEGOLDENICE, oPC)??
    //   GetHasFeat(FEAT_OBSCURE_LORE, oPC) ||
    //   GetHasFeat(FEAT_HEAVY_LITHODERMS, oPC) ||
    //   GetHasFeat(FEAT_MORADINS_SMILE, oPC) ||
    //   GetHasFeat(FEAT_MENACING_DEMEANOUR, oPC) ||
    //   GetHasFeat(FEAT_RELIC_HUNTER, oPC))                       DelayCommand(0.1, ExecuteScript("prc_ft_passive", oPC));
    //if(GetHasFeat(FEAT_TACTILE_TRAPSMITH, oPC))                  DelayCommand(0.1, ExecuteScript("prc_ft_tacttrap", oPC));

    //Baelnorn & Undead
    //if(GetHasFeat(FEAT_UNDEAD_HD, oPC))                          ExecuteScript("prc_ud_hitdice", oPC);
    //if(GetHasFeat(FEAT_TURN_RESISTANCE, oPC))                    ExecuteScript("prc_turnres", oPC);
    //if(GetHasFeat(FEAT_IMPROVED_TURN_RESISTANCE, oPC))           ExecuteScript("prc_imp_turnres", oPC);
    //if(GetHasFeat(FEAT_IMMUNITY_ABILITY_DECREASE, oPC))          ExecuteScript("prc_ui_abildrain", oPC);
    //if(GetHasFeat(FEAT_IMMUNITY_CRITICAL, oPC))                  ExecuteScript("prc_ui_critical", oPC);
    //if(GetHasFeat(FEAT_IMMUNITY_DEATH, oPC))                     ExecuteScript("prc_ui_death", oPC);
    //if(GetHasFeat(FEAT_IMMUNITY_DISEASE, oPC))                   ExecuteScript("prc_ui_disease", oPC);
    //if(GetHasFeat(FEAT_IMMUNITY_MIND_SPELLS, oPC))               ExecuteScript("prc_ui_mind", oPC);
    //if(GetHasFeat(FEAT_IMMUNITY_PARALYSIS, oPC))                 ExecuteScript("prc_ui_paral", oPC);
    //if(GetHasFeat(FEAT_IMMUNITY_POISON, oPC))                    ExecuteScript("prc_ui_poison", oPC);
    //if(GetHasFeat(FEAT_IMMUNITY_SNEAKATTACK, oPC))               ExecuteScript("prc_ui_snattack", oPC);
    //if(GetHasFeat(FEAT_POSITIVE_ENERGY_RESISTANCE, oPC))         ExecuteScript("prc_ud_poe", oPC);

    //if(GetHasFeat(FEAT_LINGERING_DAMAGE, oPC))                ExecuteScript("ft_lingdmg", oPC);
    //if(GetHasFeat(FEAT_MAGICAL_APTITUDE, oPC))                   ExecuteScript("prc_magaptitude", oPC);
    if(GetHasFeat(FEAT_ETERNAL_FREEDOM, oPC))                    ExecuteScript("etern_free", oPC);
	
    if(GetHasFeat(FEAT_INTUITIVE_ATTACK, oPC) || GetLocalInt(oPC, "VoPFeat"+IntToString(FEAT_INTUITIVE_ATTACK)))	ExecuteScript("prc_intuiatk", oPC);
    //if(GetPersistantLocalInt(oPC, "EpicSpell_TransVital"))       ExecuteScript("trans_vital", oPC);
    //if(GetHasFeat(FEAT_COMBAT_MANIFESTATION, oPC))               ExecuteScript("psi_combat_manif", oPC);
    //if(GetHasFeat(FEAT_WILD_TALENT, oPC))                        ExecuteScript("psi_wild_talent", oPC);
    if(GetHasFeat(FEAT_RAPID_METABOLISM, oPC))                   ExecuteScript("prc_rapid_metab", oPC);
    if(GetHasFeat(FEAT_PSIONIC_HOLE, oPC))                       ExecuteScript("psi_psionic_hole", oPC);
    //if(GetHasFeat(FEAT_POWER_ATTACK, oPC))                       ExecuteScript("prc_powatk_eval", oPC);
    //if(GetHasFeat(FEAT_ENDURANCE, oPC)
    //    || GetHasFeat(FEAT_TRACK, oPC)
    //    || GetHasFeat(FEAT_ETHRAN, oPC))                         ExecuteScript("prc_wyzfeat", oPC);
    //if(GetHasFeat(FAST_HEALING_1, oPC)
    //    || GetHasFeat(FAST_HEALING_2, oPC)
    //    || GetHasFeat(FAST_HEALING_3, oPC))                      ExecuteScript("prc_fastheal", oPC);

    if(GetHasFeat(FEAT_SPELLFIRE_WIELDER, oPC))                  ExecuteScript("prc_spellf_eval", oPC);
    //if(GetHasFeat(FEAT_ULTRAVISION, oPC))                        ExecuteScript("prc_ultravis", oPC);
    //if(GetHasFeat(FEAT_TWO_WEAPON_REND, oPC))                    ExecuteScript("prc_tw_rend", oPC);

    if(GetHasFeat(FEAT_SUPERIOR_UNARMED_STRIKE, oPC))            ExecuteScript("prc_frostrager", oPC); // Yes, this is deliberate
    //Races of the Dragon feats
    if(GetHasFeat(FEAT_KOB_DRAGON_TAIL, oPC)
        || GetHasFeat(FEAT_KOB_DRAGON_WING_A, oPC)
        || GetHasFeat(FEAT_KOB_DRAGON_WING_BC, oPC)
        || GetHasFeat(FEAT_KOB_DRAGON_WING_BG, oPC)
        || GetHasFeat(FEAT_KOB_DRAGON_WING_BM, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BK, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BL, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_GR, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_RD, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_WH, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_AM, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_CR, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_EM, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_SA, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_TP, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BS, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BZ, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_CP, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_GD, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_SR, oPC))              ExecuteScript("prc_rotdfeat", oPC);

    //Draconic Feats
    if(GetHasFeat(FEAT_DRACONIC_HERITAGE_BK, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_BL, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_GR, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_RD, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_WH, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_AM, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_CR, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_EM, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_SA, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_TP, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_BS, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_BZ, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_CP, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_GD, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_SR, oPC)
        || GetHasFeat(FEAT_DRACONIC_SENSES, oPC)
        || GetHasFeat(FEAT_DRAGONTOUCHED, oPC))                    ExecuteScript("prc_dracfeat", oPC);

    //Dragonfire xxxx Feats
    //if(GetHasFeat(FEAT_DRAGONFIRE_STRIKE, oPC))                    ExecuteScript("prc_dragfire_atk", oPC);

    //Draconic Aura feats
    //if(GetHasFeat(FEAT_DOUBLE_DRACONIC_AURA, oPC))                 ExecuteScript("prc_dbldracaura", oPC);
    //if(GetHasFeat(FEAT_BONUS_AURA_INSIGHT, oPC)
    //   || GetHasFeat(FEAT_BONUS_AURA_PRESENCE, oPC)
    //   || GetHasFeat(FEAT_BONUS_AURA_RESISTACID, oPC)
    //   || GetHasFeat(FEAT_BONUS_AURA_RESISTCOLD, oPC)
    //   || GetHasFeat(FEAT_BONUS_AURA_RESISTELEC, oPC)
    //   || GetHasFeat(FEAT_BONUS_AURA_RESISTFIRE, oPC)
    //   || GetHasFeat(FEAT_BONUS_AURA_RESOLVE, oPC)
    //   || GetHasFeat(FEAT_BONUS_AURA_STAMINA, oPC)
    //   || GetHasFeat(FEAT_BONUS_AURA_SENSES, oPC)
    //   || GetHasFeat(FEAT_BONUS_AURA_SWIFTNESS, oPC)
    //   || GetHasFeat(FEAT_BONUS_AURA_TOUGHNESS, oPC))             ExecuteScript("prc_xtradracaura", oPC);
       
    //Dragonfriend/thrall
    //if (GetHasFeat(FEAT_DRAGONFRIEND, oPC)
    //   || GetHasFeat(FEAT_DRAGONTHRALL, oPC))                     ExecuteScript("prc_drgnthrall", oPC);

    //Tenjac's 3.3 feats
    //if(GetHasFeat(FEAT_DEFORM_FACE, oPC))                         ExecuteScript("prc_dfrm_face", oPC);
    //if(GetHasFeat(FEAT_SHADOW_AND_STEALTH, oPC))                  ExecuteScript("prc_sb_shdstlth", oPC);

    // Feats that require OnHitCastSpell: Unique on armor
    /* Commented out until needed
    if(GetHasFeat(FEAT_, oPC)
       )
    {
        AddEventScript(oPC, EVENT_ONPLAYEREQUIP,       "prc_keep_onhit_a", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_keep_onhit_a", TRUE, FALSE);
    }
    */
}

void PRCFeat_AddMagicalBonuses(object oPC, object oSkin)
{
    //Remove previous effects applied by prc_feats.nss
    effect eTest = GetFirstEffect(oPC);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectSubType(eTest) == SUBTYPE_SUPERNATURAL
        && GetEffectDurationType(eTest) == DURATION_TYPE_PERMANENT
        && GetEffectCreator(eTest) == oSkin)
        {
            RemoveEffect(oPC, eTest);
        }
        eTest = GetNextEffect(oPC);
    }

    effect eFeat;

    if(GetHasFeat(FEAT_POSITIVE_ENERGY_RESISTANCE, oPC))
        eFeat = EffectLinkEffects(eFeat, EffectDamageResistance(DAMAGE_TYPE_POSITIVE, 10, 0));

    if(GetHasFeat(FEAT_ULTRAVISION, oPC))
        eFeat = EffectLinkEffects(eFeat, EffectUltravision());

    if(GetHasFeat(FEAT_INSIGHTFUL_REFLEXES, oPC))
    {
        int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
        int nDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
        int nMod = nInt - nDex;

        if(nMod > 0)
            eFeat = EffectLinkEffects(eFeat, EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nMod));
        else if(nMod < 0)
            eFeat = EffectLinkEffects(eFeat, EffectSavingThrowDecrease(SAVING_THROW_REFLEX, -nMod));
    }
    if(GetHasFeat(FEAT_STEADFAST_DETERMINATION, oPC))
    {
        int nWis = GetAbilityModifier(ABILITY_WISDOM, oPC);
        int nCon = GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
        int nMod;

        nMod += nCon - nWis;

        if(nMod > 0)
            eFeat = EffectLinkEffects(eFeat, EffectSavingThrowIncrease(SAVING_THROW_WILL, nMod));
	}
	if(GetHasFeat(FEAT_FORCE_PERSONALITY, oPC)
    || GetHasFeat(FEAT_INDOMITABLE_SOUL, oPC))
    {
        int nWis = GetAbilityModifier(ABILITY_WISDOM, oPC);
        int nCha = GetAbilityModifier(ABILITY_CHARISMA, oPC);
        int nMod;

        if(GetHasFeat(FEAT_FORCE_PERSONALITY, oPC))
            nMod += nCha - nWis;

        if(GetHasFeat(FEAT_INDOMITABLE_SOUL, oPC)
        && !GetHasFeat(FEAT_DIVINE_GRACE, oPC)
        && !GetHasFeat(FEAT_PRESTIGE_DARK_BLESSING, oPC))
            nMod += nCha;

        if(nMod > 0)
            eFeat = EffectLinkEffects(eFeat, EffectSavingThrowIncrease(SAVING_THROW_WILL, nMod));
    }
    if(GetHasFeat(FEAT_DRAGONFRIEND, oPC))
    {
        effect eDragFriend = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_FEAR);
               eDragFriend = VersusAlignmentEffect(eDragFriend, ALIGNMENT_ALL, ALIGNMENT_GOOD);
               eDragFriend = EffectLinkEffects(eDragFriend, EffectSkillIncrease(SKILL_PERSUADE, 4));
               eDragFriend = VersusRacialTypeEffect(eDragFriend, RACIAL_TYPE_DRAGON);
        eFeat = EffectLinkEffects(eFeat, eDragFriend);
    }
    if(GetHasFeat(FEAT_DRAGONTHRALL, oPC))
    {
        effect eDragThrall = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_FEAR);
               eDragThrall = VersusAlignmentEffect(eDragThrall, ALIGNMENT_ALL, ALIGNMENT_EVIL);
               eDragThrall = EffectLinkEffects(eDragThrall, EffectSkillIncrease(SKILL_BLUFF, 4));
               eDragThrall = EffectLinkEffects(eDragThrall, EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_MIND_SPELLS));
               eDragThrall = VersusRacialTypeEffect(eDragThrall, RACIAL_TYPE_DRAGON);
        eFeat = EffectLinkEffects(eFeat, eDragThrall);
    }
    if(GetHasFeat(FEAT_DEFORM_FACE, oPC) && GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
    {
        effect eDeform = EffectSkillIncrease(SKILL_PERSUADE, 2);
               eDeform = VersusAlignmentEffect(eDeform, ALIGNMENT_ALL, ALIGNMENT_EVIL);
               eDeform = EffectLinkEffects(eDeform, EffectSkillIncrease(SKILL_INTIMIDATE, 2));
        eFeat = EffectLinkEffects(eFeat, eDeform);
    }
    if(GetHasFeat(FEAT_STRENGTH_OF_MIND, oPC))
    {
        eFeat = EffectLinkEffects(eFeat, EffectImmunity(IMMUNITY_TYPE_STUN));
        eFeat = EffectLinkEffects(eFeat, EffectImmunity(IMMUNITY_TYPE_SLEEP));
    }
    // Shaman - Spirit Sight
    // Ghost-Faced Killer - Ghost Sight
    if(GetHasFeat(FEAT_SPIRIT_SIGHT, oPC)
    || GetHasFeat(FEAT_GHOST_SIGHT, oPC))
        eFeat = EffectLinkEffects(eFeat, EffectSeeInvisible());
    // Henshin Mystic - Blindsight
    if(GetHasFeat(FEAT_PRESTIGE_BLINDSIGHT, oPC))
    {
        eFeat = EffectLinkEffects(eFeat, EffectUltravision());
        eFeat = EffectLinkEffects(eFeat, EffectSeeInvisible());
    }
    if(GetHasFeat(FEAT_MAD_CERTAINTY, oPC))
    {
        int nPenalty = GetHasFeat(FEAT_INSANE_CERTAINTY, oPC) ? 6 : 2;
        int nRace = GetPhobiaRace(GetPhobia(oPC));
        effect ePhob = EffectSavingThrowDecrease(SAVING_THROW_TYPE_ALL, nPenalty);
               ePhob = EffectLinkEffects(ePhob, EffectAttackDecrease(nPenalty));
               ePhob = EffectLinkEffects(ePhob, EffectSkillDecrease(SKILL_ANIMAL_EMPATHY, nPenalty));
               ePhob = EffectLinkEffects(ePhob, EffectSkillDecrease(SKILL_INTIMIDATE, nPenalty));
               ePhob = EffectLinkEffects(ePhob, EffectSkillDecrease(SKILL_PERFORM, nPenalty));
               ePhob = EffectLinkEffects(ePhob, EffectSkillDecrease(SKILL_PERSUADE, nPenalty));
               ePhob = EffectLinkEffects(ePhob, EffectSkillDecrease(SKILL_USE_MAGIC_DEVICE, nPenalty));
               ePhob = EffectLinkEffects(ePhob, EffectSkillDecrease(SKILL_IAIJUTSU_FOCUS, nPenalty));
               ePhob = VersusRacialTypeEffect(ePhob, nRace);
        eFeat = EffectLinkEffects(eFeat, ePhob);
    }
    if(GetHasFeat(FEAT_SH_IMMUNITY_ABILITY_DECREASE, oPC) && !GetHasFeat(FEAT_SH_IMMUNITY_LEVEL_DRAIN))
        eFeat = EffectLinkEffects(eFeat, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
    if(GetHasFeat(FEAT_SH_IMMUNITY_DISEASE, oPC))//skullclan hunter gets protection from evil at this level
    {
        effect eProt = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
               eProt = EffectLinkEffects(eProt, EffectACIncrease(2, AC_DEFLECTION_BONUS));
               eProt = EffectLinkEffects(eProt, EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));
               eProt = VersusAlignmentEffect(eProt, ALIGNMENT_ALL, ALIGNMENT_EVIL);
        eFeat = EffectLinkEffects(eFeat, eProt);
    }
    if(GetHasFeat(FEAT_VOWOFSILENCE, oPC))
        eFeat = EffectLinkEffects(eFeat, EffectSilence());
    if(GetHasFeat(FEAT_PLANT_IMM, oPC) || GetHasFeat(FEAT_LIVING_CONSTRUCT, oPC) || GetRacialType(oPC) == RACIAL_TYPE_DOPPELGANGER || GetRacialType(oPC) == RACIAL_TYPE_MONGRELFOLK)
        eFeat = EffectLinkEffects(eFeat, EffectImmunity(IMMUNITY_TYPE_SLEEP));
    if(GetHasFeat(FEAT_JPM_RITE_WAKING, oPC))
    {
        eFeat = EffectLinkEffects(eFeat, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_FEAR));
        eFeat = EffectLinkEffects(eFeat, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_DEATH));
        SetCompositeBonus(GetPCSkin(oPC), "RiteWaking", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE);
    }
    // Speed Increase Item Property
    int iSpeed = GetLocalInt(oPC, "player_speed_increase");
    if(iSpeed)
    {
        if(iSpeed > 99) iSpeed = 99;
        eFeat = EffectLinkEffects(eFeat, EffectMovementSpeedIncrease(iSpeed));
    }
    // Speed Decrease Item Property
    iSpeed = GetLocalInt(oPC, "player_speed_decrease");
    if(iSpeed)
    {
        if(iSpeed > 99) iSpeed = 99;
        eFeat = EffectLinkEffects(eFeat, EffectMovementSpeedDecrease(iSpeed));
    }
    if(GetHasFeat(FEAT_TRAPFINDING, oPC) && !GetLevelByClass(CLASS_TYPE_ROGUE, oPC))
    {
        eFeat = EffectLinkEffects(eFeat, EffectAreaOfEffect(VFX_PER_25_FT_INVIS, "", "prc_trapfind_act"));
        if(!GetHasFeat(FEAT_KEEN_SENSE, oPC))
            eFeat = EffectLinkEffects(eFeat, EffectAreaOfEffect(VFX_PER_15_FT_INVIS, "", "prc_trapfind_pas"));
    }
    if(GetHasFeat(FEAT_SWIFTNESS_STAG, oPC))
    {
        object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);    
        int nArmour = GetBaseAC(oArmour); // Light armor only
        if (3 >= nArmour)
            eFeat = EffectLinkEffects(eFeat, EffectMovementSpeedIncrease(33));
    }    
    if(GetHasFeat(FEAT_HEART_LION, oPC))
    {
        eFeat = EffectLinkEffects(eFeat, EffectImmunity(IMMUNITY_TYPE_FEAR));
    }  
	if(GetHasFeat(FEAT_ABERRANT_INHUMAN_VISION, oPC))  
		eFeat = EffectLinkEffects(eFeat, EffectUltravision());
	if(GetHasFeat(FEAT_ABERRANT_BESTIAL_HIDE, oPC))  
		eFeat = EffectLinkEffects(eFeat, EffectACIncrease(GetAberrantFeatCount(oPC)/2, AC_NATURAL_BONUS));
		
    eFeat = SupernaturalEffect(eFeat);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFeat, oPC);
}

//////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////
void PRCFeat_AddBonusFeats(object oPC, object oSkin)
{
    if(GetHasFeat(FEAT_POWER_ATTACK, oPC))
    {
        if(GetPRCSwitch(PRC_POWER_ATTACK) != PRC_POWER_ATTACK_DISABLED)
        {
            AddSkinFeat(FEAT_POWER_ATTACK_SINGLE_RADIAL, IP_CONST_FEAT_POWER_ATTACK_SINGLE_RADIAL, oSkin, oPC);
            AddSkinFeat(FEAT_POWER_ATTACK_FIVES_RADIAL, IP_CONST_FEAT_POWER_ATTACK_FIVES_RADIAL, oSkin, oPC);
            AddSkinFeat(FEAT_POWER_ATTACK_QUICKS_RADIAL, IP_CONST_FEAT_PRC_POWER_ATTACK_QUICKS_RADIAL, oSkin, oPC);
        }
    }
    
    // If the character is missing the feats for some reason
    if(!GetHasFeat(FEAT_COMBAT_MOVE_1, oPC))
        AddSkinFeat(FEAT_COMBAT_MOVE_1, IP_CONST_FEAT_COMBAT_MOVE_1, oSkin, oPC);   
    if(!GetHasFeat(FEAT_COMBAT_MOVE_2, oPC))
        AddSkinFeat(FEAT_COMBAT_MOVE_2, IP_CONST_FEAT_COMBAT_MOVE_2, oSkin, oPC);           
    if(!GetHasFeat(FEAT_COMBAT_MOVE_3, oPC))
        AddSkinFeat(FEAT_COMBAT_MOVE_3, IP_CONST_FEAT_COMBAT_MOVE_3, oSkin, oPC);           

    if(GetHasFeat(FEAT_WILD_TALENT, oPC))
        AddSkinFeat(FEAT_PSIONIC_FOCUS, IP_CONST_FEAT_PSIONIC_FOCUS, oSkin, oPC);
	
	if(IsHiddenTalent())
	{
		AddSkinFeat(FEAT_PSIONIC_FOCUS, IP_CONST_FEAT_PSIONIC_FOCUS, oSkin, oPC);
		AddSkinFeat(FEAT_AUGMENT_PSIONICS_QUICKSELECTS, IP_CONST_FEAT_AUGMENT_PSIONICS_QUICKSELECTS, oSkin, oPC);
		AddSkinFeat(FEAT_AUGMENT_PSIONICS_DIGITS_0_4, IP_CONST_FEAT_AUGMENT_PSIONICS_DIGITS_0_4, oSkin, oPC);
		AddSkinFeat(FEAT_AUGMENT_PSIONICS_DIGITS_5_9, IP_CONST_FEAT_AUGMENT_PSIONICS_DIGITS_5_9, oSkin, oPC);
		AddSkinFeat(FEAT_AUGMENT_PSIONICS_TENS, IP_CONST_FEAT_AUGMENT_PSIONICS_TENS, oSkin, oPC);		
		AddSkinFeat(FEAT_AUGMENT_QUICKSELECTS_2, IP_CONST_FEAT_AUGMENT_QUICKSELECTS_2, oSkin, oPC);
	}	
        
    if (GetTotalEssentia(oPC))
    	AddSkinFeat(FEAT_INVEST_ESSENTIA_CONV, IP_CONST_FEAT_INVEST_ESSENTIA_CONV, oSkin, oPC);
    
    if(GetHasFeat(FEAT_TWO_WEAPON_FIGHTING, oPC) && GetPRCSwitch(PRC_35_TWO_WEAPON_FIGHTING))
        AddSkinFeat(FEAT_AMBIDEXTERITY, IP_CONST_FEAT_AMBIDEXTROUS, oSkin, oPC);        

    /*if(GetHasFeat(FEAT_DOUBLE_DRACONIC_AURA, oPC))
    {
        if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_POWER, oPC))
            AddSkinFeat(FEAT_SECOND_AURA_POWER, IP_CONST_FEAT_2ND_AURA_POWER, oSkin, oPC);

        if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_SENSES, oPC)
        || GetHasFeat(FEAT_MARSHAL_AURA_SENSES, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_SENSES, oPC))
            AddSkinFeat(FEAT_SECOND_AURA_SENSES, IP_CONST_FEAT_2ND_AURA_SENSES, oSkin, oPC);

        if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_PRESENCE, oPC)
        || GetHasFeat(FEAT_MARSHAL_AURA_PRESENCE, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_PRESENCE, oPC))
            AddSkinFeat(FEAT_SECOND_AURA_PRESENCE, IP_CONST_FEAT_2ND_AURA_PRESENCE, oSkin, oPC);

        if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_RESISTANCE, oPC))
            AddSkinFeat(FEAT_SECOND_AURA_RESISTANCE, IP_CONST_FEAT_2ND_AURA_RESISTANCE, oSkin, oPC);

        if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_ENERGYSHLD, oPC))
            AddSkinFeat(FEAT_SECOND_AURA_ENERGYSHLD, IP_CONST_FEAT_2ND_AURA_ENERGYSHLD, oSkin, oPC);

        if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_VIGOR, oPC))
            AddSkinFeat(FEAT_SECOND_AURA_VIGOR, IP_CONST_FEAT_2ND_AURA_VIGOR, oSkin, oPC);

        if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_TOUGHNESS, oPC)
        || GetHasFeat(FEAT_MARSHAL_AURA_TOUGHNESS, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_TOUGHNESS, oPC))
            AddSkinFeat(FEAT_SECOND_AURA_TOUGHNESS, IP_CONST_FEAT_2ND_AURA_TOUGHNESS, oSkin, oPC);

        if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_INSIGHT, oPC)
        || GetHasFeat(FEAT_MARSHAL_AURA_INSIGHT, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_INSIGHT, oPC))
            AddSkinFeat(FEAT_SECOND_AURA_INSIGHT, IP_CONST_FEAT_2ND_AURA_INSIGHT, oSkin, oPC);

        if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_RESOLVE, oPC)
        || GetHasFeat(FEAT_MARSHAL_AURA_RESOLVE, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_RESOLVE, oPC))
            AddSkinFeat(FEAT_SECOND_AURA_RESOLVE, IP_CONST_FEAT_2ND_AURA_RESOLVE, oSkin, oPC);

        if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_STAMINA, oPC)
        || GetHasFeat(FEAT_MARSHAL_AURA_STAMINA, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_STAMINA, oPC))
            AddSkinFeat(FEAT_SECOND_AURA_STAMINA, IP_CONST_FEAT_2ND_AURA_STAMINA, oSkin, oPC);

        if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_SWIFTNESS, oPC)
        || GetHasFeat(FEAT_MARSHAL_AURA_SWIFTNESS, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_SWIFTNESS, oPC))
            AddSkinFeat(FEAT_SECOND_AURA_SWIFTNESS, IP_CONST_FEAT_2ND_AURA_SWIFTNESS, oSkin, oPC);

        if(GetHasFeat(FEAT_MARSHAL_AURA_RESISTACID, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_RESISTACID, oPC))
            AddSkinFeat(FEAT_SECOND_AURA_RESISTACID, IP_CONST_FEAT_2ND_AURA_RESISTACID, oSkin, oPC);

        if(GetHasFeat(FEAT_MARSHAL_AURA_RESISTCOLD, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_RESISTCOLD, oPC))
            AddSkinFeat(FEAT_SECOND_AURA_RESISTCOLD, IP_CONST_FEAT_2ND_AURA_RESISTCOLD, oSkin, oPC);

        if(GetHasFeat(FEAT_MARSHAL_AURA_RESISTELEC, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_RESISTELEC, oPC))
            AddSkinFeat(FEAT_SECOND_AURA_RESISTELEC, IP_CONST_FEAT_2ND_AURA_RESISTELEC, oSkin, oPC);

        if(GetHasFeat(FEAT_MARSHAL_AURA_RESISTFIRE, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_RESISTFIRE, oPC))
            AddSkinFeat(FEAT_SECOND_AURA_RESISTFIRE, IP_CONST_FEAT_2ND_AURA_RESISTFIRE, oSkin, oPC);

        if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_MAGICPOWER, oPC)
        || GetHasFeat(FEAT_MARSHAL_AURA_MAGICPOWER, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_MAGICPOWER, oPC))
            AddSkinFeat(FEAT_SECOND_AURA_MAGICPOWER, IP_CONST_FEAT_2ND_AURA_MAGICPOWER, oSkin, oPC);

        if(GetHasFeat(FEAT_MARSHAL_AURA_ENERGYACID, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_ENERGYACID, oPC))
            AddSkinFeat(FEAT_SECOND_AURA_ENERGYACID, IP_CONST_FEAT_2ND_AURA_ENERGYACID, oSkin, oPC);

        if(GetHasFeat(FEAT_MARSHAL_AURA_ENERGYCOLD, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_ENERGYCOLD, oPC))
            AddSkinFeat(FEAT_SECOND_AURA_ENERGYCOLD, IP_CONST_FEAT_2ND_AURA_ENERGYCOLD, oSkin, oPC);

        if(GetHasFeat(FEAT_MARSHAL_AURA_ENERGYELEC, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_ENERGYELEC, oPC))
            AddSkinFeat(FEAT_SECOND_AURA_ENERGYELEC, IP_CONST_FEAT_2ND_AURA_ENERGYELEC, oSkin, oPC);

        if(GetHasFeat(FEAT_MARSHAL_AURA_ENERGYFIRE, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_ENERGYFIRE, oPC))
            AddSkinFeat(FEAT_SECOND_AURA_ENERGYFIRE, IP_CONST_FEAT_2ND_AURA_ENERGYFIRE, oSkin, oPC);

        if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_ENERGY, oPC))
            AddSkinFeat(FEAT_SECOND_AURA_ENERGY, IP_CONST_FEAT_2ND_AURA_ENERGY, oSkin, oPC);
    }

    if(GetHasFeat(FEAT_BONUS_AURA_INSIGHT, oPC)
       || GetHasFeat(FEAT_BONUS_AURA_PRESENCE, oPC)
       || GetHasFeat(FEAT_BONUS_AURA_RESISTACID, oPC)
       || GetHasFeat(FEAT_BONUS_AURA_RESISTCOLD, oPC)
       || GetHasFeat(FEAT_BONUS_AURA_RESISTELEC, oPC)
       || GetHasFeat(FEAT_BONUS_AURA_RESISTFIRE, oPC)
       || GetHasFeat(FEAT_BONUS_AURA_RESOLVE, oPC)
       || GetHasFeat(FEAT_BONUS_AURA_STAMINA, oPC)
       || GetHasFeat(FEAT_BONUS_AURA_SENSES, oPC)
       || GetHasFeat(FEAT_BONUS_AURA_SWIFTNESS, oPC)
       || GetHasFeat(FEAT_BONUS_AURA_TOUGHNESS, oPC))
    {
        int nFeat = FEAT_BONUS_DRACONIC_AURA_LEVEL_1;
        int ipFeat = IP_CONST_FEAT_BONUS_AURA_1;

        AddSkinFeat(nFeat, ipFeat, oSkin, oPC);
    }*/
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
#include "NW_I0_GENERIC"
#include "inc_persist_loca"

void PRCFeat_AddCompositeBonuses(object oPC, object oSkin)
{
    int nAlignmentGoodEvil = GetAlignmentGoodEvil(oPC);
    int nAlignmentLawChaos = GetAlignmentLawChaos(oPC);
	
    if(GetSkillRank(SKILL_JUMP, oPC) > 4)
        SetCompositeBonus(oSkin, "SkillJTum", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_TUMBLE);
	
	if(GetHasFeat(FEAT_GIFTOFFAITH, oPC) || GetLocalInt(oPC, "VoPFeat"+IntToString(FEAT_GIFTOFFAITH)))
	{
		SetCompositeBonus(oSkin, "GiftOfFaith", 2, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_FEAR);
	}
	
    if(nAlignmentGoodEvil == ALIGNMENT_GOOD)
    {
        if(GetHasFeat(FEAT_SAC_VOW, oPC))
            SetCompositeBonus(oSkin, "SacredPer", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);

		if(GetHasFeat(FEAT_VOWOFPOVERTY, oPC)) 
		{
			if(!GetPersistantLocalInt(oPC,"VoPLevel1")) SetPersistantLocalInt(oPC,"VoPLevel1",GetCharacterLevel(oPC));
			ExecuteScript("ft_vowofpoverty", oPC);
		}
		
        if(nAlignmentLawChaos == ALIGNMENT_LAWFUL)
        {
            if(GetHasFeat(FEAT_VOW_OBED, oPC) || GetLocalInt(oPC, "VoPFeat"+IntToString(FEAT_VOW_OBED)))
                SetCompositeBonus(oSkin, "VowObed", 4, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_WILL);
        }
        if(GetHasFeat(FEAT_VOW_PURITY, oPC) || GetLocalInt(oPC, "VoPFeat"+IntToString(FEAT_VOW_PURITY)))
        {
            SetCompositeBonus(oSkin, "VowPurity_De", 1, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_DEATH);
            SetCompositeBonus(oSkin, "VowPurity_Di", 1, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_DISEASE);
        }
		if(GetHasFeat(FEAT_VOWABSTINENCE, oPC) || GetLocalInt(oPC, "VoPFeat"+IntToString(FEAT_VOWABSTINENCE)))
        {
            SetCompositeBonus(oSkin, "VowAbstinence", 4, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_POISON);
        }       
		if(GetHasFeat(FEAT_VOWCHASTITY, oPC) || GetLocalInt(oPC, "VoPFeat"+IntToString(FEAT_VOWCHASTITY)))
        {
            SetCompositeBonus(oSkin, "VowChastity", 4, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_MINDAFFECTING);
        }  		
    }
    else if(nAlignmentGoodEvil == ALIGNMENT_EVIL)
    {
        if(GetHasFeat(FEAT_LICHLOVED, oPC))
        {
            SetCompositeBonus(oSkin, "LichLovedM", 1, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_MINDAFFECTING);
            SetCompositeBonus(oSkin, "LichLovedP", 1, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_POISON);
            SetCompositeBonus(oSkin, "LichLovedD", 1, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_DISEASE);
        }

        if(GetHasFeat(FEAT_VILE_WILL_DEFORM, oPC))
            SetCompositeBonus(oSkin, "WillDeform", 2, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);

        if(GetHasFeat(FEAT_VILE_DEFORM_OBESE, oPC) && !GetHasFeat(FEAT_VILE_DEFORM_GAUNT, oPC))
        {
            if(!GetPersistantLocalInt(oPC, "NWNX_DeformObese"))
            {
                SetCompositeBonus(oSkin, "DeformObeseCon", 2, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_CON);
                SetCompositeBonus(oSkin, "DeformObeseDex", 2, ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_DEX);
            }
            SetCompositeBonus(oSkin, "DeformObeseIntim", 2, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);
            SetCompositeBonus(oSkin, "DeformObesePoison", 2, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_POISON);
        }

        if(GetHasFeat(FEAT_VILE_DEFORM_GAUNT, oPC) && !GetHasFeat(FEAT_VILE_DEFORM_OBESE, oPC))
        {
            if(!GetPersistantLocalInt(oPC, "NWNX_DeformGaunt"))
            {
                SetCompositeBonus(oSkin, "DeformGauntDex", 2, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_DEX);
                SetCompositeBonus(oSkin, "DeformGauntCon", 2, ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_CON);
            }
            SetCompositeBonus(oSkin, "DeformGauntIntim", 2, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);
            SetCompositeBonus(oSkin, "DeformGauntHide", 2, ITEM_PROPERTY_SKILL_BONUS,SKILL_HIDE);
            SetCompositeBonus(oSkin, "DeformGauntMS", 2, ITEM_PROPERTY_SKILL_BONUS,SKILL_MOVE_SILENTLY);
        }

        if(GetHasFeat(FEAT_DEFORM_EYES, oPC))
            SetCompositeBonus(oSkin, "DeformEyes", 2, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_SPOT);
        if(GetHasFeat(FEAT_VILE_DEFORM_SKIN, oPC))
            SetCompositeBonus(oSkin, "DeformSkin", 1, AC_NATURAL_BONUS, ITEM_PROPERTY_AC_BONUS);
    }

    if(GetHasFeat(FEAT_TACTILE_TRAPSMITH, oPC))
    {
        int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
        int nDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
        int nMod = nDex - nInt;

        if(nMod > 0)
        {
            SetCompositeBonus(oSkin, "TactileTrapsmithSearchIncrease", nMod, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
            SetCompositeBonus(oSkin, "TactileTrapsmithDisableIncrease", nMod, ITEM_PROPERTY_SKILL_BONUS, SKILL_DISABLE_TRAP);
            SetCompositeBonus(oSkin, "TactileTrapsmithSearchDecrease", 0, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_SEARCH);
            SetCompositeBonus(oSkin, "TactileTrapsmithDisableDecrease", 0, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_DISABLE_TRAP);
        }
        else if(nMod < 0)
        {
            SetCompositeBonus(oSkin, "TactileTrapsmithSearchDecrease", -nMod, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_SEARCH);
            SetCompositeBonus(oSkin, "TactileTrapsmithDisableDecrease", -nMod, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_DISABLE_TRAP);
            SetCompositeBonus(oSkin, "TactileTrapsmithSearchIncrease", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
            SetCompositeBonus(oSkin, "TactileTrapsmithDisableIncrease", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_DISABLE_TRAP);
        }
    }
    if(GetHasFeat(FEAT_KEEN_INTELLECT, oPC))
    {
        int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
        int nWis = GetAbilityModifier(ABILITY_WISDOM, oPC);
        int nMod = nInt - nWis;

        if(nMod > 0)
        {
            SetCompositeBonus(oSkin, "KeenSensesH", nMod, ITEM_PROPERTY_SKILL_BONUS, SKILL_HEAL);
            SetCompositeBonus(oSkin, "KeenSensesSM", nMod, ITEM_PROPERTY_SKILL_BONUS, SKILL_SENSE_MOTIVE);
            SetCompositeBonus(oSkin, "KeenSensesSP", nMod, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
            SetCompositeBonus(oSkin, "KeenSensesWill", nMod, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_WILL);
        }
        else if(nMod < 0)
        {
            SetCompositeBonus(oSkin, "KeenSensesH", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_HEAL);
            SetCompositeBonus(oSkin, "KeenSensesSM", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_SENSE_MOTIVE);
            SetCompositeBonus(oSkin, "KeenSensesSP", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
            SetCompositeBonus(oSkin, "KeenSensesWill", 0, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_WILL);
        }
    }   
    if(GetHasFeat(FEAT_VREMYONNI_TRAINING, oPC))
    {
        SetCompositeBonus(oSkin, "VremyonniL", 2, ITEM_PROPERTY_SKILL_BONUS,SKILL_LORE);
        SetCompositeBonus(oSkin, "VremyonniS", 2, ITEM_PROPERTY_SKILL_BONUS,SKILL_SPELLCRAFT);
    }    
    if(GetHasFeat(FEAT_INVESTIGATOR, oPC))
    {
        SetCompositeBonus(oSkin, "InvestigatorSenseMotive", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_SENSE_MOTIVE);
        SetCompositeBonus(oSkin, "InvestogatorSearch", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
    }  	
    if(GetHasFeat(FEAT_UNDEAD_HD, oPC))
    {
        int nClass1 = GetClassByPosition(1, oPC);
        int nClass2 = GetClassByPosition(2, oPC);
        int nClass3 = GetClassByPosition(3, oPC);
        int nClass4 = GetClassByPosition(4, oPC);
        int nClass5 = GetClassByPosition(5, oPC);
        int nClass6 = GetClassByPosition(6, oPC);
        int nClass7 = GetClassByPosition(7, oPC);
        int nClass8 = GetClassByPosition(8, oPC);
		
        int nClass1Lvl = GetLevelByClass(nClass1, oPC);
        int nClass2Lvl = GetLevelByClass(nClass2, oPC);
        int nClass3Lvl = GetLevelByClass(nClass3, oPC);
        int nClass4Lvl = GetLevelByClass(nClass4, oPC);
        int nClass5Lvl = GetLevelByClass(nClass5, oPC);
        int nClass6Lvl = GetLevelByClass(nClass6, oPC);
		int nClass7Lvl = GetLevelByClass(nClass7, oPC);
        int nClass8Lvl = GetLevelByClass(nClass8, oPC);
		
        int nLevel = nClass1Lvl + nClass2Lvl + nClass3Lvl + nClass4Lvl + nClass5Lvl + nClass6Lvl + nClass7Lvl + nClass8Lvl;

        int nDie1 = StringToInt(Get2DAString("classes", "HitDie", nClass1));
        int nDie2 = StringToInt(Get2DAString("classes", "HitDie", nClass2));
        int nDie3 = StringToInt(Get2DAString("classes", "HitDie", nClass3));
		int nDie4 = StringToInt(Get2DAString("classes", "HitDie", nClass4));
        int nDie5 = StringToInt(Get2DAString("classes", "HitDie", nClass5));
        int nDie6 = StringToInt(Get2DAString("classes", "HitDie", nClass6));
		int nDie7 = StringToInt(Get2DAString("classes", "HitDie", nClass7));
        int nDie8 = StringToInt(Get2DAString("classes", "HitDie", nClass8));
		
		int nFortPenalty = (nLevel * 12 - (nClass1Lvl * nDie1 + 
											nClass2Lvl * nDie2 + 
											nClass3Lvl * nDie3 +
											nClass4Lvl * nDie4 +
											nClass5Lvl * nDie5 +
											nClass6Lvl * nDie6 +
											nClass7Lvl * nDie7 +
											nClass8Lvl * nDie8))/nLevel;				

/*         int nFortPenalty = (nLevel * 12 - (nClass1Lvl * nDie1 + nClass2Lvl * nDie2 + nClass3Lvl * nDie3))/nLevel; */
		
        if(nFortPenalty > 6)
            nFortPenalty = 6;
        int nConBonus = nFortPenalty * 2;

        if(nFortPenalty > 0)
        {
            //Make the CON bonus what it should be
            SetCompositeBonus(oSkin, "PRCUndeadHD", nConBonus, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON);
            //Fort Penalty
            SetCompositeBonus(oSkin, "PRCUndeadFSPen", nFortPenalty, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
        }
    }
    if(GetHasFeat(FEAT_TURN_RESISTANCE, oPC))
    {
        int nTurnResist = 2;
        if(nAlignmentGoodEvil == ALIGNMENT_GOOD)
            nTurnResist += GetLevelByClass(CLASS_TYPE_BAELNORN);
        SetCompositeBonus(oSkin, "TurnRes", nTurnResist, ITEM_PROPERTY_TURN_RESISTANCE);
    }
    if(GetHasFeat(FEAT_ETTERCAP_BERSERKER, oPC))
        SetCompositeBonus(oSkin, "Ettercap_Poison", 2, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_POISON);
        
    if(GetHasFeat(FEAT_IMPROVED_TURN_RESISTANCE, oPC))
        SetCompositeBonus(oSkin, "ImpTurnRes", 4, ITEM_PROPERTY_TURN_RESISTANCE);

    if(GetHasFeat(FEAT_COMBAT_MANIFESTATION, oPC))
        SetCompositeBonus(oSkin, "Combat_Mani", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_CONCENTRATION);

    if(GetHasFeat(FEAT_MAGICAL_APTITUDE, oPC))
    {
        SetCompositeBonus(oSkin, "MagicalAptitudeSpellcraft", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPELLCRAFT);
        SetCompositeBonus(oSkin, "MagicalAptitudeUMD", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_USE_MAGIC_DEVICE);
    }
    if(GetHasFeat(FEAT_PERSUASIVE, oPC))
    {
        SetCompositeBonus(oSkin, "PersuasiveBluff", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_BLUFF);
        SetCompositeBonus(oSkin, "PersuasiveIntim", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE);
    }
    if(GetHasFeat(FEAT_ENDURANCE, oPC))
        SetCompositeBonus(oSkin, "EnduranceBonus", 4, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_DEATH);

    if(GetHasFeat(FEAT_TRACK, oPC))
    {
        SetCompositeBonus(oSkin, "TrackSkillSP", 1, ITEM_PROPERTY_SKILL_BONUS,SKILL_SPOT);
        SetCompositeBonus(oSkin, "TrackSkillSR", 1, ITEM_PROPERTY_SKILL_BONUS,SKILL_SEARCH);
        SetCompositeBonus(oSkin, "TrackSkillLS", 1, ITEM_PROPERTY_SKILL_BONUS,SKILL_LISTEN);
    }

    if(GetGender(oPC) == GENDER_FEMALE && GetHasFeat(FEAT_ETHRAN, oPC))
    {
        SetCompositeBonus(oSkin, "EthranA", 2, ITEM_PROPERTY_SKILL_BONUS,SKILL_ANIMAL_EMPATHY);
        SetCompositeBonus(oSkin, "EthranP", 2, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERFORM);
        SetCompositeBonus(oSkin, "EthranPe", 2, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERSUADE);
        SetCompositeBonus(oSkin, "EthranS", 2, ITEM_PROPERTY_SKILL_BONUS,SKILL_SENSE_MOTIVE);
        SetCompositeBonus(oSkin, "EthranB", 2, ITEM_PROPERTY_SKILL_BONUS,SKILL_BLUFF);
        SetCompositeBonus(oSkin, "EthranI", 2, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);
    }

    int iRegen = (GetHasFeat(FAST_HEALING_1, oPC)
                + GetHasFeat(FAST_HEALING_2, oPC)
                + GetHasFeat(FAST_HEALING_3, oPC));
    if(iRegen)
        SetCompositeBonus(oSkin, "FastHealing", iRegen * 3, ITEM_PROPERTY_REGENERATION);

    if(GetHasFeat(FEAT_OBSCURE_LORE, oPC))
        SetCompositeBonus(oSkin, "ObscureLore", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE);

    if(GetHasFeat(FEAT_HEAVY_LITHODERMS, oPC))
        SetCompositeBonus(oSkin, "HeavyLithoderms", 1, AC_NATURAL_BONUS, ITEM_PROPERTY_AC_BONUS);

    if(GetHasFeat(FEAT_MORADINS_SMILE, oPC))
    {
        SetCompositeBonus(oSkin, "MoradinsSmileA",   2, ITEM_PROPERTY_SKILL_BONUS,SKILL_ANIMAL_EMPATHY);
        SetCompositeBonus(oSkin, "MoradinsSmileP",   2, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERFORM);
        SetCompositeBonus(oSkin, "MoradinsSmilePe",  2, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERSUADE);
        SetCompositeBonus(oSkin, "MoradinsSmileT",   2, ITEM_PROPERTY_SKILL_BONUS,SKILL_SENSE_MOTIVE);
        SetCompositeBonus(oSkin, "MoradinsSmileUMD", 2, ITEM_PROPERTY_SKILL_BONUS,SKILL_USE_MAGIC_DEVICE);
        SetCompositeBonus(oSkin, "MoradinsSmileI",   2, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);
        SetCompositeBonus(oSkin, "MoradinsSmileIj",  2, ITEM_PROPERTY_SKILL_BONUS,SKILL_IAIJUTSU_FOCUS);
    }

    if(GetHasFeat(FEAT_MENACING_DEMEANOUR, oPC))
        SetCompositeBonus(oSkin, "MenacingDemeanour", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE);

    if(GetHasFeat(FEAT_RELIC_HUNTER, oPC))
    {
        SetCompositeBonus(oSkin, "RelicHunterL", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE);
        SetCompositeBonus(oSkin, "RelicHunterA", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_APPRAISE);
    }

    if(GetHasFeat(FEAT_SHADOW_AND_STEALTH, oPC))
    {
        int nShadBonus = GetLevelByClass(CLASS_TYPE_SHADOWBLADE, oPC) / 2;
        SetCompositeBonus(oSkin, "ShdStlthH", nShadBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
        SetCompositeBonus(oSkin, "ShdStlthMS", nShadBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
    }
    
    if(GetHasFeat(FEAT_EFFICIENT_DEFENDER, oPC))
    {
    //:: Light or medium armor only
		object oArmor 	= GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

		int nEvent 		= GetRunningEvent();
		int nBaseAC		= GetBaseAC(oArmor);
		
		if(DEBUG) FloatingTextStringOnCreature("prc_feats: Efficient Defender running", oPC, FALSE);
		
		if(nBaseAC > 0 && nBaseAC < 6)	
		{
			if (DEBUG) FloatingTextStringOnCreature("prc_feats: Efficient Defender: Light or medium armor found", oPC, FALSE);
			SetCompositeBonus(oSkin, "EfficientDefender", 1, ITEM_PROPERTY_AC_BONUS);
            SetCompositeBonus(oSkin, "EDACPHide", 1, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_HIDE);
            SetCompositeBonus(oSkin, "EDACPMS", 1, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_MOVE_SILENTLY);
            SetCompositeBonus(oSkin, "EDACPParry", 1, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_PARRY);
            SetCompositeBonus(oSkin, "EDACPPP", 1, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_PICK_POCKET);
            SetCompositeBonus(oSkin, "EDACPSetT", 1, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_SET_TRAP);
            SetCompositeBonus(oSkin, "EDACPTumble", 1, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_TUMBLE);
            SetCompositeBonus(oSkin, "EDACPJump", 1, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_JUMP);
            SetCompositeBonus(oSkin, "EDACPBalance", 1, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_BALANCE);
            SetCompositeBonus(oSkin, "EDACPClimb", 1, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_CLIMB);
        }
		else
		{
			if (DEBUG) FloatingTextStringOnCreature("prc_feats: Efficient Defender: No light or medium armor found", oPC, FALSE);
			SetCompositeBonus(oSkin, "EfficientDefender", 0, ITEM_PROPERTY_AC_BONUS);
            SetCompositeBonus(oSkin, "EDACPHide", 0, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_HIDE);
            SetCompositeBonus(oSkin, "EDACPMS", 0, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_MOVE_SILENTLY);
            SetCompositeBonus(oSkin, "EDACPParry", 0, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_PARRY);
            SetCompositeBonus(oSkin, "EDACPPP", 0, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_PICK_POCKET);
            SetCompositeBonus(oSkin, "EDACPSetT", 0, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_SET_TRAP);
            SetCompositeBonus(oSkin, "EDACPTumble", 0, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_TUMBLE);
            SetCompositeBonus(oSkin, "EDACPJump", 0, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_JUMP);
            SetCompositeBonus(oSkin, "EDACPBalance", 0, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_BALANCE);
            SetCompositeBonus(oSkin, "EDACPClimb", 0, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_CLIMB);			
		}
    }  
    if(GetHasFeat(FEAT_MOUNTAINEER, oPC))
    {
       SetCompositeBonus(oSkin, "MountaineerC", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_CLIMB);
       SetCompositeBonus(oSkin, "MountaineerS", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
    }   
    if(GetHasFeat(FEAT_DOMAIN_WINTER, oPC))
    {
        SetCompositeBonus(oSkin, "WinterDomainH", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_HEAL);
        SetCompositeBonus(oSkin, "WinterDomainS", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
        SetCompositeBonus(oSkin, "WinterDomainL", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_LISTEN);
        SetCompositeBonus(oSkin, "WinterDomainM", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_SENSE_MOTIVE);
    }     
    if(GetHasFeat(FEAT_UNSPEAKABLE_VOW, oPC))
    {
       SetCompositeBonus(oSkin, "UnspeakableVow", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE);
    }   
    if(GetHasFeat(FEAT_GREAT_DIPLOMAT, oPC))
    {
       SetCompositeBonus(oSkin, "GreatDiplomat", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);
    }   
    if(GetHasFeat(FEAT_ECCLESIARCH, oPC))
    {
       SetCompositeBonus(oSkin, "Ecclesiarch", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE);
    } 
    if(GetHasFeat(FEAT_EYES_HAWK, oPC))
    {
       SetCompositeBonus(oSkin, "EyesOfTheHawk", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
    }     
    if(GetHasFeat(FEAT_SWIFT_TRACKER, oPC))
    {
        SetCompositeBonus(oSkin, "SwiftTrackS", 1, ITEM_PROPERTY_SKILL_BONUS,SKILL_SPOT);
        SetCompositeBonus(oSkin, "SwiftTrackR", 1, ITEM_PROPERTY_SKILL_BONUS,SKILL_SEARCH);
        SetCompositeBonus(oSkin, "SwiftTrackL", 1, ITEM_PROPERTY_SKILL_BONUS,SKILL_LISTEN);
    }
    if(GetHasFeat(FEAT_JUGG_RESERVED, oPC))
    {
        int nPen = GetLevelByClass(CLASS_TYPE_WARFORGED_JUGGERNAUT, oPC) * -1;
        SetCompositeBonus(oSkin, "JuggernautB", nPen, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_BLUFF);
        SetCompositeBonus(oSkin, "JuggernautS", nPen, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_SENSE_MOTIVE);
        SetCompositeBonus(oSkin, "JuggernautP", nPen, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_PERSUADE);
    }     

    //Inherent Bonuses to abilities
    if(GetPersistantLocalInt(oPC, "PRC_InherentBonus"))
    {
        int i, nBonus, iTest, nDiff;
        string sAbi;
        for(i = 0; i < 6; i++)
        {
            sAbi = IntToString(i);
            nBonus = GetPersistantLocalInt(oPC, "PRC_InherentBonus_"+sAbi);
            iTest = GetPersistantLocalInt(oPC, "NWNX_InherentBonus_"+sAbi);
            nDiff = nBonus - iTest;
            if(nDiff)
                SetCompositeBonus(oSkin, "InherentBonus"+sAbi, nDiff, ITEM_PROPERTY_ABILITY_BONUS, i);
        }
    }

    //new skill focuses
    if(GetHasFeat(FEAT_SKILL_FOCUS_ALCHEMY, oPC))
        SetCompositeBonus(oSkin, "SkillFoc_Alchemy",  3, ITEM_PROPERTY_SKILL_BONUS, SKILL_CRAFT_ALCHEMY);

    if(GetHasFeat(FEAT_EPIC_SKILL_FOCUS_ALCHEMY, oPC))
        SetCompositeBonus(oSkin, "EpicSkillFoc_Alchemy", 10, ITEM_PROPERTY_SKILL_BONUS, SKILL_CRAFT_ALCHEMY);

    if(GetHasFeat(FEAT_SKILL_FOCUS_RIDE, oPC))
        SetCompositeBonus(oSkin, "SkillFoc_Ride",  3, ITEM_PROPERTY_SKILL_BONUS, SKILL_RIDE);

    if(GetHasFeat(FEAT_EPIC_SKILL_FOCUS_RIDE, oPC))
        SetCompositeBonus(oSkin, "EpicSkillFoc_Ride", 10, ITEM_PROPERTY_SKILL_BONUS, SKILL_RIDE);

    if(GetHasFeat(FEAT_SKILL_FOCUS_JUMP, oPC))
        SetCompositeBonus(oSkin, "SkillFoc_Jump",  3, ITEM_PROPERTY_SKILL_BONUS, SKILL_JUMP);

    if(GetHasFeat(FEAT_EPIC_SKILL_FOCUS_JUMP, oPC))
        SetCompositeBonus(oSkin, "EpicSkillFoc_Jump", 10, ITEM_PROPERTY_SKILL_BONUS, SKILL_JUMP);

    if(GetHasFeat(FEAT_SKILL_FOCUS_SENSE_MOTIVE, oPC))
        SetCompositeBonus(oSkin, "SkillFoc_SenseMotive",  3, ITEM_PROPERTY_SKILL_BONUS, SKILL_SENSE_MOTIVE);

    if(GetHasFeat(FEAT_EPIC_SKILL_FOCUS_SENSE_MOTIVE, oPC))
        SetCompositeBonus(oSkin, "EpicSkillFoc_SenseMotive", 10, ITEM_PROPERTY_SKILL_BONUS, SKILL_SENSE_MOTIVE);

    if(GetHasFeat(FEAT_SKILL_FOCUS_MARTIAL_LORE, oPC))
        SetCompositeBonus(oSkin, "SkillFoc_MartialLore",  3, ITEM_PROPERTY_SKILL_BONUS, SKILL_MARTIAL_LORE);

    if(GetHasFeat(FEAT_EPIC_SKILL_FOCUS_MARTIAL_LORE, oPC))
        SetCompositeBonus(oSkin, "EpicSkillFoc_MartialLore", 10, ITEM_PROPERTY_SKILL_BONUS, SKILL_MARTIAL_LORE);

    if(GetHasFeat(FEAT_SKILL_FOCUS_BALANCE, oPC))
        SetCompositeBonus(oSkin, "SkillFoc_Balance",  3, ITEM_PROPERTY_SKILL_BONUS, SKILL_BALANCE);

    if(GetHasFeat(FEAT_EPIC_SKILL_FOCUS_BALANCE, oPC))
        SetCompositeBonus(oSkin, "EpicSkillFoc_Balance", 10, ITEM_PROPERTY_SKILL_BONUS, SKILL_BALANCE);

    if(GetHasFeat(FEAT_SKILL_FOCUS_CRAFT_POISON, oPC))
        SetCompositeBonus(oSkin, "SkillFoc_CraftPoison",  3, ITEM_PROPERTY_SKILL_BONUS, SKILL_CRAFT_POISON);

    if(GetHasFeat(FEAT_EPIC_SKILL_FOCUS_CRAFT_POISON, oPC))
        SetCompositeBonus(oSkin, "EpicSkillFoc_CraftPoison", 10, ITEM_PROPERTY_SKILL_BONUS, SKILL_CRAFT_POISON);

    if(GetHasFeat(FEAT_SKILL_FOCUS_PSICRAFT, oPC))
        SetCompositeBonus(oSkin, "SkillFoc_Psicraft",  3, ITEM_PROPERTY_SKILL_BONUS, SKILL_PSICRAFT);

    if(GetHasFeat(FEAT_EPIC_SKILL_FOCUS_PSICRAFT, oPC))
        SetCompositeBonus(oSkin, "EpicSkillFoc_Psicraft", 10, ITEM_PROPERTY_SKILL_BONUS, SKILL_PSICRAFT);

    if(GetHasFeat(FEAT_SKILL_FOCUS_CLIMB, oPC))
        SetCompositeBonus(oSkin, "SkillFoc_Climb",  3, ITEM_PROPERTY_SKILL_BONUS, SKILL_CLIMB);

    if(GetHasFeat(FEAT_EPIC_SKILL_FOCUS_CLIMB, oPC))
        SetCompositeBonus(oSkin, "EpicSkillFoc_Climb", 10, ITEM_PROPERTY_SKILL_BONUS, SKILL_CLIMB);

    if(GetHasFeat(FEAT_SKILL_FOCUS_CRAFT_GENERAL, oPC))
        SetCompositeBonus(oSkin, "SkillFoc_CraftGeneral",  3, ITEM_PROPERTY_SKILL_BONUS, SKILL_CRAFT_GENERAL);

    if(GetHasFeat(FEAT_EPIC_SKILL_FOCUS_CRAFT_GENERAL, oPC))
        SetCompositeBonus(oSkin, "EpicSkillFoc_CraftGeneral", 10, ITEM_PROPERTY_SKILL_BONUS, SKILL_CRAFT_GENERAL);
        
    if(GetHasFeat(FEAT_MASTER_OF_KNOWLEDGE, oPC))
        SetCompositeBonus(oSkin, "MasterofKnowledge", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE); 

	if(GetHasFeat(FEAT_NEGOTIATOR, oPC))
	{
		SetCompositeBonus(oSkin, "NegotiatorPersuade", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE); 
		SetCompositeBonus(oSkin, "NegotiatorSenseMotive", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_SENSE_MOTIVE);
    }
    
    // Aberrant Feats here
    if(GetHasFeat(FEAT_ABERRANT_EYES, oPC))
        SetCompositeBonus(oSkin, "AberrantBlood_Eye", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
    if(GetHasFeat(FEAT_ABERRANT_SEGMENT, oPC))
        SetCompositeBonus(oSkin, "AberrantBlood_Segment", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
    if(GetHasFeat(FEAT_ABERRANT_FINGERS, oPC))
        SetCompositeBonus(oSkin, "AberrantBlood_Fingers", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_CLIMB);
    if(GetHasFeat(FEAT_ABERRANT_TAIL, oPC))
        SetCompositeBonus(oSkin, "AberrantBlood_Tail", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_BALANCE);        
    if(GetHasFeat(FEAT_ABERRANT_INHUMAN_VISION, oPC))
        SetCompositeBonus(oSkin, "AberrantBlood_Vis", GetAberrantFeatCount(oPC), ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);        
    if(GetHasFeat(FEAT_ABERRANT_SCAVENGING_GULLET, oPC))
    {
        SetCompositeBonus(oSkin, "AberrantBlood_Sca", 4, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_POISON);
        SetCompositeBonus(oSkin, "AberrantBlood_Gul", 4, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_DISEASE);
    }        
        
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
void PRCFeat_AddEventHooks(object oPC, object oSkin)
{
    string sScript;
    if(GetHasFeat(FEAT_DRAGONFIRE_STRIKE, oPC))
    {
        sScript = "prc_dragfire_atk";
        AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   sScript, TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, sScript, TRUE, FALSE);
    }

	// Check if the player is a Ranger, wearing medium/heavy armor, and does not have Two-Weapon Fighting feat
	int bIsRestricted = FALSE;

	// Check if the player has levels in the Ranger class
	if (GetLevelByClass(CLASS_TYPE_RANGER, oPC) > 0)
	{
		// Check if the player is wearing medium or heavy armor
		int nArmorType = GetArmorType(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC));
		if (nArmorType == ARMOR_TYPE_MEDIUM || nArmorType == ARMOR_TYPE_HEAVY)
		{
			// Check if the player does not have the Two-Weapon Fighting feat
			if (!GetHasFeat(FEAT_TWO_WEAPON_FIGHTING, oPC))
			{
				// Set the restricted flag to TRUE if all conditions are met
				bIsRestricted = TRUE;
			}
		}
	}

	// Proceed with the original logic only if the restrictions are not met
	if (!bIsRestricted)
	{
		if (GetHasFeat(FEAT_TWO_WEAPON_REND, oPC))
		{
			string sScript = "prc_tw_rend";
			AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   sScript, TRUE, FALSE);
			AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, sScript, TRUE, FALSE);
		}
	}

    if(GetHasFeat(FEAT_LINGERING_DAMAGE, oPC))
    {
        sScript = "ft_lingdmg";
        AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   sScript, TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, sScript, TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONHIT,               sScript, TRUE, FALSE);
    }
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
void PRCFeat_AddMisc(object oPC, object oSkin)
{
    if(GetPersistantLocalInt(oPC, "EpicSpell_TransVital"))
    {
        IPSafeAddItemProperty(oSkin, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        IPSafeAddItemProperty(oSkin, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        SetCompositeBonus(oSkin, "TransVitalRegen", 1, ITEM_PROPERTY_REGENERATION);
        if(!GetPersistantLocalInt(oPC, "NWNX_TransVital"))
            SetCompositeBonus(oSkin, "TransVitalCon", 5, ITEM_PROPERTY_ABILITY_BONUS, ABILITY_CONSTITUTION);
    }

    if(GetHasFeat(FEAT_IMMUNITY_ABILITY_DECREASE, oPC) || GetHasFeat(FEAT_SH_IMMUNITY_LEVEL_DRAIN, oPC))
        IPSafeAddItemProperty(oSkin, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

    if(GetHasFeat(FEAT_IMMUNITY_CRITICAL, oPC))
        IPSafeAddItemProperty(oSkin, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

    if(GetHasFeat(FEAT_IMMUNITY_DEATH, oPC))
        IPSafeAddItemProperty(oSkin, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DEATH_MAGIC), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

    if(GetHasFeat(FEAT_IMMUNITY_DISEASE, oPC) || GetHasFeat(FEAT_SH_IMMUNITY_DISEASE, oPC))
        IPSafeAddItemProperty(oSkin, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

    if(GetHasFeat(FEAT_IMMUNITY_MIND_SPELLS, oPC))
        IPSafeAddItemProperty(oSkin, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

    if(GetHasFeat(FEAT_IMMUNITY_PARALYSIS, oPC) || GetHasFeat(FEAT_SH_IMMUNITY_PARALYSIS, oPC))
        IPSafeAddItemProperty(oSkin, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

    if(GetHasFeat(FEAT_IMMUNITY_POISON, oPC))
        IPSafeAddItemProperty(oSkin, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

    if(GetHasFeat(FEAT_IMMUNITY_SNEAKATTACK, oPC))
        IPSafeAddItemProperty(oSkin, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        
    if(GetHasFeat(FEAT_IMP_HEAT_ENDURANCE, oPC))
        IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_5), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

    if(GetHasFeat(FEAT_IMP_COLD_ENDURANCE, oPC))
        IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_5), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);        
}