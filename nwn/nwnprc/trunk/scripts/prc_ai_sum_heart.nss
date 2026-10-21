//:: prc_ai_heart.nss

#include "inc_prc_npc"  
#include "inc_eventhook"  
  
void main()  
{  
    // Unsummon specific masterless summons  
    // Narrowed from the old blanket check that broke Create Undead Uncontrolled  
    if (!GetIsObjectValid(GetMaster(OBJECT_SELF)))  
    {  
        string sResRef = GetResRef(OBJECT_SELF);  
        location lSelf = GetLocation(OBJECT_SELF); // cache before destroy  
  
        if (sResRef == "prc_sum_unicrn01" ||  
            sResRef == "prc_sum_andro01"  ||  
            sResRef == "prc_sum_lamasu01")  
        {  
            // Healer companions get the celestial unsummon VFX  
            ApplyEffectAtLocation(DURATION_TYPE_PERMANENT,  
                EffectVisualEffect(VFX_IMP_UNSUMMON), lSelf);  
            DestroyObject(OBJECT_SELF, 0.3f);  
            return;  
        }  
        else if (sResRef == "soul_wight_test")  
        {  
            // Soul Eater wight: burst of negative energy, then gore chunk  
            ApplyEffectAtLocation(DURATION_TYPE_PERMANENT,  
                EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), lSelf);  
            DelayCommand(0.3f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT,  
                EffectVisualEffect(VFX_COM_CHUNK_RED_SMALL), lSelf));  
            DestroyObject(OBJECT_SELF, 0.4f);  
            return;  
        }  
    }  
  
    //Any ideas why this is here? It messes up the Create Undead Uncontrolled switch  
    //if (GetMaster()== OBJECT_INVALID) DestroyObject(OBJECT_SELF);  
    ExecuteScript("nw_ch_ac1", OBJECT_SELF);  
    ExecuteScript("prc_npc_hb", OBJECT_SELF);  
    //NPC substiture for OnEquip  
    DoEquipTest();  
  
    // Execute scripts hooked to this event for the NPC triggering it  
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_NPC_ONHEARTBEAT);  
}