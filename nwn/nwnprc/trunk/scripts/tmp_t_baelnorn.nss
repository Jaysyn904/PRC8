//::///////////////////////////////////////////////
//:: Name           Baelnorn template test script
//:: FileName       tmp_t_baelnorn
//::
//:: Created By: 	Jaysyn
//:: Created On: 	2025-07-31 11:48:39
//:://////////////////////////////////////////////
/*
    Creating A Baelnorn
    
    "Baelnorn" is an acquired template that can be added to any elf (referred to hereafter as the base creature)
    
    An Baelnorn has all the base creature’s statistics and special abilities except as noted here.
    
    Size and Type
    
    The creature’s type changes to undead. Do not recalculate base attack bonus, saves, or skill points. Size is unchanged.
    
    Hit Dice
    
    Increase all current and future Hit Dice to d12s.
    
    Armor Class
    
    An Baelnorn has a +5 natural armor bonus or the base creature’s natural armor bonus, whichever is better.
    
    Attack
    
    An Baelnorn has a touch attack that it can use once per round. If the base creature can use weapons, the 
    Baelnorn retains this ability. A creature with natural weapons retains those natural weapons. An Baelnorn fighting without weapons uses either its touch attack or its primary natural weapon (if it has any). An Baelnorn armed with a weapon uses its touch or a weapon, as it desires.
    
    Full Attack
    
    An Baelnorn fighting without weapons uses either its touch attack (see above) or its natural weapons (if it has any). 
    If armed with a weapon, it usually uses the weapon as its primary attack along with a touch as a natural secondary attack, provided it has a way to make that attack (either a free hand or a natural weapon that it can use as a secondary attack).
    
    Damage
    
    An Baelnorn without natural weapons has a touch attack that uses negative energy to deal 1d8+5 points of damage to living creatures; a Will save (DC 10 + ½ Baelnorn’s HD + Baelnorn’s Cha modifier) halves the damage. An Baelnorn with natural weapons can use its touch attack or its natural weaponry, as it prefers. If it chooses the latter, it deals 1d8+5 points of extra damage on one natural weapon attack.
    
    Special Attacks
    
    An Baelnorn retains all the base creature’s special attacks and gains those described below. Save DCs are equal to 10 + ½ Baelnorn’s HD + Baelnorn’s Cha modifier unless otherwise noted.
    
    Paralyzing Touch (Su): Any living creature an Baelnorn hits with its touch attack must succeed on a Fortitude save or be permanently paralyzed. Remove paralysis or any spell that can remove a curse can free the victim (see the bestow curse spell description).
    
    The effect cannot be dispelled. Anyone paralyzed by an Baelnorn seems dead, though a DC 20 Spot check or a DC 15 Heal check reveals that the victim is still alive..
	
	Animate Dead (Sp): Baelnorns can animate skeletons or zombies to serve them, using this spell-like ability at will as a sorcerer of its character level. In general, baelnorns have no interest in raising undead armies to serve them, but they use this power in self defence in the heat of battle.
    
	Projection (Su): Three times per day, for up to 1 hour at a time, a baelnorn can send a wraithlike likeness of itself up to one mile from the baelnorn’s actual location. The baelnorn can see through this projection and into the  Ethereal Plane as well, can hear and speak through it, and even cast spells through it. The link between the baelnorn and the projection transcends physical and all known magical barriers, and can even cross between the Material and the Ethereal planes.  The projection is AC 20, has a fly speed of 20 feet (perfect maneuverability), and has the hit points of the baelnorn, but it cannot carry solid objects and it has none of the baelnorn’s special attacks or qualities.  If the projection takes damage, the baelnorn takes half the damage (round down); the projection vanishes if it loses all its hit points. It cannot be turned or magically dispelled. A projection can push against or move small things, so it may push its finger through sand or ashes to write a message, or turn a page of an open book, but it cannot carry things. The baelnorn can have only one projection in operation at a time.
	
    Spells
    
    An Baelnorn can cast any spells it could cast while alive.
    
    Special Qualities
    
    An Baelnorn retains all the base creature’s special qualities and gains those described below.
    
    Turn Resistance (Ex)
    
    An Baelnorn has +4 turn resistance.
    
    Damage Reduction (Su)
    
    An Baelnorn’s undead body is tough, giving the creature damage reduction 15/bludgeoning and magic. Its natural weapons are treated as magic weapons for the purpose of overcoming damage reduction.
    
    Immunities (Ex)
    
    Baelnorns have immunity to cold, electricity, polymorph (though they can use polymorph effects on themselves), and mind-affecting attacks. Many baelnorns cannot be turnes or destroyed by good or neutral clerics. When evil clerics attemp to rebuke or command them, they are turned or destroyed instead.
    
    Abilities
    
    Increase from the base creature as follows: Int +2, Wis +2, Cha +2. Being undead, an Baelnorn has no Constitution score.
    
    Skills
    
    Baelnorns have a +8 racial bonus on Hide, Listen, Move Silently, Search, Sense Motive, and Spot checks. Otherwise same as the base creature. 

    
    Alignment: Any nonevil.
    
   
    Level Adjustment: Same as the base creature +4.

*/

//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    string sString = "Baelnorn template: ";
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);

    int nAlignment = GetAlignmentGoodEvil(oPC);
    if(nAlignment == ALIGNMENT_EVIL)
	
    {
        SendMessageToPC(oPC, sString+"Can't be evil");
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
        SendMessageToPC(oPC, sString+"Baelnorn requires the Craft Wonderous Items feat.");
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }

    // Elf only
    int nRace = MyPRCGetRacialType(oPC);
    
    if (nRace != RACIAL_TYPE_ELF)
    {
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
}