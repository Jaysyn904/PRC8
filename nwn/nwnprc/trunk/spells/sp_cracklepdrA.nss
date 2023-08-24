////////////////////////////////////////////
// Crackle Powder on Enter
// sp_cracklepdrA.nss
////////////////////////////////////////////

// Gives -10 to Move Silently

void main()
{
        object oTarget = GetEnteringObject();
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillDecrease(SKILL_MOVE_SILENTLY, 10), oTarget);
        PlaySound("cb_ht_chitin1");
}