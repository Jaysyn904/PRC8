//::///////////////////////////////////////////////
//:: Name      Cloud of the Achaierai  
//:: FileName  sp_cloud_achai  
//:://////////////////////////////////////////////
/**@file Cloud of the Achaierai
Conjuration (Creation) [Evil]
Level: Clr 6, Demonologist 4
Components: V, S, Disease
Casting Time: 1 action
Range: Personal
Area: 10-ft.radius spread
Duration: 10 minutes/level
Saving Throw: Fortitude partial
Spell Resistance: Yes

The caster conjures a choking, toxic cloud of inky 
blackness. Those other than the caster within the 
cloud take 2d6 points of damage. They must also 
succeed at a Fortitude save or be subject to a 
confusion effect for the duration of the spell.

Disease Component: Soul rot. 

Author:    Tenjac
Created:   03/24/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_misc_const"
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_ACHAIERAI);
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    object oItemTarget = oTarget;
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDuration = (nCasterLvl * 600.0f);
    location lLoc = PRCGetSpellTargetLocation();

    //Check for Soul Rot
    if(GetPersistantLocalInt(oPC, "PRC_Has_Soul_Rot"))
    {
        //Check Extend metamagic feat.
        if(nMetaMagic & METAMAGIC_EXTEND)
            fDuration *= 2;    //Duration is +100%

        //Create an instance of the AOE Object using the Apply Effect function
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLoc, fDuration);

        object oAoE = GetAreaOfEffectObject(lLoc, "VFX_PER_ACHAIERAI");
        SetAllAoEInts(SPELL_CLOUD_OF_THE_ACHAIERAI, oAoE, PRCGetSpellSaveDC(SPELL_CLOUD_OF_THE_ACHAIERAI, SPELL_SCHOOL_CONJURATION), 0, nCasterLvl);
    }

    PRCSetSchool();
}