//::///////////////////////////////////////////////
//:: Lliiras' Aura
//:: mh_S1_LliiraAura.nss
//:://////////////////////////////////////////////
/*
    Cree une zone d'effet conferant un bonus de +4
    au jet de sauvegarde contre la peur pour une duree
    de 5 tours
*/
//:://////////////////////////////////////////////
//:: Created By: Age
//:: Created On: January, 2004
//:://////////////////////////////////////////////

void main()
{
//SpawnScriptDebugger();
    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(37,"mh_s1_lliira_ent","","mh_s1_lliira_sor");
    effect eVis = EffectVisualEffect(VFX_IMP_AURA_HOLY);
    effect eLink = EffectLinkEffects(eAOE,eVis);
    int nDuration = 5;
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, TurnsToSeconds(nDuration));
}
