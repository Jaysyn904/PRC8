// NO LONGER USED. HERE INCASE I NEED IT. 2 SCRIPTS.

void main(){return;}

/*:://////////////////////////////////////////////
//:: Spell Name Cloudkill - Create second ETC ones.
//:: Spell FileName phs_cloudkilly
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Creates the first AOE when the creature created is created. This then will
    jump to new locations 3.3 M away from the starting location (increments
    thereof) and then destroy itself after the duration.

    This is the "Heartbeat round file" of the creature.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:://///////////////////////////////////////////

#include "PHS_INC_SPELLS"

// Does exactly what is says on the tin
void DestroySelf();

void main()
{
    // Create first instance by Executing a Script on the caster, if valid
    object oCaster = GetLocalObject(OBJECT_SELF, PHS_CLOUDKILL_CASTER);
    // Get original location
    location lOriginal = GetLocalLocation(OBJECT_SELF, PHS_CLOUDKILL_LOCATION);

    if(GetIsObjectValid(oCaster))
    {
        // Get new location for X rounds done
        int iLastRounds = GetLocalInt(OBJECT_SELF, PHS_CLOUDKILL_ROUNDS_DONE);

        // Check if the duration is up to the rounds limit
        if(iLastRounds <= GetLocalInt(OBJECT_SELF, PHS_CLOUDKILL_DURATION))
        {
            // Increment
            iLastRounds++;
            // Get location based on this
            float fFromOriginal = iLastRounds * 3.33;

            // New location
            location lMove = PHS_GetLocationBehindLocation(lOriginal, GetLocation(oCaster), fFromOriginal);

            // Move me
            ClearAllActions();
            JumpToLocation(lMove);

            // New effect for 6 seconds
            // - apply at lOriginal
            effect eFog = EffectAreaOfEffect(AOE_PER_FOGKILL, "phs_s_cloudkilla", "****", "****");
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eFog, GetLocation(OBJECT_SELF), 6.0);

            // 6 second "Pesudo-heartbeat" heartbeat
            DelayCommand(6.0, ExecuteScript("phs_cloudkilly", OBJECT_SELF));
        }
        else
        {
            // Stop the script
            return;
        }
    }
    else
    {
        DestroySelf();
    }
}

void DestroySelf()
{
    SetPlotFlag(OBJECT_SELF, FALSE);
    DestroyObject(OBJECT_SELF);
}

:://////////////////////////////////////////////
//:: Spell Name Cloudkill - Create First AOE
//:: Spell FileName phs_cloudkillx
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Creates the first AOE when the creature created is created. This then will
    jump to new locations 3.3 M away from the starting location (increments
    thereof) and then destroy itself after the duration.

    This is the "Spawn file" of the creature.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:://///////////////////////////////////////////

#include "PHS_INC_SPELLS"

// Does exactly what is says on the tin
void DestroySelf();

void main()
{
    // Apply Ghost as starting one
    // Ghost
    effect eGhost = EffectCutsceneGhost();
    // No dispel
    eGhost = SupernaturalEffect(eGhost);
    // Apply effects
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, OBJECT_SELF);

    // Create first instance by Executing a Script on the caster, if valid
    object oCaster = GetLocalObject(OBJECT_SELF, PHS_CLOUDKILL_CASTER);
    // Get original location
    location lOriginal = GetLocalLocation(OBJECT_SELF, PHS_CLOUDKILL_LOCATION);

    if(GetIsObjectValid(oCaster))
    {
        // Move me
        ClearAllActions();
        JumpToLocation(lOriginal);

        // New effect for 6 seconds
        // - apply at lOriginal
        effect eFog = EffectAreaOfEffect(AOE_PER_FOGKILL, "phs_s_cloudkilla", "****", "****");
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eFog, GetLocation(OBJECT_SELF), 6.0);

        // 6 second "Pesudo-heartbeat" heartbeat
        DelayCommand(6.0, ExecuteScript("phs_cloudkilly", OBJECT_SELF));
    }
    else
    {
        DestroySelf();
    }
}

void DestroySelf()
{
    SetPlotFlag(OBJECT_SELF, FALSE);
    DestroyObject(OBJECT_SELF);
}
*/
