//:://////////////////////////////////////////////
//:: FileName: "activate_epspell"
/*   Purpose: This is the script that gets called by the OnItemActivated event
        when the item is one of the Epic Spell books. It essentially displays
        all relevant information on the epic spell, so that a player may make
        an informed decision on whether to research the spell or not.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_epicspells"
void main()
{
    if(DEBUG) DoDebug("activate_epspell executing");

    object oBook = GetItemActivated();
    string sBook = GetTag(oBook);
    string sName, sDesc;
    int nEpicSpell = GetSpellFromAbrev(sBook);
    int nDC = GetDCForSpell(nEpicSpell);
    int nIP = GetResearchIPForSpell(nEpicSpell);
    int nFE = GetResearchFeatForSpell(nEpicSpell);
    int nR1 = GetR1ForSpell(nEpicSpell);
    int nR2 = GetR2ForSpell(nEpicSpell);
    int nR3 = GetR3ForSpell(nEpicSpell);
    int nR4 = GetR4ForSpell(nEpicSpell);
    int nS1 = GetS1ForSpell(nEpicSpell);
    int nS2 = GetS2ForSpell(nEpicSpell);
    int nS3 = GetS3ForSpell(nEpicSpell);
    int nS4 = GetS4ForSpell(nEpicSpell);
    int nS5 = GetS5ForSpell(nEpicSpell);
    int nXC = GetCastXPForSpell(nEpicSpell);
    string sSc = GetSchoolForSpell(nEpicSpell);
    // If applicable, adjust the spell's DC.
    if(GetPRCSwitch(PRC_EPIC_FOCI_ADJUST_DC))
        nDC -= GetDCSchoolFocusAdjustment(OBJECT_SELF, sSc);

    int nGP = nDC * GetPRCSwitch(PRC_EPIC_GOLD_MULTIPLIER);
    int nXP = nGP / GetPRCSwitch(PRC_EPIC_XP_FRACTION);
    sName = GetStringByStrRef(StringToInt(Get2DACache("feat", "feat", nFE)));
    sDesc = GetStringByStrRef(StringToInt(Get2DACache("feat", "description", nFE)));

    // Information message sent to player about the Epic Spell.
    SendMessageToPC(OBJECT_SELF, "-------------------------------------------");
    SendMessageToPC(OBJECT_SELF, "Requirements for the research of the " + sName + ":");
    SendMessageToPC(OBJECT_SELF, " - You must be an epic level spellcaster.");
    SendMessageToPC(OBJECT_SELF, " - The DC for you to research/cast is " + IntToString(nDC) + ".");
    SendMessageToPC(OBJECT_SELF, " - The XP cost for you to research is " + IntToString(nXP) + ".");
    SendMessageToPC(OBJECT_SELF, " - The gold cost for you to research is " + IntToString(nGP) + ".");
    if (nS1 != -1)
        SendMessageToPC(OBJECT_SELF, " - " + GetStringByStrRef(StringToInt
        (Get2DACache("feat", "feat", StringToInt(Get2DACache("epicspellseeds", "FeatID", nS1))))));
    if (nS2 != -1)
        SendMessageToPC(OBJECT_SELF, " - " + GetStringByStrRef(StringToInt
        (Get2DACache("feat", "feat", StringToInt(Get2DACache("epicspellseeds", "FeatID", nS2))))));
    if (nS3 != -1)
        SendMessageToPC(OBJECT_SELF, " - " + GetStringByStrRef(StringToInt
        (Get2DACache("feat", "feat", StringToInt(Get2DACache("epicspellseeds", "FeatID", nS3))))));
    if (nS4 != -1)
        SendMessageToPC(OBJECT_SELF, " - " + GetStringByStrRef(StringToInt
        (Get2DACache("feat", "feat", StringToInt(Get2DACache("epicspellseeds", "FeatID", nS4))))));
    if (nS5 != -1)
        SendMessageToPC(OBJECT_SELF, " - " + GetStringByStrRef(StringToInt
        (Get2DACache("feat", "feat", StringToInt(Get2DACache("epicspellseeds", "FeatID", nS5))))));
    if (nR1 != 0)
        SendMessageToPC(OBJECT_SELF, " - " + GetStringByStrRef(StringToInt
        (Get2DACache("feat", "feat", nR1))));
    if (nR2 != 0)
        SendMessageToPC(OBJECT_SELF, " - " + GetStringByStrRef(StringToInt
        (Get2DACache("feat", "feat", nR2))));
    if (nR3 != 0)
        SendMessageToPC(OBJECT_SELF, " - " + GetStringByStrRef(StringToInt
        (Get2DACache("feat", "feat", nR3))));
    if (nR4 != 0)
        SendMessageToPC(OBJECT_SELF, " - " + GetStringByStrRef(StringToInt
        (Get2DACache("feat", "feat", nR4))));
    if (nXC != 0 && GetPRCSwitch(PRC_EPIC_XP_COSTS) == TRUE)
        SendMessageToPC(OBJECT_SELF, " - Additionally, " + IntToString(nXC) +
            " experience points are spent per casting.");
    SendMessageToPC(OBJECT_SELF, " ");
    SendMessageToPC(OBJECT_SELF, "Spell Description:");
    SendMessageToPC(OBJECT_SELF, sDesc);
    SendMessageToPC(OBJECT_SELF, "-------------------------------------------");

}
