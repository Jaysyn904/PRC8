//::///////////////////////////////////////////////
//:: Name      Devil's Ego
//:: FileName  sp_dels_ego.nss
//:://////////////////////////////////////////////
/**@file Devil's Ego 
Transmutation [Evil] 
Level: Diabolic 3 
Components: V, S 
Casting Time: 1 action 
Range: Personal 
Target: Caster
Duration: 1 minute/level

The caster gains an enhancement bonus to Charisma
of +4 points. Furthermore, the caster is treated 
as an outsider with regard to what spells and 
magical effects can affect her (rendering a humanoid
caster immune to charm person and hold person, for
example).

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    //Spellhook
    if(!X2PreSpellCastCode()) return;
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
    
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDur = 60.0f * nCasterLvl;
    int nBonus = 4;
    
    //eval metamagic
    if (nMetaMagic & METAMAGIC_EXTEND)
    {
        fDur = (fDur * 2);
    }
    
    if (nMetaMagic & METAMAGIC_EMPOWER)
    {
        nBonus = (nBonus + (nBonus/2));
    }
    
    itemproperty ipRace = PRCItemPropertyBonusFeat(FEAT_OUTSIDER);
    itemproperty ipCha = ItemPropertyAbilityBonus(ABILITY_CHARISMA, nBonus);
        
    AddItemProperty(DURATION_TYPE_TEMPORARY, ipRace, oSkin, fDur);
    IPSafeAddItemProperty(oSkin, ipCha, fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, TRUE);
    
    //SPEvilShift(oPC);
    PRCSetSchool();
}
    
    