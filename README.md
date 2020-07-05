# Bophex Flim

This project takes Rukano's Aphex Twin Flim Generator as it's point of departure. The goal is to use Rukano's project as a point of departure for thinking about and building useful SuperCollider projects for composing and performing music. If you want to take a look at the original unfinished repo click
[here](https://github.com/rukano/scprivatepool/tree/master/projects/aphex_flim/).

### Basic UI

![Image](https://github.com/leonardreidy/bophex-flim/blob/master/assets/bophex-flim-gui.png)

### How to use the project

To use the project execute the following steps:

1. Run the Supercollider IDE.
2. Open bos0n-flim--synths.scd.
3. Execute the server memory config and server reboot steps at the beginning of the file: bos0n-flim--synths.scd

```supercollider
  Server.local.options.memSize = Server.local.options.memSize * 4;
  Server.local.reboot;

```
4. If the previous step was not successful, you may need to increase the size further, try 8, 16, or higher. If you are still unsuccessful check the troubleshooting section at the bottom of the file for further advice.
5. Once the server has rebooted, execute the main code block. For more information read the comments in the file.
6. If you are successful so far, open the GUI file: bos0n-flim--gui.scd in the Supercollider IDE.
6. Run the main code block (wrapped in parenthesis) in that file.
7. If you have difficulty running the main GUI code block refer to that file for further guidance.
8. If all else fails, short of rebooting the machine, execute 'Kill all Servers' from the Server menu, and repeat all steps.
9. If killing all servers, restarting the Supercollider IDE, and rebooting the machine fail, please add an issue to the repository with detailed steps to reproduce the issues you have encountered, and ideally a log of the error messages you encounter in the Supercollider IDE Post Window.

### TODO

Add a Wiki, discuss the broader goals of the project with contributors, and begin documenting the process of building further subprojects for composing, making and performing music with Supercollider.