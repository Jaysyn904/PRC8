//::///////////////////////////////////////////////
//:: Time Stop
//:: NW_S0_TimeStop.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All persons in the Area are frozen in time
    except the caster.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_inc_spells" 



#include "inc_timestop"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    location lTarget = PRCGetSpellTargetLocation();
    effect eVis = EffectVisualEffect(VFX_FNF_TIME_STOP);
    effect eTime = EffectTimeStop();
    object oCaster = OBJECT_SELF;
    int nRoll = 1 + d4();
    float fDuration = RoundsToSeconds(nRoll);
    if(GetPRCSwitch(PRC_TIMESTOP_BIOWARE_DURATION))
         fDuration = 9.0;
    if(GetPRCSwitch(PRC_TIMESTOP_LOCAL))
    {
        eTime = EffectAreaOfEffect(VFX_PER_NEW_TIMESTOP);
        eTime = EffectLinkEffects(eTime, EffectEthereal());
        if(GetPRCSwitch(PRC_TIMESTOP_NO_HOSTILE))
        {
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCaster),fDuration);
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster),fDuration);
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_BULLETS, oCaster),fDuration);
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_ARROWS, oCaster),fDuration);
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_BOLTS, oCaster),fDuration);
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oCaster),fDuration);
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCaster),fDuration);
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oCaster),fDuration);            
            DelayCommand(fDuration, RemoveTimestopEquip());
            /*
            string sSpellscript = PRCGetUserSpecificSpellScript();
            DelayCommand(fDuration, PRCSetUserSpecificSpellScript(sSpellscript));
            PRCSetUserSpecificSpellScript("tsspellscript");
            */
            //integrated into main spellhook
        }
    }

    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_TIME_STOP, FALSE));
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    //Apply the VFX impact and effects
    DelayCommand(0.75, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTime, OBJECT_SELF, fDuration,TRUE,-1,CasterLvl));
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}

