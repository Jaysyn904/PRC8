@echo off

SETLOCAL

IF EXIST errorlog del errorlog

FOR %%i IN (.\2das\cls_feat_*.2da) DO (
    java -jar tools\prc.jar dupentries %%i FeatIndex
    IF EXIST errorlog (
       type errorlog >> temp_error
       del errorlog
    )
)

IF EXIST temp_error move /Y temp_error errorlog

ENDLOCAL
:end