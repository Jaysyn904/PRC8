
// Use this function to get the adjustments to a spell or SLAs saving throw
// from the various class effects
// Update this function if any new classes change saving throws
int PRCGetSaveDC(object oTarget, object oCaster, int nSpellID = -1);

//called just from above and from inc_epicspells
int GetChangesToSaveDC(object oTarget, object oCaster = OBJECT_SELF, int nSpellID = -1);

#include "prc_inc_spells"
#include "prc_class_const"
#include "prc_feat_const"
#include "lookup_2da_spell"
#include "prcsp_archmaginc"
#include "prc_alterations"
#include "prc_add_spl_pen"



// Check for CLASS_TYPE_HIEROPHANT > 0 in caller
int GetWasLastSpellHieroSLA(int spell_id, object oCaster = OBJECT_SELF)
{
    int iAbility = PRCGetLastSpellCastClass() == CLASS_TYPE_INVALID;
    int iSpell   = spell_id == SPELL_HOLY_AURA ||
                   spell_id == SPELL_UNHOLY_AURA ||
                   spell_id == SPELL_BANISHMENT ||
                   spell_id == SPELL_BATTLETIDE ||
                   spell_id == SPELL_BLADE_BARRIER ||
                   spell_id == SPELL_CIRCLE_OF_DOOM ||
                   spell_id == SPELL_CONTROL_UNDEAD ||
                   spell_id == SPELL_CREATE_GREATER_UNDEAD ||
                   spell_id == SPELL_CREATE_UNDEAD ||
                   spell_id == SPELL_CURE_CRITICAL_WOUNDS ||
                   spell_id == SPELL_DEATH_WARD ||
                   spell_id == SPELL_DESTRUCTION ||
                   spell_id == SPELL_DISMISSAL ||
                   spell_id == SPELL_DIVINE_POWER ||
                   spell_id == SPELL_EARTHQUAKE ||
                   spell_id == SPELL_ENERGY_DRAIN ||
                   spell_id == SPELL_ETHEREALNESS ||
                   spell_id == SPELL_FIRE_STORM ||
                   spell_id == SPELL_FLAME_STRIKE ||
                   spell_id == SPELL_FREEDOM_OF_MOVEMENT ||
                   spell_id == SPELL_GATE ||
                   spell_id == SPELL_GREATER_DISPELLING ||
                   spell_id == SPELL_GREATER_MAGIC_WEAPON ||
                   spell_id == SPELL_GREATER_RESTORATION ||
                   spell_id == SPELL_HAMMER_OF_THE_GODS ||
                   spell_id == SPELL_HARM ||
                   spell_id == SPELL_HEAL ||
                   spell_id == SPELL_HEALING_CIRCLE ||
                   spell_id == SPELL_IMPLOSION ||
                   spell_id == SPELL_INFLICT_CRITICAL_WOUNDS ||
                   spell_id == SPELL_MASS_HEAL ||
                   spell_id == SPELL_MONSTROUS_REGENERATION ||
                   spell_id == SPELL_NEUTRALIZE_POISON ||
                   spell_id == SPELL_PLANAR_ALLY ||
                   spell_id == SPELL_POISON ||
                   spell_id == SPELL_RAISE_DEAD ||
                   spell_id == SPELL_REGENERATE ||
                   spell_id == SPELL_RESTORATION ||
                   spell_id == SPELL_RESURRECTION ||
                   spell_id == SPELL_SLAY_LIVING ||
                   spell_id == SPELL_SPELL_RESISTANCE ||
                   spell_id == SPELL_STORM_OF_VENGEANCE ||
                   spell_id == SPELL_SUMMON_CREATURE_IV ||
                   spell_id == SPELL_SUMMON_CREATURE_IX ||
                   spell_id == SPELL_SUMMON_CREATURE_V ||
                   spell_id == SPELL_SUMMON_CREATURE_VI ||
                   spell_id == SPELL_SUMMON_CREATURE_VII ||
                   spell_id == SPELL_SUMMON_CREATURE_VIII ||
                   spell_id == SPELL_SUNBEAM ||
                   spell_id == SPELL_TRUE_SEEING ||
                   spell_id == SPELL_UNDEATH_TO_DEATH ||
                   spell_id == SPELL_UNDEATHS_ETERNAL_FOE ||
                   spell_id == SPELL_WORD_OF_FAITH;

    return iAbility && iSpell;
}

int GetHierophantSLAAdjustment(int spell_id, object oCaster = OBJECT_SELF)
{
    int retval = 0;

    if (GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster) > 0 && GetWasLastSpellHieroSLA(spell_id, oCaster) )
    {
             retval = StringToInt( lookup_spell_cleric_level(spell_id) );
         retval -= GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
        }
   
   return retval;
}

int GetHeartWarderDC(int spell_id, object oCaster = OBJECT_SELF)
{
    // Check the curent school
    if (GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR") != SPELL_SCHOOL_ENCHANTMENT)
        return 0;

    if (!GetHasFeat(FEAT_VOICE_SIREN, oCaster)) return 0;

    // Bonus Requires Verbal Spells
    string VS = lookup_spell_vs(PRCGetSpellId());
    if (VS != "v" && VS != "vs")
        return 0;

    // These feats provide greater bonuses or remove the Verbal requirement
    if (PRCGetMetaMagicFeat() & METAMAGIC_SILENT
            || GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, oCaster)
            || GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, oCaster))
        return 0;

    return 2;
}

//Elemental Savant DC boost based on elemental spell type.
int ElementalSavantDC(int spell_id, object oCaster = OBJECT_SELF)
{
    int nDC = 0;
    int nES;

    // All Elemental Savants will have this feat
    // when they first gain a DC bonus.
    if (GetHasFeat(FEAT_ES_FOCUS_1, oCaster)) {
        // get spell elemental type
        string element = ChangedElementalType(spell_id, oCaster);

        // Any value that does not match one of the enumerated feats
        int feat = 0;

        // Specify the elemental type rather than lookup by class?
        if (element == "Fire")
        {
            feat = FEAT_ES_FIRE;
            nES = GetLevelByClass(CLASS_TYPE_ES_FIRE,oCaster);
        }
        else if (element == "Cold")
        {
            feat = FEAT_ES_COLD;
            nES = GetLevelByClass(CLASS_TYPE_ES_COLD,oCaster);
        }
        else if (element == "Electricity")
        {
            feat = FEAT_ES_ELEC;
            nES = GetLevelByClass(CLASS_TYPE_ES_ELEC,oCaster);
        }
        else if (element == "Acid")
        {
            feat = FEAT_ES_ACID;
            nES = GetLevelByClass(CLASS_TYPE_ES_ACID,oCaster);
        }

        // Now determine the bonus
        if (feat && GetHasFeat(feat, oCaster)) 
        {

            if (nES > 28)       nDC = 10;
            else if (nES > 25)  nDC = 9;
            else if (nES > 22)  nDC = 8;
            else if (nES > 19)  nDC = 7;
            else if (nES > 16)  nDC = 6;
            else if (nES > 13)  nDC = 5;
            else if (nES > 10)  nDC = 4;
            else if (nES > 7)   nDC = 3;
            else if (nES > 4)   nDC = 2;
            else if (nES > 1)   nDC = 1;

        }
    }
//  SendMessageToPC(GetFirstPC(), "Your Elemental Focus modifier is " + IntToString(nDC));
    return nDC;
}



//Red Wizard DC boost based on spell school specialization
int RedWizardDC(int spell_id, object oCaster = OBJECT_SELF)
{
    int iRedWizard = GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster);
    int nDC;

    if (iRedWizard > 0)
    {
        int nSpell = PRCGetSpellId();
        string sSpellSchool = lookup_spell_school(nSpell);
        int iSpellSchool;
        int iRWSpec;

        if (sSpellSchool == "A") iSpellSchool = SPELL_SCHOOL_ABJURATION;
        else if (sSpellSchool == "C") iSpellSchool = SPELL_SCHOOL_CONJURATION;
        else if (sSpellSchool == "D") iSpellSchool = SPELL_SCHOOL_DIVINATION;
        else if (sSpellSchool == "E") iSpellSchool = SPELL_SCHOOL_ENCHANTMENT;
        else if (sSpellSchool == "V") iSpellSchool = SPELL_SCHOOL_EVOCATION;
        else if (sSpellSchool == "I") iSpellSchool = SPELL_SCHOOL_ILLUSION;
        else if (sSpellSchool == "N") iSpellSchool = SPELL_SCHOOL_NECROMANCY;
        else if (sSpellSchool == "T") iSpellSchool = SPELL_SCHOOL_TRANSMUTATION;

        if (GetHasFeat(FEAT_RW_TF_ABJ, oCaster)) iRWSpec = SPELL_SCHOOL_ABJURATION;
        else if (GetHasFeat(FEAT_RW_TF_CON, oCaster)) iRWSpec = SPELL_SCHOOL_CONJURATION;
        else if (GetHasFeat(FEAT_RW_TF_DIV, oCaster)) iRWSpec = SPELL_SCHOOL_DIVINATION;
        else if (GetHasFeat(FEAT_RW_TF_ENC, oCaster)) iRWSpec = SPELL_SCHOOL_ENCHANTMENT;
        else if (GetHasFeat(FEAT_RW_TF_EVO, oCaster)) iRWSpec = SPELL_SCHOOL_EVOCATION;
        else if (GetHasFeat(FEAT_RW_TF_ILL, oCaster)) iRWSpec = SPELL_SCHOOL_ILLUSION;
        else if (GetHasFeat(FEAT_RW_TF_NEC, oCaster)) iRWSpec = SPELL_SCHOOL_NECROMANCY;
        else if (GetHasFeat(FEAT_RW_TF_TRS, oCaster)) iRWSpec = SPELL_SCHOOL_TRANSMUTATION;

        if (iSpellSchool == iRWSpec)
        {
        
            nDC = 1;

            if (iRedWizard > 29)        nDC = 16;
            else if (iRedWizard > 27)   nDC = 15;
            else if (iRedWizard > 25)   nDC = 14;
            else if (iRedWizard > 23)   nDC = 13;
            else if (iRedWizard > 21)   nDC = 12;
            else if (iRedWizard > 19)   nDC = 11;
            else if (iRedWizard > 17)   nDC = 10;
            else if (iRedWizard > 15)   nDC = 9;
            else if (iRedWizard > 13)   nDC = 8;
            else if (iRedWizard > 11)   nDC = 7;
            else if (iRedWizard > 9)    nDC = 6;
            else if (iRedWizard > 7)    nDC = 5;
            else if (iRedWizard > 5)    nDC = 4;
            else if (iRedWizard > 3)    nDC = 3;
            else if (iRedWizard > 1)    nDC = 2;
        }


    }
//  SendMessageToPC(GetFirstPC(), "Your Spell Power modifier is " + IntToString(nDC));
    return nDC;
}


//Tattoo Focus DC boost based on spell school specialization
int TattooFocus(int spell_id, object oCaster = OBJECT_SELF)
{

        int nDC;
        int nSpell = PRCGetSpellId();
        string sSpellSchool = lookup_spell_school(nSpell);
        int iSpellSchool;
        int iRWSpec;

        if (sSpellSchool == "A") iSpellSchool = SPELL_SCHOOL_ABJURATION;
        else if (sSpellSchool == "C") iSpellSchool = SPELL_SCHOOL_CONJURATION;
        else if (sSpellSchool == "D") iSpellSchool = SPELL_SCHOOL_DIVINATION;
        else if (sSpellSchool == "E") iSpellSchool = SPELL_SCHOOL_ENCHANTMENT;
        else if (sSpellSchool == "V") iSpellSchool = SPELL_SCHOOL_EVOCATION;
        else if (sSpellSchool == "I") iSpellSchool = SPELL_SCHOOL_ILLUSION;
        else if (sSpellSchool == "N") iSpellSchool = SPELL_SCHOOL_NECROMANCY;
        else if (sSpellSchool == "T") iSpellSchool = SPELL_SCHOOL_TRANSMUTATION;

        if (GetHasFeat(FEAT_RW_TF_ABJ, oCaster)) iRWSpec = SPELL_SCHOOL_ABJURATION;
        else if (GetHasFeat(FEAT_RW_TF_CON, oCaster)) iRWSpec = SPELL_SCHOOL_CONJURATION;
        else if (GetHasFeat(FEAT_RW_TF_DIV, oCaster)) iRWSpec = SPELL_SCHOOL_DIVINATION;
        else if (GetHasFeat(FEAT_RW_TF_ENC, oCaster)) iRWSpec = SPELL_SCHOOL_ENCHANTMENT;
        else if (GetHasFeat(FEAT_RW_TF_EVO, oCaster)) iRWSpec = SPELL_SCHOOL_EVOCATION;
        else if (GetHasFeat(FEAT_RW_TF_ILL, oCaster)) iRWSpec = SPELL_SCHOOL_ILLUSION;
        else if (GetHasFeat(FEAT_RW_TF_NEC, oCaster)) iRWSpec = SPELL_SCHOOL_NECROMANCY;
        else if (GetHasFeat(FEAT_RW_TF_TRS, oCaster)) iRWSpec = SPELL_SCHOOL_TRANSMUTATION;

        if (iSpellSchool == iRWSpec)
        {
            nDC = 1;
        }
    return nDC;
}

// Shadow Weave Feat
// DC +1 (school Ench,Illu,Necro)
int ShadowWeaveDC(int spell_id, object oCaster = OBJECT_SELF)
{
    int iShadow = GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);
    int nDC;

    if (iShadow > 0)
    {
        int nSpell = PRCGetSpellId();
        string sSpellSchool = lookup_spell_school(nSpell);
        int iSpellSchool;
        
        if (sSpellSchool == "A") iSpellSchool = SPELL_SCHOOL_ABJURATION;
        else if (sSpellSchool == "C") iSpellSchool = SPELL_SCHOOL_CONJURATION;
        else if (sSpellSchool == "D") iSpellSchool = SPELL_SCHOOL_DIVINATION;
        else if (sSpellSchool == "E") iSpellSchool = SPELL_SCHOOL_ENCHANTMENT;
        else if (sSpellSchool == "V") iSpellSchool = SPELL_SCHOOL_EVOCATION;
        else if (sSpellSchool == "I") iSpellSchool = SPELL_SCHOOL_ILLUSION;
        else if (sSpellSchool == "N") iSpellSchool = SPELL_SCHOOL_NECROMANCY;
        else if (sSpellSchool == "T") iSpellSchool = SPELL_SCHOOL_TRANSMUTATION;

        if (iSpellSchool == SPELL_SCHOOL_ENCHANTMENT || iSpellSchool == SPELL_SCHOOL_NECROMANCY || iSpellSchool == SPELL_SCHOOL_ILLUSION)
        {
        
            if (iShadow > 29)   nDC = 10;
            else if (iShadow > 26)  nDC = 9;
            else if (iShadow > 23)  nDC = 8;
            else if (iShadow > 20)  nDC = 7;
            else if (iShadow > 17)  nDC = 6;
            else if (iShadow > 14)  nDC = 5;
            else if (iShadow > 11)  nDC = 4;
            else if (iShadow > 8)   nDC = 3;
            else if (iShadow > 5)   nDC = 2;
            else if (iShadow > 2)   nDC = 1;
        }


    }
    //SendMessageToPC(GetFirstPC(), "Your Spell DC modifier is " + IntToString(nDC));
    return nDC;
}

int KOTCSpellFocusVsDemons(object oTarget, object oCaster)
{
    int nDC = 0;
    int iKOTC = GetLevelByClass(CLASS_TYPE_KNIGHT_CHALICE, oCaster);
    
    if (iKOTC >= 1)
        {
            if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER)
            {
                if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
                {
                nDC = 2;
                }
            }
        }
        return nDC;
}

int BloodMagusBloodComponent(object oCaster)
{
	int nDC = 0;
	if (GetLevelByClass(CLASS_TYPE_BLOOD_MAGUS, oCaster) > 0 && GetLocalInt(oCaster, "BloodComponent") == TRUE)
	{
		nDC = 1;
		effect eSelfDamage = EffectDamage(1, DAMAGE_TYPE_MAGICAL);
		// To make sure it doesn't cause a conc check
          	DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSelfDamage, oCaster));
        }
        return nDC;
}

int RunecasterRunePowerDC(object oCaster)
{
	int nDC = 0;
	int nClass = GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
	if (nClass >= 2)
	{
            if (nClass >= 30)        nDC = 10;
            else if (nClass >= 27)   nDC = 9;
            else if (nClass >= 24)   nDC = 8;
            else if (nClass >= 21)   nDC = 7;
            else if (nClass >= 18)   nDC = 6;
            else if (nClass >= 15)   nDC = 5;
            else if (nClass >= 12)   nDC = 4;
            else if (nClass >= 9)    nDC = 3;
            else if (nClass >= 5)    nDC = 2;
            else if (nClass >= 2)    nDC = 1;
        }
        return nDC;
}

int PRCGetSaveDC(object oTarget, object oCaster, int nSpellID = -1)
{
    if(nSpellID == -1)
        nSpellID = PRCGetSpellId();
    //10+spelllevel+stat(cha default)
    int nDC = GetSpellSaveDC(); 
    // For when you want to assign the caster DC
    //this does take feat/race/class into account, it only overrides the baseDC
    if (GetLocalInt(oCaster, PRC_DC_BASE_OVERRIDE) != 0)
    {
        nDC = GetLocalInt(oCaster, PRC_DC_BASE_OVERRIDE);
        SendMessageToPC(oCaster, "Forced Base-DC casting at DC " + IntToString(nDC));
    }
    nDC += GetChangesToSaveDC(oTarget, oCaster, nSpellID);
    return nDC;
    
}

//called just from above and from inc_epicspells
int GetChangesToSaveDC(object oTarget, object oCaster = OBJECT_SELF, int nSpellID = -1)
{
    if(nSpellID == -1)
        nSpellID = PRCGetSpellId();
    int nDC;
    nDC += ElementalSavantDC(nSpellID, oCaster);
    nDC += GetHierophantSLAAdjustment(nSpellID, oCaster);
    nDC += GetHeartWarderDC(nSpellID, oCaster);
    nDC += GetSpellPowerBonus(oCaster);
    nDC += ShadowWeaveDC(nSpellID, oCaster);
    nDC += RedWizardDC(nSpellID, oCaster);
    nDC += TattooFocus(nSpellID, oCaster);
    nDC += KOTCSpellFocusVsDemons(oTarget, oCaster);
    nDC += BloodMagusBloodComponent(oCaster);
    nDC += RunecasterRunePowerDC(oCaster);
    nDC += GetLocalInt(oCaster, PRC_DC_ADJUSTMENT);//this is for builder use
    return nDC;
    
}
