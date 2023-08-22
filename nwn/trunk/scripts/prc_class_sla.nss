/**
 * @file
 * Spellscript for a range of class SLAs.
 *
 * Class SLAs that use DoRacialSLA() are all grouped in this file.
 */
/*
                    Extraordinary  Spell-Like  Supernatural
Dispel                   No           Yes          No
Spell resistance         No           Yes          No
Antimagic field          No           Yes          Yes
Attack of opportunity    No           Yes          No
*/

#include "inc_newspellbook"
#include "prc_inc_core"

void main()
{
    object oCaster = OBJECT_SELF;
    int nSpellID = GetSpellId();
    int nClass, nCasterLvl, nDC, nSpell;
    int bInstantCast = FALSE;

    switch(nSpellID){
        case 1552:// warpriest healing circle
        {
            nClass = CLASS_TYPE_WARPRIEST;
            nSpell = SPELL_HEALING_CIRCLE;
            break;
        }
        case 1555:// warpriest mass haste
        {
            nClass = CLASS_TYPE_WARPRIEST;
            nSpell = SPELL_MASS_HASTE;
            break;
        }
        case 1563:// warpriest mass heal
        {
            nClass = CLASS_TYPE_WARPRIEST;
            nSpell = SPELL_MASS_HEAL;
            break;
        }
        case 3005:// Fire Shield for the Disciple of Mephistopheles
        {
            nCasterLvl = 15;
            nSpell = SPELL_ELEMENTAL_SHIELD;
            break;
        }
        case 3002:// Flare for the Disciple of Mephistopheles
        {
            nCasterLvl = 15;
            nDC =  GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_MEPH) + GetAbilityModifier(ABILITY_CHARISMA) + 10;
            nSpell = SPELL_FLARE;
            break;
        }
        case 1764:
        {
            nClass = CLASS_TYPE_ARCANE_DUELIST;
            nSpell = SPELL_BLUR;
            break;
        }
        case 1765:
        {
            nClass = CLASS_TYPE_ARCANE_DUELIST;
            nSpell = SPELL_MIRROR_IMAGE;
            break;
        }
        case 2752:
        {
            nClass = CLASS_TYPE_DISC_BAALZEBUL;
            nSpell = SPELL_MASS_CHARM;
            break;
        }
        case 2753:
        {
            nClass = CLASS_TYPE_DISC_BAALZEBUL;
            nSpell = SPELL_CHARM_PERSON;
            break;
        }
        case 1934:
        {
            nClass = CLASS_TYPE_SLAYER_OF_DOMIEL;
            nSpell = SPELL_DETECT_EVIL;
            break;
        }
        case 2767:
        {
            nCasterLvl = 18;
            nSpell = SPELL_IRON_BODY;
            break;
        }
        case 2766:
        {
            nCasterLvl = 15;
            nSpell = SPELL_STONESKIN;
            break;
        }
        case 1619:
        {
            nClass = CLASS_TYPE_JUDICATOR;
            nSpell = SPELL_HORRID_WILTING;
            break;
        }
        case 2035:
        {
            nClass = CLASS_TYPE_HATHRAN;
            nSpell = SPELL_FEAR;
            break;
        }
        case 1644:
        {
            nClass = CLASS_TYPE_HEALER;
            nSpell = SPELL_REMOVE_BLINDNESS_AND_DEAFNESS;
            break;
        }
        case 1630:
        {
            nClass = CLASS_TYPE_HEALER;
            nSpell = SPELL_REMOVE_DISEASE;
            break;
        }
        case 1636:
        {
            nClass = CLASS_TYPE_HEALER;
            nSpell = SPELL_REMOVE_FEAR;
            break;
        }
        case 1620:
        {
            nClass = CLASS_TYPE_HEALER;
            nSpell = SPELL_REMOVE_PARALYSIS;
            break;
        }
        case 1638:
        {
            nClass = CLASS_TYPE_HEALER;
            nSpell = SPELL_NEUTRALIZE_POISON;
            break;
        }
        case 1697:
        {
            nClass = CLASS_TYPE_HEALER;
            nSpell = SPELL_REGENERATE;
            break;
        }
        case 1698:
        {
            nClass = CLASS_TYPE_HEALER;
            nSpell = SPELL_TRUE_RESURRECTION;
            break;
        }
        case 1649:
        {
            nClass = CLASS_TYPE_HEALER;
            nSpell = SPELL_GREATER_RESTORATION;
            break;
        }
        case 1653:
        {
            nClass = CLASS_TYPE_HEALER;
            nSpell = SPELL_STONE_TO_FLESH;
            break;
        }
        case 17297:
        {
            nClass = CLASS_TYPE_KNIGHT_MIDDLECIRCLE;
            nSpell = SPELL_TRUE_STRIKE;
            break;
        }
        case 1556:
        {
            nClass = CLASS_TYPE_ORCUS;
            nSpell = SPELL_FEAR;
            break;
        }
        case 3008:
        {
            nCasterLvl = GetHitDice(oCaster);
            nSpell = SPELL_TRUE_STRIKE;
            break;
        }
        case 2140://URang haste
        {
            nCasterLvl = 10;
            bInstantCast = TRUE;
            nSpell = SPELL_HASTE;
            break;
        }
        case 2086:
        {
            nClass = CLASS_TYPE_ANTI_PALADIN;
            nSpell = SPELL_DEATH_KNELL;
            break;
        }
        case 2087:
        {
            nClass = CLASS_TYPE_ANTI_PALADIN;
            nSpell = SPELL_CONTAGION;
            break;
        }
    }

    if(nClass)
    {
        nCasterLvl = GetLevelByClass(nClass, oCaster);
        nDC = 10 + GetAbilityModifier(ABILITY_CHARISMA) + nCasterLvl;
    }

    DoRacialSLA(nSpell, nCasterLvl, nDC, bInstantCast);
}