/*
   ----------------
   prc_enforce_feat
   ----------------

   7/25/04 by Stratovarius

   This script is used to enforce the proper selection of bonus feats
   so that people cannot use epic bonus feats and class bonus feats to
   select feats they should not be allowed to.
*/

//#include "prc_alterations"
#include "prc_inc_sneak"
#include "psi_inc_psifunc"
#include "tob_inc_tobfunc"
#include "moi_inc_moifunc"
#include "inv_inc_invfunc"
#include "inc_ecl"
#include "inc_epicspells"
#include "prc_inc_shifting"

//  Prevents a Man at Arms from taking improved critical
//  in a weapon that he does not have focus in.
int ManAtArmsFeats();

// Enforces the proper selection of the Red Wizard feats
// that are used to determine restricted and specialist
// spell schools. You must have two restricted and one specialist.
int RedWizardFeats();

// Enforces the proper selection of the Mage Killer
// Bonus Save feats.
int MageKiller();

// Enforces the proper selection of the Vile feats
// and prevents illegal stacking of them
int VileFeats();

// Enforces the proper selection of the Ultimate Ranger feats
// and prevents illegal use of bonus feats.
int UltiRangerFeats();

// Stops PCs from having more than one Elemental Savant Class
// as its supposed to be only one class, not 8.
int ElementalSavant();

// Enforces Genasai taking the proper elemental domain
int GenasaiFocus();

// Prevents a player from taking Lingering Damage without
// have 8d6 sneak attack
int LingeringDamage();

// check for server restricted feats/skills
int PWSwitchRestructions();

// Applies when a Marshal can select a Major or Minor Aura
int MarshalAuraLimit();

// Stops people from taking feats they cannot use because of caster levels.
int CasterFeats();

// Stops people from taking the blightbringer domain, since its prestige
//int Blightbringer();

// Stop people from taking crafting feats they don't have the caster level for
int CraftingFeats();

// Stop people from taking Sudden Metamagic feats they don't have the prereqs
int SuddenMetamagic();

// This is for feats that have more than two skill requirements. It's fairly generic
int SkillRequirements();

// This is for feats that need races. It's fairly generic
int RacialFeats();

// Acolyte of the Ego cadences
int AcolyteEgo();

// Tome of Battle feats
int ToB();

// Internal Function
int _GetSizeForPrereq(object oPC)
{
	int nSize = PRCGetCreatureSize(oPC);
	if (GetHasFeat(FEAT_RACE_POWERFUL_BUILD, oPC)) nSize++;
	
	return nSize;
}

// ---------------
// BEGIN FUNCTIONS
// ---------------

int ManAtArmsFeats()
{
    // only continue if they are a MaA taking level 3
    if(GetLevelByClass(CLASS_TYPE_MANATARMS) != 3)
        return FALSE;

    int iNumFoc;

    // we know they have at least 4 weapon focus feats
    // lets check how many coresponding imp crit feats they have
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_BASTARD_SWORD))    iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_BASTARD_SWORD);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_BATTLE_AXE))       iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_CLUB))             iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_CLUB);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_CREATURE))         iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_CREATURE);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_DAGGER))           iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_DART))             iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_DART);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_DIRE_MACE))        iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_DIRE_MACE);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_DOUBLE_AXE))       iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_DOUBLE_AXE);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_DWAXE))            iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_GREAT_AXE))        iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_AXE);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_GREAT_SWORD))      iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_SWORD);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_HALBERD))          iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_HALBERD);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_HAND_AXE))         iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW))   iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_HEAVY_FLAIL))      iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_FLAIL);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_KAMA))             iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_KAMA);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_KATANA))           iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_KATANA);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_KUKRI))            iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_KUKRI);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_LIGHT_CROSSBOW))   iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL))      iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_FLAIL);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_LIGHT_HAMMER))     iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_HAMMER);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_LIGHT_MACE))       iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_MACE);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_LONG_SWORD))       iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_LONGBOW))          iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_MORNING_STAR))     iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_MORNING_STAR);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_RAPIER))           iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_SCIMITAR))         iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_SCYTHE))           iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_SCYTHE);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_SHORT_SWORD))      iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_SHORTBOW))         iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_SHURIKEN))         iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_SHURIKEN);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_SICKLE))           iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_SICKLE);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_SLING))            iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_SLING);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_SPEAR))            iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_SPEAR);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_STAFF))            iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_STAFF);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_THROWING_AXE))     iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_THROWING_AXE);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD)) iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE))   iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_UNARMED_STRIKE);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_WAR_HAMMER))       iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_WAR_HAMMER);
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_WHIP))             iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_WHIP);

    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_MINDBLADE))
    {
        iNumFoc += GetHasFeat(FEAT_WEAPON_FOCUS_MINDBLADE);

        // If they are a soulknife, their weapon could be granting them another ImpCrit as bonus feat
        if(GetStringLeft(GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)), 14) == "prc_sk_mblade_"
        || GetStringLeft(GetTag(GetItemInSlot(INVENTORY_SLOT_LEFTHAND)), 14) == "prc_sk_mblade_")
            iNumFoc--;
    }

    // if they do not have 4 improved critical feats chosen
    if(iNumFoc < 4)
    {
        FloatingTextStringOnCreature("You must choose 4 improved critical feats for weapons which you have weapon focus in.  Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    return FALSE;
}

int RedWizardFeats()
{
    int iTF, iOS;
    if(GetHasFeat(FEAT_RW_TF_ABJ)){iTF++; iOS = GetHasFeat(2265);}
    if(GetHasFeat(FEAT_RW_TF_CON)){iTF++; iOS = GetHasFeat(2266);}
    if(GetHasFeat(FEAT_RW_TF_DIV)){iTF++; iOS = GetHasFeat(2267);}
    if(GetHasFeat(FEAT_RW_TF_ENC)){iTF++; iOS = GetHasFeat(2268);}
    if(GetHasFeat(FEAT_RW_TF_EVO)){iTF++; iOS = GetHasFeat(2269);}
    if(GetHasFeat(FEAT_RW_TF_ILL)){iTF++; iOS = GetHasFeat(2270);}
    if(GetHasFeat(FEAT_RW_TF_NEC)){iTF++; iOS = GetHasFeat(2271);}
    if(GetHasFeat(FEAT_RW_TF_TRS)){iTF++; iOS = GetHasFeat(2272);}

    if(iOS)
    {
        FloatingTextStringOnCreature("You cannot select an Opposition School as a Tattoo Focus. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    if(iTF > 1)
    {
        FloatingTextStringOnCreature("You may only have one Tattoo Focus. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    if(GetLevelByClass(CLASS_TYPE_RED_WIZARD))
    {
        int iRWRes = GetHasFeat(FEAT_RW_RES_ABJ)
                   + GetHasFeat(FEAT_RW_RES_CON)
                   + GetHasFeat(FEAT_RW_RES_DIV)
                   + GetHasFeat(FEAT_RW_RES_ENC)
                   + GetHasFeat(FEAT_RW_RES_EVO)
                   + GetHasFeat(FEAT_RW_RES_ILL)
                   + GetHasFeat(FEAT_RW_RES_NEC)
                   + GetHasFeat(FEAT_RW_RES_TRS);

        if(iRWRes != 2)
        {
            FloatingTextStringOnCreature("You must have 2 Restricted Schools. Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
        if((GetHasFeat(FEAT_RW_RES_ABJ) && GetHasFeat(2265))
        || (GetHasFeat(FEAT_RW_RES_CON) && GetHasFeat(2266))
        || (GetHasFeat(FEAT_RW_RES_DIV) && GetHasFeat(2267))
        || (GetHasFeat(FEAT_RW_RES_ENC) && GetHasFeat(2268))
        || (GetHasFeat(FEAT_RW_RES_EVO) && GetHasFeat(2269))
        || (GetHasFeat(FEAT_RW_RES_ILL) && GetHasFeat(2270))
        || (GetHasFeat(FEAT_RW_RES_NEC) && GetHasFeat(2271))
        || (GetHasFeat(FEAT_RW_RES_TRS) && GetHasFeat(2272)))
        {
            FloatingTextStringOnCreature("You cannot select an Opposition School as a Restricted School. Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
    return FALSE;
}

int MageKiller()
{
    int iMK = (GetLevelByClass(CLASS_TYPE_MAGEKILLER) + 1) / 2;

    if(iMK)
    {
        int iMKSave = GetHasFeat(FEAT_MK_REF_15)
                    + GetHasFeat(FEAT_MK_REF_14)
                    + GetHasFeat(FEAT_MK_REF_13)
                    + GetHasFeat(FEAT_MK_REF_12)
                    + GetHasFeat(FEAT_MK_REF_11)
                    + GetHasFeat(FEAT_MK_REF_10)
                    + GetHasFeat(FEAT_MK_REF_9)
                    + GetHasFeat(FEAT_MK_REF_8)
                    + GetHasFeat(FEAT_MK_REF_7)
                    + GetHasFeat(FEAT_MK_REF_6)
                    + GetHasFeat(FEAT_MK_REF_5)
                    + GetHasFeat(FEAT_MK_REF_4)
                    + GetHasFeat(FEAT_MK_REF_3)
                    + GetHasFeat(FEAT_MK_REF_2)
                    + GetHasFeat(FEAT_MK_REF_1)
                    + GetHasFeat(FEAT_MK_FORT_15)
                    + GetHasFeat(FEAT_MK_FORT_14)
                    + GetHasFeat(FEAT_MK_FORT_13)
                    + GetHasFeat(FEAT_MK_FORT_12)
                    + GetHasFeat(FEAT_MK_FORT_11)
                    + GetHasFeat(FEAT_MK_FORT_10)
                    + GetHasFeat(FEAT_MK_FORT_9)
                    + GetHasFeat(FEAT_MK_FORT_8)
                    + GetHasFeat(FEAT_MK_FORT_7)
                    + GetHasFeat(FEAT_MK_FORT_6)
                    + GetHasFeat(FEAT_MK_FORT_5)
                    + GetHasFeat(FEAT_MK_FORT_4)
                    + GetHasFeat(FEAT_MK_FORT_3)
                    + GetHasFeat(FEAT_MK_FORT_2)
                    + GetHasFeat(FEAT_MK_FORT_1);

        if(iMK != iMKSave)
        {
            FloatingTextStringOnCreature("You must select an Improved Save Feat. Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
    return FALSE;
}

int FavouredSoul()
{
    int nFS = GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL);

    if(nFS == 3)
    {
        int nFocus = GetHasFeat(FEAT_WEAPON_FOCUS_BASTARD_SWORD)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_CLUB)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_CREATURE)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_DART)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_DIRE_MACE)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_DOUBLE_AXE)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_AXE)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_SWORD)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_HALBERD)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_FLAIL)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_KAMA)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_KATANA)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_KUKRI)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_FLAIL)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_HAMMER)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_MACE)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_MORNING_STAR)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_SCYTHE)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_SHURIKEN)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_SICKLE)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_SLING)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_SPEAR)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_STAFF)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_THROWING_AXE)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_UNARMED_STRIKE)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_WAR_HAMMER)
                  || GetHasFeat(FEAT_WEAPON_FOCUS_WHIP);

        if(!nFocus)
        {
            FloatingTextStringOnCreature("You must select a Weapon Focus Feat. Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
    else if(nFS > 4)
    {
        int nEnergy = GetHasFeat(FEAT_FAVOURED_SOUL_ACID)
                    + GetHasFeat(FEAT_FAVOURED_SOUL_COLD)
                    + GetHasFeat(FEAT_FAVOURED_SOUL_ELEC)
                    + GetHasFeat(FEAT_FAVOURED_SOUL_FIRE)
                    + GetHasFeat(FEAT_FAVOURED_SOUL_SONIC);

        if(nEnergy != min(3, nFS / 5))
        {
            FloatingTextStringOnCreature("You must select an Energy Resistance Feat. Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
    return FALSE;
}

int GenasaiFocus()
{
    if(GetPRCSwitch(PRC_DISABLE_DOMAIN_ENFORCEMENT))
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_CLERIC))
    {
        int nRace = GetRacialType(OBJECT_SELF);
        int bDomain;
        string sElem;
        switch(nRace)
        {
            case RACIAL_TYPE_AIR_GEN:   bDomain = GetHasFeat(FEAT_AIR_DOMAIN_POWER);   sElem = "Air";   break;
            case RACIAL_TYPE_EARTH_GEN: bDomain = GetHasFeat(FEAT_EARTH_DOMAIN_POWER); sElem = "Earth"; break;
            case RACIAL_TYPE_FIRE_GEN:  bDomain = GetHasFeat(FEAT_FIRE_DOMAIN_POWER);  sElem = "Fire";  break;
            case RACIAL_TYPE_WATER_GEN: bDomain = GetHasFeat(FEAT_WATER_DOMAIN_POWER); sElem = "Water"; break;
            default: return FALSE;
        }

        if(!bDomain)
        {
            FloatingTextStringOnCreature("You must have the "+sElem+" Domain as an "+sElem+" Genasai.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
    return FALSE;
}

/*int ElementalSavant()
{
    int nSavant = GetLevelByClass(CLASS_TYPE_ES_ACID) > 0
                + GetLevelByClass(CLASS_TYPE_ES_COLD) > 0
                + GetLevelByClass(CLASS_TYPE_ES_ELEC) > 0
                + GetLevelByClass(CLASS_TYPE_ES_FIRE) > 0
                + GetLevelByClass(CLASS_TYPE_DIVESA) > 0
                + GetLevelByClass(CLASS_TYPE_DIVESC) > 0
                + GetLevelByClass(CLASS_TYPE_DIVESE) > 0
                + GetLevelByClass(CLASS_TYPE_DIVESF) > 0;

    if(nSavant > 1)
    {
        FloatingTextStringOnCreature("You may only have one Elemental Savant class.", OBJECT_SELF, FALSE);
        return TRUE;
    }
    return FALSE;
}*/

int VileFeats()
{
    if(GetHasFeat(FEAT_VILE_DEFORM_OBESE) && GetHasFeat(FEAT_VILE_DEFORM_GAUNT))
    {
        FloatingTextStringOnCreature("You may only have one Deformity. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    if(GetHasFeat(FEAT_THRALL_TO_DEMON) && GetHasFeat(FEAT_DISCIPLE_OF_DARKNESS))
    {
        FloatingTextStringOnCreature("You may only worship Demons or Devils, not both. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }
    if((GetHasFeat(FEAT_GREATER_CORRUPT_SPELL_FOCUS) || GetHasFeat(FEAT_CORRUPT_SPELL_FOCUS)) && GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
    {
        FloatingTextStringOnCreature("You must be neutral or evil to take Corrupt Spell Focus", OBJECT_SELF, FALSE);
        return TRUE;
    }    

    return FALSE;
}

int Ethran()
{
    if(GetGender(OBJECT_SELF) != GENDER_FEMALE
    && GetHasFeat(FEAT_ETHRAN))
    {
        FloatingTextStringOnCreature("You must be Female to take this feat. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }
    return FALSE;
}

int UltiRangerFeats()
{
    int iURanger = GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER);

    if(iURanger)
    {
        int iAbi, iFE, Ability;

        iFE = GetHasFeat(FEAT_UR_FE_DWARF)
            + GetHasFeat(FEAT_UR_FE_ELF)
            + GetHasFeat(FEAT_UR_FE_GNOME)
            + GetHasFeat(FEAT_UR_FE_HALFING)
            + GetHasFeat(FEAT_UR_FE_HALFELF)
            + GetHasFeat(FEAT_UR_FE_HALFORC)
            + GetHasFeat(FEAT_UR_FE_HUMAN)
            + GetHasFeat(FEAT_UR_FE_ABERRATION)
            + GetHasFeat(FEAT_UR_FE_ANIMAL)
            + GetHasFeat(FEAT_UR_FE_BEAST)
            + GetHasFeat(FEAT_UR_FE_CONSTRUCT)
            + GetHasFeat(FEAT_UR_FE_DRAGON)
            + GetHasFeat(FEAT_UR_FE_GOBLINOID)
            + GetHasFeat(FEAT_UR_FE_MONSTROUS)
            + GetHasFeat(FEAT_UR_FE_ORC)
            + GetHasFeat(FEAT_UR_FE_REPTILIAN)
            + GetHasFeat(FEAT_UR_FE_ELEMENTAL)
            + GetHasFeat(FEAT_UR_FE_FEY)
            + GetHasFeat(FEAT_UR_FE_GIANT)
            + GetHasFeat(FEAT_UR_FE_MAGICAL_BEAST)
            + GetHasFeat(FEAT_UR_FE_OUTSIDER)
            + GetHasFeat(FEAT_UR_FE_SHAPECHANGER)
            + GetHasFeat(FEAT_UR_FE_UNDEAD)
            + GetHasFeat(FEAT_UR_FE_VERMIN);


        if(iURanger > 10)
        {
            iAbi = GetHasFeat(FEAT_UR_SNEAKATK_3D6)
                 + GetHasFeat(FEAT_UR_ARMOREDGRACE)
                 + GetHasFeat(FEAT_UR_DODGE_FE)
                 + GetHasFeat(FEAT_UR_RESIST_FE)
                 + GetHasFeat(FEAT_UR_HAWK_TOTEM)
                 + GetHasFeat(FEAT_UR_OWL_TOTEM)
                 + GetHasFeat(FEAT_UR_VIPER_TOTEM)
                 + GetHasFeat(FEAT_UR_FAST_MOVEMENT)
                 + GetHasFeat(FEAT_UNCANNYX_DODGE_1)
                 + GetHasFeat(FEAT_UR_HIPS);


            if((iURanger-8)/3 != iAbi)
                Ability = 1;
        }

        if(iFE != (iURanger+3)/5 || Ability)
        {
            string sAbi ="1 ability ";
            string sFE =" 1 favorite enemy ";
            string msg=" You must select ";
            int bFeat;
            if(iURanger > 4 && iURanger < 21)
                bFeat = ((iURanger + 1) % 4 == 0);
            else if(iURanger > 20)
                bFeat = ((iURanger + 2) % 5 == 0);
            if(iURanger > 10 && (iURanger - 8) % 3 == 0)
                msg = msg+sAbi+" ";
            if(iURanger > 1 && (iURanger + 8) % 5 == 0)
                msg+=sFE;
            if(iURanger == 1 || iURanger == 4 || bFeat)
                msg+= " 1 bonus Feat";

            //FloatingTextStringOnCreature(" Please reselect your feats.", oPC, FALSE);
            FloatingTextStringOnCreature(msg, OBJECT_SELF, FALSE);
            return TRUE;
        }
        else
        {
            iURanger++;
            string msg =" In your next Ultimate Ranger level, you must select ";
            int bFeat;
            if(iURanger > 4 && iURanger < 21)
                bFeat = ((iURanger + 1) % 4 == 0);
            else if(iURanger > 20)
                bFeat = ((iURanger + 2) % 5 == 0);
            if(iURanger == 1 || iURanger == 4 || bFeat)
                msg+= "1 bonus Feat ";
            if(iURanger > 10 && (iURanger - 8) % 3 == 0)
                msg +="1 Ability ";
            if(iURanger > 1 && (iURanger + 8) % 5 == 0)
                msg+="1 Favorite Enemy ";
            if(msg != " In your next Ultimate Ranger level, you must select ")
                FloatingTextStringOnCreature(msg, OBJECT_SELF, FALSE);
        }
    }
    return FALSE;
}

int CheckClericShadowWeave()
{
    if(GetLevelByClass(CLASS_TYPE_CLERIC) && GetHasFeat(FEAT_SHADOWWEAVE))
    {
        int iCleDom = GetHasFeat(FEAT_EVIL_DOMAIN_POWER)
                    + GetHasFeat(FEAT_FIRE_DOMAIN_POWER)
                    + GetHasFeat(FEAT_DARKNESS_DOMAIN);

        if(iCleDom < 2)
        {
            FloatingTextStringOnCreature("You must have two of the following domains: Evil, Fire, or Darkness to use the shadow weave.", OBJECT_SELF, FALSE);
            FloatingTextStringOnCreature("Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
    return FALSE;
}

// Prevents a player from taking Lingering Damage without
// have 8d6 sneak attack
int LingeringDamage()
{
    if(GetHasFeat(FEAT_LINGERING_DAMAGE)
    && GetTotalSneakAttackDice(OBJECT_SELF) < 8)
    {
        FloatingTextStringOnCreature("You must have at least 8d6 sneak attack dice. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }
    return FALSE;
}

// check for server restricted feats/skills
int PWSwitchRestructions()
{
    int nReturn = FALSE;
    string sMessage;
    int nFeatCount = GetPRCSwitch(PRC_DISABLE_FEAT_COUNT);
    int i;
    for(i = 1; i < nFeatCount; i++)
    {
        int nFeat = GetPRCSwitch(PRC_DISABLE_FEAT_+IntToString(i));
        if(GetHasFeat(nFeat))
        {
            nReturn = TRUE;
            sMessage += "You cannot take "+GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", nFeat)))+" in this module.\n";
        }
    }

    int nSkillCount = GetPRCSwitch(PRC_DISABLE_SKILL_COUNT);
    for(i = 1; i < nSkillCount; i++)
    {
        int nSkill = GetPRCSwitch(PRC_DISABLE_SKILL_+IntToString(i));
        if(GetSkillRank(nSkill, OBJECT_SELF, TRUE))
        {
            nReturn = TRUE;
            sMessage += "You cannot take "+GetStringByStrRef(StringToInt(Get2DACache("skills", "Name", nSkill)))+" in this module.\n";
        }
    }
    FloatingTextStringOnCreature(sMessage, OBJECT_SELF, FALSE);
    return nReturn;
}

int DraDisFeats()
{
    int bLd = GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE);
    if(!bLd) return FALSE;

    int iBld;
    iBld = GetHasFeat(FEAT_RED_DRAGON)
         + GetHasFeat(FEAT_SILVER_DRAGON)
         + GetHasFeat(FEAT_BLACK_DRAGON)
         + GetHasFeat(FEAT_BLUE_DRAGON)
         + GetHasFeat(FEAT_GREEN_DRAGON)
         + GetHasFeat(FEAT_WHITE_DRAGON)
         + GetHasFeat(FEAT_BRASS_DRAGON)
         + GetHasFeat(FEAT_BRONZE_DRAGON)
         + GetHasFeat(FEAT_COPPER_DRAGON)
         + GetHasFeat(FEAT_GOLD_DRAGON)
         + GetHasFeat(FEAT_AMETHYST_DRAGON)
         + GetHasFeat(FEAT_CRYSTAL_DRAGON)
         + GetHasFeat(FEAT_EMERALD_DRAGON)
         + GetHasFeat(FEAT_SAPPHIRE_DRAGON)
         + GetHasFeat(FEAT_TOPAZ_DRAGON)
         + GetHasFeat(FEAT_BATTLE_DRAGON)
         + GetHasFeat(FEAT_BROWN_DRAGON)
         + GetHasFeat(FEAT_CHAOS_DRAGON)
         + GetHasFeat(FEAT_DEEP_DRAGON)
         + GetHasFeat(FEAT_ETHEREAL_DRAGON)
         + GetHasFeat(FEAT_FANG_DRAGON)
         + GetHasFeat(FEAT_HOWLING_DRAGON)
         + GetHasFeat(FEAT_OCEANUS_DRAGON)
         + GetHasFeat(FEAT_PYROCLASTIC_DRAGON)
         + GetHasFeat(FEAT_RADIANT_DRAGON)
         + GetHasFeat(FEAT_RUST_DRAGON)
         + GetHasFeat(FEAT_SHADOW_DRAGON)
         + GetHasFeat(FEAT_SONG_DRAGON)
         + GetHasFeat(FEAT_STYX_DRAGON)
         + GetHasFeat(FEAT_TARTIAN_DRAGON)
         + GetHasFeat(FEAT_CHIANG_LUNG_DRAGON)
         + GetHasFeat(FEAT_LI_LUNG_DRAGON)
         + GetHasFeat(FEAT_LUNG_WANG_DRAGON)
         + GetHasFeat(FEAT_PAN_LUNG_DRAGON)
         + GetHasFeat(FEAT_SHEN_LUNG_DRAGON)
         + GetHasFeat(FEAT_TIEN_LUNG_DRAGON)
         + GetHasFeat(FEAT_TUN_MI_LUNG_DRAGON)
         + GetHasFeat(FEAT_YU_LUNG_DRAGON);

    /*
    FloatingTextStringOnCreature("Dragon Disciple Level: " + IntToString(bLd), OBJECT_SELF, FALSE);
    FloatingTextStringOnCreature("Draconic Blood: " + IntToString(iBld), OBJECT_SELF, FALSE);
    */
    if(iBld > 1)
    {
        FloatingTextStringOnCreature("You cannot select more than one Draconic Heritage.", OBJECT_SELF, FALSE);
        return TRUE;
    }
    if (bLd == 1)
    {
        //if(DEBUG) FloatingTextStringOnCreature("Checking Heritage.", OBJECT_SELF, FALSE);
        //make sure you don't take a DD heritage that doesn't match your heritage
        if(((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BK) || GetHasFeat(FEAT_DRACONIC_HERITAGE_BK)) && !(GetHasFeat(FEAT_BLACK_DRAGON)))
        || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BL) || GetHasFeat(FEAT_DRACONIC_HERITAGE_BL)) && !(GetHasFeat(FEAT_BLUE_DRAGON)))
        || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_GR) || GetHasFeat(FEAT_DRACONIC_HERITAGE_GR)) && !(GetHasFeat(FEAT_GREEN_DRAGON)))
        || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_RD) || GetHasFeat(FEAT_DRACONIC_HERITAGE_RD)) && !(GetHasFeat(FEAT_RED_DRAGON)))
        || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_WH) || GetHasFeat(FEAT_DRACONIC_HERITAGE_WH)) && !(GetHasFeat(FEAT_WHITE_DRAGON)))
        || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_AM) || GetHasFeat(FEAT_DRACONIC_HERITAGE_AM)) && !(GetHasFeat(FEAT_AMETHYST_DRAGON)))
        || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_CR) || GetHasFeat(FEAT_DRACONIC_HERITAGE_CR)) && !(GetHasFeat(FEAT_CRYSTAL_DRAGON)))
        || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_EM) || GetHasFeat(FEAT_DRACONIC_HERITAGE_EM)) && !(GetHasFeat(FEAT_EMERALD_DRAGON)))
        || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_SA) || GetHasFeat(FEAT_DRACONIC_HERITAGE_SA)) && !(GetHasFeat(FEAT_SAPPHIRE_DRAGON)))
        || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_TP) || GetHasFeat(FEAT_DRACONIC_HERITAGE_TP)) && !(GetHasFeat(FEAT_TOPAZ_DRAGON)))
        || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BS) || GetHasFeat(FEAT_DRACONIC_HERITAGE_BS)) && !(GetHasFeat(FEAT_BRASS_DRAGON)))
        || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BZ) || GetHasFeat(FEAT_DRACONIC_HERITAGE_BZ)) && !(GetHasFeat(FEAT_BRONZE_DRAGON)))
        || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_CP) || GetHasFeat(FEAT_DRACONIC_HERITAGE_CP)) && !(GetHasFeat(FEAT_COPPER_DRAGON)))
        || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_GD) || GetHasFeat(FEAT_DRACONIC_HERITAGE_GD)) && !(GetHasFeat(FEAT_GOLD_DRAGON)))
        || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_SR) || GetHasFeat(FEAT_DRACONIC_HERITAGE_SR)) && !(GetHasFeat(FEAT_SILVER_DRAGON))))
        {
            FloatingTextStringOnCreature("You must take a Dragon Disciple Heritage that matches yours.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
    return FALSE;
}

int MarshalAuraLimit()
{
    int mArsh = GetLevelByClass(CLASS_TYPE_MARSHAL);
    if(!mArsh) return FALSE;

    string sMinAur = Get2DACache("cls_aukn_marsh", "Minor", mArsh-1);
    string sMajAur = Get2DACache("cls_aukn_marsh", "Major", mArsh-1);
    int MinAur2da = StringToInt(sMinAur);
    int MajAur2da = StringToInt(sMajAur);

    int MinAur, MajAur;
    MinAur = GetHasFeat(MIN_AUR_FORT)
           + GetHasFeat(MIN_AUR_WILL)
           + GetHasFeat(MIN_AUR_REF)
           + GetHasFeat(MIN_AUR_CHA)
           + GetHasFeat(MIN_AUR_CON)
           + GetHasFeat(MIN_AUR_DEX)
           + GetHasFeat(MIN_AUR_INT)
           + GetHasFeat(MIN_AUR_WIS)
           + GetHasFeat(MIN_AUR_STR)
           + GetHasFeat(MIN_AUR_CAST)
           + GetHasFeat(MIN_AUR_AOW);
    MajAur = GetHasFeat(MAJ_AUR_MOT_ARDOR)
           + GetHasFeat(MAJ_AUR_MOT_CARE)
           + GetHasFeat(MAJ_AUR_RES_TROOPS)
           + GetHasFeat(MAJ_AUR_MOT_URGE)
           + GetHasFeat(MAJ_AUR_HARD_SOLDIER)
           + GetHasFeat(MAJ_AUR_MOT_ATTACK)
           + GetHasFeat(MAJ_AUR_STEAD_HAND)
           + GetHasFeat(FEAT_MARSHAL_AURA_PRESENCE)
           + GetHasFeat(FEAT_MARSHAL_AURA_SENSES)
           + GetHasFeat(FEAT_MARSHAL_AURA_TOUGHNESS)
           + GetHasFeat(FEAT_MARSHAL_AURA_INSIGHT)
           + GetHasFeat(FEAT_MARSHAL_AURA_RESOLVE)
           + GetHasFeat(FEAT_MARSHAL_AURA_STAMINA)
           + GetHasFeat(FEAT_MARSHAL_AURA_SWIFTNESS)
           + GetHasFeat(FEAT_MARSHAL_AURA_RESISTACID)
           + GetHasFeat(FEAT_MARSHAL_AURA_RESISTCOLD)
           + GetHasFeat(FEAT_MARSHAL_AURA_RESISTELEC)
           + GetHasFeat(FEAT_MARSHAL_AURA_RESISTFIRE);

    if((MinAur != MinAur2da) || (MajAur != MajAur2da))
    {
        FloatingTextStringOnCreature("At this level you should know "+sMinAur+" Minor and "+sMajAur+" Major auras.", OBJECT_SELF, FALSE);
        return TRUE;
    }
    return FALSE;
}

int CasterFeats()
{
    int nDivCaster = GetCasterLvl(TYPE_DIVINE);
    int nArcCaster = GetCasterLvl(TYPE_ARCANE);

    if(GetHasFeat(FEAT_INSCRIBE_RUNE) && GetLocalInt(OBJECT_SELF, "PRC_DivSpell2") == 1)
    {
        FloatingTextStringOnCreature("Inscribe Rune requires level 2 Divine Spells", OBJECT_SELF, FALSE);
        return TRUE;
    }

    if(GetHasFeat(FEAT_ATTUNE_GEM) && GetLocalInt(OBJECT_SELF, "PRC_ArcSpell2") == 1)
    {
        FloatingTextStringOnCreature("Attune Gem requires level 2 Arcane Spells", OBJECT_SELF, FALSE);
        return TRUE;
    }

    if(GetHasFeat(FEAT_CORMANTHYRAN_MOON_MAGIC) && GetLocalInt(OBJECT_SELF, "PRC_AllSpell3") == 1)
    {
        FloatingTextStringOnCreature("Cormanthyran Moon Magic requires 3rd level spells", OBJECT_SELF, FALSE);
        return TRUE;
    }
    if(GetHasFeat(FEAT_WAND_MASTERY) && nArcCaster < 9 && nDivCaster < 9)
    {
        FloatingTextStringOnCreature("Wand Mastery requires 9th caster level", OBJECT_SELF, FALSE);
        return TRUE;
    }    
    if(GetHasFeat(FEAT_VREMYONNI_TRAINING) && GetLocalInt(OBJECT_SELF, "PRC_AllSpell1") == 1)
    {
        FloatingTextStringOnCreature("Vremyonni Training requires 1st level spells", OBJECT_SELF, FALSE);
        return TRUE;
    }    

    return FALSE;
}

/*int Blightbringer()
{
    // You should only have the Blightbringer domain as a bonus domain
    if(GetHasFeat(FEAT_DOMAIN_POWER_BLIGHTBRINGER) && !GetHasFeat(FEAT_BONUS_DOMAIN_BLIGHTBRINGER))
    {
        FloatingTextStringOnCreature("You may not select Blightbringer as a domain at level 1.", OBJECT_SELF, FALSE);
        return TRUE;
    }
    return FALSE;
}*/

int SkillRequirements()
{
    if(GetHasFeat(FEAT_APPRAISE_MAGIC_VALUE) && GetSkillRank(SKILL_SPELLCRAFT, OBJECT_SELF, TRUE) < 5)
    {
        FloatingTextStringOnCreature("You need at least 5 ranks of Spellcraft to select this feat", OBJECT_SELF, FALSE);
        return TRUE;
    }
    if(GetHasFeat(FEAT_DIVE_FOR_COVER) && GetReflexSavingThrow(OBJECT_SELF) < 4)
    {
        FloatingTextStringOnCreature("You need a Reflex save of at least 4 to select this feat", OBJECT_SELF, FALSE);
        return TRUE;
    }
    return FALSE;
}

int CraftingFeats()
{
    int nCasterLvl     = max(GetCasterLvl(TYPE_ARCANE), GetCasterLvl(TYPE_DIVINE)),
        nManifesterLvl = GetManifesterLevel(OBJECT_SELF, GetPrimaryPsionicClass()),
        nInvokerLvl    = GetInvokerLevel(OBJECT_SELF, GetPrimaryInvocationClass()),
        nCasterMax     = max(nCasterLvl, nInvokerLvl),
        nMax           = max(nCasterMax, nManifesterLvl),
        nArti          = GetLevelByClass(CLASS_TYPE_ARTIFICER),
        nBattle        = GetLevelByClass(CLASS_TYPE_BATTLESMITH),
        nIron          = GetLevelByClass(CLASS_TYPE_IRONSOUL_FORGEMASTER);

    int bReturn, bFirst = TRUE;
    string sError = GetStringByStrRef(16823153) + "\n"; // "Your spellcaster (or manifester) level is not high enough to take the following crafting feats:"

    if(GetHasFeat(FEAT_SCRIBE_SCROLL)
    && nMax < 1 && !nArti)
    {
        bReturn = TRUE;
        if(bFirst) bFirst = FALSE; else sError += ", ";
        sError += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", FEAT_SCRIBE_SCROLL)));
    }
    if(GetHasFeat(FEAT_BREW_POTION)
    && nMax < 3 && nArti < 2)
    {
        bReturn = TRUE;
        if(bFirst) bFirst = FALSE; else sError += ", ";
        sError += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", FEAT_BREW_POTION)));
    }
    if(GetHasFeat(FEAT_CRAFT_WONDROUS)
    && nMax < 3 && nArti < 3)
    {
        bReturn = TRUE;
        if(bFirst) bFirst = FALSE; else sError += ", ";
        sError += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", FEAT_CRAFT_WONDROUS)));
    }
    if(GetHasFeat(FEAT_CRAFT_ARMS_ARMOR)
    && nMax < 5 && nArti < 5 && nBattle == 0 && nIron < 2)
    {
        bReturn = TRUE;
        if(bFirst) bFirst = FALSE; else sError += ", ";
        sError += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", FEAT_CRAFT_ARMS_ARMOR)));
    }
    if(GetHasFeat(FEAT_CRAFT_WAND)
    && nMax < 5 && nArti < 7)
    {
        bReturn = TRUE;
        if(bFirst) bFirst = FALSE; else sError += ", ";
        sError += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", FEAT_CRAFT_WAND)));
    }
    if(GetHasFeat(FEAT_CRAFT_ROD)
    && nMax < 9 && nArti < 9)
    {
        bReturn = TRUE;
        if(bFirst) bFirst = FALSE; else sError += ", ";
        sError += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", FEAT_CRAFT_ROD)));
    }
    if(GetHasFeat(FEAT_CRAFT_STAFF)
    && nMax < 12 && nArti < 12)
    {
        bReturn = TRUE;
        if(bFirst) bFirst = FALSE; else sError += ", ";
        sError += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", FEAT_CRAFT_STAFF)));
    }
    if(GetHasFeat(FEAT_FORGE_RING)
    && nMax < 12 && nArti < 14)
    {
        bReturn = TRUE;
        if(bFirst) bFirst = FALSE; else sError += ", ";
        sError += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", FEAT_FORGE_RING)));
    }
    if(nMax < 6 && GetHasFeat(FEAT_CRAFT_SKULL_TALISMAN))
    {
        FloatingTextStringOnCreature("Craft Skull Talisman requires caster level 6", OBJECT_SELF, FALSE);
        return TRUE;
    }    

    if(bReturn)
        FloatingTextStringOnCreature(sError, OBJECT_SELF, FALSE);

    //Atrisan feats require at least one item creation feat
    if((GetHasFeat(FEAT_EXCEPTIONAL_ARTISAN_I)
     || GetHasFeat(FEAT_EXTRAORDINARY_ARTISAN_I)
     || GetHasFeat(FEAT_LEGENDARY_ARTISAN_I))
    && !GetItemCreationFeatCount())
    {
        bReturn = TRUE;
    }

    return bReturn;
}


int RacialHD()
{
    if(!GetPRCSwitch(PRC_XP_USE_SIMPLE_RACIAL_HD))
        return FALSE;

    int nRealRace = GetRacialType(OBJECT_SELF);
    int nRacialHD = StringToInt(Get2DACache("ECL", "RaceHD", nRealRace));
    int nRacialClass = StringToInt(Get2DACache("ECL", "RaceClass", nRealRace));
    if(GetLevelByClass(nRacialClass) < nRacialHD
    && GetHitDice(OBJECT_SELF)-1-GetLevelByClass(nRacialClass) > 0)
    {
        string sName = GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nRacialClass)));
        FloatingTextStringOnCreature("You must take "+IntToString(nRacialHD)+" levels in your racial hit dice class, "+sName, OBJECT_SELF, FALSE);
        return TRUE;
    }
    return FALSE;
}

int LeadershipHD()
{
    if(GetHasFeat(FEAT_LEADERSHIP))
    {
        if(GetLevelByClass(CLASS_TYPE_THRALLHERD))
        {
            FloatingTextStringOnCreature("A thrallherd cannot take the Leadership feat.", OBJECT_SELF, FALSE);
            return TRUE;
        }

        int nECL = GetECL(OBJECT_SELF);
        if(nECL < 6)
        {
            FloatingTextStringOnCreature("You must take "+IntToString(6-nECL)+" more levels before you can select Leadership.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
    return FALSE;
}

int SuddenMetamagic()
{
    if((GetHasFeat(FEAT_SUDDEN_EMPOWER) || GetHasFeat(FEAT_SUDDEN_MAXIMIZE))
    && GetLevelByClass(CLASS_TYPE_WARMAGE) < 7)
    {
        if(!(GetHasFeat(FEAT_EMPOWER_SPELL)
          || GetHasFeat(FEAT_EXTEND_SPELL)
          || GetHasFeat(FEAT_MAXIMIZE_SPELL)
          || GetHasFeat(FEAT_QUICKEN_SPELL)
          || GetHasFeat(FEAT_SILENCE_SPELL)
          || GetHasFeat(FEAT_STILL_SPELL)
          || GetHasFeat(FEAT_SUDDEN_EXTEND)
          || GetHasFeat(FEAT_SUDDEN_WIDEN)))
          //sudden feats count as metamagic for prereqs
            return TRUE;
    }
    return FALSE;
}

int DraconicFeats()
{
    //Dragonfriend and Dragonthrall exclude each other
    if(GetHasFeat(FEAT_DRAGONFRIEND) && GetHasFeat(FEAT_DRAGONTHRALL))
    {
        FloatingTextStringOnCreature("You cannot take both Dragonfriend and Dragonthrall.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    int bDragonblooded;
    int bHeritage = GetHasFeat(FEAT_DRACONIC_HERITAGE_BK)
                  + GetHasFeat(FEAT_DRACONIC_HERITAGE_BL)
                  + GetHasFeat(FEAT_DRACONIC_HERITAGE_GR)
                  + GetHasFeat(FEAT_DRACONIC_HERITAGE_RD)
                  + GetHasFeat(FEAT_DRACONIC_HERITAGE_WH)
                  + GetHasFeat(FEAT_DRACONIC_HERITAGE_AM)
                  + GetHasFeat(FEAT_DRACONIC_HERITAGE_CR)
                  + GetHasFeat(FEAT_DRACONIC_HERITAGE_EM)
                  + GetHasFeat(FEAT_DRACONIC_HERITAGE_SA)
                  + GetHasFeat(FEAT_DRACONIC_HERITAGE_TP)
                  + GetHasFeat(FEAT_DRACONIC_HERITAGE_BS)
                  + GetHasFeat(FEAT_DRACONIC_HERITAGE_BZ)
                  + GetHasFeat(FEAT_DRACONIC_HERITAGE_CP)
                  + GetHasFeat(FEAT_DRACONIC_HERITAGE_GD)
                  + GetHasFeat(FEAT_DRACONIC_HERITAGE_SR);

    //make sure they qualify for Draconic Heritage
    if(bHeritage && !GetLevelByClass(CLASS_TYPE_SORCERER) && !GetHasFeat(FEAT_DRAGONTOUCHED))
    {
        FloatingTextStringOnCreature("You need Dragontouched or a level of Sorcerer for Heritage.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    if(bHeritage > 1)
    {
        FloatingTextStringOnCreature("You cannot select more than one Draconic Heritage.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    //Check for dragonblood subtype
    int nRace = GetRacialType(OBJECT_SELF);
    if(bHeritage
    || nRace == RACIAL_TYPE_KOBOLD
    || nRace == RACIAL_TYPE_SPELLSCALE
    || nRace == RACIAL_TYPE_DRAGONBORN
    || nRace == RACIAL_TYPE_STONEHUNTER_GNOME
    || nRace == RACIAL_TYPE_SILVERBROW_HUMAN
    || nRace == RACIAL_TYPE_FORESTLORD_ELF
    || nRace == RACIAL_TYPE_FIREBLOOD_DWARF
    || nRace == RACIAL_TYPE_GLIMMERSKIN_HALFING
    || nRace == RACIAL_TYPE_FROSTBLOOD_ORC
    || nRace == RACIAL_TYPE_SUNSCORCH_HOBGOBLIN
    || nRace == RACIAL_TYPE_VILETOOTH_LIZARDFOLK
	|| nRace == RACIAL_TYPE_SPIRETOPDRAGON
    || GetHasFeat(FEAT_DRAGONTOUCHED)
    || GetHasFeat(FEAT_DRACONIC_DEVOTEE)
    || GetHasFeat(FEAT_DRAGON)
    || GetHasFeat(DRAGON_BLOODED)
    || GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE) > 9)
        bDragonblooded = TRUE;

    //check for Draconic Feats that only need heritage
    if((GetHasFeat(FEAT_DRACONIC_SKIN)
    || GetHasFeat(FEAT_DRACONIC_ARMOR)
    || GetHasFeat(FEAT_DRACONIC_BREATH)
    || GetHasFeat(FEAT_DRACONIC_CLAW)
    || GetHasFeat(FEAT_DRACONIC_GRACE)
    || GetHasFeat(FEAT_DRACONIC_KNOWLEDGE)
    || GetHasFeat(FEAT_DRACONIC_PERSUADE)
    || GetHasFeat(FEAT_DRACONIC_POWER)
    || GetHasFeat(FEAT_DRACONIC_PRESENCE)
    || GetHasFeat(FEAT_DRACONIC_RESISTANCE)
    || GetHasFeat(FEAT_DRACONIC_VIGOR))
    && !bHeritage)
    {
        FloatingTextStringOnCreature("You must take a Dragon Heritage first.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    //special test for Draconic Senses
    if(GetHasFeat(FEAT_DRACONIC_SENSES)
       && !(bDragonblooded
         || GetLevelByClass(CLASS_TYPE_SWIFT_WING) > 1
         || GetLevelByClass(CLASS_TYPE_HANDOTWM)))
    {
        FloatingTextStringOnCreature("You must be dragonblood subtype.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    //special test for Dragonfire Strike
    if(GetHasFeat(FEAT_DRAGONFIRE_STRIKE)
    && !(bDragonblooded || (GetLevelByClass(CLASS_TYPE_HANDOTWM) > 2)))
    {
        FloatingTextStringOnCreature("You must be dragonblood subtype.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    //testing for Dragonblood only
    if((GetHasFeat(FEAT_DRAGONFIRE_ASSAULT)
    || GetHasFeat(FEAT_DRAGONFIRE_CHANNELING)
    || GetHasFeat(FEAT_DRAGONFIRE_INSPIRATION)
    || GetHasFeat(FEAT_ENTANGLING_EXHALATION)
    || GetHasFeat(FEAT_EXHALED_BARRIER)
    || GetHasFeat(FEAT_EXHALED_IMMUNITY))
    && !bDragonblooded)
    {
        FloatingTextStringOnCreature("You must be dragonblood subtype.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    //Swift Wing Dragon Affinity test - make sure only one is taken
    int nSWLevel = GetLevelByClass(CLASS_TYPE_SWIFT_WING);
    if(nSWLevel)
    {
        int nAffinities = GetHasFeat(FEAT_DRAGON_AFFINITY_BK)
                        + GetHasFeat(FEAT_DRAGON_AFFINITY_BL)
                        + GetHasFeat(FEAT_DRAGON_AFFINITY_GR)
                        + GetHasFeat(FEAT_DRAGON_AFFINITY_RD)
                        + GetHasFeat(FEAT_DRAGON_AFFINITY_WH)
                        + GetHasFeat(FEAT_DRAGON_AFFINITY_AM)
                        + GetHasFeat(FEAT_DRAGON_AFFINITY_CR)
                        + GetHasFeat(FEAT_DRAGON_AFFINITY_EM)
                        + GetHasFeat(FEAT_DRAGON_AFFINITY_SA)
                        + GetHasFeat(FEAT_DRAGON_AFFINITY_TP)
                        + GetHasFeat(FEAT_DRAGON_AFFINITY_BS)
                        + GetHasFeat(FEAT_DRAGON_AFFINITY_BZ)
                        + GetHasFeat(FEAT_DRAGON_AFFINITY_CP)
                        + GetHasFeat(FEAT_DRAGON_AFFINITY_GD)
                        + GetHasFeat(FEAT_DRAGON_AFFINITY_SR);

        if(nAffinities > 1)
        {
            FloatingTextStringOnCreature("You cannot select more than one Dragon Affinity.", OBJECT_SELF, FALSE);
            return TRUE;
        }

        //Draconic Surge test
        if(nSWLevel > 9)
        {
            int nPSurge = GetHasFeat(FEAT_DRACONIC_SURGE_STR)
                        + GetHasFeat(FEAT_DRACONIC_SURGE_DEX)
                        + GetHasFeat(FEAT_DRACONIC_SURGE_CON);

            int nMSurge = GetHasFeat(FEAT_DRACONIC_SURGE_INT)
                        + GetHasFeat(FEAT_DRACONIC_SURGE_WIS)
                        + GetHasFeat(FEAT_DRACONIC_SURGE_CHA);

            if(nPSurge > 1 || nMSurge > 1)
            {
                FloatingTextStringOnCreature("You must select one Mental and one Physical Surge.", OBJECT_SELF, FALSE);
                return TRUE;
            }
        }
    }

    //racial tests - make sure user is Dragonblooded subtype
    if((GetHasFeat(FEAT_KOB_DRAGON_WING_A)
    || GetHasFeat(FEAT_KOB_DRAGON_TAIL))
    && !bDragonblooded)
        return TRUE;

    //Make sure only kobolds take Dragonwrought
    if((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BK)
    || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BL)
    || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_GR)
    || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_RD)
    || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_WH)
    || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_AM)
    || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_CR)
    || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_EM)
    || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_SA)
    || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_TP)
    || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BS)
    || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BZ)
    || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_CP)
    || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_GD)
    || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_SR))
    && nRace != RACIAL_TYPE_KOBOLD)
        return TRUE;

    return FALSE;
}

int MetabreathFeats()
{
    int bRechargeBreath;
    int bBreath;

    //sources of breaths with recharge rounds
    if((GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE) > 9)
       || (GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN) > 3)
       || GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT)
       || (GetLevelByClass(CLASS_TYPE_INITIATE_DRACONIC) > 9)
       || (GetLevelByClass(CLASS_TYPE_SHIFTER) > 6)
       || (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_DRAGON)
	   || (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_SPIRETOPDRAGON))
       bRechargeBreath = TRUE;

    if(bRechargeBreath
       || (GetLevelByClass(CLASS_TYPE_SWIFT_WING) > 2)
       || (GetLevelByClass(CLASS_TYPE_DIAMOND_DRAGON) > 3)
       || (GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER) > 9)
       || (GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT))
       || GetHasFeat(FEAT_DRACONIC_BREATH)
       || GetPersistantLocalInt(OBJECT_SELF, "HalfDragon_Template"))
       bBreath = TRUE;

    //metabreath requires breath weapons with a recharge time
    if((GetHasFeat(FEAT_CLINGING_BREATH)
     || GetHasFeat(FEAT_LINGERING_BREATH)
     || GetHasFeat(FEAT_ENLARGE_BREATH)
     || GetHasFeat(FEAT_HEIGHTEN_BREATH)
     || GetHasFeat(FEAT_MAXIMIZE_BREATH)
     || GetHasFeat(FEAT_RECOVER_BREATH)
     || GetHasFeat(FEAT_SHAPE_BREATH)
     || GetHasFeat(FEAT_SPREAD_BREATH)
     || GetHasFeat(FEAT_TEMPEST_BREATH))
    && !(bRechargeBreath))
    {
        FloatingTextStringOnCreature("You must have a breath weapon with a recharge time.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    //breath channeling works with any breath weapon
    if((GetHasFeat(FEAT_ENTANGLING_EXHALATION)
     || GetHasFeat(FEAT_EXHALED_BARRIER)
     || GetHasFeat(FEAT_EXHALED_IMMUNITY))
    && !(bBreath))
    {
        FloatingTextStringOnCreature("You must have a breath weapon.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    //Fivefold Tiamat and Bahamut breath alignment restrictions
    if((GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL && GetHasFeat(FEAT_BAHAMUT_ADEPTBREATH))
    || (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD && GetHasFeat(FEAT_TIAMAT_ADEPTBREATH)))
    {
        FloatingTextStringOnCreature("Your alignment does not allow you to take this breath effect.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    return FALSE;
}

int DragonShamanFeats()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN);
    if(!nLevel) return FALSE;

    if(GetHasFeat(FEAT_DRAGONSHAMAN_RED)
    + GetHasFeat(FEAT_DRAGONSHAMAN_BLACK)
    + GetHasFeat(FEAT_DRAGONSHAMAN_BLUE)
    + GetHasFeat(FEAT_DRAGONSHAMAN_SILVER)
    + GetHasFeat(FEAT_DRAGONSHAMAN_BRASS)
    + GetHasFeat(FEAT_DRAGONSHAMAN_GOLD)
    + GetHasFeat(FEAT_DRAGONSHAMAN_GREEN)
    + GetHasFeat(FEAT_DRAGONSHAMAN_COPPER)
    + GetHasFeat(FEAT_DRAGONSHAMAN_WHITE)
    + GetHasFeat(FEAT_DRAGONSHAMAN_BRONZE)
    != 1)
    {
        FloatingTextStringOnCreature("You cannot take more than one Dragon Totem, please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    int nNumSF = GetHasFeat(FEAT_SKILLFOCUS_APPRAISE)
               + GetHasFeat(FEAT_SKILL_FOCUS_BLUFF)
               + GetHasFeat(FEAT_SKILL_FOCUS_HEAL)
               + GetHasFeat(FEAT_SKILL_FOCUS_HIDE)
               + GetHasFeat(FEAT_SKILL_FOCUS_MOVE_SILENTLY)
               + GetHasFeat(FEAT_SKILL_FOCUS_PERSUADE)
               + GetHasFeat(FEAT_SKILL_FOCUS_SEARCH)
               + GetHasFeat(FEAT_SKILL_FOCUS_SPELLCRAFT);

    if(nLevel > 1 && nNumSF < 1)
    {
        FloatingTextStringOnCreature("You must have 1 class skill focus, please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }
    else if(nLevel > 7 && nNumSF < 2)
    {
        FloatingTextStringOnCreature("You must have 2 class skill focuses, please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }
    else if(nLevel > 15 && nNumSF < 3)
    {
        FloatingTextStringOnCreature("You must have 3 class skill focuses, please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    int nNumAuras = GetHasFeat(FEAT_DRAGONSHAMAN_AURA_POWER)
                  + GetHasFeat(FEAT_DRAGONSHAMAN_AURA_PRESENCE)
                  + GetHasFeat(FEAT_DRAGONSHAMAN_AURA_ENERGYSHLD)
                  + GetHasFeat(FEAT_DRAGONSHAMAN_AURA_SENSES)
                  + GetHasFeat(FEAT_DRAGONSHAMAN_AURA_RESISTANCE)
                  + GetHasFeat(FEAT_DRAGONSHAMAN_AURA_VIGOR)
                  + GetHasFeat(FEAT_DRAGONSHAMAN_AURA_TOUGHNESS)
                  + GetHasFeat(FEAT_DRAGONSHAMAN_AURA_INSIGHT)
                  + GetHasFeat(FEAT_DRAGONSHAMAN_AURA_RESOLVE)
                  + GetHasFeat(FEAT_DRAGONSHAMAN_AURA_STAMINA)
                  + GetHasFeat(FEAT_DRAGONSHAMAN_AURA_SWIFTNESS)
                  + GetHasFeat(FEAT_DRAGONSHAMAN_AURA_MAGICPOWER)
                  + GetHasFeat(FEAT_DRAGONSHAMAN_AURA_ENERGY)
                  + GetHasFeat(FEAT_SHAMANIC_INVOCATION);//shamanic invocation replaces one aura

    if(nLevel < 3 && nNumAuras != 3)
    {
        FloatingTextStringOnCreature("You may only have 3 auras at this level, please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }
    else if((nLevel == 3 || nLevel == 4) && nNumAuras != 4)
    {
        FloatingTextStringOnCreature("You may only have 4 auras at this level, please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }
    else if((nLevel == 5 || nLevel == 6) && nNumAuras != 5)
    {
        FloatingTextStringOnCreature("You may only have 5 auras at this level, please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }
    else if((nLevel == 7 || nLevel == 8) && nNumAuras != 6)
    {
        FloatingTextStringOnCreature("You may only have 6 auras at this level, please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }
    else if(nLevel >= 9 && nNumAuras != 7)
    {
        FloatingTextStringOnCreature("You may only have 7 auras at this level, please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }
    return FALSE;
}

int Swordsage()
{
    int nClass = GetLevelByClass(CLASS_TYPE_SWORDSAGE);

    if(nClass)
    {
        int nWF = GetHasFeat(FEAT_SS_DF_WF_DW)
                + GetHasFeat(FEAT_SS_DF_WF_DM)
                + GetHasFeat(FEAT_SS_DF_WF_SS)
                + GetHasFeat(FEAT_SS_DF_WF_SH)
                + GetHasFeat(FEAT_SS_DF_WF_SD)
                + GetHasFeat(FEAT_SS_DF_WF_TC);

        if(nWF > 1)
        {
            FloatingTextStringOnCreature("You may only have one Discipline Focus (Weapon Focus). Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }

        if(nClass > 3)
        {
            int nIS = GetHasFeat(FEAT_SS_DF_IS_DW)
                    + GetHasFeat(FEAT_SS_DF_IS_DM)
                    + GetHasFeat(FEAT_SS_DF_IS_SS)
                    + GetHasFeat(FEAT_SS_DF_IS_SH)
                    + GetHasFeat(FEAT_SS_DF_IS_SD)
                    + GetHasFeat(FEAT_SS_DF_IS_TC);

            if((nIS > 1 && nClass < 12)
            || (nIS > 2 && nClass > 11))
            {
                FloatingTextStringOnCreature("You do not have the correct amount of Discipline Focus (Insightful Strike). Please reselect your feats.", OBJECT_SELF, FALSE);
                return TRUE;
            }
        }

        if(nClass > 7)
        {
            int nDS = GetHasFeat(FEAT_SS_DF_DS_DW)
                    + GetHasFeat(FEAT_SS_DF_DS_DM)
                    + GetHasFeat(FEAT_SS_DF_DS_SS)
                    + GetHasFeat(FEAT_SS_DF_DS_SH)
                    + GetHasFeat(FEAT_SS_DF_DS_SD)
                    + GetHasFeat(FEAT_SS_DF_DS_TC);

            if((nDS > 1 && nClass < 16)
            || (nDS > 2 && nClass > 15))
            {
                FloatingTextStringOnCreature("You do not have the correct amount of Discipline Focus (Defensive Stance). Please reselect your feats.", OBJECT_SELF, FALSE);
                return TRUE;
            }
        }
    }
    return FALSE;
}

int BonusDomains()
{
    //Determine minimum number of bonus domains (selected by player)
    int nMin;
    if(GetLevelByClass(CLASS_TYPE_MYSTIC))
        nMin += 1;//1 domain at 1st level
    if(GetLevelByClass(CLASS_TYPE_TEMPLAR))
        nMin += 2;//2 domains at 1st level
    if(GetLevelByClass(CLASS_TYPE_SHAMAN))
    {
        if(GetLevelByClass(CLASS_TYPE_SHAMAN) > 10)
            nMin += 1;//1 PRC domain at 11th level
    }
    if(GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE))
    {
        if(GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE) > 5)
            nMin += 2;//2 domains at 6th level
        else
            nMin += 1;//1 domain at 1st level
    }

    if(!nMin)
        return FALSE;

    int dPC;
    // Blightbringer Prestige domain can only be taken by Blightlord class so it's not added here
    dPC = GetHasFeat(FEAT_BONUS_DOMAIN_AIR)
        + GetHasFeat(FEAT_BONUS_DOMAIN_ANIMAL)
        + GetHasFeat(FEAT_BONUS_DOMAIN_DEATH)
        + GetHasFeat(FEAT_BONUS_DOMAIN_DESTRUCTION)
        + GetHasFeat(FEAT_BONUS_DOMAIN_EARTH)
        + GetHasFeat(FEAT_BONUS_DOMAIN_EVIL)
        + GetHasFeat(FEAT_BONUS_DOMAIN_FIRE)
        + GetHasFeat(FEAT_BONUS_DOMAIN_GOOD)
        + GetHasFeat(FEAT_BONUS_DOMAIN_HEALING)
        + GetHasFeat(FEAT_BONUS_DOMAIN_KNOWLEDGE)
        + GetHasFeat(FEAT_BONUS_DOMAIN_MAGIC)
        + GetHasFeat(FEAT_BONUS_DOMAIN_PLANT)
        + GetHasFeat(FEAT_BONUS_DOMAIN_PROTECTION)
        + GetHasFeat(FEAT_BONUS_DOMAIN_STRENGTH)
        + GetHasFeat(FEAT_BONUS_DOMAIN_SUN)
        + GetHasFeat(FEAT_BONUS_DOMAIN_TRAVEL)
        + GetHasFeat(FEAT_BONUS_DOMAIN_TRICKERY)
        + GetHasFeat(FEAT_BONUS_DOMAIN_WAR)
        + GetHasFeat(FEAT_BONUS_DOMAIN_WATER)
        + GetHasFeat(FEAT_BONUS_DOMAIN_DARKNESS)
        + GetHasFeat(FEAT_BONUS_DOMAIN_STORM)
        + GetHasFeat(FEAT_BONUS_DOMAIN_METAL)
        + GetHasFeat(FEAT_BONUS_DOMAIN_PORTAL)
        + GetHasFeat(FEAT_BONUS_DOMAIN_FORCE)
        + GetHasFeat(FEAT_BONUS_DOMAIN_SLIME)
        + GetHasFeat(FEAT_BONUS_DOMAIN_TYRANNY)
        + GetHasFeat(FEAT_BONUS_DOMAIN_DOMINATION)
        + GetHasFeat(FEAT_BONUS_DOMAIN_SPIDER)
        + GetHasFeat(FEAT_BONUS_DOMAIN_UNDEATH)
        + GetHasFeat(FEAT_BONUS_DOMAIN_TIME)
        + GetHasFeat(FEAT_BONUS_DOMAIN_DWARF)
        + GetHasFeat(FEAT_BONUS_DOMAIN_CHARM)
        + GetHasFeat(FEAT_BONUS_DOMAIN_ELF)
        + GetHasFeat(FEAT_BONUS_DOMAIN_FAMILY)
        + GetHasFeat(FEAT_BONUS_DOMAIN_FATE)
        + GetHasFeat(FEAT_BONUS_DOMAIN_GNOME)
        + GetHasFeat(FEAT_BONUS_DOMAIN_ILLUSION)
        + GetHasFeat(FEAT_BONUS_DOMAIN_HATRED)
        + GetHasFeat(FEAT_BONUS_DOMAIN_HALFLING)
        + GetHasFeat(FEAT_BONUS_DOMAIN_NOBILITY)
        + GetHasFeat(FEAT_BONUS_DOMAIN_OCEAN)
        + GetHasFeat(FEAT_BONUS_DOMAIN_ORC)
        + GetHasFeat(FEAT_BONUS_DOMAIN_RENEWAL)
        + GetHasFeat(FEAT_BONUS_DOMAIN_RETRIBUTION)
        + GetHasFeat(FEAT_BONUS_DOMAIN_RUNE)
        + GetHasFeat(FEAT_BONUS_DOMAIN_SPELLS)
        + GetHasFeat(FEAT_BONUS_DOMAIN_SCALEYKIND)
        + GetHasFeat(FEAT_BONUS_DOMAIN_DRAGON)
        + GetHasFeat(FEAT_BONUS_DOMAIN_COLD)
        + GetHasFeat(FEAT_BONUS_DOMAIN_WINTER);

    int nMax = nMin;
    //Determine maximum number of bonus domains (domains added automatically)
    if(GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS))
        nMax += 3;//3 domains at 1st level
    if(GetLevelByClass(CLASS_TYPE_SWIFT_WING))
        nMax += 1;//1 domain at 1st level

    if(nMin > dPC || dPC > nMax)
    {
        FloatingTextStringOnCreature("You have wrong amount of bonus domains. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }
    return FALSE;
}

int Shaman()
{
    int nClass = GetLevelByClass(CLASS_TYPE_SHAMAN);
    if(nClass)
    {
        int nIS = GetHasFeat(FEAT_DODGE)
                + GetHasFeat(FEAT_STUNNING_FIST)
                + GetHasFeat(FEAT_EXPERTISE)
                + GetHasFeat(FEAT_IMPROVED_EXPERTISE)
                + GetHasFeat(FEAT_IMPROVED_TRIP)
                + GetHasFeat(FEAT_IMPROVED_GRAPPLE)
                + GetHasFeat(FEAT_EARTHS_EMBRACE)
                + GetHasFeat(FEAT_PRC_IMP_DISARM)
                + GetHasFeat(FEAT_MOBILITY)
                + GetHasFeat(FEAT_SPRING_ATTACK)
                + GetHasFeat(FEAT_BLIND_FIGHT)
                + GetHasFeat(FEAT_DEFLECT_ARROWS);

          if(nIS < min(5, (nClass/4)))
          {
               FloatingTextStringOnCreature("You do not have the correct amount of bonus feats. Please reselect your feats.", OBJECT_SELF, FALSE);
               return TRUE;
          }
     }
     return FALSE;
}

int RacialFeats()
{
    int nRace = GetRacialType(OBJECT_SELF);

    if(nRace != RACIAL_TYPE_KALASHTAR
    && (GetHasFeat(FEAT_SOULBLADE_WARRIOR)
     || GetHasFeat(FEAT_SPIRITUAL_FORCE)
     || GetHasFeat(FEAT_STRENGTH_OF_TWO)
     || GetHasFeat(FEAT_SHIELD_OF_THOUGHT)))
    {
        FloatingTextStringOnCreature("You must be Kalashtar.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    if(!(nRace == RACIAL_TYPE_HUMAN
      || nRace == RACIAL_TYPE_TIEFLING
      || nRace == RACIAL_TYPE_TANARUKK
      || nRace == RACIAL_TYPE_FIRE_GEN)
     && GetHasFeat(FEAT_BLOODLINE_OF_FIRE))
    {
        FloatingTextStringOnCreature("You must be a Human or a Fire Planetouched to take this feat. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }
    
    if(nRace != RACIAL_TYPE_HUMAN
      && nRace != RACIAL_TYPE_HALFORC
      && nRace != RACIAL_TYPE_AARAKOCRA
      && nRace != RACIAL_TYPE_WEMIC
      && !GetHasFeat(FEAT_ORCISH)
      && GetHasFeat(FEAT_FURIOUS_CHARGE))
    {
        FloatingTextStringOnCreature("You must be a Human, Orc, Aarakocra, or Wemic to take Furious Charge. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }    

    if(nRace != RACIAL_TYPE_HUMAN && GetHasFeat(FEAT_PLAGUE_RESISTANT))
    {
        FloatingTextStringOnCreature("You must be a Human to take this feat. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }
    
    if(nRace != RACIAL_TYPE_HUMAN && GetHasFeat(FEAT_RHINO_TRIBE_CHARGE))
    {
        FloatingTextStringOnCreature("You must be a Human to take Rhino Tribe Charge. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }  
    
    if(nRace != RACIAL_TYPE_HUMAN && GetHasFeat(FEAT_GREAT_STAG_BERSERKER))
    {
        FloatingTextStringOnCreature("You must be a Human to take Great Stag Berserker. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }   
    
    if(nRace != RACIAL_TYPE_HUMAN && GetHasFeat(FEAT_ETTERCAP_BERSERKER))
    {
        FloatingTextStringOnCreature("You must be a Human to take Ettercap Berserker. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }   

    if(nRace != RACIAL_TYPE_HUMAN && GetHasFeat(FEAT_ICE_TROLL_BERSERKER))
    {
        FloatingTextStringOnCreature("You must be a Human to take Ice Troll Berserker. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }   
    
    if(nRace != RACIAL_TYPE_HUMAN && GetHasFeat(FEAT_WOLF_BERSERKER))
    {
        FloatingTextStringOnCreature("You must be a Human to take Wolf Berserker. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }      
    
    if(nRace != RACIAL_TYPE_HUMAN && GetHasFeat(FEAT_SNOW_TIGER_BERSERKER))
    {
        FloatingTextStringOnCreature("You must be a Human to take Snow Tiger Berserker. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    } 
    
    if(nRace != RACIAL_TYPE_HUMAN && GetHasFeat(FEAT_OWLBEAR_BERSERKER))
    {
        FloatingTextStringOnCreature("You must be a Human to take Owlbear Berserker. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }     
    
    if(nRace != RACIAL_TYPE_HUMAN && GetHasFeat(FEAT_LION_TRIBE_WARRIOR))
    {
        FloatingTextStringOnCreature("You must be a Human to take Lion Tribe Warrior. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    } 
    
    if(nRace != RACIAL_TYPE_HUMAN && GetHasFeat(FEAT_JOTUNBRUD))
    {
        FloatingTextStringOnCreature("You must be a Human to take Jotunbrud. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }     
    
    if(nRace != RACIAL_TYPE_HUMAN && GetHasFeat(FEAT_KEEN_INTELLECT))
    {
        FloatingTextStringOnCreature("You must be a Human to take Keen Intellect. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }   
    
    if(nRace != RACIAL_TYPE_HUMAN && GetHasFeat(FEAT_VREMYONNI_TRAINING))
    {
        FloatingTextStringOnCreature("You must be a Human to take Vremyonni Training. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }      

    if((nRace != RACIAL_TYPE_GOLIATH && nRace != RACIAL_TYPE_FERAL_GARGUN) && GetHasFeat(FEAT_HEAVY_LITHODERMS))
    {
        FloatingTextStringOnCreature("You must be a Goliath or Feral Gargun to take Heavy Lithoderms. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }
    
    if(nRace != RACIAL_TYPE_CATFOLK && GetHasFeat(FEAT_CATFOLK_POUNCE))
    {
        FloatingTextStringOnCreature("You must be a Catfolk to take Catfolk Pounce. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }    

    if(GetHasFeat(FEAT_LOLTHS_MEAT)
    && !(nRace == RACIAL_TYPE_DROW_FEMALE
      || nRace == RACIAL_TYPE_DROW_MALE
      || nRace == RACIAL_TYPE_HALFDROW))
    {
        FloatingTextStringOnCreature("You must be a Drow or Half-Drow to take this feat. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    if(GetHasFeat(FEAT_BLOOD_OF_THE_WARLORD)
    && nRace != RACIAL_TYPE_HALFORC
    && !GetHasFeat(FEAT_ORCISH))
    {
        FloatingTextStringOnCreature("You must be of orcish blood to take this feat. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    if(nRace == RACIAL_TYPE_SHIFTER)
    {
        int nNumFeats = GetShiftingFeats(OBJECT_SELF);
        if((GetHasFeat(FEAT_EXTRA_SHIFTER_TRAIT)     && nNumFeats < 3)
        || (GetHasFeat(FEAT_SHIFTER_DEFENSE)         && nNumFeats < 3)
        || (GetHasFeat(FEAT_GREATER_SHIFTER_DEFENSE) && nNumFeats < 5))
        {
            FloatingTextStringOnCreature("You must take more Shifter feats to take this feat.", OBJECT_SELF, FALSE);
            return TRUE;
        }
        
    	if(!GetHasFeat(FEAT_SHIFTER_LONGTOOTH) && !GetHasFeat(FEAT_SHIFTER_GOREBRUTE) && !GetHasFeat(FEAT_SHIFTER_RAZORCLAW) && GetHasFeat(FEAT_SHIFTER_SAVAGERY))
    	{
    	    FloatingTextStringOnCreature("You must have the Longtooth, Gorebrute, or Razorclaw trait to take Shifter Savagery. Please reselect your feats.", OBJECT_SELF, FALSE);
    	    return TRUE;
    	}         
    }
    
    if(GetHasFeat(FEAT_SHADOWFORM_FAMILIAR) && nRace != RACIAL_TYPE_KRINTH)
    {
        FloatingTextStringOnCreature("You must be a Krinth to take Shadowform Familiar. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }   
    if(GetHasFeat(FEAT_SHADOWSTRIKE) && nRace != RACIAL_TYPE_KRINTH)
    {
        FloatingTextStringOnCreature("You must be a Krinth to take Shadowstrike. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }      
    if(GetHasFeat(FEAT_SHIELD_DWARF_WARDER) && nRace != RACIAL_TYPE_DWARF)
    {
        FloatingTextStringOnCreature("You must be a original recipe Dwarf to take Shield Dwarf Warder. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }     
    
    nRace = MyPRCGetRacialType(OBJECT_SELF);

    if(nRace != RACIAL_TYPE_DWARF && GetHasFeat(FEAT_MORADINS_SMILE))
    {
        FloatingTextStringOnCreature("You must be a Dwarf to take this feat. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    if(nRace != RACIAL_TYPE_HUMANOID_ORC && nRace != RACIAL_TYPE_HALFORC && GetHasFeat(FEAT_MENACING_DEMEANOUR))
    {
        FloatingTextStringOnCreature("You must be an Orc to take this feat. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    return FALSE;
}

int WarlockFeats()
{
    if(GetHasFeat(FEAT_EXTRA_INVOCATION_I) && GetInvokerLevel(OBJECT_SELF, GetPrimaryInvocationClass()) < 6)
    {
        FloatingTextStringOnCreature("You must have access to lesser invocations to learn extra ones.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    if(GetHasFeat(FEAT_EPIC_EXTRA_INVOCATION_I) && GetInvokerLevel(OBJECT_SELF, GetPrimaryInvocationClass()) < 16)
    {
        FloatingTextStringOnCreature("You must have access to dark invocations to learn epic extra ones.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    int nWarlock = GetLevelByClass(CLASS_TYPE_WARLOCK);
    if(!nWarlock) return FALSE;

    int nFeats = GetHasFeat(FEAT_WARLOCK_RESIST_ACID)
               + GetHasFeat(FEAT_WARLOCK_RESIST_COLD)
               + GetHasFeat(FEAT_WARLOCK_RESIST_ELEC)
               + GetHasFeat(FEAT_WARLOCK_RESIST_FIRE)
               + GetHasFeat(FEAT_WARLOCK_RESIST_SONIC);

    if(nFeats > 2)
    {
        FloatingTextStringOnCreature("You can only choose two resistances.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    if(GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_I))
    {
        int nInvLvl = GetInvokerLevel(OBJECT_SELF, CLASS_TYPE_WARLOCK);
        int nEldBlast;
        if(nInvLvl < 13)
            nEldBlast = (nInvLvl + 1) / 2;
        else if(nInvLvl < 20)
            nEldBlast = (nInvLvl + 7) / 3;
        else
            nEldBlast = 9 + (nInvLvl - 20) / 2;

        if(nEldBlast < 9)
        {
            FloatingTextStringOnCreature("You must have 9d6 eldritch blast to take Epic Eldritch Blast.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }

    if(GetHasFeat(FEAT_WARLOCK_SHADOWMASTER))
    {
        if(!GetHasInvocation(INVOKE_BESHADOWED_BLAST)
        || !GetHasInvocation(INVOKE_DARK_DISCORPORATION)
        || !GetHasInvocation(INVOKE_DARKNESS)
        || !GetHasInvocation(INVOKE_ENERVATING_SHADOW))
        {
            FloatingTextStringOnCreature("You must have Beshadowed Blast, Dark Discorporation, Darkness, and Enervating Shadow.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }

    if(GetHasFeat(FEAT_PARAGON_VISIONARY))
    {
        if(!GetHasInvocation(INVOKE_DARK_FORESIGHT)
        || !GetHasInvocation(INVOKE_DEVILS_SIGHT)
        || !GetHasInvocation(INVOKE_SEE_THE_UNSEEN)
        || !GetHasInvocation(INVOKE_VOIDSENSE))
        {
            FloatingTextStringOnCreature("You must have Dark Foresight, Devil's Sight, See the Unseen, and Voidsense.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }

    if(GetHasFeat(FEAT_MORPHEME_SAVANT))
    {
        if(!GetHasInvocation(INVOKE_BALEFUL_UTTERANCE)
        || !GetHasInvocation(INVOKE_BEGUILING_INFLUENCE)
        || !GetHasInvocation(INVOKE_WORD_OF_CHANGING))
        {
            FloatingTextStringOnCreature("You must have Baleful Utterance, Beguiling Influence, and Word of Changing.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }

    if(GetHasFeat(FEAT_MASTER_OF_THE_ELEMENTS))
    {
        if(!GetHasInvocation(INVOKE_BREATH_OF_THE_NIGHT)
        || !GetHasInvocation(INVOKE_CHILLING_TENTACLES)
        || !GetHasInvocation(INVOKE_STONY_GRASP)
        || !GetHasInvocation(INVOKE_WALL_OF_PERILOUS_FLAME))
        {
            FloatingTextStringOnCreature("You must have Breath of the Night, Chilling Tentacles, Stony Grasp, and Wall of Perilous Flame.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
    
    if(GetHasFeat(FEAT_VERMINLORD))
    {
        if(!GetHasInvocation(INVOKE_TENACIOUS_PLAGUE)
        || !GetHasInvocation(INVOKE_SUMMON_SWARM))
        {
            FloatingTextStringOnCreature("You must have Tenacious Plague and Summon Swarm to take Verminlord.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }    

    if(GetHasFeat(FEAT_ELDRITCH_SCULPTOR))
    {
        // Dark blast shapes
        if(!GetHasInvocation(INVOKE_ELDRITCH_DOOM)
        // Greater blast shapes
        || !(GetHasInvocation(INVOKE_ELDRITCH_CONE)
          || GetHasInvocation(INVOKE_ELDRITCH_LINE))
        // Lesser blast shapes
        || !GetHasInvocation(INVOKE_ELDRITCH_CHAIN)
        // Least blast shapes
        || !(GetHasInvocation(INVOKE_ELDRITCH_GLAIVE)
          || GetHasInvocation(INVOKE_ELDRITCH_SPEAR)
          || GetHasInvocation(INVOKE_HIDEOUS_BLOW)))
        {
            FloatingTextStringOnCreature("You must have a blast shape invocation of each invocation level.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }

    if(GetHasFeat(FEAT_LORD_OF_ALL_ESSENCES))
    {
        // Dark essences
        if(!(GetHasInvocation(INVOKE_BINDING_BLAST)
          || GetHasInvocation(INVOKE_UTTERDARK_BLAST))
        // Greater essences
        || !(GetHasInvocation(INVOKE_BEWITCHING_BLAST)
          || GetHasInvocation(INVOKE_HINDERING_BLAST)
          || GetHasInvocation(INVOKE_INCARNUM_BLAST)
          || GetHasInvocation(INVOKE_NOXIOUS_BLAST)
          || GetHasInvocation(INVOKE_PENETRATING_BLAST)
          || GetHasInvocation(INVOKE_VITRIOLIC_BLAST))
        // Lesser essences
        || !(GetHasInvocation(INVOKE_BANEFUL_BLAST_ABBERATION)
          || GetHasInvocation(INVOKE_BANEFUL_BLAST_BEAST)
          || GetHasInvocation(INVOKE_BANEFUL_BLAST_CONSTRUCT)
          || GetHasInvocation(INVOKE_BANEFUL_BLAST_DRAGON)
          || GetHasInvocation(INVOKE_BANEFUL_BLAST_DWARF)
          || GetHasInvocation(INVOKE_BANEFUL_BLAST_ELF)
          || GetHasInvocation(INVOKE_BANEFUL_BLAST_ELEMENTAL)
          || GetHasInvocation(INVOKE_BANEFUL_BLAST_FEY)
          || GetHasInvocation(INVOKE_BANEFUL_BLAST_GIANT)
          || GetHasInvocation(INVOKE_BANEFUL_BLAST_GOBLINOID)
          || GetHasInvocation(INVOKE_BANEFUL_BLAST_GNOME)
          || GetHasInvocation(INVOKE_BANEFUL_BLAST_HALFLING)
          || GetHasInvocation(INVOKE_BANEFUL_BLAST_HUMAN)
          || GetHasInvocation(INVOKE_BANEFUL_BLAST_MONSTEROUS)
          || GetHasInvocation(INVOKE_BANEFUL_BLAST_ORC)
          || GetHasInvocation(INVOKE_BANEFUL_BLAST_OUTSIDER)
          || GetHasInvocation(INVOKE_BANEFUL_BLAST_PLANT)
          || GetHasInvocation(INVOKE_BANEFUL_BLAST_REPTILIAN)
          || GetHasInvocation(INVOKE_BANEFUL_BLAST_SHAPECHANGER)
          || GetHasInvocation(INVOKE_BANEFUL_BLAST_UNDEAD)
          || GetHasInvocation(INVOKE_BANEFUL_BLAST_VERMIN)
          || GetHasInvocation(INVOKE_BESHADOWED_BLAST)
          || GetHasInvocation(INVOKE_BRIMSTONE_BLAST)
          || GetHasInvocation(INVOKE_HELLRIME_BLAST))
        // Least essences
        || !(GetHasInvocation(INVOKE_FRIGHTFUL_BLAST)
          || GetHasInvocation(INVOKE_HAMMER_BLAST)
          || GetHasInvocation(INVOKE_SICKENING_BLAST)))
        {
            FloatingTextStringOnCreature("You must have an eldritch essence invocation of each invocation level.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
    return FALSE;
}

/*int FavoredOfMilil()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_FAVORED_MILIL);
    if(!nLevel) return FALSE;

    int nSongs = GetHasFeat(FEAT_FOM_DIVINE_SONG_BLESS)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_CONVICTION)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_CURELIGHT)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_REMOVEFEAR)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_SANCTUARY)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_SHIELDFAITH)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_AID)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_BULLSTRENGTH)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_CUREMODERATE)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_EAGLESPLENDOR)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_ENDURANCE)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_FOXCUNNING)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_LESSRESTORE)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_OWLWISDOM)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_CLAIRVOYANCE)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_CLARITY)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_CURESERIOUS)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_NEGATIVEPROT)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_PRAYER)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_PROTELEMENTS)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_REMOVECURSE)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_CURECRITICAL)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_DEATHWARD)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_FREEDOMMOVEMENT)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_PANACEA)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_RESTORATION)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_STONESKIN)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_TRUESEEING)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_MONSTREGEN)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_RAISEDEAD)
               + GetHasFeat(FEAT_FOM_DIVINE_SONG_SPELLRESISTANCE);

    if(nSongs > (nLevel+1)/2)
    {
        FloatingTextStringOnCreature("You do not have the correct amount of Divine Songs. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    return FALSE;
}*/

int AcolyteEgo()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_ACOLYTE_EGO);
    if(!nLevel) return FALSE;

    int nCount = GetHasFeat(FEAT_EGO_BULL)
               + GetHasFeat(FEAT_EGO_IRON)
               + GetHasFeat(FEAT_EGO_HEART)
               + GetHasFeat(FEAT_EGO_SWALLOW)
               + GetHasFeat(FEAT_EGO_WOUND)
               + GetHasFeat(FEAT_EGO_FOOL)
               + GetHasFeat(FEAT_EGO_FORT)
               + GetHasFeat(FEAT_EGO_FRIGHT)
               + GetHasFeat(FEAT_EGO_DRAKE)
               + GetHasFeat(FEAT_EGO_STEP);
    int nReturn = FALSE;   

    if(nCount == 5 && nLevel != 10) nReturn = TRUE;
    else if(nCount == 4 && (nLevel != 9 && nLevel != 8)) nReturn = TRUE;
    else if(nCount == 3 && (nLevel != 7 && nLevel != 6)) nReturn = TRUE;
    else if(nCount == 2 && (nLevel != 5 && nLevel != 4)) nReturn = TRUE;
    else if(nCount == 1 && (nLevel != 3 && nLevel != 2)) nReturn = TRUE;
    
    if (nReturn)
    {
        FloatingTextStringOnCreature("You do not have the correct amount of cadences. Please reselect your feats.", OBJECT_SELF, FALSE);
        return TRUE;
    }

    return FALSE;
}


int EpicCasting()
{
    if(GetLocalInt(OBJECT_SELF, "PRC_ArcSpell9") || GetLocalInt(OBJECT_SELF, "PRC_DivSpell9"))
    {
        if(GetHasFeat(FEAT_EPIC_SPELLCASTING))
        {
            FloatingTextStringOnCreature("Epic Spellcasting requires level 9 Arcane or Divine spells", OBJECT_SELF, FALSE);
            return TRUE;
        }

        if(GetHasFeat(FEAT_IGNORE_MATERIALS))
        {
            FloatingTextStringOnCreature("You must be able to cast 9th level spells to take this feat.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
    return FALSE;
}

int OcularAdeptDomains()
{
    if(GetLevelByClass(CLASS_TYPE_OCULAR))
    {
        int iCleDom = GetHasFeat(FEAT_EVIL_DOMAIN_POWER)
                    + GetHasFeat(FEAT_STRENGTH_DOMAIN_POWER)
                    + GetHasFeat(FEAT_DOMAIN_POWER_HATRED)
                    + GetHasFeat(FEAT_DOMAIN_POWER_TYRANNY);

        if(iCleDom < 2)
        {
            FloatingTextStringOnCreature("You must have two of the following domains: Evil, Strength, Hatred, or Tyranny to be an Ocular Adept. Please reselect your feats.", OBJECT_SELF, FALSE);
            return TRUE;
        }
    }
    return FALSE;
}

int ReserveFeats()
{
    object oPC = OBJECT_SELF;

    int nClass = GetPrimarySpellcastingClass(oPC);
    int nLevel = GetLevelByClass(nClass, oPC);

    if (GetIsDivineClass(nClass, oPC)) nLevel += GetDivinePRCLevels(oPC, nClass);
    else if (GetIsArcaneClass(nClass, oPC)) nLevel += GetArcanePRCLevels(oPC, nClass);
    
    int nSpellLevelKnown = GetMaxSpellLevelForCasterLevel(nClass, nLevel);

    if (GetHasFeat(FEAT_HOLY_WARRIOR, oPC) && (nSpellLevelKnown < 4 || (!GetHasFeat(FEAT_WAR_DOMAIN_POWER, oPC) && !GetHasFeat(FEAT_BONUS_DOMAIN_WAR, oPC))))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Holy Warrior", oPC, FALSE);
        return TRUE;
    }

    if (GetHasFeat(FEAT_ACIDIC_SPLATTER, oPC) && (nSpellLevelKnown < 2))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Acidic Splatter", oPC, FALSE);
        return TRUE;
    }

    if (GetHasFeat(FEAT_FIERY_BURST, oPC) && (nSpellLevelKnown < 2))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Fiery Burst", oPC, FALSE);
        return TRUE;
    }

    if (GetHasFeat(FEAT_STORM_BOLT, oPC) && (nSpellLevelKnown < 3))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Storm Bolt", oPC, FALSE);
        return TRUE;
    }

    if (GetHasFeat(FEAT_WINTERS_BLAST, oPC) && (nSpellLevelKnown < 2))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Winter's Blast", oPC, FALSE);
        return TRUE;
    }

    if (GetHasFeat(FEAT_MYSTIC_BACKLASH, oPC) && (nSpellLevelKnown < 5))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Mystic Backlash", oPC, FALSE);
        return TRUE;
    }

    if (GetHasFeat(FEAT_CLAP_OF_THUNDER, oPC) && (nSpellLevelKnown < 3))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Clap of Thunder", oPC, FALSE);
        return TRUE;
    }

    if (GetHasFeat(FEAT_SICKENING_GRASP, oPC) && (nSpellLevelKnown < 3))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Sickening Grasp", oPC, FALSE);
        return TRUE;
    }

    if (GetHasFeat(FEAT_TOUCH_OF_HEALING, oPC) && (nSpellLevelKnown < 2))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Touch of Healing", oPC, FALSE);
        return TRUE;
    }

    if (GetHasFeat(FEAT_DIMENSIONAL_JAUNT, oPC) && (nSpellLevelKnown < 4))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Dimensional Jaunt", oPC, FALSE);
        return TRUE;
    }

    if (GetHasFeat(FEAT_CLUTCH_OF_EARTH, oPC) && (nSpellLevelKnown < 2))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Clutch of Earth", oPC, FALSE);
        return TRUE;
    }

    if (GetHasFeat(FEAT_BORNE_ALOFT, oPC) && (nSpellLevelKnown < 5))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Borne Aloft", oPC, FALSE);
        return TRUE;
    }

    if (GetHasFeat(FEAT_PROTECTIVE_WARD, oPC) && !GetHasFeat(FEAT_PROTECTION_DOMAIN_POWER, oPC) && !GetHasFeat(FEAT_BONUS_DOMAIN_PROTECTION, oPC))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Protective Ward", oPC, FALSE);
        return TRUE;
    }
    
    if (GetHasFeat(FEAT_SHADOW_VEIL, oPC) && (nSpellLevelKnown < 2))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Shadow Veil", oPC, FALSE);
        return TRUE;
    }

    if (GetHasFeat(FEAT_SUNLIGHT_EYES, oPC) && (nSpellLevelKnown < 2))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Sunlight Eyes", oPC, FALSE);
        return TRUE;
    }

    if (GetHasFeat(FEAT_TOUCH_OF_DISTRACTION, oPC) && (nSpellLevelKnown < 3))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Touch of Distraction", oPC, FALSE);
        return TRUE;
    }

    if (GetHasFeat(FEAT_UMBRAL_SHROUD, oPC) && (nSpellLevelKnown < 3))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Umbral Shroud", oPC, FALSE);
        return TRUE;
    }

    if (GetHasFeat(FEAT_CHARNEL_MIASMA, oPC) && !GetHasFeat(FEAT_DEATH_DOMAIN_POWER, oPC) && !GetHasFeat(FEAT_BONUS_DOMAIN_DEATH, oPC))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Charnel Miasma", oPC, FALSE);
        return TRUE;
    }

    if (GetHasFeat(FEAT_DROWNING_GLANCE, oPC) && (nSpellLevelKnown < 4))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Drowning Glance", oPC, FALSE);
        return TRUE;
    }

    if (GetHasFeat(FEAT_INVISIBLE_NEEDLE, oPC) && (nSpellLevelKnown < 3))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Invisible Needle", oPC, FALSE);
        return TRUE;
    }

    if (GetHasFeat(FEAT_SUMMON_ELEMENTAL, oPC) && (nSpellLevelKnown < 4))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Summon Elemental", oPC, FALSE);
        return TRUE;
    }

    if (GetHasFeat(FEAT_DIMENSIONAL_REACH, oPC) && (nSpellLevelKnown < 3))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Dimensional Reach", oPC, FALSE);
        return TRUE;
    }

    if (GetHasFeat(FEAT_HURRICANE_BREATH, oPC) && (nSpellLevelKnown < 2))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Hurricane Breath", oPC, FALSE);
        return TRUE;
    }

    if (GetHasFeat(FEAT_MINOR_SHAPESHIFT, oPC) && (nSpellLevelKnown < 4))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Minor Shapeshift", oPC, FALSE);
        return TRUE;
    }

    if (GetHasFeat(FEAT_FACECHANGER, oPC) && (nSpellLevelKnown < 3))
    {
        FloatingTextStringOnCreature("You do not meet the prerequisites for Face-Changer", oPC, FALSE);
        return TRUE;
    }
    return FALSE;
}

int ToB()
{
    object oInitiator = OBJECT_SELF;
    
    if (GetAlignmentGoodEvil(OBJECT_SELF) != ALIGNMENT_GOOD && GetHasFeat(FEAT_AVENGING_STRIKE))
    {
        FloatingTextStringOnCreature("You must be of good alignment to take Avenging Strike.", OBJECT_SELF, FALSE);
        return TRUE;    
    }
    if (!GetIsBladeMagicUser(oInitiator) && BladeMeditationFeat(oInitiator) >= 1) // Have to know one maneuver
    {
        FloatingTextStringOnCreature("You must know at least one maneuver to take Blade Meditation", OBJECT_SELF, FALSE);
        return TRUE;    
    }  
    if (GetManeuverCount(oInitiator, DISCIPLINE_DESERT_WIND, MANEUVER_TYPE_STRIKE) >= 1  && GetHasFeat(FEAT_DESERT_FIRE))
    {
        FloatingTextStringOnCreature("You must know a Desert Wind strike to take Desert Fire.", OBJECT_SELF, FALSE);
        return TRUE;    
    }    
    if (GetManeuverCount(oInitiator, DISCIPLINE_DESERT_WIND, MANEUVER_TYPE_MANEUVER) >= 1  && GetHasFeat(FEAT_DESERT_WIND_DODGE))
    {
        FloatingTextStringOnCreature("You must know a Desert Wind maneuver to take Desert Wind Dodge.", OBJECT_SELF, FALSE);
        return TRUE;    
    }   
    if (GetManeuverCount(oInitiator, DISCIPLINE_DEVOTED_SPIRIT, MANEUVER_TYPE_MANEUVER) >= 1  && GetHasFeat(FEAT_DEVOTED_BULWARK))
    {
        FloatingTextStringOnCreature("You must know a Devoted Spirit maneuver to take Devoted Bulwark.", OBJECT_SELF, FALSE);
        return TRUE;    
    } 
    if (GetManeuverCount(oInitiator, DISCIPLINE_DEVOTED_SPIRIT, MANEUVER_TYPE_STANCE) >= 1  && GetHasFeat(FEAT_DIVINE_SPIRIT))
    {
        FloatingTextStringOnCreature("You must know a Devoted Spirit stance to take Divine Spirit.", OBJECT_SELF, FALSE);
        return TRUE;    
    }   
    if (GetManeuverCount(oInitiator, DISCIPLINE_IRON_HEART, MANEUVER_TYPE_STANCE) >= 1  && GetHasFeat(FEAT_IRONHEART_AURA))
    {
        FloatingTextStringOnCreature("You must know an Iron Heart stance to take Ironheart Aura.", OBJECT_SELF, FALSE);
        return TRUE;    
    }     
    if (GetManeuverCount(oInitiator, DISCIPLINE_SHADOW_HAND, MANEUVER_TYPE_STANCE) >= 1  && GetHasFeat(FEAT_SHADOW_BLADE))
    {
        FloatingTextStringOnCreature("You must know a Shadow Hand stance to take Shadow Blade.", OBJECT_SELF, FALSE);
        return TRUE;    
    }   
    if (GetManeuverCount(oInitiator, DISCIPLINE_SHADOW_HAND, MANEUVER_TYPE_STRIKE) >= 1  && GetHasFeat(FEAT_SHADOW_TRICKSTER) && (GetCasterLvl(TYPE_DIVINE) + GetCasterLvl(TYPE_ARCANE)) == 0)
    {
        FloatingTextStringOnCreature("You must know a Shadow Hand strike and have a caster level to take Shadow Trickster.", OBJECT_SELF, FALSE);
        return TRUE;    
    } 
    if (!GetIsBladeMagicUser(oInitiator) && GetHasFeat(FEAT_VITAL_RECOVERY)) // Every base class grants at least 2
    {
        FloatingTextStringOnCreature("You must know at least two maneuvers to take Vital Recovery.", OBJECT_SELF, FALSE);
        return TRUE;    
    }  
    if (GetManeuverCount(oInitiator, DISCIPLINE_WHITE_RAVEN, MANEUVER_TYPE_STANCE) >= 1  && GetHasFeat(FEAT_WHITE_RAVEN_DEFENSE))
    {
        FloatingTextStringOnCreature("You must know a White Raven stance to take White Raven Defense.", OBJECT_SELF, FALSE);
        return TRUE;    
    }  
    if (!GetIsBladeMagicUser(oInitiator) && GetHasFeat(FEAT_SUDDEN_RECOVERY)) // Every base class grants at least 1
    {
        FloatingTextStringOnCreature("You must know at least one maneuver to take Sudden Recovery.", OBJECT_SELF, FALSE);
        return TRUE;    
    } 
    if (GetManeuverCount(oInitiator, DISCIPLINE_WHITE_RAVEN, MANEUVER_TYPE_MANEUVER) >= 1 && GetHasFeat(FEAT_SONG_WHITE_RAVEN))
    {
        FloatingTextStringOnCreature("You must know a White Raven maneuver to take Song of the White Raven.", OBJECT_SELF, FALSE);
        return TRUE;    
    }     
    if (!GetIsBladeMagicUser(oInitiator) && !GetIsPsionicCharacter(oInitiator) && GetHasFeat(FEAT_PSYCHIC_RENEWAL))
    {
        FloatingTextStringOnCreature("You must be an initiator and have a psionic focus to take this feat.", OBJECT_SELF, FALSE);
        return TRUE;    
    }  
    if (GetManeuverCount(oInitiator, DISCIPLINE_TIGER_CLAW, MANEUVER_TYPE_MANEUVER) >= 1  && GetHasFeat(FEAT_TIGER_BLOODED))
    {
        FloatingTextStringOnCreature("You must know a Tiger Claw maneuver and be able to rage, shift, or wild shape to take Tiger Blooded.", OBJECT_SELF, FALSE);
        return TRUE;    
    }  
    if (GetManeuverCount(oInitiator, DISCIPLINE_STONE_DRAGON, MANEUVER_TYPE_MANEUVER) >= 1  && GetHasFeat(FEAT_STONE_POWER))
    {
        FloatingTextStringOnCreature("You must know a Stone Dragon maneuver to take Stone Power.", OBJECT_SELF, FALSE);
        return TRUE;    
    }     
    
    
    // Frostburn feats tucked in here as well
    if (GetAlignmentGoodEvil(OBJECT_SELF) != ALIGNMENT_EVIL && GetAlignmentLawChaos(OBJECT_SELF) != ALIGNMENT_CHAOTIC && GetHasFeat(FEAT_CHOSEN_OF_IBORIGHU))
    {
        FloatingTextStringOnCreature("You must be of Chaotic Evil alignment to take Chosen of Iborighu.", OBJECT_SELF, FALSE);
        return TRUE;    
    }   
    if (GetHasFeat(FEAT_FAITH_IN_THE_FROST) && !GetHasFeat(FEAT_DOMAIN_COLD) && !GetHasFeat(FEAT_DOMAIN_WINTER))
    {
        FloatingTextStringOnCreature("You must have either the Cold or Winter domain to take Faith in the Frost.", OBJECT_SELF, FALSE);
        return TRUE;    
    } 
    
    // Complete Warrior too
    if (GetHasFeat(FEAT_ANVIL_OF_THUNDER))
    {
        int nAxe = GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE);
        nAxe += GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE);
        nAxe += GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE);
        
        int nHam = GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_HAMMER);
        nHam += GetHasFeat(FEAT_WEAPON_FOCUS_WAR_HAMMER);
        
        if (1 > nHam || 1 > nAxe)
        {
            FloatingTextStringOnCreature("You must have weapon focus in a one handed axe and a one handed hammer to take Anvil of Thunder", OBJECT_SELF, FALSE);
            return TRUE;    
        }    
    }   
    if (GetHasFeat(FEAT_HAMMERS_EDGE))
    {
        int nAxe = GetHasFeat(FEAT_WEAPON_FOCUS_BASTARD_SWORD);
        nAxe += GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD);
        nAxe += GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR);
        
        int nHam = GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_HAMMER);
        nHam += GetHasFeat(FEAT_WEAPON_FOCUS_WAR_HAMMER);
        
        if (1 > nHam || 1 > nAxe)
        {
            FloatingTextStringOnCreature("You must have weapon focus in a one handed sword and a one handed hammer to take Hammer's Edge", OBJECT_SELF, FALSE);
            return TRUE;    
        }    
    } 
    if (GetHasFeat(FEAT_HIGH_SWORD_LOW_AXE))
    {
        int nAxe = GetHasFeat(FEAT_WEAPON_FOCUS_BASTARD_SWORD);
        nAxe += GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD);
        nAxe += GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR);
        
        int nHam = GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE);
        nHam += GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE);
        nHam += GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE);
        
        if (1 > nHam || 1 > nAxe)
        {
            FloatingTextStringOnCreature("You must have weapon focus in a one handed sword and a one handed axe to take High Sword Low Axe", OBJECT_SELF, FALSE);
            return TRUE;    
        }    
    }    
    if (GetHasFeat(FEAT_THREE_MOUNTAINS) && !GetHasFeat(FEAT_WEAPON_FOCUS_DIRE_MACE) && !GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_FLAIL) && !GetHasFeat(FEAT_WEAPON_FOCUS_MORNING_STAR) && !GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_MACE))
    {
        FloatingTextStringOnCreature("You must have weapon focus in heavy mace, dire mace, heavy flail, or morning star to take Three Mountains.", OBJECT_SELF, FALSE);
        return TRUE;    
    }    
    if (GetHasFeat(FEAT_INLINDL_SCHOOL) && !GetHasFeat(FEAT_SHIELD_PROFICIENCY))
    {
        FloatingTextStringOnCreature("You must have shield proficiency to take Inlindl School.", OBJECT_SELF, FALSE);
        return TRUE;    
    }      
    if (GetAlignmentGoodEvil(OBJECT_SELF) != ALIGNMENT_EVIL && GetAlignmentLawChaos(OBJECT_SELF) != ALIGNMENT_CHAOTIC && GetHasFeat(FEAT_CHOSEN_OF_IBORIGHU))
    {
        FloatingTextStringOnCreature("You must be of Chaotic Evil alignment to take Chosen of Iborighu.", OBJECT_SELF, FALSE);
        return TRUE;    
    }   
    if (GetHasFeat(FEAT_LOLTHS_BOON))
    {
        int nValid = FALSE;
        // Chaotic Evil or Drow
        if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL && GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_CHAOTIC) nValid = TRUE;
        if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_DROW_FEMALE || GetRacialType(OBJECT_SELF) == RACIAL_TYPE_DROW_MALE) nValid = TRUE;
        if (!nValid)
        {
            FloatingTextStringOnCreature("You must be Chaotic Evil or a Drow to take Lolth's Boon", OBJECT_SELF, FALSE);
            return TRUE;    
        }    
    }     
    if (2 > GetFortitudeSavingThrow(OBJECT_SELF) && GetHasFeat(FEAT_HEAT_ENDURANCE) && GetRacialType(OBJECT_SELF) != RACIAL_TYPE_ASHERATI)
    {
        FloatingTextStringOnCreature("You must have a base fortitude save of +2 or greater to take Heat Endurance", OBJECT_SELF, FALSE);
        return TRUE;    
    }     
    if (6 > GetFortitudeSavingThrow(OBJECT_SELF) && GetHasFeat(FEAT_IMP_HEAT_ENDURANCE))
    {
        FloatingTextStringOnCreature("You must have a base fortitude save of +6 or greater to take Improved Heat Endurance", OBJECT_SELF, FALSE);
        return TRUE;    
    } 
    if (2 > GetFortitudeSavingThrow(OBJECT_SELF) && GetHasFeat(FEAT_COLD_ENDURANCE))
    {
        FloatingTextStringOnCreature("You must have a base fortitude save of +2 or greater to take Cold Endurance", OBJECT_SELF, FALSE);
        return TRUE;    
    }     
    if (6 > GetFortitudeSavingThrow(OBJECT_SELF) && GetHasFeat(FEAT_IMP_COLD_ENDURANCE))
    {
        FloatingTextStringOnCreature("You must have a base fortitude save of +6 or greater to take Improved Cold Endurance", OBJECT_SELF, FALSE);
        return TRUE;    
    }    
    if (GetHasFeat(FEAT_CRESCENT_MOON))
    {
        int nAxe = GetHasFeat(FEAT_WEAPON_FOCUS_BASTARD_SWORD);
        nAxe += GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD);
        nAxe += GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR);
        nAxe += GetHasFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD);
        
        int nHam = GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER);
        
        if (1 > nHam || 1 > nAxe)
        {
            FloatingTextStringOnCreature("You must have weapon focus in a one handed sword and a dagger to take Crescent Moon", OBJECT_SELF, FALSE);
            return TRUE;    
        }    
    }  
    if (GetHasFeat(FEAT_STEAL_AND_STRIKE))
    {
        int nAxe = GetHasFeat(FEAT_WEAPON_FOCUS_KUKRI);
        
        int nHam = GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER);
        
        if (1 > nHam || 1 > nAxe)
        {
            FloatingTextStringOnCreature("You must have weapon focus in rapier and kukri to take Steal and Strike", OBJECT_SELF, FALSE);
            return TRUE;    
        }    
    } 
    if (GetHasFeat(FEAT_BEAR_FANG))
    {
        int nAxe = GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE);
        nAxe += GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE);
        nAxe += GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE);
        
        int nHam = GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER);
        
        if (1 > nHam || 1 > nAxe)
        {
            FloatingTextStringOnCreature("You must have weapon focus in a one handed axe and a dagger to take Bear Fang", OBJECT_SELF, FALSE);
            return TRUE;    
        }    
    }  
    if (GetHasFeat(FEAT_QUICK_STAFF) && !GetHasFeat(FEAT_WEAPON_FOCUS_STAFF))
    {
        FloatingTextStringOnCreature("You must have weapon focus in the quarterstaff to take Quick Staff", OBJECT_SELF, FALSE);
        return TRUE;    
    } 
    
    if (GetHasFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING) && !GetHasFeat(FEAT_AMBIDEXTERITY) && !GetPRCSwitch(PRC_35_TWO_WEAPON_FIGHTING) && !GetLevelByClass(CLASS_TYPE_TEMPEST) && 9 > GetLevelByClass(CLASS_TYPE_RANGER))
    {
        FloatingTextStringOnCreature("You must have ambidexterity to take Improved Two Weapon Fighting", OBJECT_SELF, FALSE);
        return TRUE;    
    } 
    
    if (GetHasFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING) && GetPRCSwitch(PRC_35_TWO_WEAPON_FIGHTING) && 17 > GetAbilityScore(OBJECT_SELF, ABILITY_DEXTERITY, TRUE) && !GetLevelByClass(CLASS_TYPE_TEMPEST) && 9 > GetLevelByClass(CLASS_TYPE_RANGER))
    {
        FloatingTextStringOnCreature("You must have 17 Dexterity to take Improved Two Weapon Fighting under 3.5 rules", OBJECT_SELF, FALSE);
        return TRUE;    
    }  
    
    if (GetHasFeat(FEAT_TWO_WEAPON_FIGHTING) && GetPRCSwitch(PRC_35_TWO_WEAPON_FIGHTING) && 15 > GetAbilityScore(OBJECT_SELF, ABILITY_DEXTERITY, TRUE) && !GetLevelByClass(CLASS_TYPE_RANGER) && 2 > GetLevelByClass(CLASS_TYPE_CW_SAMURAI))
    {
        FloatingTextStringOnCreature("You must have 15 Dexterity to take Two Weapon Fighting under 3.5 rules", OBJECT_SELF, FALSE);
        return TRUE;    
    }       
    
    if (GetHasFeat(FEAT_AWESOME_BLOW) && _GetSizeForPrereq(OBJECT_SELF) < CREATURE_SIZE_LARGE && !GetHasSpellEffect(MELD_WORMTAIL_BELT, OBJECT_SELF))
    {
        FloatingTextStringOnCreature("You must be size large or greater to take Awesome Blow", OBJECT_SELF, FALSE);
        return TRUE;    
    } 
    if (GetHasFeat(FEAT_RAMPAGING_BULL_RUSH) && _GetSizeForPrereq(OBJECT_SELF) < CREATURE_SIZE_LARGE)
    {
        FloatingTextStringOnCreature("You must be size large or greater to take Rampaging Bull Rush", OBJECT_SELF, FALSE);
        return TRUE;    
    }  
    if (GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE) && MyPRCGetRacialType(OBJECT_SELF) != RACIAL_TYPE_DWARF && !GetHasFeat(FEAT_WEAPON_PROFICIENCY_DWARVEN_WARAXE) && !GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC))
    {
        FloatingTextStringOnCreature("You must be a dwarf to take Weapon Focus: Dwarven War Axe without Exotic proficiency", OBJECT_SELF, FALSE);
        return TRUE;    
    }  
    if (GetHasFeat(FEAT_IMPROVED_CRITICAL_DWAXE) && MyPRCGetRacialType(OBJECT_SELF) != RACIAL_TYPE_DWARF && !GetHasFeat(FEAT_WEAPON_PROFICIENCY_DWARVEN_WARAXE) && !GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC))
    {
        FloatingTextStringOnCreature("You must be a dwarf to take Improved Critical: Dwarven War Axe without Exotic proficiency", OBJECT_SELF, FALSE);
        return TRUE;    
    }     
    
    // Shadowcasting feats
    int nCount = GetHasFeat(FEAT_EMPOWER_MYSTERY)
               + GetHasFeat(FEAT_EXTEND_MYSTERY)
               + GetHasFeat(FEAT_MAXIMIZE_MYSTERY)
               + GetHasFeat(FEAT_QUICKEN_MYSTERY)
               + GetHasFeat(FEAT_STILL_MYSTERY) -1; // The minus one is to not account for any feat they just acquired
    
    if (1 > nCount && GetHasFeat(FEAT_EMPOWER_MYSTERY))
    {
        FloatingTextStringOnCreature("You must have one other Metashadow feat before taking Empower Mystery", OBJECT_SELF, FALSE);
        return TRUE;    
    }      
    if (2 > nCount && GetHasFeat(FEAT_MAXIMIZE_MYSTERY))
    {
        FloatingTextStringOnCreature("You must have two other Metashadow feats before taking Maximize Mystery", OBJECT_SELF, FALSE);
        return TRUE;    
    }      
    if (3 > nCount && GetHasFeat(FEAT_QUICKEN_MYSTERY))
    {
        FloatingTextStringOnCreature("You must have three other Metashadow feats before taking Quicken Mystery", OBJECT_SELF, FALSE);
        return TRUE;    
    }    
    
    // Incarnum Feats
    if(GetLocalInt(OBJECT_SELF, "PRC_PsiPower2") && GetHasFeat(FEAT_MIDNIGHT_AUGMENTATION))
    {
        FloatingTextStringOnCreature("You must be able to manifest 2nd level Psionic Powers before taking Midnight Augmentation", OBJECT_SELF, FALSE);
        return TRUE;    
    }  
    if(!GetCanBindChakra(OBJECT_SELF, CHAKRA_HEART) && GetHasFeat(FEAT_HEART_INCARNUM))
    {
        FloatingTextStringOnCreature("You must be able to bind your heart chakra before taking Heart of Incarnum", OBJECT_SELF, FALSE);
        return TRUE;    
    }  
    if(2 > GetTotalEssentia(OBJECT_SELF) && GetHasFeat(FEAT_IMPROVED_ESSENTIA_CAPACITY))
    {
        FloatingTextStringOnCreature("You must have an Essentia Pool of two or greater before taking Improved Essentia Capacity", OBJECT_SELF, FALSE);
        return TRUE;    
    }  
    if(GetTotalEssentia(OBJECT_SELF) && GetHasFeat(FEAT_INCARNUM_RESISTANCE))
    {
        FloatingTextStringOnCreature("You must not have an Essentia Pool when taking Incarnum Resistance", OBJECT_SELF, FALSE);
        return TRUE;    
    } 
    if((!GetTotalSoulmeldCount(OBJECT_SELF) || GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD) && GetHasFeat(FEAT_NECROCARNUM_ACOLYTE))
    {
        FloatingTextStringOnCreature("You must be able to shape soulmelds and be nongood to take Necrocarnum Acolyte", OBJECT_SELF, FALSE);
        return TRUE;    
    }
    if(MyPRCGetRacialType(OBJECT_SELF) != RACIAL_TYPE_UNDEAD && GetHasFeat(FEAT_UNDEAD_MELDSHAPER))
    {
        FloatingTextStringOnCreature("You must be undead to take Undead Meldshaper", OBJECT_SELF, FALSE);
        return TRUE;    
    }     
    if((GetHasFeat(FEAT_DOUBLE_CHAKRA_CROWN    ) ||
        GetHasFeat(FEAT_DOUBLE_CHAKRA_FEET     ) ||
        GetHasFeat(FEAT_DOUBLE_CHAKRA_HANDS    ) ||
        GetHasFeat(FEAT_DOUBLE_CHAKRA_ARMS     ) ||
        GetHasFeat(FEAT_DOUBLE_CHAKRA_BROW     ) ||
        GetHasFeat(FEAT_DOUBLE_CHAKRA_SHOULDERS) ||
        GetHasFeat(FEAT_DOUBLE_CHAKRA_THROAT   ) ||
        GetHasFeat(FEAT_DOUBLE_CHAKRA_WAIST    ) ||
        GetHasFeat(FEAT_DOUBLE_CHAKRA_HEART    ) ||
        GetHasFeat(FEAT_DOUBLE_CHAKRA_SOUL     ) ||
        GetHasFeat(FEAT_DOUBLE_CHAKRA_TOTEM    )) && 9 > GetHighestMeldshaperLevel(OBJECT_SELF))
    {
        FloatingTextStringOnCreature("You must have a meldshaper level of 9th to take Double Chakra", OBJECT_SELF, FALSE);
        return TRUE;     
    }
    if((GetHasFeat(FEAT_EXPANDED_SOULMELD_CAPACITY_1) ||
        GetHasFeat(FEAT_EXPANDED_SOULMELD_CAPACITY_2) ||
        GetHasFeat(FEAT_EXPANDED_SOULMELD_CAPACITY_3) ||
        GetHasFeat(FEAT_EXPANDED_SOULMELD_CAPACITY_4) ||
        GetHasFeat(FEAT_EXPANDED_SOULMELD_CAPACITY_5)) && !GetHighestMeldshaperLevel(OBJECT_SELF))
    {
        FloatingTextStringOnCreature("You must have a meldshaper level of 1st to take Expanded Soulmeld Capacity", OBJECT_SELF, FALSE);
        return TRUE;     
    }    

	// Epic Incarnum    
	int nMelds = GetTotalSoulmeldCount(OBJECT_SELF);
    if(5 > nMelds && GetHasFeat(FEAT_BONUS_SOULMELD_1))
    {
        FloatingTextStringOnCreature("You must be able to shape five soulmelds to take Bonus Soulmeld", OBJECT_SELF, FALSE);
        return TRUE;    
    }    
    
   	int i;
   	nCount = 1;
   	for(i = FEAT_EPIC_ESSENTIA_1; i <= FEAT_EPIC_ESSENTIA_6; i++)
   	{
   	    if(GetHasFeat(i, OBJECT_SELF) && (nCount * 3) > nMelds) 
   	    {
        	FloatingTextStringOnCreature("You must be able to shape "+IntToString(nCount * 3)+" soulmelds to take Epic Essentia "+IntToString(nCount), OBJECT_SELF, FALSE);
        	return TRUE;     	    	
   	    }
   	    nCount += 1; 
   	}   

    if(!GetCanBindChakra(OBJECT_SELF, CHAKRA_ARMS) && 3 > GetMaxBindCount(OBJECT_SELF, GetPrimaryIncarnumClass(OBJECT_SELF)) && GetHasFeat(FEAT_EXTRA_CHAKRA_BIND_1))
    {
        FloatingTextStringOnCreature("You must be able to bind three chakras and use your arms chakra to take Extra Chakra Bind" , OBJECT_SELF, FALSE);
        return TRUE;    
    }
    
    if(12 > GetHighestMeldshaperLevel(OBJECT_SELF) && GetHasFeat(FEAT_RAPID_MELDSHAPING_1))
    {
        FloatingTextStringOnCreature("You must have a meldshaper level of 12th or higher to take Rapid Meldshaping", OBJECT_SELF, FALSE);
        return TRUE;    
    } 

   	for(i = FEAT_REBIND_SOULMELD_CROWN; i <= FEAT_REBIND_SOULMELD_TOTEM; i++)
   	{
   	    if(GetHasFeat(i, OBJECT_SELF) && 12 > GetHighestMeldshaperLevel(OBJECT_SELF)) 
   	    {
        	FloatingTextStringOnCreature("You must have a meldshaper level of 12th or higher to take Rebind Soulmeld", OBJECT_SELF, FALSE);
        	return TRUE;     	    	
   	    }
   	}    
    
    // This counts favoured enemies
	int nTotal;
    for (i = 261; i < 287; i++)
    {
		if (GetHasFeat(i, OBJECT_SELF)) 
			nTotal += 1;	
    } 
      
    if(!nTotal && GetHasFeat(FEAT_AZURE_ENMITY))
    {
        FloatingTextStringOnCreature("You must have a favoured enemy when taking Azure Enmity", OBJECT_SELF, FALSE);
        return TRUE;    
    }      
    
    // Binding Feats
    if(4 > GetWillSavingThrow(OBJECT_SELF) && GetHasFeat(FEAT_SKILLED_PACT_MAKING))
    {
        FloatingTextStringOnCreature("You must have a base Will save of 4 or greater to take Skilled Pact Making", OBJECT_SELF, FALSE);
        return TRUE;    
    } 
    
    // Aligned Spell Focus
    if(GetHasFeat(FEAT_SPELL_FOCUS_CHAOS) && GetAlignmentLawChaos(OBJECT_SELF) != ALIGNMENT_CHAOTIC)
    {
        FloatingTextStringOnCreature("You must be chaotic to take Spell Focus (Chaos)", OBJECT_SELF, FALSE);
        return TRUE;
    }     
    if(GetHasFeat(FEAT_SPELL_FOCUS_LAWFUL) && GetAlignmentLawChaos(OBJECT_SELF) != ALIGNMENT_LAWFUL)
    {
        FloatingTextStringOnCreature("You must be lawful to take Spell Focus (Lawful)", OBJECT_SELF, FALSE);
        return TRUE;
    }         
    if(GetHasFeat(FEAT_SPELL_FOCUS_EVIL) && GetAlignmentGoodEvil(OBJECT_SELF) != ALIGNMENT_EVIL)
    {
        FloatingTextStringOnCreature("You must be evil to take Spell Focus (Evil)", OBJECT_SELF, FALSE);
        return TRUE;
    }         
    if(GetHasFeat(FEAT_SPELL_FOCUS_GOOD) && GetAlignmentGoodEvil(OBJECT_SELF) != ALIGNMENT_GOOD)
    {
        FloatingTextStringOnCreature("You must be good to take Spell Focus (Good)", OBJECT_SELF, FALSE);
        return TRUE;
    }  
    // Deepspawn counts as aberrant, hence why we check 3 rather than 2
    if(3 > GetAberrantFeatCount(OBJECT_SELF) && GetHasFeat(FEAT_ABERRANT_DEEPSPAWN))
    {
        FloatingTextStringOnCreature("You must have at least two Aberrant feats when taking Deepspawn", OBJECT_SELF, FALSE);
        return TRUE;    
    }     
    
    
    return FALSE;
}    

void main()
{
    if(BonusDomains()
    || CasterFeats()
    || CheckClericShadowWeave()
    || CraftingFeats()
    || DraconicFeats()
    || DraDisFeats()
    || DragonShamanFeats()
    //|| ElementalSavant()
    || EpicCasting()
    || Ethran()
//    || FavoredOfMilil()
    || FavouredSoul()
    || GenasaiFocus()
    || LeadershipHD()
    || LingeringDamage()
    || MageKiller()
    || ManAtArmsFeats()
    || MarshalAuraLimit()
    || MetabreathFeats()
    || PnPShifterFeats()
    || PWSwitchRestructions()
    || RacialFeats()
    || RacialHD()
    || RedWizardFeats()
    || SkillRequirements()
    || SuddenMetamagic()
    || Swordsage()
    || UltiRangerFeats()
    || VileFeats()
    || WarlockFeats()
    || AcolyteEgo()
    || ToB()
    || OcularAdeptDomains()
    || ReserveFeats()
  //|| Blightbringer()
  //|| Shaman()
       )
    {
       int nHD = GetHitDice(OBJECT_SELF);
       int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
       int nOldXP = GetXP(OBJECT_SELF);
       int nNewXP = nMinXPForLevel - 1000;
       SetXP(OBJECT_SELF, nNewXP);
       DelayCommand(0.2, SetXP(OBJECT_SELF, nOldXP));
       SetLocalInt(OBJECT_SELF, "RelevelXP", nOldXP);
    }
}