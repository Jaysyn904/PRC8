
#include "prc_inc_spells"
#include "prc_alterations"
#include "prc_add_spell_dc"

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);
    // End of Spell Cast Hook

    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS,"sp_blacklighta","","sp_blacklightb");
    location lTarget = PRCGetSpellTargetLocation();
    object oTarget = PRCGetSpellTargetObject();

    int nCastLvl = PRCGetCasterLevel();
    float  nDuration = PRCGetMetaMagicDuration(RoundsToSeconds(nCastLvl));

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DARKNESS));
      //Make SR Check
      if (!PRCDoResistSpell(OBJECT_SELF, oTarget,SPGetPenetrAOE(GetAreaOfEffectCreator())))
      {
      	if (GetIsObjectValid(oTarget))
          //Create an instance of the AOE Object using the Apply Effect function
          SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, nDuration);
        else
          ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, nDuration);

      }
    }
    else
    {
      	if (GetIsObjectValid(oTarget))
          //Create an instance of the AOE Object using the Apply Effect function
          SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, nDuration);
        else
          ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, nDuration);
    }

    object oAoE = GetAreaOfEffectObject(lTarget, "VFX_PER_DARKNESS");
    SetAllAoEInts(SPELL_BLACKLIGHT, oAoE, PRCGetSpellSaveDC(SPELL_BLACKLIGHT, SPELL_SCHOOL_EVOCATION), 0, nCastLvl);

    PRCSetSchool();

}
