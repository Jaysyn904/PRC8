/**
 * @file
 * Spellscript for a range of racial SLAs.
 *
 * Racial SLAs that use DoRacialSLA() are all grouped in this file.
 */

#include "inc_newspellbook"
#include "prc_inc_core"

void ClearLocals()
{
    DeleteLocalInt(OBJECT_SELF, PRC_CASTERLEVEL_OVERRIDE);
    DeleteLocalInt(OBJECT_SELF, PRC_DC_TOTAL_OVERRIDE);
}

void main()
{
    int nRace = GetRacialType(OBJECT_SELF);
    int nHD = GetHitDice(OBJECT_SELF);
    int nCasterLvl = nHD, nDC, nSpell;

    switch(GetSpellId()){
        case SPELL_URDINNIR_STONESKIN:
        {
            nCasterLvl = 4;
            nSpell = SPELL_STONESKIN;
            break;
        }
        case SPELL_RACE_DARKNESS:
        {
            nCasterLvl = nRace == RACIAL_TYPE_OMAGE ? 9 : 3;
            nSpell = SPELL_DARKNESS;
            break;
        }
        case SPELL_RACE_DAZE:
        {
            nCasterLvl = 3;
            nSpell = SPELL_DAZE;
            break;
        }
        case SPELL_RACE_LIGHT:
        {
            nSpell = SPELL_LIGHT;
            break;
        }
        case SPELL_SVIRF_BLINDDEAF:
        {
            // 10 + Spell level (2) + Racial bonus (4) + Cha Mod
            nDC = 16 + GetAbilityModifier(ABILITY_CHARISMA);
            nSpell = SPELL_BLINDNESS_AND_DEAFNESS;
            break;
        }
        case SPELL_ILLITHID_CHARM_MONSTER:
        {
            nCasterLvl = 8;
            nSpell = SPELL_CHARM_MONSTER;
            break;
        }
        case SPELL_RACE_CHARM_PERSON:
        {
            if (nRace == RACIAL_TYPE_PURE_YUAN) { nCasterLvl = 3; }
            else if (nRace == RACIAL_TYPE_NIXIE) { nCasterLvl = 4; }
            else if (nRace == RACIAL_TYPE_BRALANI) { nCasterLvl = 6; }
            else if (nRace == RACIAL_TYPE_OMAGE) { nCasterLvl = 9; }
            nSpell = SPELL_CHARM_PERSON;
            break;
        }
        case SPELL_FEYRI_ENERVATION:
        {
            nSpell = SPELL_ENERVATION;
            break;
        }
        case SPELL_RACE_ENTANGLE:
        {
            nCasterLvl = 3;
            if(nRace == RACIAL_TYPE_PIXIE)
                nCasterLvl = 8;
            else if(nRace == RACIAL_TYPE_GRIG)
                nCasterLvl = 9;
            nSpell = SPELL_ENTANGLE;
            break;
        }
        case SPELL_RACE_FEAR:
        {
            nCasterLvl = 3;
            nSpell = SPELL_FEAR;
            break;
        }
        case SPELL_RACE_CLAIR:
        {
            nSpell = SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE;
            break;
        }
        case SPELL_RACE_NEUTRALIZE_POISON:
        {
            nSpell = SPELL_NEUTRALIZE_POISON;
            break;
        }
        case SPELL_PIXIE_CONFUSION:
        {
            nCasterLvl = 8;
            nSpell = SPELL_CONFUSION;
            break;
        }
        case SPELL_PIXIE_IMPINVIS:
        case SPELL_DUERGAR_INVIS:
        {
            nCasterLvl = 8;
            if(nRace == RACIAL_TYPE_GRIG)
                nCasterLvl = 9;
            else if(nRace == RACIAL_TYPE_DUERGAR)
                nCasterLvl = (nHD * 2);
            nSpell = SPELL_INVISIBILITY;
            break;
        }
        case SPELL_PIXIE_DISPEL:
        {
            nCasterLvl = 8;
            nSpell = SPELL_DISPEL_MAGIC;
            break;
        }
        case SPELL_RACE_CHILLTOUCH:
        {
            if(nRace == RACIAL_TYPE_MORTIF)
                nCasterLvl = (nHD)+2;
            else if(nRace == RACIAL_TYPE_ZAKYA_RAKSHASA)
                nCasterLvl = 7;
            nSpell = SPELL_CHILL_TOUCH;
            break;
        }
        case SPELL_RACE_SILENCE:
        {
            nSpell = SPELL_SILENCE;
            break;
        }
        case SPELL_RACE_MAGE_HAND:
        {
            nSpell = SPELL_MAGE_HAND;
            break;
        }
        case SPELL_ZAKYA_VAMPIRIC_TOUCH:
        {
            nCasterLvl = 7;
            nSpell = SPELL_VAMPIRIC_TOUCH;
            break;
        }
        case SPELL_GRIG_PYROTECHNICS_FIREWORKS:
        {
            nCasterLvl = 9;
            nSpell = SPELL_PYROTECHNICS_FIREWORKS;
            break;
        }
        case SPELL_GRIG_PYROTECHNICS_SMOKE:
        {
            nCasterLvl = 9;
            nSpell = SPELL_PYROTECHNICS_SMOKE;
            break;
        }
        case SPELL_BRALANI_LIGHTNING_BOLT:
        {
            nCasterLvl = 6;
            nSpell = SPELL_LIGHTNING_BOLT;
            break;
        }
        case SPELL_BRALANI_CURE_SERIOUS_WOUNDS:
        {
            nCasterLvl = 6;
            nSpell = SPELL_CURE_SERIOUS_WOUNDS;
            break;
        }
        case SPELL_BRALANI_GUST_OF_WIND:
        {
            nCasterLvl = 6;
            nSpell = SPELL_GUST_OF_WIND;
            break;
        }
        case SPELL_BRALANI_MIRROR_IMAGE:
        {
            nCasterLvl = 6;
            nSpell = SPELL_MIRROR_IMAGE;
            break;
        }
        case SPELL_IRDA_FLARE:
        {
            nSpell = SPELL_FLARE;
            break;
        }
        case SPELL_HOUND_DETECTEVIL:
        {
            nSpell = SPELL_DETECT_EVIL;
            break;
        }
        case SPELL_HOUND_AID:
        {
            nCasterLvl = 6;
            nSpell = SPELL_AID;
            break;
        }
        case SPELL_HOUND_CONTFLAME:
        {
            nCasterLvl = 6;
            nSpell = SPELL_CONTINUAL_FLAME;
            break;
        }
        case SPELL_HOUND_TELEPORT:
        {
            nCasterLvl = 6;
            nSpell = SPELL_GREATER_TELEPORT_SELF;
            DelayCommand(1.0f, ClearLocals());
            break;
        }
        case SPELL_ZENYTH_TRUE_STRIKE:
        {
            nSpell = SPELL_TRUE_STRIKE;
            break;
        }
        case SPELL_RACIAL_CIRCLE_VS_GOOD:
        {
            nSpell = SPELL_MAGIC_CIRCLE_AGAINST_GOOD;
            break;
        }
        case SPELL_RACIAL_CIRCLE_VS_EVIL:
        {
            nSpell = SPELL_MAGIC_CIRCLE_AGAINST_EVIL;
            break;
        }
        case SPELL_RACIAL_CIRCLE_VS_LAW:
        {
            nSpell = SPELL_MAGIC_CIRCLE_AGAINST_LAW;
            break;
        }
        case SPELL_RACIAL_CIRCLE_VS_CHAOS:
        {
            nSpell = SPELL_MAGIC_CIRCLE_AGAINST_CHAOS;
            break;
        }
        case SPELL_NATHRI_EXPEDITIOUS_RETREAT:
        {
            nSpell = SPELL_EXPEDITIOUS_RETREAT;
            break;
        }
        case SPELL_NYMPH_DIMDOOR_SELF:
        {
            nCasterLvl = 7;
            nSpell = SPELL_DIMENSION_DOOR_SELF;
            DelayCommand(1.0f, ClearLocals());
            break;
        }
        case SPELL_NYMPH_DIMDOOR_PARTY:
        {
            nCasterLvl = 7;
            nSpell = SPELL_DIMENSION_DOOR_PARTY;
            DelayCommand(1.0f, ClearLocals());
            break;
        }
        case SPELL_NYMPH_DIMDOOR_DIST_SELF:
        {
            nCasterLvl = 7;
            nSpell = SPELL_DIMENSION_DOOR_DIRDIST_SELF;
            DelayCommand(1.0f, ClearLocals());
            break;
        }
        case SPELL_NYMPH_DIMDOOR_DIST_PARTY:
        {
            nCasterLvl = 7;
            nSpell = SPELL_DIMENSION_DOOR_DIRDIST_PARTY;
            DelayCommand(1.0f, ClearLocals());
            break;
        }
        case SPELL_DRIDER_DETECTGOOD:
        {
            nSpell = SPELL_DETECT_GOOD;
            break;
        }
        case SPELL_DRIDER_DETECTLAW:
        {
            nSpell = SPELL_DETECT_LAW;
            break;
        }
        case SPELL_RACE_BLUR:
        {
            if(nRace == RACIAL_TYPE_GITHYANKI)
                nCasterLvl = 3;
            else if(nRace == RACIAL_TYPE_BRALANI)
                nCasterLvl = 6;
            nSpell = SPELL_BLUR;
            break;
        }
		case SPELL_HYBSIL_MIRROR_IMAGE:
		{
			nCasterLvl = 1;
            nSpell = SPELL_MIRROR_IMAGE;
            break;			
		}
		case SPELL_HYBSIL_DANCLIGHTS:
		{
			nCasterLvl = 1;
            nSpell = SPELL_DANCING_LIGHTS;
            break;			
		}
		case SPELL_HYBSIL_JUMP:
		{
			nCasterLvl = 1;
            nSpell = SPELL_SPELL_JUMP;
            break;			
		}
        case 1965://Faerie fire
        {
            nSpell = SPELL_FAERIE_FIRE;
            break;
        }
        case 3494: // Magic Stone for Stonechild
        {
            nCasterLvl = 3;
            nSpell = SPELL_MAGIC_STONE;
            break;
        }
        case 3804: // Uldra Ray of Frost
        {
            nDC = 10 + GetAbilityModifier(ABILITY_WISDOM);
            nCasterLvl = GetHitDice(OBJECT_SELF);
            nSpell = SPELL_RAY_OF_FROST;
            break;
        }
        case 3805: // Uldra Touch of Fatigue
        {
            nDC = 10 + GetAbilityModifier(ABILITY_WISDOM);
            nCasterLvl = GetHitDice(OBJECT_SELF);
            nSpell = SPELL_TOUCH_FATIGUE;
            break;
        }  
        case 3826: // Extaminaar Charm Animal
        {
            nCasterLvl = GetHitDice(OBJECT_SELF);
            nSpell = SPELL_CHARM_PERSON_OR_ANIMAL;
            break;
        }        
    }

    DoRacialSLA(nSpell, nCasterLvl, nDC);
	DelayCommand(0.1f, ClearLocals());
}
