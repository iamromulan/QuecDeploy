## False positive Virus issue :

Reference from original reported issue here:  [Issue 6](https://github.com/iamromulan/RM520N-GL/issues/6)
Windows Defender thinks this is a virus. **It is not a virus.** Its a false positive as a result of:
1. I do not sign the exe; buy me a cert if you would like (open an issue, looks [expensive](https://www.digicert.com/signing/compare-code-signing-certificates) ) 
2. The tool used to download the files from my mega.nz account ([megatools](https://xff.cz/megatools)) is converted to a base64 and embedded into the ps1 script. The exe is created from the ps1 file using  [PSPackager](https://ironmansoftware.com/release/powershell-packager)

# To fix the issue (new)

If it won't even download then just disable real-time protection until you are done using QuecDeploy:

Go To: Virus & Threat Protection then Manage Settings

![](./images/disable_wind_def1.png)

Set Real-time to off and then try the download again. Be sure to turn it back on when you are done with QuecDeploy.

![](./images/disable_wind_def2.png)

# To fix the issue (old):
After the download fails, Open Windows Defender:

![](./images/allow_wind_def.png)

Anything that says allow click it. If you don't see this then go into protection history and allow it from there:

![](./images/allow_wind_def_hist.png)

**Once Done, try your download again.**
