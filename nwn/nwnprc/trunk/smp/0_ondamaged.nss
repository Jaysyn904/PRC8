// 0_ondamaged

// On Damage report. report feedback information via. Speak String.


void main()
{
    object oDamager = GetLastDamager(); // returns the object that last dealt damage to OBJECT_SELF, causing this event to fire.
    int nTotalDamage = GetTotalDamageDealt();// returns the amount of damage dealt to a creature (returns 0 when used in a Door's or Placeable Object's OnDamaged event).
    //int n = GetDamageDealtByType(int nDamageType);// returns the amount of damage dealt by particular attacks.
    int nCurHP = GetCurrentHitPoints(OBJECT_SELF);// can be used to return the current hit points of the caller.
    int nMaxHP = GetMaxHitPoints(OBJECT_SELF);// can be used to return the maximum hit points (and used with GetCurrentHitPoints(object oObject = OBJECT_SELF) for determining how threatened the creature is with death).

    // Report
    SpeakString("[DAMAGED] [" + GetName(OBJECT_SELF) + "] By: " + GetName(oDamager) + ". Total: " + IntToString(nTotalDamage) +
                ". Current HP: " + IntToString(nCurHP) + ". MaxHP: " + IntToString(nMaxHP));
}
