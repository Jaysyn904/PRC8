//;:
//:: sp_lw_invpick
//::
#include "inc_dynconv"
#include "inc_cache_setup"
#include "inv_inc_invfunc"
#include "inv_invoc_const"
 
const int STAGE_LIST          = 0;
const int WARLOCK_INV_MAX_ROW = 110;
 
int IsBlastOrEssence(int nRealSpellID)
{
    // Baneful blast essences — contiguous range
    if (nRealSpellID >= INVOKE_BANEFUL_BLAST_ABERRATION && nRealSpellID <= INVOKE_BANEFUL_BLAST_VERMIN)
        return TRUE;
 
    switch (nRealSpellID)
    {
        // Blast shapes
        case INVOKE_ELDRITCH_GLAIVE:
        case INVOKE_ELDRITCH_SPEAR:
        case INVOKE_HIDEOUS_BLOW:
        case INVOKE_ELDRITCH_CHAIN:
        case INVOKE_ELDRITCH_CONE:
        case INVOKE_ELDRITCH_LINE:
        case INVOKE_ELDRITCH_DOOM:
        // Blast essences
        case INVOKE_FRIGHTFUL_BLAST:
        case INVOKE_HAMMER_BLAST:
        case INVOKE_SICKENING_BLAST:
        case INVOKE_BESHADOWED_BLAST:
        case INVOKE_BRIMSTONE_BLAST:
        case INVOKE_HELLRIME_BLAST:
        case INVOKE_BEWITCHING_BLAST:
        case INVOKE_HINDERING_BLAST:
        case INVOKE_NOXIOUS_BLAST:
        case INVOKE_PENETRATING_BLAST:
        case INVOKE_VITRIOLIC_BLAST:
        case INVOKE_UTTERDARK_BLAST:
            return TRUE;
    }
    return FALSE;
}
 
void BuildInvocationList(object oPC)
{
    int nMaxGrade = GetLocalInt(oPC, "LW_InvMaxGrade");
    int nRow;
 
    SetHeader("Choose a warlock invocation:", oPC);
 
    for (nRow = 0; nRow <= WARLOCK_INV_MAX_ROW; nRow++)
    {
        string sLevel = Get2DACache("cls_inv_warlok", "Level", nRow);
        if (sLevel == "" || sLevel == "****") continue;
 
        int nGrade = StringToInt(sLevel);
        if (nGrade > nMaxGrade) continue;
 
        int nRealSpellID = StringToInt(Get2DACache("cls_inv_warlok", "RealSpellID", nRow));
        if (IsBlastOrEssence(nRealSpellID)) continue;
 
        string sGradeName = (nGrade == 1) ? "Least"   :
                            (nGrade == 2) ? "Lesser"  :
                            (nGrade == 3) ? "Greater" :
                            (nGrade == 4) ? "Dark"    : "Unknown";
 
        // Check if this is a radial master — if so add sub-spells instead
        string sSub1 = Get2DACache("spells", "SubRadSpell1", nRealSpellID);
        if (sSub1 != "" && sSub1 != "****")
        {
            int i;
            for (i = 1; i <= 8; i++)
            {
                string sSub = Get2DACache("spells", "SubRadSpell" + IntToString(i), nRealSpellID);
                if (sSub == "" || sSub == "****") break;
 
                int nSubID = StringToInt(sSub);
                int nStrRef = StringToInt(Get2DACache("spells", "Name", nSubID));
                string sDisplay = (nStrRef > 0)
                    ? GetStringByStrRef(nStrRef) + " (" + sGradeName + ")"
                    : Get2DACache("spells", "Label", nSubID) + " (" + sGradeName + ")";
 
                AddChoice(sDisplay, nSubID, oPC);
            }
        }
        else
        {
            int nStrRef = StringToInt(Get2DACache("spells", "Name", nRealSpellID));
            string sDisplay = (nStrRef > 0)
                ? GetStringByStrRef(nStrRef) + " (" + sGradeName + ")"
                : Get2DACache("spells", "Label", nRealSpellID) + " (" + sGradeName + ")";
 
            AddChoice(sDisplay, nRealSpellID, oPC);
        }
    }
}

void main()
{
    object oPC    = GetPCSpeaker();
    int    nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    int    nStage = GetStage(oPC);
 
    if (nValue == 0) return;
 
    if (nValue == DYNCONV_SETUP_STAGE)
    {
        if (!GetIsStageSetUp(nStage, oPC))
        {
            if (nStage == STAGE_LIST)
            {
                BuildInvocationList(oPC);
                MarkStageSetUp(nStage, oPC);
                SetDefaultTokens();
            }
        }
        SetupTokens(oPC);
        return;
    }
 
    if (nValue == DYNCONV_EXITED || nValue == DYNCONV_ABORTED) return;
 
    // Invocation chosen — nChoice is already the RealSpellID, no +1/-1 adjustment
    int nChoice = GetChoice(oPC);
    SetLocalInt(oPC, "LW_ChosenSpell",  nChoice);
    SetLocalInt(oPC, "LW_IsInvocation", 1);
    SetLocalObject(GetModule(), "LW_CastingPC", oPC);
    ExecuteScript("sp_lw_castchosen", GetModule());
    AllowExit(DYNCONV_EXIT_FORCE_EXIT, FALSE, oPC);
}