//::///////////////////////////////////////////////
//:: Two-Weapon Rend
//:: prc_tw_rend
//:://////////////////////////////////////////////
/** @file
    TWO-WEAPON REND [EPIC]
    Prerequisites: Dex 15, base attack bonus +9,
    Improved Two-Weapon Fighting, Two-Weapon Fighting.

    Benefit: If the character hits an opponent with a
    weapon in each hand in the same round, he or she
    may automatically rend the opponent. This deals
    additional damage equal to the base damage of the
    smaller weapon (if both weapons are of same size,
    the weapon in main hand is used) plus 1 1/2 times
    the character’s Strength modifier. Base weapon
    damage includes an enhancement bonus on damage,
    if any.
    The character can only rend once per round,
    regardless of how many successful attacks he or
    she makes.

    @author Ornedan
    @date   Created - 2006.07.05
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"

const string REND_FIRST_MAINHAND_HIT_PREFIX = "PRC_TWRend_MainHandHitBy_";
const string REND_FIRST_OFFHAND_HIT_PREFIX  = "PRC_TWRend_OffHandHitBy_";
const string REND_LOCK                      = "PRC_TWRend_Used";

void main()
{
    object oPC, oItem;
    int nEvent = GetRunningEvent();

    if(DEBUG) DoDebug("prc_tw_rend running, event: " + IntToString(nEvent));

    // We're being called from the OnHit eventhook, so deal the damage
    if(nEvent == EVENT_ITEM_ONHIT)
    {
        oPC            = OBJECT_SELF;
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("prc_tw_rend: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        // Only run if called by a melee weapon and rend hasn't already been used for this round
        if(IPGetIsMeleeWeapon(oItem) && !GetLocalInt(oPC, REND_LOCK))
        {
            string sPCOID = ObjectToString(oPC);

            // Determine if the weapon is the mainhand one or the offhand one
            int bIsMainHand = oItem == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

            // Determine if the other hand has hit
            int bBothHandsHit;
            if(bIsMainHand)
                bBothHandsHit = GetLocalInt(oTarget, REND_FIRST_OFFHAND_HIT_PREFIX + sPCOID);
            else
                bBothHandsHit = GetLocalInt(oTarget, REND_FIRST_MAINHAND_HIT_PREFIX + sPCOID);

            if(DEBUG) DoDebug("prc_tw_rend: OnHit: bBothHandsHit = " + DebugBool2String(bBothHandsHit));

            // If both hands did hit, run the rending code
            if(bBothHandsHit)
            {
                // Get the equipped weapons
                object oRightHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
                object oLeftHand  = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,  oPC);

                // Make sure both are valid before continuing. If the PC is changing their loadout mid-battle,
                // they are not going to be able to rend things at the same time.
                if(!GetIsObjectValid(oRightHand) || !GetIsObjectValid(oLeftHand))
                {
                    if(DEBUG) DoDebug("prc_tw_rend: OnHit: One of the weapons was not present:\n"
                                    + "oRightHand = " + DebugObject2Str(oRightHand) + "\n"
                                    + "oLeftHand = "  + DebugObject2Str(oLeftHand)  + "\n"
                                      );
                    return;
                }

                // Determine which is smaller, preferring the right hand in case of equal size
                int nRightSize  = StringToInt(Get2DACache("baseitems", "WeaponSize", GetBaseItemType(oRightHand)));
                int nLeftSize   = StringToInt(Get2DACache("baseitems", "WeaponSize", GetBaseItemType(oLeftHand)));
                object oSmaller = nRightSize >= nLeftSize ? oRightHand : oLeftHand;
                int nSmaller    = GetBaseItemType(oSmaller);

                // Determine dice to roll
                int nDieSize = StringToInt(Get2DACache("baseitems", "DieToRoll", nSmaller));
                int nNumDice = StringToInt(Get2DACache("baseitems", "NumDice",   nSmaller));

                // Determine damage bonus from enhancement
                int nBonus = 0;
                itemproperty ipTest = GetFirstItemProperty(oSmaller);
                while(GetIsItemPropertyValid(ipTest))
                {
                    // Get the highest enhancement bonus property on the item
                    if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
                        nBonus = PRCMax(nBonus, GetItemPropertyCostTableValue(ipTest));

                    ipTest = GetNextItemProperty(oSmaller);
                }

                // Add STR modifier to damage bonus
                nBonus += FloatToInt(1.5f * GetAbilityModifier(ABILITY_STRENGTH, oPC));

                // Start with bonus and add damage rolls
                int nDamage = nBonus;
                for(; nNumDice > 0; nNumDice--)
                    nDamage += Random(nDieSize) + 1;

                // Apply effects. Damage type is slashing, since it seems most appropriate
                effect eLink =                          EffectDamage(nDamage, DAMAGE_TYPE_SLASHING);
                       eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_COM_BLOOD_CRT_RED));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);

                // Do some feedback
                //                            * PCName rends TargetName *
                FloatingTextStringOnCreature("* " + GetName(oPC) + " " + GetStringByStrRef(0x01000000 + 51197) + " " + GetName(oTarget) + " *",
                                             oPC,
                                             TRUE);

                // Set the feat used for this round, queue lock variable deletion
                SetLocalInt(oPC, REND_LOCK, TRUE);
                DelayCommand(6.0f, DeleteLocalInt(oPC, REND_LOCK));
            }
            else
            {
                // Just a single hit in so far, set marker local and queue it's deletion
                string sVar = (bIsMainHand ? REND_FIRST_MAINHAND_HIT_PREFIX : REND_FIRST_OFFHAND_HIT_PREFIX) + sPCOID;
                SetLocalInt(oTarget, sVar, TRUE);
                DelayCommand(6.0f, DeleteLocalInt(oTarget, sVar));
            }
        }// end if - Item is a melee weapon and Two-Weapon Rend hasn't already been used up for the round
    }// end if - Running OnHit event
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oPC's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oPC   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("prc_tw_rend - OnEquip");

        // Only applies to melee weapons
        if(IPGetIsMeleeWeapon(oItem))
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "prc_tw_rend", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("prc_tw_rend - OnUnEquip");

        // Only applies to melee weapons
        if(IPGetIsMeleeWeapon(oItem))
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "prc_tw_rend", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);
        }
    }
}