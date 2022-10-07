#include "prc_inc_spells"

void RemoveOldSongs(object oTarget)
{
   if (GetHasSpellEffect(SPELL_DSL_SONG_STRENGTH,oTarget)) PRCRemoveEffectsFromSpell(oTarget, SPELL_DSL_SONG_STRENGTH);
   if (GetHasSpellEffect(SPELL_DSL_SONG_COMPULSION,oTarget)) PRCRemoveEffectsFromSpell(oTarget, SPELL_DSL_SONG_COMPULSION);
   if (GetHasSpellEffect(SPELL_DSL_SONG_SPEED,oTarget)) PRCRemoveEffectsFromSpell(oTarget, SPELL_DSL_SONG_SPEED);
   if (GetHasSpellEffect(SPELL_DSL_SONG_FEAR,oTarget)) PRCRemoveEffectsFromSpell(oTarget, SPELL_DSL_SONG_FEAR);
   if (GetHasSpellEffect(SPELL_DSL_SONG_HEALING,oTarget)) PRCRemoveEffectsFromSpell(oTarget, SPELL_DSL_SONG_HEALING);

}


void main()
{

   int iConc = GetLocalInt(GetAreaOfEffectCreator(), "SpellConc");
   if (!iConc)
   {
        RemoveOldSongs(GetAreaOfEffectCreator());
        DestroyObject(OBJECT_SELF);    
  
   }
   
}