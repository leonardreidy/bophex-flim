# Bophex Flim

This project takes Rukano's Aphex Twin Flim Generator as it's point of departure. The goal is to use Rukano's project as a point of departure for thinking about and building useful SuperCollider projects for composing and performing music. If you want to take a look at the original unfinished repo click
[here](https://github.com/rukano/scprivatepool/tree/master/projects/aphex_flim/).
To check out Rukano's other work, navigate [here](https://github.com/rukano).

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
4. Once the server has rebooted, execute the main code block.
5. If there are no errors, open the GUI file: `bos0n-flim--gui.scd`.
6. Execute the main code block. The GUI widget should now be visible.
7. Start song playback with the START ALL button. Try the other buttons and controls.

### Troubleshooting

#### Memory allocation issues
If step 3 was not successful, you may need to increase the memory size further, try 8, 16, or higher. If you are still unsuccessful check the troubleshooting section at the bottom of the file for further advice.

#### GUI widget visibility
The GUI widget may not be visible at first, even if the project is running successfully. If it doesn't raise to the front of other applications immediately, you may need to check the OS taskbar. If the icon is visible click it to bring it to the front of other applications. It is also possible that either the synths code or the GUI code failed to execute successfully. Check for errors in the Post Window of the Supercollider IDE. If you cannot resolve the issue with a Google search and keywords or key phrases from the error log, create an issue on this repository with detailed steps to reproduce your problem, and a copy of the logs from the IDE post window and I will try to help you to resolve the issue, time permitting.

#### General advice
If all else fails, execute 'Kill all Servers' from the Server menu, and repeat all steps. If this fails, execute 'Kill all Servers' again and close the Supercollider IDE. Reopen, and repeat the steps. If this fails, which it may on occasion, reboot the OS. This is a last resort solution and shouldn't be necessary very often. But there are some situations in which it is unavoidable. Operating systems are complex and the interactions between operating systems and the user land applications that run on them are extremely complex and many issues lie outside the user's control, and indeed the developer's control.


### Todo

Add a Wiki, discuss the broader goals of the project with contributors, and begin documenting the process of building further subprojects for composing, making and performing music with Supercollider.

### License (TODO)

Because this project is based on code originally by another author, [Rukano](https://github.com/rukano), but not a standard fork, I cannot claim exclusive ownership or copyright of the project code. The code in the GUI module is largely a refactor and it is very much the product of my own work and understanding. But the approach to making music with Supercollider articulated by the original source files, and much of the existing source code, largely, though not exclusively in the synths module, was originally authored by [Rukano](https://github.com/rukano) and he deserves any credit and any copyright that may attach to the original source code. Please use the code with the corresponding care, respect and whatever legal responsibilities attach to using code with this heritage. So, have fun with the code and don't be an asshole. On that note, I should also add the following standard disclaimer:

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.