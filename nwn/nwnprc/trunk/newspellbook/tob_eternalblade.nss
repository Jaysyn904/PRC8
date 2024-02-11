/*
   ----------------
   Eternal Blade class script

   tob_eternalblade.nss
   ----------------

    10 MAR 09 by GC
*/ /** @file

    This file handles the following:

    - Addition of maneuvers upon levelup
    - Blade guide death/revive
    - Application of Eternal Knowledge
    - Appliation of Uncanny Dodge
*/

#include "tob_inc_tobfunc"
#include "tob_inc_recovery"
////#include "prc_alterations"
//#include "tob_inc_etbl"

void ApplyLore(object oInitiator)
{
    object oSkin = GetPCSkin(oInitiator);
    int nSkill = GetSkillRank(SKILL_LORE, oInitiator, TRUE);
    int nBonus = GetLevelByClass(CLASS_TYPE_ETERNAL_BLADE, oInitiator);// + GetAbilityModifier(ABILITY_INTELLIGENCE, oInitiator)); caster gets this bonus normaly
        nBonus = (nBonus - nSkill >= 1) ? (nBonus - nSkill) : 0; // if blade guide won't help lore score, return

    if(GetLocalInt(oSkin, "EternalKnowledge") != nBonus && nBonus >= 1)
    SetCompositeBonus(oSkin, "EternalKnowledge", nBonus, ITEM_PROPERTY_SKILL_BONUS,SKILL_LORE);
    //if(DEBUG) DoDebug("nBonus lore: " + IntToString(nBonus));
}

void RemoveLore(object oInitiator)
{
    object oSkin = GetPCSkin(oInitiator);
    SetCompositeBonus(oSkin, "EternalKnowledge", 0, ITEM_PROPERTY_SKILL_BONUS,SKILL_LORE);
}

void ApplyUncannyDodge(object oInitiator)
{
    if(!GetLocalInt(oInitiator, "ETBL_AUD_Applied"))
    {
        object oSkin = GetPCSkin(oInitiator);
        itemproperty ipUD;
        if(GetHasFeat(FEAT_UNCANNY_DODGE_1, oInitiator))
        {
            // if they have uncanny dodge already, give them version 2
            ipUD = PRCItemPropertyBonusFeat(IP_CONST_FEAT_UNCANNY_DODGE2);
            //if(DEBUG) DoDebug("Adding Uncanny Doddge 2");
        }
        else
        {
            //if(DEBUG) DoDebug("Adding Uncanny Doddge 1");
            ipUD = PRCItemPropertyBonusFeat(IP_CONST_FEAT_UNCANNY_DODGE1);
        }
        IPSafeAddItemProperty(oSkin, ipUD, 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        SetLocalInt(oInitiator, "ETBL_AUD_Applied", TRUE);
    }
}

void RemoveUncannyDodge(object oInitiator)
{
    if(GetLocalInt(oInitiator, "ETBL_AUD_Applied") == TRUE)
    {
        object oSkin = GetPCSkin(oInitiator);
        if(GetHasFeat(FEAT_UNCANNY_DODGE_1, oInitiator))
        {
            //if(DEBUG) DoDebug("Removing Uncanny Doddge 2");
            RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT, IP_CONST_FEAT_UNCANNY_DODGE2, -1, -1, "", -1, DURATION_TYPE_TEMPORARY);
        }
        else
        {
            //if(DEBUG) DoDebug("Removing Uncanny Doddge 1");
            RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT, IP_CONST_FEAT_UNCANNY_DODGE1, -1, -1, "", -1, DURATION_TYPE_TEMPORARY);
        }
        DeleteLocalInt(oInitiator, "ETBL_AUD_Applied");
    }
}
void BladeGuide(object oInitiator, object oItem)
{
    if (GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
    {

        //://////////////////////////////////////
        //: Blade Guide death/resurrection
        /*
            Adds/removed passive boni from the
            Eternal Blade's blade guide presence

            The way granting abilities is handled,
            this can be run through EVENT_DAMAGED alone
        */
        //://////////////////////////////////////
        if(DEBUG) DoDebug("etbl EVENT_DAMAGED: running");
        object oAttacker = GetLastDamager();
        int nDamageTaken = GetTotalDamageDealt();
        int nHitPoints   = GetMaxHitPoints(oInitiator);
        if(DEBUG) DoDebug("EVENT_DAMAGED: damage dealt: " + IntToString(nDamageTaken));
        if(DEBUG) DoDebug("EVENT_DAMAGED: PC MAX hitpoints: " + IntToString(nHitPoints));

        // since player can have armor, dr, various immunities, etc., apply reasonable damage multiplyer for blage guide
         nDamageTaken *= 2;

        // Blade guide alive, but no HP int.
        // This would be the first hit after he respawns or the player rests or after load
        if(!GetLocalInt(oInitiator, "ETBL_BladeGuideDead") && !GetLocalInt(oInitiator, "ETBL_BladeGuideHP"))
        {
            SetLocalInt(oInitiator, "ETBL_BladeGuideHP", nHitPoints);
            if(DEBUG) DoDebug("EVENT_DAMAGED: New blade guide HP set to: " + IntToString(nHitPoints));
        }

        // Damage taken and blade guide alive
        if(nDamageTaken > 0 && !GetLocalInt(oInitiator, "ETBL_BladeGuideDead"))
        {
            int nCurrent = GetLocalInt(oInitiator, "ETBL_BladeGuideHP");
            if(DEBUG) DoDebug("EVENT_DAMAGED: current blade guide HP: " + IntToString(nCurrent));

            // blade guide is killed
            if(nCurrent - nDamageTaken <= 0)
            {
                //effect eGuide  = EffectVisualEffect(VFX_DUR_IOUNSTONE_BLUE);
                if(DEBUG) DoDebug("EVENT_DAMAGED: blade guide killed");

                // mark blade guide dead and remove stored HP
                // checked for class abilities
                SetLocalInt(oInitiator, "ETBL_BladeGuideDead", TRUE);
                DeleteLocalInt(oInitiator, "ETBL_BladeGuideHP");
                DeleteLocalInt(oInitiator, "ETBL_BladeGuideVis");

                // let the player know he died :(
                FloatingTextStringOnCreature("*Blade Guide destroyed*", oInitiator, FALSE);

                // remove blade guide vfx
                PRCRemoveEffectsFromSpell(oInitiator, ETBL_BLADE_GUIDE);

                DeleteLocalInt(oInitiator, "ETBL_BladeGuideVis");
                // remove bonuses blade guide provides
                RemoveLore(oInitiator);
                RemoveUncannyDodge(oInitiator);

                // blade guide comes back in 1d6 rounds, yay!
                // remove dead marker, let player know he's back, reapply visual
                float fDur = RoundsToSeconds(d6(1));

                DelayCommand(fDur, DeleteLocalInt(oInitiator, "ETBL_BladeGuideDead"));
                DelayCommand(fDur, FloatingTextStringOnCreature("*Blade Guide returned*", oInitiator, FALSE));
                DelayCommand(fDur, ActionCastSpellOnSelf(ETBL_BLADE_GUIDE));
            }
            else
                SetLocalInt(oInitiator, "ETBL_BladeGuideHP", (nCurrent - nDamageTaken));
            if(DEBUG) DoDebug("blade guide hp: "+ IntToString((nCurrent - nDamageTaken)));
        }
        // if blade guide is dead at the moment, do nothing
    }
}


void main()
{

    object oInitiator, oItem;
    int nEvent        = GetRunningEvent();

    switch(nEvent)
    {
        case EVENT_ITEM_ONHIT:          oInitiator = OBJECT_SELF;                                                break;
        case EVENT_ONPLAYEREQUIPITEM:   oInitiator = GetItemLastEquippedBy();   oItem = GetItemLastEquipped();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oInitiator = GetItemLastUnequippedBy(); oItem = GetItemLastUnequipped(); break;
        case EVENT_ONHEARTBEAT:         oInitiator = OBJECT_SELF;                                                break;

        default:
            oInitiator = OBJECT_SELF;
            oItem      = GetItemInSlot(INVENTORY_SLOT_CHEST, oInitiator);
    }

    int nClass        = CLASS_TYPE_ETERNAL_BLADE;
    int nLevel        = GetLevelByClass(CLASS_TYPE_ETERNAL_BLADE, oInitiator);
    int nMoveTotal    = GetKnownManeuversModifier(oInitiator, nClass, MANEUVER_TYPE_MANEUVER);
    int nStncTotal    = GetKnownManeuversModifier(oInitiator, nClass, MANEUVER_TYPE_STANCE);
    int nRdyTotal     = GetReadiedManeuversModifier(oInitiator, nClass);

    if(DEBUG) DoDebug("tob_eternalblade running, event: " + IntToString(nEvent));

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // let them know our friend, Blade Guide is with them
        if(!GetHasSpellEffect(ETBL_BLADE_GUIDE, oInitiator) && !GetLocalInt(oInitiator, "ETBL_BladeGuideDead"))
            ActionCastSpellOnSelf(ETBL_BLADE_GUIDE);

        // Hook in the events, needed for various abilities
        if(DEBUG) DoDebug("tob_eternalblade: Adding eventhooks");
        AddEventScript(oInitiator, EVENT_ONHEARTBEAT,         "tob_eternalblade", TRUE, FALSE);
        AddEventScript(oInitiator, EVENT_ONPLAYEREQUIPITEM,         "tob_eternalblade", TRUE, FALSE);
        AddEventScript(oInitiator, EVENT_ONPLAYERUNEQUIPITEM,         "tob_eternalblade", TRUE, FALSE);

        // Allows gaining of maneuvers by prestige classes
        // It's not pretty, but it works
        if (nLevel >= 1 && !GetPersistantLocalInt(oInitiator, "ToBEternalBlade1"))
        {
            if(DEBUG) DoDebug("tob_eternalblade: Adding Maneuver 1");
            SetKnownManeuversModifier(oInitiator, GetPrimaryBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBEternalBlade1", TRUE);
            SetPersistantLocalInt(oInitiator, "AllowedDisciplines", 270);//DISCIPLINE_DEVOTED_SPIRIT + DISCIPLINE_DIAMOND_MIND + DISCIPLINE_IRON_HEART + DISCIPLINE_WHITE_RAVEN
        }

        if (nLevel >= 3 &&!GetPersistantLocalInt(oInitiator, "ToBEternalBlade3"))
        {
            if(DEBUG) DoDebug("tob_eternalblade: Adding Maneuver 3");
            SetReadiedManeuversModifier(oInitiator, GetPrimaryBladeMagicClass(oInitiator), ++nRdyTotal);
            SetKnownManeuversModifier(oInitiator, GetPrimaryBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBEternalBlade3", TRUE);
            SetPersistantLocalInt(oInitiator, "AllowedDisciplines", 270);//DISCIPLINE_DEVOTED_SPIRIT + DISCIPLINE_DIAMOND_MIND + DISCIPLINE_IRON_HEART + DISCIPLINE_WHITE_RAVEN
        }

        if (nLevel >= 5 && !GetPersistantLocalInt(oInitiator, "ToBEternalBlade5"))
        {
            if(DEBUG) DoDebug("tob_eternalblade: Adding Maneuver 5");
            SetKnownManeuversModifier(oInitiator, GetPrimaryBladeMagicClass(oInitiator), ++nStncTotal, MANEUVER_TYPE_STANCE);
            SetKnownManeuversModifier(oInitiator, GetPrimaryBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBEternalBlade5", TRUE);
            SetPersistantLocalInt(oInitiator, "AllowedDisciplines", 270);//DISCIPLINE_DEVOTED_SPIRIT + DISCIPLINE_DIAMOND_MIND + DISCIPLINE_IRON_HEART + DISCIPLINE_WHITE_RAVEN
        }

        if (nLevel >= 6 && !GetPersistantLocalInt(oInitiator, "ToBEternalBlade6"))
        {
            if(DEBUG) DoDebug("tob_eternalblade: Adding Maneuver 6");
            SetReadiedManeuversModifier(oInitiator, GetPrimaryBladeMagicClass(oInitiator), ++nRdyTotal);
            SetPersistantLocalInt(oInitiator, "ToBEternalBlade6", TRUE);
        }

        if (nLevel >= 7 && !GetPersistantLocalInt(oInitiator, "ToBEternalBlade7"))
        {
            if(DEBUG) DoDebug("tob_eternalblade: Adding Maneuver 7");
            SetKnownManeuversModifier(oInitiator, GetPrimaryBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBEternalBlade7", TRUE);
            SetPersistantLocalInt(oInitiator, "AllowedDisciplines", 270);//DISCIPLINE_DEVOTED_SPIRIT + DISCIPLINE_DIAMOND_MIND + DISCIPLINE_IRON_HEART + DISCIPLINE_WHITE_RAVEN
        }

        if (nLevel >= 9 && !GetPersistantLocalInt(oInitiator, "ToBEternalBlade9"))
        {
            if(DEBUG) DoDebug("tob_eternalblade: Adding Maneuver 9");
            SetReadiedManeuversModifier(oInitiator, GetPrimaryBladeMagicClass(oInitiator), ++nRdyTotal);
            SetKnownManeuversModifier(oInitiator, GetPrimaryBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBEternalBlade9", TRUE);
            SetPersistantLocalInt(oInitiator, "AllowedDisciplines", 270);//DISCIPLINE_DEVOTED_SPIRIT + DISCIPLINE_DIAMOND_MIND + DISCIPLINE_IRON_HEART + DISCIPLINE_WHITE_RAVEN
        }

        // Hook to OnLevelDown to remove the maneuver slots granted here
        AddEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_eternalblade", TRUE, FALSE);
    }
    else if(nEvent == EVENT_ONPLAYERLEVELDOWN)
    {
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBEternalBlade1") && nLevel < 1)
        {
            DeletePersistantLocalInt(oInitiator, "ToBEternalBlade1");
            SetKnownManeuversModifier(oInitiator, GetPrimaryBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
        }
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBEternalBlade3") && nLevel < 3)
        {
            DeletePersistantLocalInt(oInitiator, "ToBEternalBlade3");
            SetReadiedManeuversModifier(oInitiator, GetPrimaryBladeMagicClass(oInitiator), --nRdyTotal);
            SetKnownManeuversModifier(oInitiator, GetPrimaryBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
        }
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBEternalBlade5") && nLevel < 5)
        {
            DeletePersistantLocalInt(oInitiator, "ToBEternalBlade5");
            SetKnownManeuversModifier(oInitiator, GetPrimaryBladeMagicClass(oInitiator), --nStncTotal, MANEUVER_TYPE_STANCE);
            SetKnownManeuversModifier(oInitiator, GetPrimaryBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
        }
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBEternalBlade6") && nLevel < 6)
        {
            DeletePersistantLocalInt(oInitiator, "ToBEternalBlade6");
            SetReadiedManeuversModifier(oInitiator, GetPrimaryBladeMagicClass(oInitiator), --nRdyTotal);
        }
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBEternalBlade7") && nLevel < 7)
        {
            DeletePersistantLocalInt(oInitiator, "ToBEternalBlade7");
            SetKnownManeuversModifier(oInitiator, GetPrimaryBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
        }
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBEternalBlade9") && nLevel < 9)
        {
            DeletePersistantLocalInt(oInitiator, "ToBEternalBlade9");
            SetKnownManeuversModifier(oInitiator, GetPrimaryBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetReadiedManeuversModifier(oInitiator, GetPrimaryBladeMagicClass(oInitiator), --nRdyTotal);
        }

        // Remove eventhook if the character no longer has levels in Eernal Blade
        if(nLevel == 0)
        {
            RemoveEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_eternalblade", TRUE, FALSE);
            RemoveEventScript(oInitiator, EVENT_ONHEARTBEAT, "tob_eternalblade", TRUE, FALSE);
            RemoveEventScript(oInitiator, EVENT_ONPLAYEREQUIPITEM, "tob_eternalblade", TRUE, FALSE);
            RemoveEventScript(oInitiator, EVENT_ONPLAYERUNEQUIPITEM, "tob_eternalblade", TRUE, FALSE);
        }
    }
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem = GetSpellCastItem();
        if(oItem == GetItemInSlot(INVENTORY_SLOT_CHEST, oInitiator))
        {        
            BladeGuide(oInitiator, oItem);
        }    
    }
    else if(nEvent == EVENT_ONHEARTBEAT)
    {
        //if(DEBUG) DoDebug("ETBL OnHeartbeat running");
        // If the blade guide is alive, add passsive abilities
        if(!GetLocalInt(oInitiator, "ETBL_BladeGuideDead"))
        {
            if(nLevel >= 3) ApplyUncannyDodge(oInitiator);
            if(nLevel >= 4) ApplyLore(oInitiator);
        }
        else
        {// Else remove them
            RemoveUncannyDodge(oInitiator);
            RemoveLore(oInitiator);
        }

        //DoBladeGuideHB(oInitiator);
    }
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        if(oItem == GetItemInSlot(INVENTORY_SLOT_CHEST, oInitiator))
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "tob_eternalblade", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oInitiator's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        if(oItem == GetItemInSlot(INVENTORY_SLOT_CHEST, oInitiator))
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_eternalblade", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }
    }
}