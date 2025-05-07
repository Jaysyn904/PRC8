#include "prc_inc_function"
#include "shd_inc_shdfunc"      

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("shd_childnight running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oShadow = OBJECT_SELF;

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        int nChild = GetLevelByClass(CLASS_TYPE_CHILD_OF_NIGHT);
        object oSkin = GetPCSkin(oShadow);
        itemproperty ipIP;
        
        SetCompositeBonus(oSkin, "ChildNightHide", nChild, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);

		if (nChild >= 37)
            ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_50);
        else if (nChild >= 33)
            ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_45);
        else if (nChild >= 29)
            ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_40);
        else if (nChild >= 25)
            ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_35);
        else if (nChild >= 21)
            ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_30);
        else if (nChild >= 17)
            ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_25);
        else if (nChild >= 13)
            ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_20);
        else if (nChild >= 9)
            ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_15);
        else if (nChild >= 5)
            ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_10);            
        else
            ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_5);

        
/*         if (nChild >= 9)
            ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_15);
        else if (nChild >= 5)
            ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_10);            
        else
            ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_5); */                        
        
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        
        if (nChild >= 8)
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectConcealment(20)), oShadow);        
        
        if (nChild >= 8)
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectImmunity(IMMUNITY_TYPE_SLEEP)), oShadow);
    }
}
