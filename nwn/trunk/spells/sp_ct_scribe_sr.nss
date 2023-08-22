void main()
{
    // Get the caster, set the chosen tatoo effect, and cast the scribe
    // tatoo spell, cheating because the scribe spell isn't on anyone's
    // spell list and doing it instantly because we've already done
    // the spell incantation.
    object oPC = GetPCSpeaker();
    SetLocalInt(oPC, "SP_CREATETATOO_EFFECT", 1);
    AssignCommand(oPC,
        ActionCastSpellAtObject(
            GetLocalInt(oPC, "SP_CREATETATOO_SPELLID"),
            GetLocalObject(oPC, "SP_CREATETATOO_TARGET"),
            GetLocalInt(oPC, "SP_CREATETATOO_METAMAGIC"),
            TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
}
