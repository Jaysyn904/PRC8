#include "prc_alterations"
#include "prc_craft_inc"

itemproperty ReadIPFrom2DA(string sFile, int nLine, int nIndex)
{
    itemproperty ip;
    int nTemp;
    string sTemp = Get2DACache(sFile, "Type" + IntToString(nIndex), nLine);
    if(sTemp == "") return ip;
    int nType = StringToInt(sTemp);
    int nSubType = StringToInt(Get2DACache(sFile, "SubType" + IntToString(nIndex), nLine));
    int nCostTableValue = StringToInt(Get2DACache(sFile, "CostTableValue" + IntToString(nIndex), nLine));
    int nParam1Value = StringToInt(Get2DACache(sFile, "Param1Value" + IntToString(nIndex), nLine));

    return ConstructIP(nType, nSubType, nCostTableValue, nParam1Value);
}

void DumpCrafting2DAHB(string sFile, int nEnd, int i = 0)
{
    string sDesc, sTemp1, sTemp2, sType;
    string sName = GetName(GetTempCraftChest());
    string sDoubleQuote = GetStringLeft(sName, 1);
    itemproperty ip;
    int j, nTemp1;
    // ";\n
    //  <entry id="51521" lang="en" sex="m">
    sDesc;
    sDesc += "  <entry id=" + sDoubleQuote;
    sDesc += IntToString(StringToInt(Get2DACache(sFile, "Description", i)) - 16777216);
    sDesc += sDoubleQuote + " lang=" + sDoubleQuote + "en" + sDoubleQuote + " sex=";
    sDesc += sDoubleQuote + "m" + sDoubleQuote + ">";
    if(sFile == "craft_wondrous")
    {
        sDesc += "Base Item: " + GetStringByStrRef(StringToInt(Get2DACache("baseitems", "Name", StringToInt(Get2DACache(sFile, "BaseItem", i))))) + "\n\n";
    }
    sDesc += "Description: \n\n";
    for(j = 1; j <= 6; j++)
    {
        ip = ReadIPFrom2DA(sFile, i, j);
        if(Get2DACache(sFile, "Type" + IntToString(j), i) != "")
            sDesc += GetItemPropertyString(ip);
    }
    sDesc += "\nPrerequisites: \n\n";
    sType = Get2DACache(sFile, "PropertyType", i);
    if(sType == "M")
        sDesc += "Caster ";
    else if(sType == "P")
        sDesc += "Manifester ";
    sDesc += "Level: " + Get2DACache(sFile, "Level", i) + "\n";
    sTemp1 = Get2DACache(sFile, "Race", i);
    if(sTemp1 != "")
        sDesc += "Race: " + GetStringByStrRef(StringToInt(Get2DACache("racialtypes", "Name", StringToInt(sTemp1)))) + "\n";
    sTemp1 = Get2DACache(sFile, "Feat", i);
    if(sTemp1 != "")
        sDesc += "Feat: " + GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", StringToInt(sTemp1)))) + "\n";
    sTemp1 = Get2DACache(sFile, "Skill", i);
    if(sTemp1 != "")
        sDesc += "Skill: " + GetStringByStrRef(StringToInt(Get2DACache("skills", "Name", StringToInt(sTemp1)))) + " " + Get2DACache(sFile, "SkillRanks", i) + " ranks\n";
    sTemp1 = Get2DACache(sFile, "AlignGE", i);
    sTemp2 = Get2DACache(sFile, "AlignLC", i);
    if(sTemp1 != "" || sTemp2 != "")
    {
        sDesc += "Alignment: ";
        if(sTemp1 == "N" && sTemp2 == "N")
            sDesc += "True Neutral";
        else
        {
            if(sTemp2 != "")
            {
                if(sTemp2 == "L") sDesc += "Lawful ";
                else if(sTemp2 == "C") sDesc += "Chaotic ";
                else if(sTemp2 == "N") sDesc += "Neutral ";
            }
            if(sTemp1 != "")
            {
                if(sTemp1 == "G") sDesc += "Good";
                else if(sTemp1 == "E") sDesc += "Evil";
                else if(sTemp1 == "N") sDesc += "Neutral";
            }
        }
        sDesc += "\n";
    }
    sTemp1 = Get2DACache(sFile, "SpellPattern", i);
    if(sTemp1 != "")
    {
        nTemp1 = StringToInt(sTemp1);
        if(sType == "M")
            sDesc += "Spell(s): ";
        else if(sType == "P")
            sDesc += "Power(s): ";
        if(nTemp1 & 1)
            sDesc += GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", StringToInt(Get2DACache(sFile, "Spell1", i)))));
        if(nTemp1 & 2)
            sDesc += ", " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", StringToInt(Get2DACache(sFile, "Spell2", i)))));
        if(nTemp1 & 4)
            sDesc += ", " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", StringToInt(Get2DACache(sFile, "Spell3", i)))));
        if(nTemp1 & 8)
            sDesc += ", " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", StringToInt(Get2DACache(sFile, "SpellOR1", i)))));
        if(nTemp1 & 16)
            sDesc += " or " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", StringToInt(Get2DACache(sFile, "SpellOR2", i)))));
        sDesc += "\n";
    }
    if(StringToInt(Get2DACache(sFile, "Epic", i)))
        sDesc += "Epic\n";
    sDesc += "\nCost: \n\n";
    sTemp1 = Get2DACache(sFile, "Enhancement", i);
    if(sTemp1 != "")
        sDesc += "+" + sTemp1 + " Enhancement\n";
    sTemp1 = Get2DACache(sFile, "AdditionalCost", i);
    if(sTemp1 != "")
        sDesc += "+" + sTemp1 + "gp\n";
    sDesc += "</entry>\n";
    PrintString(sDesc);
    if(i < nEnd)
        DelayCommand(0.01, DumpCrafting2DAHB(sFile, nEnd, i + 1));
    else
        if(DEBUG) DoDebug("DumpCrafting2DAHB: Finished " + sFile);
}

void main()
{
    //DumpCrafting2DAHB("craft_armour", PRCGetFileEnd("craft_armour"), 20);
    //DelayCommand(6.0, DumpCrafting2DAHB("craft_weapon", PRCGetFileEnd("craft_weapon"), 20));
    DumpCrafting2DAHB("craft_wondrous", 113);
}