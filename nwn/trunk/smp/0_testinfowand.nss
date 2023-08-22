void main()
{
    // Display info about the target
    object oUser = GetItemActivator();
    object oTarget = GetItemActivatedTarget();
    string sInfo = "[INFO] [Of: " + GetName(oTarget);

    // Get effects
    if(GetIsObjectValid(oTarget))
    {
        sInfo += "] [Tag: " + GetTag(oTarget);
        sInfo += "] [CurHP: " + IntToString(GetCurrentHitPoints(oTarget));
        sInfo += "] [MaxHP: " + IntToString(GetMaxHitPoints(oTarget));
        sInfo += "] [Reputation: " + IntToString(GetReputation(oTarget, oUser));
        sInfo += "] [Effects: ";

        // Effects
        int nAmount = 0;
        effect eCheck = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eCheck))
        {
            nAmount++;
            // Name creator, spell name and id, duration type, subtype and effect type.
            sInfo += "[" + IntToString(nAmount) + ". [Type:" + IntToString(GetEffectType(eCheck)) +
                   "] [Id:" + IntToString(GetEffectSpellId(eCheck)) +
                   "] [Name:" + GetStringByStrRef(StringToInt(Get2DAString("Spells", "Name", GetEffectSpellId(eCheck)))) +
                   "] [Subtype:" + IntToString(GetEffectSubType(eCheck)) +
                   "] [Duration:" + IntToString(GetEffectDurationType(eCheck)) + "]";
            eCheck = GetNextEffect(oTarget);
        }

        sInfo += "]";
    }

    // Say it
    AssignCommand(oUser, SpeakString(sInfo));

}
