

// Use this function to get the adjustments to a spell or SLAs spell penetration
// from the various class effects
// Update this function if any new classes change spell pentration
int add_spl_pen(object oCaster = OBJECT_SELF);

#include "prc_inc_spells"
#include "prc_alterations"
#include "prcsp_archmaginc"

int GetHeartWarderPene(int spell_id, object oCaster = OBJECT_SELF) {
    // Guard Expensive Calculations
    if (!GetHasFeat(FEAT_VOICE_SIREN, oCaster)) return 0;

    int  nSchool = GetLocalInt(OBJECT_SELF,"X2_L_LAST_SPELLSCHOOL_VAR");
    
    if ( nSchool != SPELL_SCHOOL_ENCHANTMENT) return 0;
    
    // Bonus Requires Verbal Spells
    string VS = lookup_spell_vs(spell_id);
    if (VS != "v" && VS != "vs")
        return 0;

    // These feats provide greater bonuses or remove the Verbal requirement
    if (PRCGetMetaMagicFeat() & METAMAGIC_SILENT
            || GetHasFeat(FEAT_SPELL_PENETRATION, oCaster)
            || GetHasFeat(FEAT_GREATER_SPELL_PENETRATION, oCaster)
            || GetHasFeat(FEAT_EPIC_SPELL_PENETRATION, oCaster))
        return 0;

    return 2;
}

//
//  Calculate Elemental Savant Contributions
//
int ElementalSavantSP(int spell_id, object oCaster = OBJECT_SELF)
{
    int nSP = 0;
    int nES;

    // All Elemental Savants will have this feat
    // when they first gain a penetration bonus.
    // Otherwise this would require checking ~4 items (class or specific feats)
    if (GetHasFeat(FEAT_ES_PEN_1, oCaster)) {
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

            if (nES > 28)       nSP = 10;
            else if (nES > 25)  nSP = 9;
            else if (nES > 22)  nSP = 8;
            else if (nES > 19)  nSP = 7;
            else if (nES > 16)  nSP = 6;
            else if (nES > 13)  nSP = 5;
            else if (nES > 10)  nSP = 4;
            else if (nES > 7)   nSP = 3;
            else if (nES > 4)   nSP = 2;
            else if (nES > 1)   nSP = 1;

        }
    }
//  SendMessageToPC(GetFirstPC(), "Your Elemental Penetration modifier is " + IntToString(nSP));
    return nSP;
}

//Red Wizard SP boost based on spell school specialization
int RedWizardSP(int spell_id, object oCaster = OBJECT_SELF)
{
    int iRedWizard = GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster);
    int nSP;

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
        
            nSP = 1;

            if (iRedWizard > 29)        nSP = 16;
            else if (iRedWizard > 27)   nSP = 15;
            else if (iRedWizard > 25)   nSP = 14;
            else if (iRedWizard > 23)   nSP = 13;
            else if (iRedWizard > 21)   nSP = 12;
            else if (iRedWizard > 19)   nSP = 11;
            else if (iRedWizard > 17)   nSP = 10;
            else if (iRedWizard > 15)   nSP = 9;
            else if (iRedWizard > 13)   nSP = 8;
            else if (iRedWizard > 11)   nSP = 7;
            else if (iRedWizard > 9)    nSP = 6;
            else if (iRedWizard > 7)    nSP = 5;
            else if (iRedWizard > 5)    nSP = 4;
            else if (iRedWizard > 3)    nSP = 3;
            else if (iRedWizard > 1)    nSP = 2;
        
        }


    }
//  SendMessageToPC(GetFirstPC(), "Your Spell Power modifier is " + IntToString(nSP));
    return nSP;
}

int GetSpellPenetreFocusSchool(object oCaster = OBJECT_SELF)
{
  int  nSchool = GetLocalInt(OBJECT_SELF,"X2_L_LAST_SPELLSCHOOL_VAR");
  
  if (nSchool >0){
     if (GetHasFeat(FEAT_FOCUSED_SPELL_PENETRATION_ABJURATION+nSchool-1, oCaster))
       return 4;}   
    
  return 0;
}

int GetSpellPowerBonus(object oCaster = OBJECT_SELF)
{
    int nBonus = 0;

    if(GetHasFeat(FEAT_SPELLPOWER_10, oCaster))
        nBonus = 10;
    else if(GetHasFeat(FEAT_SPELLPOWER_8, oCaster))
        nBonus = 8;
    else if(GetHasFeat(FEAT_SPELLPOWER_6, oCaster))
        nBonus = 6;
    else if(GetHasFeat(FEAT_SPELLPOWER_4, oCaster))
        nBonus = 4;
    else if(GetHasFeat(FEAT_SPELLPOWER_2, oCaster))
        nBonus = 2;

    return nBonus;
}

// Shadow Weave Feat
// +1 caster level vs SR (school Ench,Illu,Necro)
int ShadowWeavePen(int spell_id, object oCaster = OBJECT_SELF)
{
    int iShadow = GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster);
    int nSP;

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
        
            if (iShadow > 29)   nSP = 10;
            else if (iShadow > 26)  nSP = 9;
            else if (iShadow > 23)  nSP = 8;
            else if (iShadow > 20)  nSP = 7;
            else if (iShadow > 17)  nSP = 6;
            else if (iShadow > 14)  nSP = 5;
            else if (iShadow > 11)  nSP = 4;
            else if (iShadow > 8)   nSP = 3;
            else if (iShadow > 5)   nSP = 2;
            else if (iShadow > 2)   nSP = 1;
        }


    }
    //SendMessageToPC(GetFirstPC(), "Your Spell Pen modifier is " + IntToString(nSP));
    return nSP;
}

int KOTCSpellPenVsDemons(object oCaster)
{
	int nSP = 0;
	int iKOTC = GetLevelByClass(CLASS_TYPE_KNIGHT_CHALICE, oCaster);
	object oTarget = PRCGetSpellTargetObject();
	
	if (iKOTC >= 1)
    	{
    		if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER)
    		{
    			if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
    			{
				nSP = 2;
    			}
    		}
    	}
    	return nSP;
}

int RunecasterRunePowerSP(object oCaster)
{
	int nSP = 0;
	int nClass = GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);
	if (nClass >= 2)
	{
            if (nClass >= 30)        nSP = 10;
            else if (nClass >= 27)   nSP = 9;
            else if (nClass >= 24)   nSP = 8;
            else if (nClass >= 21)   nSP = 7;
            else if (nClass >= 18)   nSP = 6;
            else if (nClass >= 15)   nSP = 5;
            else if (nClass >= 12)   nSP = 4;
            else if (nClass >= 9)    nSP = 3;
            else if (nClass >= 5)    nSP = 2;
            else if (nClass >= 2)    nSP = 1;
        }
        return nSP;
}

int add_spl_pen(object oCaster = OBJECT_SELF)
{
    int spell_id = PRCGetSpellId();
    int nSP = ElementalSavantSP(spell_id, oCaster);
    nSP += GetHeartWarderPene(spell_id, oCaster);
    nSP += RedWizardSP(spell_id, oCaster);
    nSP += GetSpellPowerBonus(oCaster);
    nSP += GetSpellPenetreFocusSchool(oCaster);
    nSP += ShadowWeavePen(spell_id,oCaster);
    nSP += KOTCSpellPenVsDemons(oCaster);
    nSP += RunecasterRunePowerSP(oCaster);
        
    return nSP;
}
