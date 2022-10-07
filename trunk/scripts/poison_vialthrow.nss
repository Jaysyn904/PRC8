//::///////////////////////////////////////////////
//:: Poison Vial throw impactscript
//:: poison_vialthrow
//::///////////////////////////////////////////////
/*
    This is a script for the grenadelike use of a
    poison item.

    The number of poison used is gotten from
    local integer "pois_idx" on the item being cast from.
    The last 3 letters of the item's tag will be used instead
    if the following module switch is set:

    PRC_USE_TAGBASED_INDEX_FOR_POISON


    If the poison used is an inhaled poison, any
    creatures in a RADIUS_SIZE_MEDIUM will be effected.
    A contact poison will only affect a targeted creature.
    Any other poison type will have no effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 12.12.2004
//:: Updated On: 20.12.2004
//:://////////////////////////////////////////////

#include "prc_inc_sp_tch"
#include "inc_poison"

void main(){
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    object oItem = GetSpellCastItem();
    string sTag = GetTag(oItem);
    location lTarget = GetSpellTargetLocation();
    float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);


    // Get the 2da row to lookup the poison from
    int nPoisonIdx;
    if(GetPRCSwitch(PRC_USE_TAGBASED_INDEX_FOR_POISON))
        nPoisonIdx = StringToInt(GetStringRight(GetTag(oItem), 3));
    else
        nPoisonIdx = GetLocalInt(oItem, "pois_idx");


    /** Do paranoia **/

    if (nPoisonIdx < 0)
    {
        WriteTimestampedLogEntry ("Error: Item with resref " +GetResRef(oItem)+ ", tag " +GetTag(oItem) + " has the Poison Vial spellscript attached but "
                                   + (GetPRCSwitch(PRC_USE_TAGBASED_INDEX_FOR_POISON) ? "it's tag" : "it's local integer variable 'pois_idx'")
                                   + " contains an invalid value!");
        return;
    }

    if(GetPoisonType(nPoisonIdx) != POISON_TYPE_CONTACT &&
       GetPoisonType(nPoisonIdx) != POISON_TYPE_INHALED
       )
    {
        SendMessageToPC(oPC, GetName(oItem) +" " + GetStringByStrRef(STRREF_SHATTER_HARMLESS)); // * Nothing happens *
        WriteTimestampedLogEntry ("Error: Item with resref " +GetResRef(oItem)+ ", tag " +GetTag(oItem) + ", pois_idx " + IntToString(nPoisonIdx) + " has the Poison Vial spellscript attached but the poison is not a valid one for this script!");
        return;
    }


    /** All is OK. Following mostly ripped from PRCDoGrenade in x0_i0_spells **/

    effect ePoison = EffectPoison(nPoisonIdx);

    if(GetPoisonType(nPoisonIdx) == POISON_TYPE_CONTACT)
    {
        // This was a contact poison, so we only affect one target.
        // First, check if it's a valid one.
        if(GetIsObjectValid(oTarget) == TRUE)
        {
            int nTouch = PRCDoRangedTouchAttack(oTarget);;

            if (nTouch > 0)
            {
                SignalEvent(oTarget, EventSpellCastAt(oPC, SPELL_GRENADE_POISONVIAL));
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget, 0.0f, FALSE,
                                      SPELL_GRENADE_POISONVIAL, 1, oPC);
            }
        }
    }// end if - handle vial containing a contact poison
    else{
        // We had an inhalation poison.
        //Apply the explosion at the location captured above.
        effect eExplode = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);

        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        //Cycle through the targets within the spell shape until an invalid object is captured.
        while (GetIsObjectValid(oTarget))
        {
            float fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            // Apply effects to the currently selected target.
            SignalEvent(oTarget, EventSpellCastAt(oPC, SPELL_GRENADE_POISONVIAL));
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget, 0.0f, FALSE, SPELL_GRENADE_POISONVIAL, 1, oPC));
            //Select the next target within the spell shape.
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }
    }// end else - handle vial containing an inhalation poison
}