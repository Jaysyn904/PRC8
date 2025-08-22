//::///////////////////////////////////////////////
//:: Name           Lich template test script
//:: FileName       tmp_t_lich
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creating A Lich
    
    "Lich" is an acquired template that can be added to any humanoid creature (referred to hereafter as the base 
    creature), provided it can create the required phylactery.
    
    A lich has all the base creature’s statistics and special abilities except as noted here.
    
    Size and Type
    
    The creature’s type changes to undead. Do not recalculate base attack bonus, saves, or skill points. 
    Size is unchanged.
    
    Hit Dice
    
    Increase all current and future Hit Dice to d12s.
    
    Armor Class
    
    A lich has a +5 natural armor bonus or the base creature’s natural armor bonus, whichever is better.
    
    Attack
    
    A lich has a touch attack that it can use once per round. If the base creature can use weapons, the 
    lich retains this ability. A creature with natural weapons retains those natural weapons. A lich fighting 
    without weapons uses either its touch attack or its primary natural weapon (if it has any). A lich armed 
    with a weapon uses its touch or a weapon, as it desires.
    
    Full Attack
    
    A lich fighting without weapons uses either its touch attack (see above) or its natural weapons (if it has any). 
    If armed with a weapon, it usually uses the weapon as its primary attack along with a touch as a natural 
    secondary attack, provided it has a way to make that attack (either a free hand or a natural weapon that it 
    can use as a secondary attack).
    
    Damage
    
    A lich without natural weapons has a touch attack that uses negative energy to deal 1d8+5 points of damage 
    to living creatures; a Will save (DC 10 + ½ lich’s HD + lich’s Cha modifier) halves the damage. A lich with 
    natural weapons can use its touch attack or its natural weaponry, as it prefers. If it chooses the latter, 
    it deals 1d8+5 points of extra damage on one natural weapon attack.
    
    Special Attacks
    
    A lich retains all the base creature’s special attacks and gains those described below. Save DCs are equal 
    to 10 + ½ lich’s HD + lich’s Cha modifier unless otherwise noted.
    
    Fear Aura (Su)
    
    Liches are shrouded in a dreadful aura of death and evil. Creatures of less than 5 HD in a 60-foot radius 
    that look at the lich must succeed on a Will save or be affected as though by a fear spell from a sorcerer 
    of the lich’s level. A creature that successfully saves cannot be affected again by the same lich’s aura 
    for 24 hours.
    
    Paralyzing Touch (Su)
    
    Any living creature a lich hits with its touch attack must succeed on a Fortitude save or be permanently 
    paralyzed. Remove paralysis or any spell that can remove a curse can free the victim (see the bestow curse 
    spell description).
    
    The effect cannot be dispelled. Anyone paralyzed by a lich seems dead, though a DC 20 Spot check or 
    a DC 15 Heal check reveals that the victim is still alive..
    
    Spells
    
    A lich can cast any spells it could cast while alive.
    
    Special Qualities
    
    A lich retains all the base creature’s special qualities and gains those described below.
    
    Turn Resistance (Ex)
    
    A lich has +4 turn resistance.
    
    Damage Reduction (Su)
    
    A lich’s undead body is tough, giving the creature damage reduction 15/bludgeoning and magic. 
    Its natural weapons are treated as magic weapons for the purpose of overcoming damage reduction.
    
    Immunities (Ex)
    
    Liches have immunity to cold, electricity, polymorph (though they can use polymorph effects on 
    themselves), and mind-affecting attacks.
    
    Abilities
    
    Increase from the base creature as follows: Int +2, Wis +2, Cha +2. Being undead, a lich has no 
    Constitution score.
    
    Skills
    
    Liches have a +8 racial bonus on Hide, Listen, Move Silently, Search, Sense Motive, and Spot 
    checks. Otherwise same as the base creature.
    
    Organization
    
    Solitary or troupe (1 lich, plus 2-4 vampires and 5-8 vampire spawn).
    
    Challenge Rating
    
    Same as the base creature + 2.
    
    Treasure
    
    Standard coins; double goods; double items.
    
    Alignment
    
    Any evil.
    
    Advancement
    
    By character class.
    
    Level Adjustment
    
    Same as the base creature +4.
    
    Lich Characters
    
    The process of becoming a lich is unspeakably evil and can be undertaken only by a willing character. 
    A lich retains all class abilities it had in life.
    
    The Lich’s Phylactery
    
    An integral part of becoming a lich is creating a magic phylactery in which the character stores its 
    life force. As a rule, the only way to get rid of a lich for sure is to destroy its phylactery. 
    Unless its phylactery is located and destroyed, a lich reappears 1d10 days after its apparent death.
    
    Each lich must make its own phylactery, which requires the Craft Wondrous Item feat. The character 
    must be able to cast spells and have a caster level of 11th or higher. The phylactery costs 120,000 gp 
    and 4,800 XP to create and has a caster level equal to that of its creator at the time of creation.
    
    The most common form of phylactery is a sealed metal box containing strips of parchment on which magical
    phrases have been transcribed. The box is Tiny and has 40 hit points, hardness 20, and a break DC of 40.
    
    Other forms of phylacteries can exist, such as rings, amulets, or similar items.  

*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: 18/04/06
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    string sString = "Lich template: ";
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);

    int nAlignment = GetAlignmentGoodEvil(oPC);
    if(nAlignment != ALIGNMENT_EVIL && GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER) < 20)
    {
        SendMessageToPC(oPC, sString+"Not evil");
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }
    else if(GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER, oPC) >= 20 && nAlignment == ALIGNMENT_GOOD)
    {
        SendMessageToPC(oPC, sString+"Can't be a good Dread Necromancer");
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }

    int nArcCasterLevel = GetPrCAdjustedCasterLevelByType(TYPE_ARCANE, oPC, TRUE);
    int nDivCasterLevel = GetPrCAdjustedCasterLevelByType(TYPE_DIVINE, oPC, TRUE);
    if(nArcCasterLevel < 11 && nDivCasterLevel < 11)
    {
        SendMessageToPC(oPC, sString+"Arcane Caster Level = "+IntToString(nArcCasterLevel));
        SendMessageToPC(oPC, sString+"Divine Caster Level = "+IntToString(nDivCasterLevel));
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }

    if(!GetHasFeat(FEAT_CRAFT_WONDROUS))
    {
        SendMessageToPC(oPC, sString+"No craft wondrous items");
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }

	//:: No undead.
    if(GetHasTemplate(TEMPLATE_LICH, oPC) ||
    GetHasTemplate(TEMPLATE_DEMILICH, oPC) ||
	GetHasTemplate(TEMPLATE_ARCHLICH, oPC) ||
    GetHasTemplate(TEMPLATE_NECROPOLITAN, oPC) ||	
	GetHasTemplate(TEMPLATE_ALHOON, oPC) ||
	GetHasTemplate(TEMPLATE_CURST, oPC) ||
	GetHasTemplate(TEMPLATE_CRYPTSPAWN, oPC) ||
	GetHasTemplate(TEMPLATE_BAELNORN, oPC) ||	
    GetLevelByClass(CLASS_TYPE_BAELNORN, oPC) > 0 ||
    GetLevelByClass(CLASS_TYPE_LICH, oPC) > 0)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }	
	
    // Humanoid only
    int nRace = MyPRCGetRacialType(oPC);
    if(nRace == RACIAL_TYPE_ABERRATION ||
       nRace == RACIAL_TYPE_ANIMAL ||
       nRace == RACIAL_TYPE_BEAST ||
       nRace == RACIAL_TYPE_CONSTRUCT ||
       nRace == RACIAL_TYPE_DRAGON ||
       nRace == RACIAL_TYPE_ELEMENTAL ||
       nRace == RACIAL_TYPE_FEY ||
       nRace == RACIAL_TYPE_GIANT ||
       nRace == RACIAL_TYPE_MAGICAL_BEAST ||
       nRace == RACIAL_TYPE_PLANT ||
       nRace == RACIAL_TYPE_OOZE ||
       nRace == RACIAL_TYPE_OUTSIDER ||
       nRace == RACIAL_TYPE_SHAPECHANGER ||
       nRace == RACIAL_TYPE_UNDEAD ||
       nRace == RACIAL_TYPE_VERMIN)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }  
}