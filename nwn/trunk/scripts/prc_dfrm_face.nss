////////////////////////////////////////////////////////////////
/*
Deformity (Face) [Vile, Deformity]
Because of intentional self-mutilation, you have a hideous
face.
Prerequisite: Willing Deformity.
Benefit: You gain a +2 circumstance bonus on Intimidate
checks and a +2 deformity bonus on Diplomacy checks dealing
with evil creatures of a different type.
*/
// x - moved to prc_feats_eff.nss
void main()
{
//        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectLinkEffects(EffectSkillIncrease(SKILL_INTIMIDATE, 2), VersusAlignmentEffect(EffectSkillIncrease(SKILL_PERSUADE, 2), ALIGNMENT_ALL, ALIGNMENT_EVIL)), OBJECT_SELF);
}