#include "prc_inc_assoc"

void main()
{
    object oPC = OBJECT_SELF;
    object oFam = GetAssociateNPC(ASSOCIATE_TYPE_FAMILIAR, oPC, NPC_PNP_FAMILIAR);
    object oFamToken = GetItemPossessedBy(oPC, "prc_pnp_familiar");

    if(GetIsObjectValid(oFam) && !GetIsDead(oFam))
    {
        if(GetDistanceBetween(oPC, oFam) > 3.33)
        {
            AssignCommand(oFam, ActionForceMoveToObject(oPC, TRUE, 1.0f, 30.0f));
            DelayCommand(3.0, ExecuteScript("prc_pnp_fam_hide", oPC));
        }
        else
        {
            oFamToken = CreateItemOnObject("prc_pnp_familiar", oPC);
            SetName(oFamToken, GetName(oFam));
            MyDestroyObject(oFam);
        }
    }
    else if(GetIsObjectValid(oFamToken))
        ActionCastSpell(318);
    else
        FloatingTextStringOnCreature("You don't have a familiar!", oPC, FALSE);
}