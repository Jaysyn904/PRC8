// Companion for the existing appearance-only hybrid. Does not change WW rules.
#include "inc_persist_loca"

const string HP_WWV_SAVED = "HP_WW_VoiceSaved";
const string HP_WWV_ORIGINAL = "HP_WW_VoiceOriginal";

int HPWWVoiceCoveringShape(object oPC)
{
    effect e = GetFirstEffect(oPC);
    while(GetIsEffectValid(e))
    {
        if(GetEffectType(e) == EFFECT_TYPE_POLYMORPH) return TRUE;
        e = GetNextEffect(oPC);
    }
    return GetPersistantLocalInt(oPC, "nPCShifted")
        || GetLocalInt(oPC, "PRC_Shifting_InProcess")
        || GetLocalInt(oPC, "shifting");
}

int HPWWVoiceSync(object oPC)
{
    int bActive = GetPersistantLocalInt(oPC, "PRC_WW_HybActive");
    int bHybridSaved = GetPersistantLocalInt(oPC, "PRC_WW_HybSaved");
    int bSaved = GetPersistantLocalInt(oPC, HP_WWV_SAVED);
    int bCover = HPWWVoiceCoveringShape(oPC);
    if(bActive && bHybridSaved && GetAppearanceType(oPC) == 171 && !bCover)
    {
        if(!bSaved)
        {
            SetPersistantLocalInt(oPC, HP_WWV_ORIGINAL, GetSoundset(oPC));
            SetPersistantLocalInt(oPC, HP_WWV_SAVED, TRUE);
            bSaved = TRUE;
        }
        if(GetSoundset(oPC) != 100) SetSoundset(oPC, 100);
    }
    else if(bSaved && !bActive && !bHybridSaved && !bCover)
    {
        int nOriginal = GetPersistantLocalInt(oPC, HP_WWV_ORIGINAL);
        if(GetSoundset(oPC) != nOriginal) SetSoundset(oPC, nOriginal);
        if(GetSoundset(oPC) == nOriginal)
        {
            // Clear the validity flag first; an interrupted cleanup cannot
            // mistake a missing original value for a valid soundset zero.
            DeletePersistantLocalInt(oPC, HP_WWV_SAVED);
            DeletePersistantLocalInt(oPC, HP_WWV_ORIGINAL);
            bSaved = FALSE;
        }
    }
    return bActive || bHybridSaved || bSaved;
}

void HPWWVoiceTick(object oPC, string sKey, int nGeneration)
{
    object oModule = GetModule();
    if(!GetIsObjectValid(oPC)
        || GetLocalInt(oModule, sKey + "G") != nGeneration) return;
    DeleteLocalInt(oModule, sKey + "Q");
    if(HPWWVoiceSync(oPC))
    {
        SetLocalInt(oModule, sKey + "Q", TRUE);
        DelayCommand(0.3, HPWWVoiceTick(oPC, sKey, nGeneration));
    }
}

void main()
{
    object oPC = OBJECT_SELF;
    if(!GetIsObjectValid(oPC) || GetObjectType(oPC) != OBJECT_TYPE_CREATURE) return;
    object oModule = GetModule();
    // Module locals are runtime-only, so reconnect/reset cannot preserve a
    // stale queued flag. Persistent original voice stays on the character.
    string sKey = "HP_WWV_" + ObjectToString(oPC);
    int nGeneration = GetLocalInt(oModule, sKey + "G");
    if(HPWWVoiceSync(oPC))
    {
        if(!GetLocalInt(oModule, sKey + "Q"))
        {
            nGeneration++;
            SetLocalInt(oModule, sKey + "G", nGeneration);
            SetLocalInt(oModule, sKey + "Q", TRUE);
            DelayCommand(0.3, HPWWVoiceTick(oPC, sKey, nGeneration));
        }
    }
    else if(GetLocalInt(oModule, sKey + "Q"))
    {
        SetLocalInt(oModule, sKey + "G", nGeneration + 1);
        DeleteLocalInt(oModule, sKey + "Q");
    }
}
