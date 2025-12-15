# Qtile Config
# Author: jeancarlos.dev
# Github: https://github.com/jeancarlos-ing
#
# A clean, efficient, and well-commented configuration file for the Qtile Window Manager.
# Optimized and commented by Gemini (A Google AI).

# ===================================================================
# IMPORTS & GLOBAL VARIABLES
# ===================================================================

# Import necessary modules from the Qtile library and standard Python libraries
import os
import subprocess
from libqtile import bar, hook, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy

# --- Essential Global Variables ---
mod = "mod4"        # Super key (Windows/Cmd key) for all main shortcuts
terminal = "alacritty"
browser = "qutebrowser"
emacs = "emacsclient -c -a 'emacs' "
launcher = "dmenu_run -c -bw 2 -l 20 -g 4 -p 'RUN:'"
font = "Mononoki Nerd Font"
temperature = "redshift -O 2400"
no_temperature = "redshift -x"
screenshot = "scrot 'screenshot_%Y-%m-%d-%T_$wx$h.png' -e 'mkdir -p ~/.screenshots/ | mv $f ~/.screenshots/'"
screenshot_capture = "scrot -s 'screenshot_%Y-%m-%d-%T_$wx$h.png' -e 'mkdir -p ~/.screenshots/ | mv $f ~/.screenshots/'"
bookmarkthis = "/home/jc/.local/bin/bookmarkthis"

# ===================================================================
# THEMES / COLORS
# ===================================================================

# Define color palettes (e.g., DoomOne, Dracula).
# Index 8 (color07) is typically used for the active/focus border.

DoomOne = [
    ["#282c34", "#282c34"], # [0] Background
    ["#bbc2cf", "#bbc2cf"], # [1] Foreground (Text)
    ["#1c1f24", "#1c1f24"], # [2] Black/Inactive
    ["#ff6c6b", "#ff6c6b"], # [3] Red
    ["#98be65", "#98be65"], # [4] Green
    ["#da8548", "#da8548"], # [5] Yellow
    ["#51afef", "#51afef"], # [6] Blue
    ["#c678dd", "#c678dd"], # [7] Magenta
    ["#46d9ff", "#46d9ff"], # [8] Cyan (Primary Accent/Focus Border)
    ["#7d7d7d", "#7d7d7d"]  # [9] Gray (Secondary Inactive)
    ]

# --- Selected Theme ---
colors = DoomOne

# ===================================================================
# CUSTOM LAZY FUNCTIONS
# ===================================================================

# NOTE: The add_treetab_section function is kept for compatibility,
# but the TreeTab layout must be uncommented below for it to work.
@lazy.layout.function
def add_treetab_section(layout):
    """Prompts user for a section name in TreeTab layout."""
    prompt = qtile.widgets_map["prompt"]
    prompt.start_input("Section name: ", layout.cmd_add_section)

@lazy.function
def minimize_all(qtile):
    """Toggles the minimized state of all windows in the current group."""
    for win in qtile.current_group.windows:
        if hasattr(win, "toggle_minimize"):
            win.toggle_minimize()
            
@lazy.function
def maximize_by_switching_layout(qtile):
    """Toggles the current layout between 'monadtall' and 'max'."""
    current_layout_name = qtile.current_group.layout.name
    if current_layout_name == 'monadtall':
        qtile.current_group.layout = 'max'
    elif current_layout_name == 'max':
        qtile.current_group.layout = 'monadtall'
# *** END CUSTOM FUNCTIONS ***

# ===================================================================
# GROUPS (Workspaces)
# ===================================================================

groups = []
# Group names map to the keybindings (1, 2, 3...)
group_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"] 

# Labels displayed in the GroupBox widget (Nerd Font icons or text)
group_labels = ["DEV", "WWW", "SYS", "DOC", "VBOX", "CHAT", "MUS", "VID", "GFX", "MISC"]

# Default layout for each workspace
group_layouts = ["monadtall"] * len(group_names)

# Create the Group objects
for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
        ))

# ===================================================================
# KEYBINDINGS
# ===================================================================

keys = [
    # --- Qtile & System Essentials ---
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch Terminal"),
    Key([mod, "shift"], "Return", lazy.spawn(launcher), desc='Run Launcher'),
    Key([mod, "shift"], "b", lazy.spawn(bookmarkthis), desc='Save bookmark'),
    Key([mod], "w", lazy.spawn(browser), desc='Launch Web browser'),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle to next layout in group"),
    Key([mod, "shift"], "c", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload Qtile config in place"),
    Key([mod, "shift"], "q", lazy.spawn("dm-logout -r"), desc="Show Logout menu"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using prompt"),
    Key([mod], "b", lazy.hide_show_bar('all'), desc="Toggle all bars to show/hide"),

    # --- Window Focus and Movement ---
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left pane/window"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right pane/window"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window in stack"),
    
    # Move windows (Swap position)
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window left (or tab left in TreeTab)"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window right (or tab right in TreeTab)"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down/next"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up/previous"),
    Key([mod, "shift"], "space", lazy.layout.toggle_split(), desc="Toggle between split and unsplit (Monad/Stack)"),

    # --- Sizing, Floating, Fullscreen ---
    Key([mod], "equal", 
        lazy.layout.grow_main().when(layout=["monadtall", "monadwide"]), 
        lazy.layout.grow().when(layout=["bsp", "columns"]), 
        desc="Increase window size/master width"),
    Key([mod], "minus", 
        lazy.layout.shrink_main().when(layout=["monadtall", "monadwide"]), 
        lazy.layout.shrink().when(layout=["bsp", "columns"]), 
        desc="Decrease window size/master width"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "m", maximize_by_switching_layout(), desc='Toggle MAX/TALL layout (Quick Maximize)'), # Uses custom function
    Key([mod], "t", lazy.window.toggle_floating(), desc='Toggle window floating mode'),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc='Toggle fullscreen'),
    Key([mod, "shift"], "m", minimize_all(), desc="Toggle hide/show all windows (Minimize all)"),
    
    # --- Monitor/Screen Focus ---
    Key([mod], "period", lazy.next_screen(), desc='Move focus to next monitor'),
    Key([mod], "comma", lazy.prev_screen(), desc='Move focus to previous monitor'),
    
    # --- Redshift ---
    Key([mod], "x", lazy.spawn(temperature), desc='Control temperature of color'),
    Key([mod,"shift"], "x", lazy.spawn(no_temperature), desc='Control temperature of color'),
    
    # --- Screenshot
    Key([mod], "s", lazy.spawn(screenshot)),
    Key([mod, "shift"], "s", lazy.spawn(screenshot_capture)),

    # ------------ Hardware Configs ------------

    # Volume
    Key(["control"], "F7", lazy.spawn(
        "pactl set-sink-volume @DEFAULT_SINK@ -5%"
    )),
    Key(["control"], "F8", lazy.spawn(
        "pactl set-sink-volume @DEFAULT_SINK@ +5%"
    )),
    Key(["control"], "F9", lazy.spawn(
        "pactl set-sink-mute @DEFAULT_SINK@ toggle"
    )),

    # Brightness
    Key(["control"], "F5", lazy.spawn("brightnessctl set +10%")),
    Key(["control"], "F6", lazy.spawn("brightnessctl set 10%-")),

    # --- Group/Workspace Navigation ---
    Key([mod, "control"], "Right", lazy.screen.next_group(), desc="Switch to the next group on the right"),
    Key([mod, "control"], "Left", lazy.screen.prev_group(), desc="Switch to the previous group on the left"),
]

# --- Group Keybindings Generation ---
# Generates bindings for switching group and moving window to group (MOD + Num, MOD + Shift + Num)
for i in groups:
    keys.extend(
        [
            # MOD + Num: Switch to group (workspace)
            Key([mod], i.name, lazy.group[i.name].toscreen(), desc="Switch to group {}".format(i.name)),
            # MOD + Shift + Num: Move focused window to group
            Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=False), desc="Move focused window to group {}".format(i.name)),
        ]
    )

# ===================================================================
# LAYOUTS
# ===================================================================

# Default settings for all layouts
layout_theme = {
    "border_width": 2,
    "margin": 12, # A good margin makes the desktop look cleaner
    "border_focus": colors[8],
    "border_normal": colors[0]
}

# List of active layouts
layouts = [
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.Max(**layout_theme),
    # layout.Bsp(**layout_theme), # Useful alternative for dense coding
    # layout.Columns(**layout_theme),
    # layout.Stack(num_stacks=2, **layout_theme),
    # layout.Tile(**layout_theme),
    # layout.TreeTab(font=font, section_fg=colors[8], **layout_theme)
]

# ===================================================================
# BAR AND WIDGETS
# ===================================================================

# Default Settings for All Widgets
widget_defaults = dict(
    font=font,
    fontsize = 12,
    padding = 3, # Increased padding for better separation
    background=colors[0] 
)

extension_defaults = widget_defaults.copy()

def init_widgets_list():
    """Initializes the main widget list for the primary bar."""
    widgets_list=[
        widget.Prompt(
            font = font,
            fontsize=14,
            foreground = colors[1]
        ),
        widget.GroupBox(
            fontsize = 11,
            margin_y = 5,
            margin_x = 10,
            padding_y = 0,
            padding_x = 2,
            borderwidth = 3,
            active = colors[8],
            inactive = colors[9], 
            rounded = False,
            highlight_method = "line",
            this_current_screen_border = colors[7],
            this_screen_border = colors [4],
            other_current_screen_border = colors[7],
            other_screen_border = colors[4],
        ),
        widget.Sep( # Separator
            linewidth = 1,
            padding = 10,
            foreground = colors[9],
            background = colors[0]
        ),
        widget.CurrentLayout(
            foreground = colors[1],
            padding = 8,
            fmt='Layout: {}' # Improved format
        ),
        widget.Sep( # Separator
            linewidth = 1,
            padding = 10,
            foreground = colors[9],
            background = colors[0]
        ),
        widget.WindowName(
            foreground = colors[6],
            padding = 8,
            max_chars = 60 # Allows more space for long titles
        ),
        # --- Right Side Widgets (System Information) ---
        widget.GenPollText( # Kernel version
            update_interval = 300,
            func = lambda: subprocess.check_output("uname -r", shell=True, text=True).strip(), # Added .strip()
            foreground = colors[3],
            padding = 8, 
            fmt = '❤ Kernel: {}',
        ),
        widget.CPU(
            foreground = colors[4],
            padding = 8, 
            mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(f'{terminal} -e htop')}, 
            format = ' CPU: {load_percent}%',
        ),
        widget.Memory(
            foreground = colors[8],
            padding = 8, 
            mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(f'{terminal} -e htop')}, 
            format = '{MemUsed: .0f}{mm}',
            fmt = '󰍛 Mem: {}',
        ),
        widget.DF( # Disk Free space
            update_interval = 60,
            foreground = colors[5],
            padding = 8, 
            partition = '/',
            format = ' Disk: {uf}{m} free', # More readable format
            visible_on_warn = False,
        ),
        widget.Volume(
            foreground = colors[7],
            padding = 8, 
            fmt = ' Vol: {}',
        ),
        widget.Clock(
            foreground = colors[8],
            padding = 8, 
            mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn('notify-send "$(date +\"%A, %B %d\")"')}, # Better notification
            format = "⧗ %I:%M %p", 
        ),
        widget.Systray(padding = 6),
        widget.Spacer(length = 8),
    ]
    return widgets_list

# Functions to initialize screens
def init_widgets_screen1():
    return init_widgets_list() 

def init_screens():
    # Define the bar for the screen(s)
    # margin=[top, right, bottom, left]
    return [Screen(top=bar.Bar(
        widgets=init_widgets_screen1(), 
        margin=[8, 12, 0, 12], 
        size=30,
        opacity=0.9 # Optional: Add a slight transparency
    ))]

# This ensures screens are defined and widgets are initialized when Qtile starts
if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_list()
    widgets_screen1 = init_widgets_screen1()

# ===================================================================
# UTILITY FUNCTIONS & HOOKS
# ===================================================================

# --- Mouse Bindings ---
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

# --- Floating Rules ---
dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    border_focus=colors[8],
    border_width=2,
    float_rules=[
        # Default rules for common dialogs
        *layout.Floating.default_float_rules,
        # Custom rules for specific apps
        Match(wm_class="confirmreset"),
        Match(wm_class="dialog"),
        Match(wm_class="download"),
        Match(wm_class="error"),
        Match(wm_class="file_progress"),
        Match(wm_class='kdenlive'),
        Match(wm_class="notification"),
        Match(wm_class='pinentry-gtk-2'),
        Match(wm_class="ssh-askpass"),
        Match(wm_class="Yad"),
        Match(title="pinentry"),
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart" # Focus on new windows smartly
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wmname = "LG3D" # Required for some Java UI toolkits

# --- Startup Hook ---
@hook.subscribe.startup_once
def start_once():
    """Run autostart script once at startup."""
    home = os.path.expanduser('~')
    subprocess.call([f'{home}/.config/qtile/autostart.sh'])
