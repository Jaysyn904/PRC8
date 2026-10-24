//::///////////////////////////////////////////////
//:: D&D 3.0 werewolf template maintenance
//:: tmp_m_wwolf
//:://////////////////////////////////////////////

#include "prc_inc_template"
#include "prc_inc_wwolf"

void main()
{
    object oPC = OBJECT_SELF;
    int nEvent = GetRunningEvent();

    if(nEvent == EVENT_ONHEARTBEAT)
    {
        if(!PRCWWHasTemplate(oPC))
        {
            // Cure may precede the asynchronous hybrid cleanup. Resume it
            // after reconnect, then retire this hook when recovery is done.
            if(PRCWWHasHybridData(oPC))
                PRCWWRemoveHybrid(oPC);
            if(!PRCWWHasHybridData(oPC))
                RemoveEventScript(oPC, EVENT_ONHEARTBEAT,
                    "tmp_m_wwolf", TRUE, FALSE);
            return;
        }
        PRCWWHeartbeat(oPC);
        return;
    }
    if(nEvent == EVENT_ONPLAYERDEATH)
    {
        oPC = GetLastPlayerDied();
        if(PRCWWHasTemplate(oPC))
            PRCWWRevertTemplateForm(oPC, FALSE);
        if(PRCWWHasAfflictedTemplate(oPC))
            PRCWWClearInjuryState(oPC, "death-reset");
        return;
    }
    if(nEvent == EVENT_NPC_ONDEATH)
    {
        if(PRCWWHasTemplate(oPC))
            PRCWWRevertTemplateForm(oPC, FALSE);
        if(PRCWWHasAfflictedTemplate(oPC))
            PRCWWClearInjuryState(oPC, "death-reset");
        return;
    }
    if(nEvent != FALSE || !PRCWWHasTemplate(oPC))
        return;

    // Rehydrate episode/form state before properties or radials are rebuilt.
    PRCWWLoadPersistentState(oPC);
    PRCWWSyncSeluniteControl(oPC);
    int nDetectedForm = PRCWWDetectTemplateForm(oPC);
    if(nDetectedForm != PRC_WW_FORM_NONE)
    {
        PRCWWSetActiveForm(oPC, nDetectedForm);
        if(nDetectedForm == PRC_WW_FORM_WOLF)
        {
            SetLocalInt(oPC, "WWWolf", TRUE);
            DeleteLocalInt(oPC, "WWHybrid");
        }
        else
        {
            SetLocalInt(oPC, "WWHybrid", TRUE);
            DeleteLocalInt(oPC, "WWWolf");
        }
        PRCWWCommitVoluntaryAlignment(oPC);
    }

    object oSkin = GetPCSkin(oPC);
    itemproperty ipIP;

    // The equipped hybrid shares this skin with the humanoid form. Maintain
    // one template contribution, including after normal equipment changes.
    PRCWWUpdateTemplateSkin(oPC, PRCWWHasHybrid(oPC));
    if(PRCWWHasHybridData(oPC))
        PRCWWRefreshHybrid(oPC);

    // A deliberately selected afflicted template begins aware; bite victims
    // do not receive form controls until the post-episode awareness check.
    if(!PRCWWHasAfflictedTemplate(oPC)
    || GetPersistantLocalInt(oPC, "PRC_WW_Aware"))
    {
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_WEREWOLF_WOLF_FORM);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0,
            X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_WEREWOLF_HYBRID_FORM);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0,
            X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_WEREWOLF_SHAPECHANGER);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0,
            X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }
    else
    {
        RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
            IP_CONST_FEAT_TEMPLATE_WEREWOLF_WOLF_FORM, -1, -1);
        RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
            IP_CONST_FEAT_TEMPLATE_WEREWOLF_HYBRID_FORM, -1, -1);
        RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
            IP_CONST_FEAT_TEMPLATE_WEREWOLF_SHAPECHANGER, -1, -1);
    }

    if(PRCWWHasNaturalTemplate(oPC)
    && !PRCWWHasSeluniteControl(oPC))
        PRCWWSetAlignment(oPC, 0, 0, "natural-template-maintenance");

    AddEventScript(oPC, EVENT_ONHEARTBEAT, "tmp_m_wwolf", TRUE, FALSE);
    if(GetIsPC(oPC))
        AddEventScript(oPC, EVENT_ONPLAYERDEATH,
            "tmp_m_wwolf", TRUE, FALSE);
    else
        AddEventScript(oPC, EVENT_NPC_ONDEATH,
            "tmp_m_wwolf", TRUE, FALSE);
}
