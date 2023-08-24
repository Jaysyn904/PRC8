//::///////////////////////////////////////////////
//:: Name           Dark template script
//:: FileName       tmp_m_dark
//:: 
//:://////////////////////////////////////////////
/* �Dark� is an acquired or inherited template that can be added to any creature (referred to hereafter as the base creature). 

Dark creatures tend to be much duller in color, with more gray and black skin tones and hair highlights, than their Material Plane versions. 
In general, they also weigh less, as if part of their very substance was mere shadow stuff. 

A dark creature has all the base creature�s statistics and special abilities except as noted here. 

Size and Type: Type and size are unchanged. 

Speed: +10 feet to all modes of movement. 

Special Qualities: A dark creature retains all the special qualities of the base creature and also gains the following. 
� Darkvision 60 ft. 
� Hide in Plain Sight (Ex)
� Resistance to cold 10
� Low-light vision. 

Skills: Hide +8 and Move Silently +6. 

Level Adjustment: +1.
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 27.02.19
//:://////////////////////////////////////////////

#include "prc_inc_template"
#include "inc_nwnx_funcs"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    itemproperty ipIP;

    // Feats
    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_LOWLIGHT_VISION);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_DARKVISION);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_HIDE_IN_PLAIN_SIGHT);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_BarbEndurance);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);    

    // Cold resistance    
    ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_10);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);    

    //marker feat
    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_DARK_TEMPLATE_MARKER);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
   
    // Skill bonuses
    SetCompositeBonus(oSkin, "DarkTempHide", 8, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
    SetCompositeBonus(oSkin, "DarkTempMS", 6, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
}