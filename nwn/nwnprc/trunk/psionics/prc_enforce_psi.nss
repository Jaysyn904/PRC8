/** @file
   ----------------
   prc_enforce_psi
   ----------------

   21/10/04 by Stratovarius

   This script is used to enforce the proper selection of bonus feats
   so that people cannot use epic bonus feats and class bonus feats to
   select feats they should not be allowed to.

   Is also used to enforce the proper discipline selection.
*/

#include "psi_inc_psifunc"
#include "true_inc_trufunc"

string PLEASE_RESELECT = GetStringByStrRef(16826471); //"Please reselect your feats."

/**
 * Enforces the proper selection of the Psion feats that are used to determine discipline.
 * A character must have only one discipline.
 *
 * @param oPC The PC whose feats to check.
 * @return    TRUE if needed to relevel, FALSE otherwise.
 */
int PsionDiscipline(object oPC = OBJECT_SELF);


/**
 * Enforces feats that require one to *not* be a psionic character.
 *
 * @param oPC The PC whose feats to check.
 * @return    TRUE if needed to relevel, FALSE otherwise.
 */
int AntiPsionicFeats(object oPC);


/**
 * Enforces feats that require one to be a psionic character.
 *
 * @param oPC The PC whose feats to check.
 * @return    TRUE if needed to relevel, FALSE otherwise.
 */
int PsionicFeats(object oPC);

/**
 * Enforces feats that require one to be an epic psionic character.
 *
 * @param oPC The PC whose feats to check.
 * @return    TRUE if needed to relevel, FALSE otherwise.
 */
int EpicPsionicFeats(object oPC);

/**
 * Checks the requirement of at least one metapsionic feat of Split Psionic Ray
 *
 * @param oPC The PC whose feats to check.
 * @return    TRUE if needed to relevel, FALSE otherwise.
 */
int SplitPsionicRay(object oPC);

/**
 * Enforces the restriction that Thrallherds cannot have leadership.
 *
 * @param oPC The PC whose feats to check.
 * @return    TRUE if needed to relevel, FALSE otherwise.
 */
int Thrallherd(object oPC);

// ---------------
// BEGIN FUNCTIONS
// ---------------

int PsionDiscipline(object oPC = OBJECT_SELF)
{
    int nPsion = GetLevelByClass(CLASS_TYPE_PSION, oPC);
    if(nPsion)
    {
        if(GetHasFeat(FEAT_PSION_DIS_EGOIST, oPC)
         + GetHasFeat(FEAT_PSION_DIS_KINETICIST, oPC)
         + GetHasFeat(FEAT_PSION_DIS_NOMAD, oPC)
         + GetHasFeat(FEAT_PSION_DIS_SEER, oPC)
         + GetHasFeat(FEAT_PSION_DIS_SHAPER, oPC)
         + GetHasFeat(FEAT_PSION_DIS_TELEPATH, oPC)
         != 1)
        {    //                           "You may only have 1 Discipline."
             FloatingTextStringOnCreature(GetStringByStrRef(16826470) + " " + PLEASE_RESELECT, oPC, FALSE);
             return TRUE;
        }
    }
    return FALSE;
}

int AntiPsionicFeats(object oPC)
{
    int bHasAntiPsionicFeats = FALSE,
        bRelevel             = FALSE,
        bFirst               = 1;
    string sFeats = "";

    if(GetHasFeat(FEAT_CLOSED_MIND))        { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826422); }
    if(GetHasFeat(FEAT_FORCE_OF_WILL))      { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826424); }
    if(GetHasFeat(FEAT_HOSTILE_MIND))       { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826426); }
    if(GetHasFeat(FEAT_MENTAL_RESISTANCE))  { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826428); }
    if(GetHasFeat(FEAT_PSIONIC_HOLE))       { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826430); }
    //if(GetHasFeat())      { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(); }

    if(bRelevel)
    {
                                   //You are a psionic character and may not take
        FloatingTextStringOnCreature(GetStringByStrRef(16826473) + " " + sFeats + ". " + PLEASE_RESELECT, oPC, FALSE);
    }

    return bRelevel;
}

int PsionicFeats(object oPC)
{
    int bRelevel = FALSE,
        bFirst   = 1;
    string sFeats = "";


    if(GetHasFeat(FEAT_BOOST_CONSTRUCT))              { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826476); }
    if(GetHasFeat(FEAT_COMBAT_MANIFESTATION))         { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826432); }
    if(GetHasFeat(FEAT_MENTAL_LEAP))                  { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826434); }
    // Only check for the first Metamorphic Transfer feat... If some source forces one of the other feats on the char, nothing releveling could do about it, anyway
    // Metamorphosis isn't in yet, so neither are Metamorphic Transfers
    //if(GetHasFeat(FEAT_METAMORPHIC_TRANSFER_1))       { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(-1/*FIXME*/); }
    if(GetHasFeat(FEAT_NARROW_MIND))                  { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826436); }
    if(GetHasFeat(FEAT_OVERCHANNEL))                  { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826478); }
    if(GetHasFeat(FEAT_TALENTED))                     { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826500); }
    if(GetHasFeat(FEAT_POWER_PENETRATION))            { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826438); }
    if(GetHasFeat(FEAT_GREATER_POWER_PENETRATION))    { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826440); }
    if(GetHasFeat(FEAT_POWER_SPECIALIZATION))         { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826446); }
    if(GetHasFeat(FEAT_GREATER_POWER_SPECIALIZATION)) { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826448); }
    if(GetHasFeat(FEAT_PSIONIC_DODGE))                { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826450); }
    if(GetHasFeat(FEAT_PSIONIC_ENDOWMENT))            { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826452); }
    if(GetHasFeat(FEAT_GREATER_PSIONIC_ENDOWMENT))    { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826454); }
    if(GetHasFeat(FEAT_PSIONIC_FIST))                 { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826456); }
    if(GetHasFeat(FEAT_GREATER_PSIONIC_FIST))         { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826458); }
    if(GetHasFeat(FEAT_UNAVOIDABLE_STRIKE))           { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826506); }
    if(GetHasFeat(FEAT_PSIONIC_MEDITATION))           { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826501); }
    if(GetHasFeat(FEAT_PSIONIC_SHOT))                 { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826464); }
    if(GetHasFeat(FEAT_GREATER_PSIONIC_SHOT))         { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826466); }
    // Only check for the first Psionic Talent feat
    if(GetHasFeat(FEAT_PSIONIC_TALENT_1))             { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826488); }
    if(GetHasFeat(FEAT_PSIONIC_WEAPON))               { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826460); }
    if(GetHasFeat(FEAT_GREATER_PSIONIC_WEAPON))       { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826462); }
    if(GetHasFeat(FEAT_SPEED_OF_THOUGHT))             { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826486); }
    if(GetHasFeat(FEAT_WOUNDING_ATTACK))              { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826510); }
    if(GetHasFeat(FEAT_DEEP_IMPACT))                  { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826514); }
    if(GetHasFeat(FEAT_FELL_SHOT))                    { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826516); }
    if(GetHasFeat(FEAT_INVEST_ARMOUR))                { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16822550); }
    // Only check for the first Expanded Knowledge feat
    if(GetHasFeat(FEAT_EXPANDED_KNOWLEDGE_1))         { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826520); }

    // Metapsionic feats
    if(GetHasFeat(FEAT_CHAIN_POWER,       oPC)) { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826532); }
    if(GetHasFeat(FEAT_EMPOWER_POWER,     oPC)) { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826534); }
    if(GetHasFeat(FEAT_EXTEND_POWER,      oPC)) { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826536); }
    if(GetHasFeat(FEAT_MAXIMIZE_POWER,    oPC)) { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826538); }
    if(GetHasFeat(FEAT_SPLIT_PSIONIC_RAY, oPC)) { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826540); }
    if(GetHasFeat(FEAT_TWIN_POWER,        oPC)) { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826542); }
    if(GetHasFeat(FEAT_WIDEN_POWER,       oPC)) { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826544); }
    if(GetHasFeat(FEAT_QUICKEN_POWER,     oPC)) { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826651); }

    if(bRelevel)
    {
                                   //You are not a psionic character and may not take
        FloatingTextStringOnCreature(GetStringByStrRef(16826472) + " " + sFeats + ". " + PLEASE_RESELECT, oPC, FALSE);
    }

    return bRelevel;
}


int EpicPsionicFeats(object oPC)
{
    int bCanManifMax = (GetLevelByClass(CLASS_TYPE_PSION, oPC)          + (GetPsionicPRCLevels(oPC, CLASS_TYPE_PSION))) >= 17 ||
                       (GetLevelByClass(CLASS_TYPE_WILDER, oPC)         + (GetPsionicPRCLevels(oPC, CLASS_TYPE_WILDER))) >= 18 ||
                       (GetLevelByClass(CLASS_TYPE_PSYWAR, oPC)         + (GetPsionicPRCLevels(oPC, CLASS_TYPE_PSYWAR))) >= 16 ||
                       (GetLevelByClass(CLASS_TYPE_PSYCHIC_ROGUE, oPC)  + (GetPsionicPRCLevels(oPC, CLASS_TYPE_PSYCHIC_ROGUE))) >= 17 ||
                       (GetLevelByClass(CLASS_TYPE_FIST_OF_ZUOKEN, oPC) + (GetPsionicPRCLevels(oPC, CLASS_TYPE_FIST_OF_ZUOKEN))) >= 9  ||
                       (GetLevelByClass(CLASS_TYPE_WARMIND, oPC)        + (GetPsionicPRCLevels(oPC, CLASS_TYPE_WARMIND))) >= 10;

/*     int bCanManifMax = (GetLevelByClass(CLASS_TYPE_PSION, oPC)          + (CLASS_TYPE_PSION          == GetPrimaryPsionicClass(oPC) ? GetPsionicPRCLevels(oPC) : 0)) >= 17 ||
                       (GetLevelByClass(CLASS_TYPE_WILDER, oPC)         + (CLASS_TYPE_WILDER         == GetPrimaryPsionicClass(oPC) ? GetPsionicPRCLevels(oPC) : 0)) >= 18 ||
                       (GetLevelByClass(CLASS_TYPE_PSYWAR, oPC)         + (CLASS_TYPE_PSYWAR         == GetPrimaryPsionicClass(oPC) ? GetPsionicPRCLevels(oPC) : 0)) >= 16 ||
                       (GetLevelByClass(CLASS_TYPE_PSYCHIC_ROGUE, oPC)  + (CLASS_TYPE_PSYCHIC_ROGUE  == GetPrimaryPsionicClass(oPC) ? GetPsionicPRCLevels(oPC) : 0)) >= 17 ||
                       (GetLevelByClass(CLASS_TYPE_FIST_OF_ZUOKEN, oPC) + (CLASS_TYPE_FIST_OF_ZUOKEN == GetPrimaryPsionicClass(oPC) ? GetPsionicPRCLevels(oPC) : 0)) >= 9  ||
                       (GetLevelByClass(CLASS_TYPE_WARMIND, oPC)        + (CLASS_TYPE_WARMIND        == GetPrimaryPsionicClass(oPC) ? GetPsionicPRCLevels(oPC) : 0)) >= 10; */
					   
    int bRelevel = FALSE,
        bFirst   = 1;
    string sManifLimitedFeats = "";

    if(GetHasFeat(FEAT_EPIC_EXPANDED_KNOWLEDGE_1))        sManifLimitedFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826522);
    if(GetHasFeat(FEAT_IMPROVED_MANIFESTATION_1))         sManifLimitedFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826526);
    if(GetHasFeat(FEAT_POWER_KNOWLEDGE_PSION_1))          sManifLimitedFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826528);
    if(GetHasFeat(FEAT_POWER_KNOWLEDGE_PSYWAR_1))         sManifLimitedFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826529);
    if(GetHasFeat(FEAT_POWER_KNOWLEDGE_PSYROG_1))         sManifLimitedFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(99999999);
    if(GetHasFeat(FEAT_POWER_KNOWLEDGE_WILDER_1))         sManifLimitedFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826530);
    if(GetHasFeat(FEAT_POWER_KNOWLEDGE_FIST_OF_ZUOKEN_1)) sManifLimitedFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826640);
    if(GetHasFeat(FEAT_POWER_KNOWLEDGE_WARMIND_1))        sManifLimitedFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826657);

    if(GetHasFeat(FEAT_EPIC_PSIONIC_FOCUS_1))             sManifLimitedFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826518);


    if(!bCanManifMax && bFirst < 1)
    {
        bRelevel = TRUE;           //You do not have the ability to manifest powers of the normal maximum power level in at least one psionic class and may not take
        FloatingTextStringOnCreature(GetStringByStrRef(16826469) + " " + sManifLimitedFeats + ". " + PLEASE_RESELECT, oPC, FALSE);
    }

    if(GetHasFeat(FEAT_IMPROVED_METAPSIONICS_1))
    {
       int nMetaPsi = GetHasFeat(FEAT_CHAIN_POWER,       oPC) +
                      GetHasFeat(FEAT_EMPOWER_POWER,     oPC) +
                      GetHasFeat(FEAT_EXTEND_POWER,      oPC) +
                      GetHasFeat(FEAT_MAXIMIZE_POWER,    oPC) +
                      GetHasFeat(FEAT_SPLIT_PSIONIC_RAY, oPC) +
                      GetHasFeat(FEAT_TWIN_POWER,        oPC) +
                      GetHasFeat(FEAT_WIDEN_POWER,       oPC) +
                      GetHasFeat(FEAT_QUICKEN_POWER,     oPC);

        if(nMetaPsi < 4)
        {
            bRelevel = TRUE;           //You do not posses 4 metapsionic feats and may not take Improved Metapsionics.
            FloatingTextStringOnCreature(GetStringByStrRef(16826468) + " " + PLEASE_RESELECT, oPC, FALSE);
        }
    }


    return bRelevel;
}


int SplitPsionicRay(object oPC)
{
    if(GetHasFeat(FEAT_SPLIT_PSIONIC_RAY, oPC))
    {
        if(!GetHasFeat(FEAT_CHAIN_POWER, oPC)
        && !GetHasFeat(FEAT_EMPOWER_POWER, oPC)
        && !GetHasFeat(FEAT_EXTEND_POWER, oPC)
        && !GetHasFeat(FEAT_MAXIMIZE_POWER, oPC)
        && !GetHasFeat(FEAT_TWIN_POWER, oPC)
        && !GetHasFeat(FEAT_WIDEN_POWER, oPC)
        && !GetHasFeat(FEAT_QUICKEN_POWER, oPC))
        {                              //You do not have at least one other metapsionic feat besides Split Psionic Ray, so you may not take it.
            FloatingTextStringOnCreature(GetStringByStrRef(16826546) + " " + PLEASE_RESELECT, oPC, FALSE);
            return TRUE;
        }
    }
    return FALSE;
}

int Thrallherd(object oPC)
{
    if(GetLevelByClass(CLASS_TYPE_THRALLHERD, oPC) > 0 && GetHasFeat(FEAT_LEADERSHIP, oPC))
    {
        FloatingTextStringOnCreature("You cannot take the Thrallherd class if you have the Leadership feat.", oPC, FALSE);
        return TRUE;
    }

    return FALSE;
}

int Recitations(object oPC)
{
    int nTrue = GetLevelByClass(CLASS_TYPE_TRUENAMER, oPC);
    int nAcolyte = GetLevelByClass(CLASS_TYPE_ACOLYTE_EGO, oPC);

    int nRec =     GetHasFeat(FEAT_RECITATION_FORTIFIED,    oPC) +
                   GetHasFeat(FEAT_RECITATION_MEDITATIVE,   oPC) +
                   GetHasFeat(FEAT_RECITATION_MINDFUL,      oPC) +
                   GetHasFeat(FEAT_RECITATION_SANGUINE,     oPC) +
                   GetHasFeat(FEAT_RECITATION_VITAL,        oPC);

    // Include bonus Recitation granted by Acolyte at level 7
    if (nAcolyte >= 7)
    {
        nRec += 1;
    }

    // Truenamer Recitation requirements
    if ((nTrue >= 15 && nRec < 2) || (nTrue >= 8 && nRec < 1))
    {
        FloatingTextStringOnCreature("You do not have the correct amount of Recitations. Please reselect your feat.", oPC, FALSE);
        return TRUE;
    }

    // Acolyte of the Ego Recitation requirement
    if (nAcolyte >= 7 && nRec < 1)
    {
        FloatingTextStringOnCreature("You do not have the correct amount of Recitations. Please reselect your feat.", oPC, FALSE);
        return TRUE;
    }

    return FALSE;
}

/* int Recitations(object oPC)
{
    int nTrue = GetLevelByClass(CLASS_TYPE_TRUENAMER, oPC);
    int nRec =     GetHasFeat(FEAT_RECITATION_FORTIFIED,    oPC) +
                   GetHasFeat(FEAT_RECITATION_MEDITATIVE,   oPC) +
                   GetHasFeat(FEAT_RECITATION_MINDFUL,      oPC) +
                   GetHasFeat(FEAT_RECITATION_SANGUINE,     oPC) +
                   GetHasFeat(FEAT_RECITATION_VITAL,        oPC);

    // Bonus Recitation for Acolyte of the Ego at level 7
    if (GetLevelByClass(CLASS_TYPE_ACOLYTE_EGO, oPC) >= 7)
    {
        nRec += 1;
    }

    // Need 2 at level 15, 1 at level 8
    if ((nTrue >= 15 && 2 > nRec) || (nTrue >= 8 && 1 > nRec))
    {
        FloatingTextStringOnCreature("You must select a Recitation feat.", oPC, FALSE);
        return TRUE;
    }

    return FALSE;
} */

/* int Recitations(object oPC)
{
    int nTrue = GetLevelByClass(CLASS_TYPE_TRUENAMER, oPC);
    int nRec =     GetHasFeat(FEAT_RECITATION_FORTIFIED,    oPC) +
                   GetHasFeat(FEAT_RECITATION_MEDITATIVE,    oPC) +
                   GetHasFeat(FEAT_RECITATION_MINDFUL,       oPC) +
                   GetHasFeat(FEAT_RECITATION_SANGUINE,      oPC) +
                   GetHasFeat(FEAT_RECITATION_VITAL,         oPC);
    // Need 2 at level 15, 1 at level 8
    if((nTrue >= 15 && 2 > nRec) || (nTrue >= 8 && 1 > nRec))
    {
        FloatingTextStringOnCreature("You must select a Recitation feat.", oPC, FALSE);
        return TRUE;
    }

    return FALSE;
}
 */
int PyroElement(object oPC = OBJECT_SELF)
{
     int nLevel = GetLevelByClass(CLASS_TYPE_PYROKINETICIST, oPC);
     if(nLevel)
     {
          if(GetHasFeat(FEAT_PYRO_PYROKINETICIST, oPC)
           + GetHasFeat(FEAT_PYRO_CRYOKINETICIST, oPC)
           + GetHasFeat(FEAT_PYRO_SONOKINETICIST, oPC)
           + GetHasFeat(FEAT_PYRO_ELECTROKINETICIST, oPC)
           + GetHasFeat(FEAT_PYRO_ACETOKINETICIST, oPC)
           != 1)
          {
               FloatingTextStringOnCreature("You may only have 1 element as a Pyrokineticist.", oPC, FALSE);
               return TRUE;
          }
     }
     return FALSE;
}

void main()
{
    //Declare Major Variables
    object oPC = OBJECT_SELF;
    int bRelevel = FALSE;

    // Psion disciplines
    bRelevel |= PsionDiscipline(oPC);
    // Thrallherd
    bRelevel |= Thrallherd(oPC);
    // Cross class cap on TrueSpeech
    bRelevel |= CheckTrueSpeechSkill(oPC);
    // Recitations
    bRelevel |= Recitations(oPC);
    // Recitations
    bRelevel |= PyroElement(oPC);


    if(GetIsPsionicCharacter(oPC))
        bRelevel |= AntiPsionicFeats(oPC); // Feats that require one to *not* be a psionic character
    else
        bRelevel |= PsionicFeats(oPC);     // Feats that require one to be a psionic character

    bRelevel |= SplitPsionicRay(oPC);

    if(GetHitDice(oPC) > 20) bRelevel |= EpicPsionicFeats(oPC);

    if(bRelevel)
    {
        int nHD = GetHitDice(oPC);
        int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
        int nOldXP = GetXP(oPC);
        int nNewXP = nMinXPForLevel - 1000;
        SetXP(oPC,nNewXP);
        DelayCommand(1.0, SetXP(oPC,nOldXP));
    }
}