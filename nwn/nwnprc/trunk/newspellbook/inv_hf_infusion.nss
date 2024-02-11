//::///////////////////////////////////////////////
//:: Hellfire Infusion
//:: inv_hf_infusion.nss
//:://////////////////////////////////////////////
//:: Applies Empower, Extend or Maximize
//:: to next spell cast from item.
//:://////////////////////////////////////////////
#include "inv_invoc_const"

void main()
{
    object oPC = OBJECT_SELF;
    int nSpellID = GetSpellId();
    int nMeta;
    string sMeta;

    switch(nSpellID)
    {
        case INVOKE_HF_INFUSION_EMPOWER:  nMeta = METAMAGIC_EMPOWER; sMeta = "Empower"; break;
        case INVOKE_HF_INFUSION_EXTEND:   nMeta = METAMAGIC_EXTEND;  sMeta = "Extend";  break;
        case INVOKE_HF_INFUSION_MAXIMIZE: nMeta = METAMAGIC_MAXIMIZE; sMeta = "Maximize"; break;
        case INVOKE_HF_INFUSION_WIDEN:    nMeta = 0; sMeta = "Widen"; SetLocalFloat(oPC, "PRC_HF_Infusion_Wid", 2.0f); break;
        default: return;
    }

    SetLocalInt(oPC, "PRC_HF_Infusion", nMeta);
    if(nSpellID != INVOKE_HF_INFUSION_WIDEN)
        DeleteLocalFloat(oPC, "PRC_HF_Infusion_Wid");

    FloatingTextStringOnCreature("Hellfire Infusion: "+sMeta+" Activated", oPC, FALSE);
}