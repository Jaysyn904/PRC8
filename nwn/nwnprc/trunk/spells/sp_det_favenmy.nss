//::///////////////////////////////////////////////
//:: Name      Detect Favored Enemy
//:: FileName  sp_det_favenmy.nss
//:://////////////////////////////////////////////
/**@file Detect Favored Enemies
Divination
Level: Ranger 1
Components: V, S
Casting Time: 1 standard action
Area: 60 ft radius around the caster
Saving Throw: None
Spell Resistance: No

You can sense the types of favored enemies in the 
area and the number of each type.

*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void CheckForPresence(int nType, location lLoc, string sType, string sType2);

#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_DIVINATION);

    object oPC = OBJECT_SELF;
    int nType;
    location lLoc = GetLocation(oPC);
    string sType;
    string sType2;

    if(GetHasFeat(FEAT_FAVORED_ENEMY_ABERRATION ,oPC))
        CheckForPresence(RACIAL_TYPE_ABERRATION, lLoc, "aberration", "aberrations");
    if(GetHasFeat(FEAT_FAVORED_ENEMY_ANIMAL ,oPC))
        CheckForPresence(RACIAL_TYPE_ANIMAL, lLoc, "animal", "animals");
    if(GetHasFeat(FEAT_FAVORED_ENEMY_BEAST ,oPC))
        CheckForPresence(RACIAL_TYPE_BEAST, lLoc, "beast", "beasts");
    if(GetHasFeat(FEAT_FAVORED_ENEMY_CONSTRUCT ,oPC))
        CheckForPresence(RACIAL_TYPE_CONSTRUCT, lLoc, "construct", "constructs");
    if(GetHasFeat(FEAT_FAVORED_ENEMY_DRAGON ,oPC))
        CheckForPresence(RACIAL_TYPE_DRAGON, lLoc, "dragon", "dragons");
    if(GetHasFeat(FEAT_FAVORED_ENEMY_DWARF ,oPC))
        CheckForPresence(RACIAL_TYPE_DWARF, lLoc, "dwarf", "dwarves");
    if(GetHasFeat(FEAT_FAVORED_ENEMY_ELEMENTAL ,oPC))
        CheckForPresence(RACIAL_TYPE_ELEMENTAL, lLoc, "elemental", "elementals");
    if(GetHasFeat(FEAT_FAVORED_ENEMY_ELF ,oPC))
        CheckForPresence(RACIAL_TYPE_ELF, lLoc, "elf", "elves");
    if(GetHasFeat(FEAT_FAVORED_ENEMY_FEY ,oPC))
        CheckForPresence(RACIAL_TYPE_FEY, lLoc, "fey", "fey");
    if(GetHasFeat(FEAT_FAVORED_ENEMY_GIANT ,oPC))
        CheckForPresence(RACIAL_TYPE_GIANT, lLoc, "giant", "giants");
    if(GetHasFeat(FEAT_FAVORED_ENEMY_GNOME ,oPC))
        CheckForPresence(RACIAL_TYPE_GNOME, lLoc, "gnome", "gnomes");
    if(GetHasFeat(FEAT_FAVORED_ENEMY_GOBLINOID ,oPC))
        CheckForPresence(RACIAL_TYPE_HUMANOID_GOBLINOID, lLoc, "goblinoid", "goblinoids");
    if(GetHasFeat(FEAT_FAVORED_ENEMY_HALFELF ,oPC))
        CheckForPresence(RACIAL_TYPE_HALFELF, lLoc, "halfelf", "halfelves");
    if(GetHasFeat(FEAT_FAVORED_ENEMY_HALFLING ,oPC))
        CheckForPresence(RACIAL_TYPE_HALFLING, lLoc, "halfling", "halflings");
    if(GetHasFeat(FEAT_FAVORED_ENEMY_HALFORC ,oPC))
        CheckForPresence(RACIAL_TYPE_HALFORC, lLoc, "halforc", "halforcs");
    if(GetHasFeat(FEAT_FAVORED_ENEMY_HUMAN ,oPC))
        CheckForPresence(RACIAL_TYPE_HUMAN, lLoc, "human", "humans");
    if(GetHasFeat(FEAT_FAVORED_ENEMY_MAGICAL_BEAST ,oPC))
        CheckForPresence(RACIAL_TYPE_MAGICAL_BEAST, lLoc, "magical beast", "magical beasts");
    if(GetHasFeat(FEAT_FAVORED_ENEMY_MONSTROUS ,oPC))
        CheckForPresence(RACIAL_TYPE_HUMANOID_MONSTROUS, lLoc, "monster", "monsters");
    if(GetHasFeat(RACIAL_TYPE_HUMANOID_ORC ,oPC))
        CheckForPresence(RACIAL_TYPE_ORC, lLoc, "orc", "orcs");
    if(GetHasFeat(FEAT_FAVORED_ENEMY_OUTSIDER ,oPC))
        CheckForPresence(RACIAL_TYPE_OUTSIDER, lLoc, "outsider", "outsiders");
    if(GetHasFeat(FEAT_FAVORED_ENEMY_REPTILIAN ,oPC))
        CheckForPresence(RACIAL_TYPE_HUMANOID_REPTILIAN, lLoc, "reptilian", "reptilians");
    if(GetHasFeat(FEAT_FAVORED_ENEMY_SHAPECHANGER ,oPC))
        CheckForPresence(RACIAL_TYPE_SHAPECHANGER, lLoc, "shapechanger", "shapechangers");
    if(GetHasFeat(FEAT_FAVORED_ENEMY_UNDEAD ,oPC))
        CheckForPresence(RACIAL_TYPE_UNDEAD, lLoc, "undead", "undead");
    if(GetHasFeat(FEAT_FAVORED_ENEMY_VERMIN ,oPC))
        CheckForPresence(RACIAL_TYPE_VERMIN, lLoc, "vermin", "vermin");

    PRCSetSchool();
}

void CheckForPresence(int nType, location lLoc, string sType, string sType2)
{
    float fRadius = FeetToMeters(60.0f);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    int nCount = 0;

    while(GetIsObjectValid(oTarget))
    {
        if(MyPRCGetRacialType(oTarget) == nType)
        {
            if(oTarget != OBJECT_SELF) nCount++;
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    }

    if(nCount > 0)
    {
        if(nCount <2)
        {
            SendMessageToPC(OBJECT_SELF, "You detect " + IntToString(nCount) + " " + sType + "nearby.");
        }
        else SendMessageToPC(OBJECT_SELF, "You detect " + IntToString(nCount) + " " + sType2 + " nearby.");
    }
}
