/*:://////////////////////////////////////////////
//:: Spell Name Whirlwind: Move
//:: Spell FileName PHS_S_Whirlwindd
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    A new spell.

    On the caster item it is, and will allow the caster to select another location
    to move the whirlwind too.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

void main()
{
    // Get director and target
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();

    // Get current whirlwind
    object oWhirlwind = GetLocalObject(oCaster, "PHS_SPELL_WHIRLWIND_CURRENT");

    // Check if valid
    if(GetIsObjectValid(oWhirlwind))
    {
        // Need to check if it is still in control
        if(GetLocalInt(oWhirlwind, "PHS_SPELL_WHIRLWIND_OUTOFCONTROL") == TRUE)
        {
            // Message mistake
            FloatingTextStringOnCreature("*The whirlwind went out of range and is uncontrollable*", oCaster, FALSE);
        }
        else
        {
            // Message sucess
            FloatingTextStringOnCreature("*You direct the whirlwind to a new location*", oCaster, FALSE);

            // Set new location
            SetLocalLocation(oWhirlwind, "PHS_SPELL_WHIRLWIND_LOCATION", lTarget);
        }
    }
    else
    {
        // Message mistake
        FloatingTextStringOnCreature("*You have no whirlwind to control*", oCaster, FALSE);
    }
}
