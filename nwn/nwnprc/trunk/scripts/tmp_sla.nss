/**
 * @file
 * Spellscript for a range of template SLAs.
 */
//constants 16300 - 17300
const int HALF_CELESTIAL_SLA_PROTECTION_FROM_EVIL     = 16304;
const int HALF_CELESTIAL_SLA_BLESS                    = 16305;
const int HALF_CELESTIAL_SLA_AID                      = 16306;
const int HALF_CELESTIAL_SLA_DETECT_EVIL              = 16307;
const int HALF_CELESTIAL_SLA_CURE_SERIOUS_WOUNDS      = 16308;
const int HALF_CELESTIAL_SLA_NEUTRALIZE_POISON        = 16309;
const int HALF_CELESTIAL_SLA_HOLYSMITE                = 16310;
const int HALF_CELESTIAL_SLA_REMOVE_DISEASE           = 16311;
const int HALF_CELESTIAL_SLA_DISPELEVIL               = 16312;
const int HALF_CELESTIAL_SLA_HOLY_WORD                = 16313;
const int HALF_CELESTIAL_SLA_HOLYAURA                 = 16314;
const int HALF_CELESTIAL_SLA_HALLOW                   = 16315;
const int HALF_CELESTIAL_SLA_MASS_CHARM               = 16316;
const int HALF_CELESTIAL_SLA_SUMMON_CREATURE_IX       = 16317;
const int HALF_CELESTIAL_SLA_SUMMON_CREATURE_IX_AIR   = 16318;
const int HALF_CELESTIAL_SLA_SUMMON_CREATURE_IX_EARTH = 16319;
const int HALF_CELESTIAL_SLA_SUMMON_CREATURE_IX_FIRE  = 16320;
const int HALF_CELESTIAL_SLA_SUMMON_CREATURE_IX_WATER = 16321;
const int HALF_CELESTIAL_SLA_RESURRECTION             = 16322;
const int HALF_CELESTIAL_SLA_DAYLIGHT                 = 16323;

const int HALF_FIENDISH_SLA_DARKNESS                  = 16325;
const int HALF_FIENDISH_SLA_DESECRATE                 = 16326;
const int HALF_FIENDISH_SLA_UNHOLY_BLIGHT             = 16327;
const int HALF_FIENDISH_SLA_POISON                    = 16328;
const int HALF_FIENDISH_SLA_CONTAGION                 = 16329;
const int HALF_FIENDISH_SLA_BLASPHEMY                 = 16330;
const int HALF_FIENDISH_SLA_UNHOLY_AURA               = 16331;
const int HALF_FIENDISH_SLA_UNHALLOW                  = 16332;
const int HALF_FIENDISH_SLA_HORRID_WILTING            = 16333;
const int HALF_FIENDISH_SLA_SUMMON_CREATURE_IX        = 16334;
const int HALF_FIENDISH_SLA_SUMMON_CREATURE_IX_AIR    = 16335;
const int HALF_FIENDISH_SLA_SUMMON_CREATURE_IX_EARTH  = 16336;
const int HALF_FIENDISH_SLA_SUMMON_CREATURE_IX_FIRE   = 16337;
const int HALF_FIENDISH_SLA_SUMMON_CREATURE_IX_WATER  = 16338;
const int HALF_FIENDISH_SLA_DESTRUCTION               = 16339;

const int DEMILICH_ALTER_SELF_LEARN            = 16344;
const int DEMILICH_ALTER_SELF_OPTIONS          = 16345;
const int DEMILICH_ALTER_SELF_QS1              = 16346;
const int DEMILICH_ALTER_SELF_QS2              = 16347;
const int DEMILICH_ALTER_SELF_QS3              = 16348;
const int DEMILICH_ASTRAL_PROJECTION           = 16349;
const int DEMILICH_CREATE_GREATER_UNDEAD       = 16350;
const int DEMILICH_CREATE_UNDEAD               = 16351;
const int DEMILICH_DEATH_KNELL                 = 16352;
const int DEMILICH_ENERVATION                  = 16353;
const int DEMILICH_GREATER_DISPEL_MAGIC        = 16354;
const int DEMILICH_HARM                        = 16355;
const int DEMILICH_SUMMON_CREATURE_I           = 16356;
const int DEMILICH_SUMMON_CREATURE_II          = 16357;
const int DEMILICH_SUMMON_CREATURE_III         = 16358;
const int DEMILICH_SUMMON_CREATURE_IV          = 16359;
const int DEMILICH_SUMMON_CREATURE_V           = 16360;
const int DEMILICH_SUMMON_CREATURE_VI          = 16361;
const int DEMILICH_SUMMON_CREATURE_VII_AIR     = 16363;
const int DEMILICH_SUMMON_CREATURE_VII_EARTH   = 16364;
const int DEMILICH_SUMMON_CREATURE_VII_FIRE    = 16365;
const int DEMILICH_SUMMON_CREATURE_VII_WATER   = 16366;
const int DEMILICH_SUMMON_CREATURE_VIII_AIR    = 16368;
const int DEMILICH_SUMMON_CREATURE_VIII_EARTH  = 16369;
const int DEMILICH_SUMMON_CREATURE_VIII_FIRE   = 16370;
const int DEMILICH_SUMMON_CREATURE_VIII_WATER  = 16371;
const int DEMILICH_SUMMON_CREATURE_IX_AIR      = 16373;
const int DEMILICH_SUMMON_CREATURE_IX_EARTH    = 16374;
const int DEMILICH_SUMMON_CREATURE_IX_FIRE     = 16375;
const int DEMILICH_SUMMON_CREATURE_IX_WATER    = 16376;
const int DEMILICH_TELEKINESIS                 = 16377;
const int DEMILICH_WEIRD                       = 16378;
const int DEMILICH_GREATER_PLANAR_ALLY         = 16379;

const int ARCHLICH_TURN_UNDEAD                 = 16381;

//:: Saint Template
const int SAINT_SLA_BLESS                      = 16382;
//const int SAINT_SLA_GUIDANCE                 = 16383;
const int SAINT_SLA_RESISTANCE                 = 16384;
const int SAINT_SLA_VIRTUE                     = 16385;


#include "inc_newspellbook"
#include "prc_inc_core"


//Check for remining SLA uses
int CheckUses(object oPC, int nSpellID, int nUses)
{
    if(nUses == 0) //unlimited uses per day
        return TRUE;

    int nTest = GetLocalInt(oPC, "TemplateSLA_"+IntToString(nSpellID));

    if(nTest < nUses)
    {
        nTest++;
        SetLocalInt(oPC, "TemplateSLA_"+IntToString(nSpellID), nTest);
        return TRUE;
    }
    else
    {
        FloatingTextStringOnCreature("You have already used this ability today.", oPC);
        return FALSE;
    }
}

void main()
{
    object oPC = OBJECT_SELF;
    int nSpellID = GetSpellId();
    int nCasterLvl = GetHitDice(oPC);
    int nUses = 1, nSpell;
    int nHD = GetHitDice(oPC);
    int nDC = 10 + GetAbilityModifier(ABILITY_CHARISMA, oPC);

    switch(nSpellID)
    {
        case HALF_CELESTIAL_SLA_PROTECTION_FROM_EVIL:
        {
            nUses = 3;
            nSpell = SPELL_PROTECTION_FROM_EVIL;
            break;
        }
        case HALF_CELESTIAL_SLA_BLESS:
        {
            nSpell = SPELL_BLESS;
            break;
        }
        case HALF_CELESTIAL_SLA_AID:
        {
            nSpell = SPELL_AID;
            break;
        }
        case HALF_CELESTIAL_SLA_DETECT_EVIL:
        {
            nSpell = SPELL_DETECT_EVIL;
            break;
        }
        case HALF_CELESTIAL_SLA_CURE_SERIOUS_WOUNDS:
        {
            nSpell = SPELL_CURE_SERIOUS_WOUNDS;
            break;
        }
        case HALF_CELESTIAL_SLA_NEUTRALIZE_POISON:
        {
            nSpell = SPELL_NEUTRALIZE_POISON;
            break;
        }
        case HALF_CELESTIAL_SLA_HOLYSMITE:
        {
            //nSpell = ?;
            break;
        }
        case HALF_CELESTIAL_SLA_REMOVE_DISEASE:
        {
            nSpell = SPELL_REMOVE_DISEASE;
            break;
        }
        case HALF_CELESTIAL_SLA_DISPELEVIL:
        {
            //nSpell = ?;
            break;
        }
        case HALF_CELESTIAL_SLA_HOLY_WORD:
        {
            nSpell = SPELL_HOLY_WORD;
            break;
        }
        case HALF_CELESTIAL_SLA_HOLYAURA:
        {
            nUses = 3;
            nSpell = SPELL_PRC_HOLY_AURA;
            break;
        }
        case HALF_CELESTIAL_SLA_HALLOW:
        {
            //nSpell = ?;
            break;
        }
        case HALF_CELESTIAL_SLA_MASS_CHARM:
        {
            nSpell = SPELL_MASS_CHARM;
            break;
        }
        case HALF_CELESTIAL_SLA_SUMMON_CREATURE_IX_AIR:
        {
            nSpellID = HALF_CELESTIAL_SLA_SUMMON_CREATURE_IX;
            nSpell = 3197;
            break;
        }
        case HALF_CELESTIAL_SLA_SUMMON_CREATURE_IX_EARTH:
        {
            nSpellID = HALF_CELESTIAL_SLA_SUMMON_CREATURE_IX;
            nSpell = 3198;
            break;
        }
        case HALF_CELESTIAL_SLA_SUMMON_CREATURE_IX_FIRE:
        {
            nSpellID = HALF_CELESTIAL_SLA_SUMMON_CREATURE_IX;
            nSpell = 3199;
            break;
        }
        case HALF_CELESTIAL_SLA_SUMMON_CREATURE_IX_WATER:
        {
            nSpellID = HALF_CELESTIAL_SLA_SUMMON_CREATURE_IX;
            nSpell = 3200;
            break;
        }
        case HALF_CELESTIAL_SLA_RESURRECTION:
        {
            nSpell = SPELL_RESURRECTION;
            break;
        }
        case HALF_CELESTIAL_SLA_DAYLIGHT:
        {
            nUses = 0;
            nSpell = SPELL_DAYLIGHT;
            break;
        }
        case HALF_FIENDISH_SLA_DARKNESS:
        {
            nUses = 3;
            nSpell = SPELL_DARKNESS;
            break;
        }
        case HALF_FIENDISH_SLA_DESECRATE:
        {
            //nSpell = ?;
            break;
        }
        case HALF_FIENDISH_SLA_UNHOLY_BLIGHT:
        {
            //nSpell = ?;
            break;
        }
        case HALF_FIENDISH_SLA_POISON:
        {
            nUses = 3;
            nSpell = SPELL_POISON;
            break;
        }
        case HALF_FIENDISH_SLA_CONTAGION:
        {
            nSpell = SPELL_CONTAGION;
            break;
        }
        case HALF_FIENDISH_SLA_BLASPHEMY:
        {
            nSpell = SPELL_BLASPHEMY;
            break;
        }
        case HALF_FIENDISH_SLA_UNHOLY_AURA:
        {
            nUses = 3;
            //nSpell = ?;
            break;
        }
        case HALF_FIENDISH_SLA_UNHALLOW:
        {
            //nSpell = ?;
            break;
        }
        case HALF_FIENDISH_SLA_HORRID_WILTING:
        {
            nSpell = SPELL_HORRID_WILTING;
            break;
        }
        case HALF_FIENDISH_SLA_SUMMON_CREATURE_IX_AIR:
        {
            nSpellID = HALF_FIENDISH_SLA_SUMMON_CREATURE_IX;
            nSpell = 3197;
            break;
        }
        case HALF_FIENDISH_SLA_SUMMON_CREATURE_IX_EARTH:
        {
            nSpellID = HALF_FIENDISH_SLA_SUMMON_CREATURE_IX;
            nSpell = 3198;
            break;
        }
        case HALF_FIENDISH_SLA_SUMMON_CREATURE_IX_FIRE:
        {
            nSpellID = HALF_FIENDISH_SLA_SUMMON_CREATURE_IX;
            nSpell = 3199;
            break;
        }
        case HALF_FIENDISH_SLA_SUMMON_CREATURE_IX_WATER:
        {
            nSpellID = HALF_FIENDISH_SLA_SUMMON_CREATURE_IX;
            nSpell = 3200;
            break;
        }
        case HALF_FIENDISH_SLA_DESTRUCTION:
        {
            nSpell = SPELL_DESTRUCTION;
            break;
        }
        case DEMILICH_ALTER_SELF_LEARN:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = SPELL_ALTER_SELF_LEARN;
            break;
        }
        case DEMILICH_ALTER_SELF_OPTIONS:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = SPELL_ALTER_SELF_OPTIONS;
            break;
        }
        case DEMILICH_ALTER_SELF_QS1:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = SPELL_ALTER_SELF_QS1;
            break;
        }
        case DEMILICH_ALTER_SELF_QS2:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = SPELL_ALTER_SELF_QS2;
            break;
        }
        case DEMILICH_ALTER_SELF_QS3:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = SPELL_ALTER_SELF_QS3;
            break;
        }
        case DEMILICH_ASTRAL_PROJECTION:
        {
            nUses = 0;
            nDC += nCasterLvl;
            //nSpell = ?;
            break;
        }
        case DEMILICH_CREATE_GREATER_UNDEAD:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = SPELL_CREATE_GREATER_UNDEAD;
            break;
        }
        case DEMILICH_CREATE_UNDEAD:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = SPELL_CREATE_UNDEAD;
            break;
        }
        case DEMILICH_DEATH_KNELL:
        {
            nUses = 0;
            nDC += nCasterLvl;
            //nSpell = ?;
            break;
        }
        case DEMILICH_ENERVATION:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = SPELL_ENERVATION;
            break;
        }
        case DEMILICH_GREATER_DISPEL_MAGIC:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = SPELL_GREATER_DISPELLING;
            break;
        }
        case DEMILICH_HARM:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = SPELL_HARM;
            break;
        }
        case DEMILICH_SUMMON_CREATURE_I:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = SPELL_SUMMON_CREATURE_I;
            break;
        }
        case DEMILICH_SUMMON_CREATURE_II:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = SPELL_SUMMON_CREATURE_II;
            break;
        }
        case DEMILICH_SUMMON_CREATURE_III:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = SPELL_SUMMON_CREATURE_III;
            break;
        }
        case DEMILICH_SUMMON_CREATURE_IV:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = SPELL_SUMMON_CREATURE_IV;
            break;
        }
        case DEMILICH_SUMMON_CREATURE_V:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = SPELL_SUMMON_CREATURE_V;
            break;
        }
        case DEMILICH_SUMMON_CREATURE_VI:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = SPELL_SUMMON_CREATURE_VI;
            break;
        }
        case DEMILICH_SUMMON_CREATURE_VII_AIR:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = 3189;
            break;
        }
        case DEMILICH_SUMMON_CREATURE_VII_EARTH:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = 3190;
            break;
        }
        case DEMILICH_SUMMON_CREATURE_VII_FIRE:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = 3191;
            break;
        }
        case DEMILICH_SUMMON_CREATURE_VII_WATER:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = 3192;
            break;
        }
        case DEMILICH_SUMMON_CREATURE_VIII_AIR:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = 3193;
            break;
        }
        case DEMILICH_SUMMON_CREATURE_VIII_EARTH:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = 3194;
            break;
        }
        case DEMILICH_SUMMON_CREATURE_VIII_FIRE:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = 3195;
            break;
        }
        case DEMILICH_SUMMON_CREATURE_VIII_WATER:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = 3196;
            break;
        }
        case DEMILICH_SUMMON_CREATURE_IX_AIR:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = 3197;
            break;
        }
        case DEMILICH_SUMMON_CREATURE_IX_EARTH:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = 3198;
            break;
        }
        case DEMILICH_SUMMON_CREATURE_IX_FIRE:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = 3199;
            break;
        }
        case DEMILICH_SUMMON_CREATURE_IX_WATER:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = 3200;
            break;
        }
        case DEMILICH_TELEKINESIS:
        {
            nUses = 0;
            nDC += nCasterLvl;
            //nSpell = ?;
            break;
        }
        case DEMILICH_WEIRD:
        {
            nUses = 0;
            nDC += nCasterLvl;
            nSpell = SPELL_WEIRD;
            break;
        }
        case DEMILICH_GREATER_PLANAR_ALLY:
        {
            nUses = 2;
            nDC += nCasterLvl;
            nSpell = SPELL_GREATER_PLANAR_ALLY;
            break;
        }
	    case ARCHLICH_TURN_UNDEAD:
        {
            nUses = 3;
            nUses += GetAbilityModifier(ABILITY_CHARISMA, oPC);
            if (nUses == 0) nUses = -1;
            nDC += nCasterLvl;
            nSpell = SPELLABILITY_TURN_UNDEAD;
            break;
        }
	    case SAINT_SLA_BLESS:
        {
            if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
            {
                nUses = 0;
                nDC += nCasterLvl;
                nSpell = SPELL_BLESS;
                break;
            }
            else
            { 
                SendMessageToPC(oPC, "Saints must be good aligned");
                break;
            }				
        }
	    case SAINT_SLA_RESISTANCE:
        {
            if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
            {
                nUses = 0;
                nDC += nCasterLvl;
                nSpell = SPELL_RESISTANCE;
                break;
            }
            else
            { 
                SendMessageToPC(oPC, "Saints must be good aligned");
                break;
            }
        }
	    case SAINT_SLA_VIRTUE:
        {
            if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
            {
                 nUses = 0;
                 nDC += nCasterLvl;
                 nSpell = SPELL_VIRTUE;  //:: Virtue
                 break;
            }
            else
            { 
                 SendMessageToPC(oPC, "Saints must be good aligned");
                 break;
            }
        }
		
   }
	if(CheckUses(oPC, nSpellID, nUses))
	DoRacialSLA(nSpell, nCasterLvl, nDC);		
}