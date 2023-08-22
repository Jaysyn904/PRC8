//////////////////////////////////////////////////////////////
// Green Fog Heartbeat
// sp_green_fogC.nss
/////////////////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        location lLoc = GetLocation(OBJECT_SELF);
        int nType;
        float fDur;
        
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 500.0f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
        
        while(GetIsObjectValid(oTarget))
        {
                if(!GetLocalInt(oTarget, "PRC_GREEN_FOG_POLY"))
                {
                        //Save DC 17
                        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, 17, SAVING_THROW_TYPE_SPELL))
                        {                        
                                //polymorph
                                nType = d3(1);
                                fDur = MinutesToSeconds(d6(10));
                                
                                if(nType == 1) nType = POLYMORPH_TYPE_CHICKEN;
                                else if(nType == 2) nType = POLYMORPH_TYPE_COW;
                                else if(nType == 3) nType = POLYMORPH_TYPE_PENGUIN;
                                
                                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph(nType, TRUE), oTarget, fDur);
                                SetLocalInt(oTarget, "PRC_GREEN_FOG_POLY", 1);
                                DelayCommand(fDur, DeleteLocalInt(oTarget, "PRC_GREEN_FOG_POLY"));
                        }
                        oTarget = MyNextObjectInShape(SHAPE_SPHERE, 500.0f, lLoc, FALSE, OBJECT_TYPE_CREATURE);       
                }
        }
}        