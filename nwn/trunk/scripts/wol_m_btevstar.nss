//::///////////////////////////////////////////////
//:: Name           Bright Evening Star maintain script
//:: FileName       wol_m_btevstar
//:://////////////////////////////////////////////
//:: By ebonfowl for the PRC
//:: Dedicated to Edgar, the real Ebonfowl
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Save Penalty: -1 at 6th
Skill Check Penalty: -1 at 8th
Caster Level Penalty: -1 at 7th, -2 at 13th
Spell Slot Penalty: -1 1st level spell slot at 6th, and lose one slot of the next highest level every two levels thereafter

LEGACY ITEM ABILITIES
Starbright (Su): At 5th level you gain low-light vision while outside at night, if you have low-light vision, the range triples
Fire of the Heart (Sp): At 6th level and higher, at will on command, you can evoke a burst of magical starlight, which works as a faerie fire spell. The light created is blue. Caster level 5th.
Enthralling Lights (Sp): Starting at 7th level, three times per day on command, you can create an area of dancing stars and glowing dust, duplicating the effect of a hypnotic pattern spell. The save DC is 11, or 11 + your Charisma modifier, whichever is higher. Caster level 5th.
Color Spray (Sp): At 8th level and higher, you can command Bright Evening Star to emit a fountain of multicolored light that functions as a color spray spell. The save DC is 11, or 11 + your Charisma modifier, whichever is higher. This ability is usable three times per day. Caster level 5th
Blinding Flash (Sp): Beginning at 10th level, three times per day on command, you can cause Bright Evening Star to flare with a pulse of sudden, bright light that acts as a blindness spell. The save DC is 13, or 12 + your Charisma modifier, whichever is higher. Caster level 5th.
Shooting Stars (Sp): At 11th level and higher, two times per day, you can command Bright Evening Star to fire five darts of force that look like shooting stars. They function as a magic missile spell cast by a 10th-level caster.
Glittering Motes (Sp): Starting at 13th level, once per day on command, you can use glitterdust as the spell. The save DC is 13, or 12 + your Charisma modifier, whichever is higher. Caster level 5th.
Starlight Resistance (Su): At 14th level, Bright Evening Star grants you a +3 resistance bonus on all saving throws. At your option, the effect creates a glimmer of hundreds of tiny stars, which are visible on your body and clothing
Twinkle (Sp): At 16th level and higher, three times per day on command, you can use blink as the spell. Your image seems to fl icker like a twinkling star. Caster level 11th.
Silver Starlight (Sp): Beginning at 17th level, once per day on command, you can summon forth up to four beams of painfully bright, cold light. This ability functions much like sunbeam, but the light is pure, focused starlight and moonlight. The beam deals no extra damage to undead. Instead, lycanthropes take damage from the beam as if they were undead being affected by a normal sunbeam spell. Fungi, mold, oozes, and slimes still take extra damage (as if they were lycanthropes). The save DC is 20, or 17 + your Charisma modifi er, whichever is higher. Caster level 15th.
Starlight Dispelling (Sp): At 18th level and higher, once per day on command, you can use greater dispel magic as the spell. If the dispelling attempt is initiated by night under an unclouded sky, the associated caster level check is made with a +5 bonus. Caster level 15th.
Tales in the Sky (Sp): Many sages know that the future can be read through the stars, but few realize that, by tracing their movements backward, secrets of long ago can be divined. Beginning at 19th level, once per day on command, you can use legend lore as the spell. You must be able to see the stars for this ability to function. Caster level 15th.
Call Down a Star (Sp): At 20th level and higher, once every other day on command, you can summon an elder fi re elemental. Caster level 17th.
*/

#include "prc_inc_template"
#include "prc_inc_combat"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("wol_m_btevstar running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nSlot = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_BrtEvnStar");
    
    // You get nothing if you don't have the item
   if(oWOL != GetItemInSlot(INVENTORY_SLOT_LEFTRING, oPC) && oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC)) 
   {
        SetCompositeBonus(oSkin, "BtEvStar_SavesF", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
        SetCompositeBonus(oSkin, "BtEvStar_SavesW", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
        SetCompositeBonus(oSkin, "BtEvStar_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
        SetLocalInt(oPC, "WoLCasterPenalty", 0);
        WoLSpellSlotPenalty(oPC, 0);
        SetCompositeBonus(oSkin, "BtEvStar_StarResist", 0, ITEM_PROPERTY_SAVING_THROW_BONUS, SAVING_THROW_ALL);
        return;
   }
    
    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {    
	    // 5th to 10th level abilities
	    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
	    {
	        if(nHD >= 5)
	        {
	        	AddEventScript(oPC, EVENT_ONHEARTBEAT, "wol_m_btevstar", TRUE, FALSE);
	        }         
	        if(nHD >= 6)
	        {
	            nSlot = 1;
                SetCompositeBonus(oSkin, "BtEvStar_SavesF", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
                SetCompositeBonus(oSkin, "BtEvStar_SavesW", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
                SetCompositeBonus(oSkin, "BtEvStar_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
	            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BES_FIRE_OF_THE_HEART), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }     
	        if(nHD >= 7)
	        {
	            SetLocalInt(oPC, "WoLCasterPenalty", 1);
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BES_ENTHRALLING_LIGHT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        } 
	        if(nHD >= 8)
	        {
				nSlot = 2;
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BES_COLOR_SPRAY), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        } 
	        if(nHD >= 10)
	        {
	            nSlot = 3;
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BES_BLINDING_FLASH), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        }    
	    }
	    // 11th to 16th level abilities
	    if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
	    {    
	        if(nHD >= 11)
	        {
	            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BES_SHOOTING_STARS), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        }
	        if(nHD >= 12)
	        {
	            nSlot = 4;
	        }    
	        if(nHD >= 13)
	        {
	        	SetLocalInt(oPC, "WoLCasterPenalty", 2);
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BES_GLITTERING_MOTES), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        }
	        if(nHD >= 14)
	        {
	            nSlot = 5;
                SetCompositeBonus(oSkin, "BtEvStar_StarResist", 3, ITEM_PROPERTY_SAVING_THROW_BONUS, SAVING_THROW_ALL);
	        }            
	        if(nHD >= 16)
	        {
	            nSlot = 6;
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BES_TWINKLE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        }     
	    }
	    // 17th+ level abilities
	    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
	    {    
	        if(nHD >= 17)
	        {    
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BES_SILVER_STARLIGHT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        }  
	        if(nHD >= 18)
	        {
	        	nSlot = 7;
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BES_STARLIGHT_DISPELLING), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);      	
	        } 
	        if(nHD >= 19)
	        {
	        	IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BES_TALES_IN_THE_SKY), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        } 
	        if(nHD >= 20)
	        {
	        	nSlot = 8;
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BES_CALL_DOWN_A_STAR), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        } 
	    }
        WoLSpellSlotPenalty(oPC, nSlot);    
    }
    else if(nEvent == EVENT_ONHEARTBEAT)
    {
        object oArea = GetArea(oPC);

        if(nHD >= 5
        && !(oWOL != GetItemInSlot(INVENTORY_SLOT_LEFTRING, oPC))
        && GetIsObjectValid(oArea)
        && !GetIsDay()
        && GetIsAreaAboveGround(oArea) == AREA_ABOVEGROUND
        && !GetIsAreaInterior(oArea))
        {
            itemproperty ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_LOWLIGHT_VISION);
            AddItemProperty(DURATION_TYPE_TEMPORARY, ipIP, oSkin, 5.9);
        }    
        else if(nHD >= 5
        && !(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC)) 
        && GetIsObjectValid(oArea)
        && !GetIsDay()
        && GetIsAreaAboveGround(oArea) == AREA_ABOVEGROUND
        && !GetIsAreaInterior(oArea))
        {
            itemproperty ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_LOWLIGHT_VISION);
            AddItemProperty(DURATION_TYPE_TEMPORARY, ipIP, oSkin, 5.9);
        }    
    

    }// end if - Running HB event     
}