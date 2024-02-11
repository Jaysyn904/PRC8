//::///////////////////////////////////////////////
//:: Continual Flame
//:: x0_s0_clight.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Permanent Light spell

    XP2
    If cast on an item, item will get permanently
    get the property "light".
    Previously existing permanent light properties
    will be removed!

*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 18, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:
//:: Added XP2 cast on item code: Georg Z, 2003-06-05
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff

#include "prc_inc_spells"
#include "prc_x2_craft"
#include "prc_add_spell_dc"

void main()
{
   //if (GetHasFeat(FEAT_SHADOWWEAVE,OBJECT_SELF)) return;
   
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ILLUSION);


    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run
    // this spell.
    if (!X2PreSpellCastCode())
    {
        return;
    }
    int nDuration;
    int nMetaMagic;

    object oTarget = PRCGetSpellTargetObject();

    // Handle spell cast on item....
    if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM && ! CIGetIsCraftFeatBaseItem(oTarget))
    {
        // Do not allow casting on not equippable items
        if (!IPGetIsItemEquipable(oTarget))
        {
            // Item must be equipable...
            FloatingTextStrRefOnCreature(83326,OBJECT_SELF);
            return;
        }
        itemproperty ip = ItemPropertyLight (IP_CONST_LIGHTBRIGHTNESS_BRIGHT, IP_CONST_LIGHTCOLOR_WHITE);
        IPSafeAddItemProperty(oTarget, ip, 0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,TRUE,TRUE);
    }
    else
    {

        //Declare major variables
        effect eVis = (EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20));
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = SupernaturalEffect(EffectLinkEffects(eVis, eDur));

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 419, FALSE));

        int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

        //Apply the VFX impact and effects
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget,0.0f,TRUE,-1,CasterLvl);
   }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}



