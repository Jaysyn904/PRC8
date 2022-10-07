//::///////////////////////////////////////////////
//:: Mind over Body
//:: psi_imnd_mindbody
//::///////////////////////////////////////////////
/*
    1 to 3 times per day, an Iron Mind can replace a Fort or Reflex
    saving throw with a will save. In all other respects the spell is the same.
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 14.02.2006
//:://////////////////////////////////////////////

void main()
{
    object oCaster = OBJECT_SELF;
    SetLocalInt(oCaster, "IronMind_MindOverBody", TRUE);
    FloatingTextStringOnCreature("Mind Over Body will activate on your next Reflex or Will save", oCaster, FALSE);
}