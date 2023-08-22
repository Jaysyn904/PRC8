/*:://////////////////////////////////////////////
//:: Spell Name Poison
//:: Spell FileName
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy
    Level: Clr 4, Drd 3
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Touch
    Target: Living creature touched
    Duration: Instantaneous; see text
    Saving Throw: Fortitude negates; see text
    Spell Resistance: Yes

    Calling upon the venomous powers of natural predators, you infect the
    subject with a horrible poison by making a successful melee touch attack.
    The poison deals 1d10 points of Constitution damage immediately and another
    1d10 points of Constitution damage 1 minute later. Each instance of damage
    can be negated by a Fortitude save (DC 10 + 1/2 your caster level + your Wis
    modifier).
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Not sure about the "minute later", ubt I think it is already like that for
    all poisons.

    Cirtainly needs testing - will a new poison.2da work?

    Added values from PHS_POISON_SPELL_POISON_ENTRY_START upwards, DC 13 up to
    DC 50.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// DC13 Entry in the poisons.2da
const int PHS_POISON_SPELL_POISON_ENTRY_START = 101;

// Gets the 2da of the poison to use
int Get2daEntry(int nDC);

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_POISON)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();
    int nAbility = PHS_GetAppropriateAbilityBonus();

    // Get the DC. 10 + Ability Modifier (Wisdom) + Half caster level
    int nDC = 10 + PHS_LimitInteger(nCasterLevel/2) + nAbility;

    if(nDC > 50) nDC = 50;

    // Do touch attack
    int nTouch = PHS_SpellTouchAttack(PHS_TOUCH_MELEE, oTarget, TRUE);

    // Delcare Effects
    effect ePoison = EffectPoison(Get2daEntry(nDC));

    // Signal spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_POISON);

    // Melee Touch attack
    if(nTouch)
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Spell resistance and immunity check
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Apply poison (permament)
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget);
            }
        }
    }
}

// Gets the 2da of the poison to use
int Get2daEntry(int nDC)
{
    int nResult = PHS_POISON_SPELL_POISON_ENTRY_START;
    switch(nDC)
    {
        case 50: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 37; break;
        case 49: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 36; break;
        case 48: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 35; break;
        case 47: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 34; break;
        case 46: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 33; break;
        case 45: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 32; break;
        case 44: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 31; break;
        case 43: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 30; break;
        case 42: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 29; break;
        case 41: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 28; break;
        case 40: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 27; break;
        case 39: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 26; break;
        case 38: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 25; break;
        case 37: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 24; break;
        case 36: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 23; break;
        case 35: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 22; break;
        case 34: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 21; break;
        case 33: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 20; break;
        case 32: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 19; break;
        case 31: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 18; break;
        case 30: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 17; break;
        case 29: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 16; break;
        case 28: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 15; break;
        case 27: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 14; break;
        case 26: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 13; break;
        case 25: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 12; break;
        case 24: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 11; break;
        case 23: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 10; break;
        case 22: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 9; break;
        case 21: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 8; break;
        case 20: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 7; break;
        case 19: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 6; break;
        case 18: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 5; break;
        case 17: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 4; break;
        case 16: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 3; break;
        case 15: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 2; break;
        case 14: nResult = PHS_POISON_SPELL_POISON_ENTRY_START + 1; break;
        // Default to DC13
        default: nResult = PHS_POISON_SPELL_POISON_ENTRY_START; break;
    }
    return nResult;
}
