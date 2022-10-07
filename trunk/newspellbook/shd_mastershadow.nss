#include "shd_inc_shdfunc"      

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("shd_mastershadow running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oShadow = OBJECT_SELF;

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        int nChild = GetLevelByClass(CLASS_TYPE_MASTER_OF_SHADOW);
        object oSkin = GetPCSkin(oShadow);
        itemproperty ipIP;
        
        if (nChild >= 10)
            ipIP =ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEIMMUNITY_100_PERCENT);
        else if (nChild >= 6)
            ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_20); 
        else if (nChild >= 4)
            ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_10);            
        else if (nChild >= 2)
            ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_5);                        
        
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }
}
