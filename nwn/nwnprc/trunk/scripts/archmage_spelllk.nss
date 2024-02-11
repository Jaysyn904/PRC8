#include "prc_alterations"
#include "x2_inc_spellhook"

/*
 * This is the spellhook code, called when the Spell-Like feat is activated
 */
void main()
{
    object focus = GetItemPossessedBy(OBJECT_SELF, "ArchmagesFocusofPower");
    int nMetaMagic = PRCGetMetaMagicFeat();
    string nSpellLevel = Get2DACache("spells", "Wiz_Sorc", PRCGetSpellId());
    string nEpicSpell = Get2DACache("spells", "Innate", PRCGetSpellId());

    /* Whatever happens next we must restore the hook */
    PRCSetUserSpecificSpellScript(GetLocalString(OBJECT_SELF, "spelllike_save_overridespellscript"));

    /* Tell to not execute the original spell */
    PRCSetUserSpecificSpellScriptFinished();

    /* Paranoia -- should never happen */
    if (!GetHasFeat(FEAT_SPELL_LIKE, OBJECT_SELF)) return;

    /* Only wizard/sorc spells */
    if ((nSpellLevel == "") && (nEpicSpell != "10" ))
    {
        FloatingTextStringOnCreature("Spell-Like can only use arcane spells.", OBJECT_SELF, FALSE);
        return;
    }

    /* No item casting */
    if (GetIsObjectValid(GetSpellCastItem()))
    {
        FloatingTextStringOnCreature("Spell-Like may not be used with scrolls.", OBJECT_SELF, FALSE);
        return;
    }

    /* Setup is done */
    SetLocalInt(focus, "spell_like_setup", 0);

    /* Store all the info needed */
    SetLocalInt(focus, "spell_like_spell", PRCGetSpellId());
    SetLocalInt(focus, "spell_like_meta", nMetaMagic);
    SetLocalInt(focus, "spell_like_present", TRUE);

    FloatingTextStringOnCreature("Spell-Like ability ready.", OBJECT_SELF, FALSE);
}
