// 0_onspellcast

// On Spell Cast At report. report feedback information via. Speak String.


void main()
{
    int nSpell = GetLastSpell();// returns the SPELL_* that was cast.
    object oCaster = GetLastSpellCaster();// returns the object that cast the spell.
    int bHarmful = GetLastSpellHarmful();// returns TRUE if the spell was marked as hostile, FALSE otherwise.

    SpeakString("[SPELL CAST AT] [" + GetName(OBJECT_SELF) + "] Caster: " + GetName(oCaster) +
                ". nSpell: " + IntToString(nSpell) + ". bHarmful: " + IntToString(bHarmful));
}
