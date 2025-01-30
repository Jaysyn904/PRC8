/**
 * A script that reads some 2da values through the caching read function.
 *
 * Currently caches:
 *  - feat & spells values specified in the precacherows.2da, which is
 *    generated via the prc.jar prec2dagen tool.
 *  - Flaming_Sword's crafting system data. craft_*.2da and prc_craft_gen_it.2da
 *
 * NOTE: Intended to be run via the make process using the Precacher.mod module,
 *       not by users. Takes some 30+ minutes to run to completion.
 */
#include "inc_utility"

void auxLoop(int i);
void precacheSpell(int row);
void precacheNewSpell(int row);
void precachePower(int row);
void precachePowerFeat(int row);
void precachePowerSpell(int row);
void handleCraft();
void handleCraftProperties2da(string s2da, int row = 0);
void handleCraftItems2da(int row = 0);
void handleMaterialComponents(int row = 0);

void main()
{
    int i = 0;

    auxLoop(i);
}

void auxLoop(int i)
{
    int j;
    string sType;
    for(j = i + 10; i < j; i++)
    {
        // Do not want to cache this stuff, so we use Get2DAString() instead of Get2DACache()
        sType = Get2DAString("precacherows", "Type", i);
        DoDebug("Handling precache row " + IntToString(i));

        // The precacher program outputs one last, blank row. Every other row has non-empty Type column
        if(sType != "")
        {
            if     (sType == "N" )
                precacheSpell(StringToInt(Get2DAString("precacherows", "RowNum", i)));
            else if(sType == "NS")
                precacheNewSpell(StringToInt(Get2DAString("precacherows", "RowNum", i)));
            else if(sType == "P" )
                precachePower(StringToInt(Get2DAString("precacherows", "RowNum", i)));
            else if(sType == "PF" )
                precachePowerFeat(StringToInt(Get2DAString("precacherows", "RowNum", i)));
            else if(sType == "PS" )
                precachePowerSpell(StringToInt(Get2DAString("precacherows", "RowNum", i)));

            else
                DoDebug("Unknown precache type: " + sType);
        }
        else
        {
            DoDebug("Finished handling precacherows.2da");
            DelayCommand(0.0f, handleCraft());
            return;
        }
    }

    DelayCommand(0.0f, auxLoop(i));
}

void precacheSpell(int row)
{
    Get2DACache("spells", "Name",     row);
    Get2DACache("spells", "School",   row);
    Get2DACache("spells", "VS",       row);
    Get2DACache("spells", "Bard",     row);
    Get2DACache("spells", "Cleric",   row);
    Get2DACache("spells", "Druid",    row);
    Get2DACache("spells", "Paladin",  row);
    Get2DACache("spells", "Ranger",   row);
    Get2DACache("spells", "Wiz_Sorc", row);
    if(Get2DACache("spells", "Innate", row) == "")
        Get2DACache("spells", "Master",     row);
//    Get2DACache("spells", "ItemImmunity",   row);
//    Get2DACache("spells", "ConjTime",       row);
//    Get2DACache("spells", "CastTime",       row);
    Get2DACache("spells", "Category",       row);
    Get2DACache("spells", "HostileSetting", row);
    Get2DACache("spells", "ImpactScript",   row);
    Get2DACache("spells", "Range",          row);
    Get2DACache("spells", "TargetType",     row);
    Get2DACache("spells", "UserType",       row);
    Get2DACache("prc_spells", "Subschool",  row);
    Get2DACache("prc_spells", "Descriptor", row);
    Get2DACache("prc_spells", "XP",         row);
    Get2DACache("prc_spells", "GP",         row);
    Get2DACache("prc_spells", "Component1", row);
    Get2DACache("prc_spells", "CompName1",  row);
    Get2DACache("prc_spells", "Component2", row);
    Get2DACache("prc_spells", "CompName2",  row);
    Get2DACache("prc_spells", "Component3", row);
    Get2DACache("prc_spells", "CompName3",  row);
    Get2DACache("prc_spells", "Component4", row);
    Get2DACache("prc_spells", "CompName4",  row);
}

void precacheNewSpell(int row)
{
    Get2DACache("spells", "Name",         row);
    Get2DACache("spells", "VS",           row);
    Get2DACache("spells", "Innate",       row);
    Get2DACache("spells", "Master",       row);
}

void precachePower(int row)
{
    Get2DACache("spells", "Innate",    row);
    Get2DACache("spells", "Range",     row); // Needed by the PRCGetSpellTargetObject() in UsePower()
//    Get2DACache("spells", "ConjTime",  row);
//    Get2DACache("spells", "CastTime",  row);
}

void precachePowerFeat(int row)
{
    Get2DACache("feat", "Constant",    row);
    Get2DACache("feat", "DESCRIPTION", row);
    if(Get2DACache("feat", "PREREQFEAT1", row) != "")
        Get2DACache("feat", "PREREQFEAT2", row);
    if(Get2DACache("feat", "OrReqFeat0", row) != "" &&
       Get2DACache("feat", "OrReqFeat1", row) != "" &&
       Get2DACache("feat", "OrReqFeat2", row) != "" &&
       Get2DACache("feat", "OrReqFeat3", row) != "")
        Get2DACache("feat", "OrReqFeat4", row);
}

void precachePowerSpell(int row)
{
//    Get2DACache("spells", "Name",     row);
    Get2DACache("spells", "School",   row);
    if(Get2DACache("spells", "Innate", row) == "")
        Get2DACache("spells", "Master",     row);
    Get2DACache("spells", "ItemImmunity",   row);
    Get2DACache("spells", "ConjTime",       row);
    Get2DACache("spells", "CastTime",       row);
//    Get2DACache("spells", "HostileSetting", row);
    Get2DACache("spells", "ImpactScript",   row);
    Get2DACache("spells", "Range",          row);
//    Get2DACache("spells", "TargetType",     row);
//    Get2DACache("spells", "UserType",       row);
}

void handleCraft()
{
    DoDebug("Precaching crafting 2das");
    DelayCommand(0.0f, handleCraftProperties2da("craft_armour"));
    DelayCommand(0.0f, handleCraftProperties2da("craft_ring"));
    DelayCommand(0.0f, handleCraftProperties2da("craft_weapon"));
    DelayCommand(0.0f, handleCraftProperties2da("craft_wondrous"));
    DelayCommand(0.0f, handleCraftItems2da());
}

void handleCraftProperties2da(string s2da, int row = 0)
{
    int max, i;
    for(max = row + 10; row < max; row++)
    {
        if(Get2DAString(s2da, "Label", row) != "")
        {
            DoDebug("Handling " + s2da + " row " + IntToString(row));

            Get2DACache(s2da, "Name",           row);
            //Get2DACache(s2da, "Description",    row);
            Get2DACache(s2da, "PropertyType",   row);
            Get2DACache(s2da, "Level",          row);
            Get2DACache(s2da, "Race",           row);
            Get2DACache(s2da, "Feat",           row);
            Get2DACache(s2da, "Skill",          row);
            Get2DACache(s2da, "SkillRanks",     row);
            Get2DACache(s2da, "SpellPattern",   row);
            Get2DACache(s2da, "Spell1",         row);
            Get2DACache(s2da, "Spell2",         row);
            Get2DACache(s2da, "Spell3",         row);
            Get2DACache(s2da, "SpellOR1",       row);
            Get2DACache(s2da, "SpellOR2",       row);
            Get2DACache(s2da, "AlignGE",        row);
            Get2DACache(s2da, "AlignLC",        row);
            Get2DACache(s2da, "Enhancement",    row);
            Get2DACache(s2da, "AdditionalCost", row);
            if(s2da == "craft_armour" || s2da == "craft_weapon")
                Get2DACache(s2da, "ReplaceLast", row);
            else
                Get2DACache(s2da, "BaseItem",    row);
            /*for(i = 1; i <= 6; i++)
            {
                Get2DACache(s2da, "Type"           + IntToString(i), row);
                Get2DACache(s2da, "SubType"        + IntToString(i), row);
                Get2DACache(s2da, "CostTableValue" + IntToString(i), row);
                Get2DACache(s2da, "Param1Value"    + IntToString(i), row);
            }*/
            Get2DACache(s2da, "Epic",    row);
            Get2DACache(s2da, "Special", row);
        }
        else
        {
            DoDebug("Finished handling " + s2da + ".2da");
            return;
        }
    }

    DelayCommand(0.0f, handleCraftProperties2da(s2da, row));
}

void handleCraftItems2da(int row = 0)
{
    int max;
    for(max = PRCMin(row + 25, PRCGetFileEnd("prc_craft_gen_it")); row < max; row++)
    {
        DoDebug("Handling prc_craft_gen_it row " + IntToString(row));

        Get2DACache("prc_craft_gen_it", "Name",      row);
        Get2DACache("prc_craft_gen_it", "Blueprint", row);
        Get2DACache("prc_craft_gen_it", "Type",      row);
    }

    if(row < PRCGetFileEnd("prc_craft_gen_it"))
        DelayCommand(0.0f, handleCraftItems2da(row));
    else
        DoDebug("Finished handling prc_craft_gen_it.2da");
}