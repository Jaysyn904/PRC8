//::///////////////////////////////////////////////
//:: Name           Template main script
//:: FileName       prc_templates
//:://////////////////////////////////////////////
/*
    This deals with maintaining the bonus' that the
    various templates grant.
    
    This also applies the bonuses that Weapons of
    Legacy grant to the PC
*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor, Strat
//:: Created On: 18/04/06
//:://////////////////////////////////////////////

#include "prc_inc_template"

void RunTemplateStuff(int nTemplate, object oPC = OBJECT_SELF)
{
    //run the maintenance script
    string sScript = Get2DACache("templates", "MaintainScript", nTemplate);
    if(DEBUG) DoDebug("Running template maintenance script "+sScript);
    DelayCommand(0.0f, ExecuteScript(sScript, oPC));
}

void ApplyLegacy(int nWoL, object oPC = OBJECT_SELF)
{
    object oSkin = GetPCSkin(oPC);
    int nLegacy = GetPersistantLocalInt(oPC, "LegacyRitual");
    if (nLegacy == 1)
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_LEAST_LEGACY), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    else if (nLegacy == 2)
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_LESSER_LEGACY), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    else if (nLegacy == 3)
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_GREATER_LEGACY), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        
	// Clean up prior effects before applying new ones
	effect eEffect = GetFirstEffect(oPC);
    while(GetIsEffectValid(eEffect))
    {
    	// Is it a WOL effect?
        if(GetEffectTag(eEffect) == "WOLEffect")
			RemoveEffect(oPC, eEffect);

        eEffect = GetNextEffect(oPC);	
	}
	
    string sScript = Get2DACache("wol_items", "MaintainScript", nWoL);
    if(DEBUG) DoDebug("Running legacy application script "+sScript);
    DelayCommand(0.0f, ExecuteScript(sScript, oPC));
    if (sScript == "wol_m_devious") DelayCommand(0.0f, ExecuteScript("wol_m_vicious", oPC));
}

void main()
{
    if(DEBUG) DoDebug("Running prc_templates");
    object oPC = OBJECT_SELF;

    //loop over all templates and see if the player has them
    if(!persistant_array_exists(oPC, "templates"))
    {
        persistant_array_create(oPC, "templates");
    }
    int i;
    int bHasTemplate = FALSE;
    for(i=0; i<persistant_array_get_size(oPC, "templates"); i++)
    {
        int nTemplate = persistant_array_get_int(oPC, "templates", i);
        if(GetHasTemplate(nTemplate, oPC))
        {
            bHasTemplate = TRUE;
            RunTemplateStuff(nTemplate, oPC);
        }
    }
    
    // This stores the row number, if any, for the weapon of legacy
    int nWoL = GetPersistantLocalInt(oPC, "LegacyOwner");
    if (nWoL)
        ApplyLegacy(nWoL, oPC);

    if(bHasTemplate || nWoL)
    {
        if(DEBUG) DoDebug("Re-running prc_feat");

        //run the main PRC feat system so we trigger any feats we've borrowed
        DelayCommand(0.5, ExecuteScript("prc_feats", oPC));
    }
}