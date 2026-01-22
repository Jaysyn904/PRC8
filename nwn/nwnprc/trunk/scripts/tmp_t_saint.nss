//::///////////////////////////////////////////////
//:: Name:          Saint template test script
//:: FileName:		tmp_t_saint.nss
//:: 
//:: Created By: 	Jaysyn
//:: Created On: 	22/06/04
//:://////////////////////////////////////////////
/*CREATING A SAINT
"Saint" is an acquired template that can be added to any living creature of good alignment that is not an outsider or an elemental (referred to hereafter as the "base creature").

Size and Type: The creature's type changes to "outsider." The saint has the native subtype. Size is unchanged.

Armor Class: A saint gains an insight bonus to AC equal to the character's Wisdom bonus.

Special Attacks: A saint retains all the character's special attacks and gains those listed below.

Holy Power (Su): The save DCs of any and all of the saint's special attacks, including spells as well as spell-like, supernatural, and extraordinary abilities, increase by +2.

Holy Touch (Su): A saint's entire being is suffused with holy power, which likewise flows into any weapon the saint wields. A saint's melee attacks with any weapon (or unarmed) deal an additional 1d6 points of holy damage against evil creatures, and 1d8 points against evil undead and evil outsiders. Any evil creature that strikes a saint with a natural weapon takes holy damage as if hit by the saint's attack.

Spell-Like Abilities: At will - guidance, resistance, virtue, and bless. A saint's caster level is equal to its Hit Die total. The save DCs are Charisma-based.

Special Qualities: A saint retains all the character's special qualities and gains those listed below, as well as the outsider type.

Damage Reduction (Ex): Saints gain damage reduction according to their Hit Dice (including character level).
HD		Damage Reduction
1-3		-
4-7		5/magic
8-11	5/evil
12+		10/evil

If the base creature already has damage reduction, use the better value.

Fast Healing (Ex): Each round, a saint heals damage equal to half of its Hit Dice (including character levels, to a maximum of 10 points healed). If the base creature already has fast healing, use the better value.

Immunities (Ex): A saint is immune to acid, cold, electricity, and petrification attacks.

Keen Vision (Ex): Saints have low-light vision and 60-foot darkvision.

Protective Aura (Su): As a free action, a saint can surround herself with a nimbus of light having a radius of 20 feet. This acts as a double-strength magic circle against evil and as a lesser globe of invulnerability both as cast by a cleric whose level equal to the saint's Hit Dice.

Resistances (Ex): Saints have resistance to fire 10 and receive a +4 racial bonus on Fortitude saves against poison.

Tongues (Su): A saint can speak with any creature that has a language, as though using a tongues spell cast by a 14th-level cleric. This ability is always active.

Abilities: Modify the base creature as follows: Con +2, Wis +2, Cha +4.

Alignment: Saints are always good-aligned.

Level Adjustment: Same as base creature +2.
*/
//:://////////////////////////////////////////////


#include "prc_alterations"
#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);

//:: No evil creatures
	if (GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD)
	{
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    } 

//:: Any living creature of good alignment that is not an outsider or an elemental,
//:: allowing Warforged and Warforged Juggernaut races to continue.
	int nRace = MyPRCGetRacialType(oPC);
	int nExactRace = GetRacialType(oPC);

	if((nRace == RACIAL_TYPE_CONSTRUCT &&
	   nExactRace != RACIAL_TYPE_WARFORGED && 
	   nExactRace != RACIAL_TYPE_WARFORGED_SCOUT &&
	   nExactRace != RACIAL_TYPE_WARFORGED_CHARGER) ||
	   nRace == RACIAL_TYPE_ELEMENTAL ||
	   nRace == RACIAL_TYPE_OUTSIDER ||
	   nRace == RACIAL_TYPE_UNDEAD)
	{
		SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
	}

//:: No Undead templates or classes.  No saint stacking.
	if(GetHasTemplate(TEMPLATE_SAINT, oPC) 
	||	GetHasTemplate(TEMPLATE_DEMILICH, oPC)
	||	GetHasTemplate(TEMPLATE_LICH, oPC)
	||	GetHasTemplate(TEMPLATE_CURST, oPC)
	||	GetHasTemplate(TEMPLATE_GRAVETOUCHED_GHOUL, oPC)
	||	GetHasTemplate(TEMPLATE_NECROPOLITAN, oPC)
	||	GetLevelByClass(CLASS_TYPE_BAELNORN, oPC) > 0
	||	GetLevelByClass(CLASS_TYPE_LICH, oPC) > 0) 
	{
		SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
	}
}