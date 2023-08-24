//::///////////////////////////////////////////////
//:: Evil Blight
//:: x2_s0_EvilBlight
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Any enemies within the area of effect will
    suffer a curse effect
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Jan 2/03
//:://////////////////////////////////////////////
//:: Updated by: Andrew Nobbs
//:: Updated on: March 28, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller

//:: modified by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"





#include "prc_add_spell_dc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);
    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook

    //Declare major variables
    object oTarget;
    effect eImpact = EffectVisualEffect(VFX_IMP_DOOM);
    effect eVis = EffectVisualEffect(VFX_IMP_EVIL_HELP);
    effect eCurse = SupernaturalEffect(EffectCurse(3,3,3,3,3,3));

    //Apply Spell Effects
    location lLoc = GetLocation(OBJECT_SELF);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lLoc);

   
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    CasterLvl +=SPGetPenetr();
    


    //Get first target in the area of effect
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE);
    float fDelay;

    while(GetIsObjectValid(oTarget))
    {
        //Check faction of oTarget
        if (GetIsEnemy(oTarget))
        {
            //Signal spell cast at event
            SignalEvent(oTarget, EventSpellCastAt(oTarget,  PRCGetSpellId()));
            //Make SR Check
            if (!PRCDoResistSpell(OBJECT_SELF, oTarget,CasterLvl))
            {
               int nDC = PRCGetSaveDC(oTarget,OBJECT_SELF);
                    //Make Will Save
                if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (nDC)))
                {
                    // wont stack
                    if (!GetHasSpellEffect(PRCGetSpellId(), oTarget))
                        {
                             SPApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
                             SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eCurse, oTarget);
                        }
                }
            }
        }
        //Get next spell target
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}
