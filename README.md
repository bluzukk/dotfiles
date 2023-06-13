
> This setup is heavily focused on only using colors defined by [Pywal](https://github.com/dylanaraps/pywal).

<image align="center" src="awesome-base/assets/screenshots/screen.png"/>


<image align="right" width="400" src="awesome/assets/screenshots/fetch.png"/>

Details about my setup:
+ **WM**: [**AwesomeWM**](https://github.com/awesomeWM/awesome/) (👾 config included)
+ **Font**: [**Cascadia-Code**](https://github.com/microsoft/cascadia-code)
+ **Terminal**: [**st**](https://st.suckless.org/) (👾 config included)
+ **Shell**: [**zsh**](https://wiki.archlinux.org/index.php/Zsh) (👾 config included)
+ **File Manager**: [**lf**](https://github.com/gokcehan/lf) (👾 config included)
+ **Editor**: [**Neovim**](https://github.com/neovim/neovim/) (👾 config included)
+ **Mail**: [**NeoMutt**](https://github.com/neomutt/neomutt) (👾 config included)
+ **Browser**: [**Librewolf**](https://librewolf.net/) ([SimpleFox](https://github.com/migueravila/SimpleFox) + [Pywalfox](https://github.com/Frewacom/pywalfox))

## 


## Installation

1. Install dependencies then move stuff into your `.config/` or use symlinks ;)
```shell
yay -S awesome-git alsa-utils python-pywal ttf-cascadia-code
```
2. Configure important Variables. You should adjust the variables in `awesome/rc.lua` to make everything work as expected.
3. Optional: Configure `awesome/config/settings.lua`. (Default Apps, Font, Panels, Gaps, Shapes, ...)

## Notable Features
#### 
- [x]  **[Dashboard including](#dashboard)**
    - [x] Clock + Greeter
    - [x] Volume Control
    - [x] Microphone Control
    - [ ] Brightness Control
    - [x] Weather (Current + 5 Day Forecast)
    - [x] Calendar
    - [x] Notes/To-Do List
    - [x] Powermenu
    - [x] System Info/Graphs (Temps/Usage/Processes/Clocks/...)
####
- [x] **[Zenmode Panel](#zenmode-panel)**
- [x] **[Theme Changer](#theme-changer-select-wallpaper-and-call-pywalpyfox-etc)**
- [x] **[Alternative Panel](#alternative-continuous-panel)**


## Keybinds
> **Note** <br>
> I do not cover all keybinds here. You can change them in `awesome/config/keybinds.lua`.

#### Basics
| Keybind | Action |
| --- | --- |
| <kbd>super + Enter</kbd> | Spawn Terminal |
| <kbd>super + t</kbd> | Launch Browser |
| <kbd>super + z</kbd> | Launch alternative Browser |
| <kbd>super + u</kbd> | Launch Wallpaper Selector |
| <kbd>super + Space</kbd> | Launch Prompt (App Launcher) |
| <kbd>super + Shift + Space</kbd> | Toggle Dashboard |
| <kbd>super + F1</kbd> | Launch NeoMutt |
| <kbd>super + F4</kbd> | Toggle Zenmode |
| ... | ... |


#### Tag/Client/Layout Keys
| Keybind | Action |
| --- | --- |
| <kbd>super + Tab </kbd> | Focus next Client by ID |
| <kbd>super + q</kbd> | Close client |
| <kbd>super + f</kbd> | Toggle fullscreen |
| <kbd>super + n</kbd> | Minimize |
| <kbd>super + m</kbd> | Restore minimized |
| <kbd>super + s</kbd> | Toggle sticky client |
| <kbd>super + Control + Space</kbd> | Toggle floating client |
| <kbd>super + [1-3]</kbd> | View Tag [1-3] |
| <kbd>super + Shift + [1-3]</kbd> | Move focused client to tag [1-3]|
| <kbd>super + [arrow keys]</kbd> | Increase/Decrease Client Size |
| <kbd>super + [hjkl]</kbd> | Increase/Decrease Client Size |
| <kbd>super + Escape </kbd> | Swap parent/child Clients |
| <kbd>super + ^ </kbd> | Focus next Monitor by ID |
| ... | ... |

## Gallery

<image align="center" src="awesome/assets/screenshots/screen.png"/>

### Dashboard
<image align="center" src="awesome/assets/screenshots/dashboard.png"/>

### Theme Changer (Select Wallpaper and call pywal+pyfox etc.)
<image src="awesome/assets/screenshots/wallpaper-selector.png"/> 


