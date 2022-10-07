// 0_onattacked

// On Attacked report. report feedback information via. Speak String.



void main()
{
    object oAttacker = GetLastAttacker();// returns the object that last attacked OBJECT_SELF.
    object oDamager = GetLastDamager();// returns the object that actually dealt damage last (not neccessarily the last attacker).
    object oWeapon = GetLastWeaponUsed(oAttacker);// will return the last weapon used to attack the creature, if any.
    int nMode = GetLastAttackMode(oAttacker);// will return the last combat mode the attacking creature used, if any.
    int nType = GetLastAttackType(oAttacker);// will return the last special attack the attacking creature used, if any.

    SpeakString("[ATTACKED] By: " + GetName(oAttacker) + ". With: " + GetName(oWeapon) +
                ". Last Damager: " + GetName(oDamager) + ". nMode: " + IntToString(nMode) +
                ". nType: " + IntToString(nType));
}
