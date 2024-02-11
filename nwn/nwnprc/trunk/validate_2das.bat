@REM tools\ssed -R "$! {s/^/\"/g};s/$/\"/g"
@dir /b /s 2das\*.2da | java -Xmx150m -jar tools\prc.jar 2da -n - 2>&1 -> valid2da.log
@dir /b /s Craft2das\*.2da | java -Xmx150m -jar tools\prc.jar 2da -n - 2>&1 -> validcraft2da.log
@pause
