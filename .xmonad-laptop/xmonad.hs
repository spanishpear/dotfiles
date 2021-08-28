-- Xmonad is a dynamically tiling X11 window manager that is written and
-- configured in Haskell. Official documentation: https://xmonad.org

------------------------------------------------------------------------
-- IMPORTS
------------------------------------------------------------------------
    -- Base
import XMonad
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

    -- Actions
import XMonad.Actions.CopyWindow (kill1, killAllOtherCopies)
import XMonad.Actions.CycleWS (WSType(..))
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import qualified XMonad.Actions.TreeSelect as TS
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Actions.Search as S
import XMonad.Actions.DynamicWorkspaces
import XMonad.Actions.DynamicWorkspaceOrder

    -- Data
import Data.Char (isSpace)
import Data.Monoid
import Data.Maybe (isJust)
import Data.Tree
import Data.Functor
import qualified Data.Tuple.Extra as TE
import qualified Data.Map as M

    -- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.DynamicProperty
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory

    -- Layouts
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

    -- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.ShowWName
import XMonad.Layout.Spacing
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

    -- Prompt
import XMonad.Prompt
import XMonad.Prompt.Input
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Man
import XMonad.Prompt.Pass
import XMonad.Prompt.Shell (shellPrompt, prompt, unsafePrompt)
import XMonad.Prompt.Ssh
import XMonad.Prompt.XMonad
import Control.Arrow (first)

    -- Utilities
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Actions.SpawnOn

import Graphics.X11.ExtraTypes.XF86
------------------------------------------------------------------------t
-- VARIABLES
------------------------------------------------------------------------
myFont :: String
myFont = "xft:Mononoki Nerd Font:bold:size=9"

myModMask :: KeyMask
myModMask = mod4Mask       -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "alacritty"   -- Sets default terminal

mySpacingConst :: Integer
mySpacingConst = 3

myBorderWidth :: Dimension
myBorderWidth = 2          -- Sets border width for windows

myNormColor :: String
myNormColor   = "#292d3e"  -- Border color of normal windows

myFocusColor :: String
myFocusColor  = "#bbc5ff"  -- Border color of focused windows

altMask :: KeyMask
altMask = mod1Mask         -- Setting this for use in xprompts

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

------------------------------------------------------------------------
-- AUTOSTART
------------------------------------------------------------------------
spawnToWorkspace :: String -> String -> X ()
spawnToWorkspace program workspace = do
                                      spawn program     
                                      windows $ W.greedyView workspace

myStartupHook :: X ()
myStartupHook = do
          setWMName "LG3D"
          spawnOnce "nitrogen --restore &"
          spawnOnce "xmodmap ~/.Xmodmap"



------------------------------------------------------------------------
-- GRID SELECT
------------------------------------------------------------------------
-- GridSelect displays items (programs, open windows, etc.) in a 2D grid
-- and lets the user select from it with the cursor/hjkl keys or the mouse.
myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x29,0x2d,0x3e) -- lowest inactive bg
                  (0x29,0x2d,0x3e) -- highest inactive bg
                  (0xc7,0x92,0xea) -- active bg
                  (0xc0,0xa7,0x9a) -- inactive fg
                  (0x29,0x2d,0x3e) -- active fg

-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 0
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

------------------------------------------------------------------------
-- XPROMPT SETTINGS
------------------------------------------------------------------------
dtXPConfig :: XPConfig
dtXPConfig = def
      { font                = myFont
      , bgColor             = "#292d3e"
      , fgColor             = "#d0d0d0"
      , bgHLight            = "#c792ea"
      , fgHLight            = "#000000"
      , borderColor         = "#535974"
      , promptBorderWidth   = 0
      , promptKeymap        = dtXPKeymap
      , position            = Top
      , height              = 20
      , historySize         = 256
      , historyFilter       = id
      , defaultText         = []
      , autoComplete        = Just 100000  -- set Just 100000 for .1 sec
      , showCompletionOnTab = False
      , searchPredicate     = fuzzyMatch
      , alwaysHighlight     = True
      , maxComplRows        = Nothing      -- set to Just 5 for 5 rows
      }

-- The same config above minus the autocomplete feature which is annoying
-- on certain Xprompts, like the search engine prompts.
dtXPConfig' :: XPConfig
dtXPConfig' = dtXPConfig
      { autoComplete        = Nothing
      }


------------------------------------------------------------------------
-- XPROMPT KEYMAP (emacs-like key bindings for xprompts)
------------------------------------------------------------------------
dtXPKeymap :: M.Map (KeyMask,KeySym) (XP ())
dtXPKeymap = M.fromList $
     map (first $ (,) controlMask)   -- control + <key>
     [ (xK_z, killBefore)            -- kill line backwards
     , (xK_k, killAfter)             -- kill line forwards
     , (xK_a, startOfLine)           -- move to the beginning of the line
     , (xK_e, endOfLine)             -- move to the end of the line
     , (xK_m, deleteString Next)     -- delete a character foward
     , (xK_b, moveCursor Prev)       -- move cursor forward
     , (xK_f, moveCursor Next)       -- move cursor backward
     , (xK_BackSpace, killWord Prev) -- kill the previous word
     , (xK_y, pasteString)           -- paste a string
     , (xK_g, quit)                  -- quit out of prompt
     , (xK_bracketleft, quit)
     ]
     ++
     map (first $ (,) altMask)       -- meta key + <key>
     [ (xK_BackSpace, killWord Prev) -- kill the prev word
     , (xK_f, moveWord Next)         -- move a word forward
     , (xK_b, moveWord Prev)         -- move a word backward
     , (xK_d, killWord Next)         -- kill the next word
     , (xK_n, moveHistory W.focusUp')   -- move up thru history
     , (xK_p, moveHistory W.focusDown') -- move down thru history
     ]
     ++
     map (first $ (,) 0) -- <key>
     [ (xK_Return, setSuccess True >> setDone True)
     , (xK_KP_Enter, setSuccess True >> setDone True)
     , (xK_BackSpace, deleteString Prev)
     , (xK_Delete, deleteString Next)
     , (xK_Left, moveCursor Prev)
     , (xK_Right, moveCursor Next)
     , (xK_Home, startOfLine)
     , (xK_End, endOfLine)
     , (xK_Down, moveHistory W.focusUp')
     , (xK_Up, moveHistory W.focusDown')
     , (xK_Escape, quit)
     ]

------------------------------------------------------------------------
-- WORKSPACES
------------------------------------------------------------------------
-- My workspaces are clickable meaning that the mouse can be used to switch
-- workspaces. This requires xdotool. You need to use UnsafeStdInReader instead
-- of simply StdInReader in xmobar config so you can pass actions to it.

xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

myWorkspaces :: [String]
myWorkspaces = clickable . map xmobarEscape
               $ ["dev", "www", "tutr", "uni", "media"]
  where
        clickable l = [ "<action=xdotool key super+" ++ show n ++ ">" ++ ws ++ "</action>" |
                      (i,ws) <- zip [1..9] l,
                      let n = i ]

------------------------------------------------------------------------
-- MANAGEHOOK
------------------------------------------------------------------------
-- Sets some rules for certain programs. Examples include forcing certain
-- programs to always float, or to always appear on a certain workspace.
-- Forcing programs to a certain workspace with a doShift requires xdotool
-- if you are using clickable workspaces. You need the className or title
-- of the program. Use xprop to get this info.


myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     [] <+> namedScratchpadManageHook myScratchPads


------------------------------------------------------------------------
-- LOGHOOK
------------------------------------------------------------------------
-- Sets opacity for inactive (unfocused) windows. I prefer to not use
-- this feature so I've set opacity to 1.0. If you want opacity, set
-- this to a value of less than 1 (such as 0.9 for 90% opacity).
myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount
    where fadeAmount = 1

------------------------------------------------------------------------
-- LAYOUTS
------------------------------------------------------------------------
-- Makes setting the spacingRaw simpler to write. The spacingRaw
-- module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw True (Border i i i i) True (Border i i i i ) True


-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw False (Border 10 0 10 0) True (Border 0 10 0 10) True

-- Defining a bunch of layouts, many that I don't use.
tall     = renamed [Replace "tall"]
           $ limitWindows 12
           $ mySpacing mySpacingConst
           $ ResizableTall 1 (3/100) (1/2) []
grid     = renamed [Replace "grid"]
           $ limitWindows 12
           $ mySpacing mySpacingConst
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
threeRow = renamed [Replace "threeRow"]
           $ limitWindows 7
           $ (mySpacing' $  mySpacingConst `div` 2)
           -- Mirror takes a layout and rotates it by 90 degrees.
           -- So we are applying Mirror to the ThreeCol layout.
           $ Mirror
           $ ThreeCol 1 (3/100) (1/2)

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Sans:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#000000"
    , swn_color             = "#FFFFFF"
    }

-- The layout hook
myLayoutHook = avoidStruts $ mouseResize $ windowArrange {-$ T.toggleLayouts floats-} $
               mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               -- I've commented out the layouts I don't use.
               myDefaultLayout =     tall
                                 -- ||| magnify
                                 -- ||| noBorders monocle
                                 -- ||| floats
                                 ||| grid
                                 -- ||| noBorders tabs
                                 -- spirals
                                 -- ||| threeCol
                                 ||| threeRow

------------------------------------------------------------------------
-- SCRATCHPADS
------------------------------------------------------------------------
-- Allows to have several floating scratchpads running different applications.
-- Import Util.NamedScratchpad.  Bind a key to namedScratchpadSpawnAction.

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "discord" "discord" (className =? "discord") discordHook
                , NS "slack" "slack" (className =? "Slack") spotifyHook
                , NS "teams" "teams" (className =? "Microsoft Teams - Preview") teamsHook 
                ]
        where discordHook = customFloating $ rr (1/10) (1/10) (8/10) (8/10)
              spotifyHook = customFloating $ rr (1/10) (1/10) (8/10) (8/10)
              teamsHook   = customFloating $ rr (1/10) (1/10) (8/10) (8/10)
              rr          = W.RationalRect


spotifyHandleEventHook :: Event -> X All
spotifyHandleEventHook = dynamicPropertyChange "WM_NAME" (title =? "Spotify" --> floating)
        where floating = customFloating $ W.RationalRect (1/10) (1/10) (8/10) (8/10)


------------------
-- Other functions
------------------

toggleFloat w = windows (\s -> if M.member w (W.floating s)
                            then W.sink w s
                            else (W.float w (W.RationalRect (1/10) (1/10) (8/10) (8/10)) s))

xReturn :: a -> X a
xReturn = return

moveToNSP :: X ()
moveToNSP = getXWorkspaceId "NSP" >>= windows . W.shift

getXWorkspaceId :: WorkspaceId -> X (WorkspaceId)
getXWorkspaceId w = return w


data WSPrompt = WSPrompt String

instance XPrompt WSPrompt where
  showXPrompt (WSPrompt s) = s

makeWorkspace :: XPConfig -> String -> X ()
makeWorkspace xp s =
  mkXPrompt (WSPrompt s) xp (const $ return []) makeWorkspace'

makeWorkspace' :: String -> X ()
makeWorkspace' = addWorkspaceAt (\x xs -> x:xs)

insertBeforeLast :: x -> [x] -> [x]
insertBeforeLast x []     = [x]
insertBeforeLast x (y:[]) = [x, y]
insertBeforeLast x (y:ys) = y : insertBeforeLast x ys


------------------------------------------------------------------------
-- KEYBINDINGS
------------------------------------------------------------------------
-- I am using the Xmonad.Util.EZConfig module which allows keybindings
-- to be written in simpler, emacs-like format.
myKeys :: [(String, X ())]
myKeys =
    -- Xmonad
        [ ("M-q", spawn "killall xmobar;xmonad --recompile;xmonad --restart")      -- Recompiles xmonad
        , ("M-S-r", spawn "xmonad --restart")        -- Restarts xmonad
        , ("M-S-q", io exitSuccess)                  -- Quits xmonad

    -- Open my preferred terminal
        , ("M-<Return>", spawn myTerminal)

    -- Run Prompt
        , ("M-<Space>", spawn "/home/shrey/.config/rofi/launchers/ribbon/launcher.sh")   -- app search bar
        , ("M-S-p", spawn "power")

    -- Windows
        , ("M-z", kill1)                           -- Kill the currently focused client
        , ("M-S-z", killAll)  

    -- Floating windows
        , ("M-f", withFocused toggleFloat)       -- Toggles my 'floats' layout

    -- Media keys
        , ("<XF86AudioRaiseVolume>", spawn "/home/shrey/.local/bin/volume_up")
        , ("<XF86AudioLowerVolume>", spawn "/home/shrey/.local/bin/volume_down")
        , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")    
        , ("<XF86AudioMicMute>", spawn "/home/shrey/.local/bin/mic_toggle")

        , ("<XF86AudioPlay>", spawn "playerctl play-pause")    
        , ("<XF86AudioPrev>", spawn "playerctl previous")    
        , ("<XF86AudioNext>", spawn "playerctl next")    
        , ("<XF86MonBrightnessUp>",   spawn "/home/shrey/.local/bin/brightness_up")
        , ("<XF86MonBrightnessDown>", spawn "/home/shrey/.local/bin/brightness_down")

    -- Scratchpads
        , ("M-d", namedScratchpadAction myScratchPads "discord")
        , ("M-s", namedScratchpadAction myScratchPads "slack")
        , ("M-t", namedScratchpadAction myScratchPads "teams")

    -- Utility
        , ("M-b", spawn "firefox")
        , ("M-g", bringSelected $ mygridConfig myColorizer)
        , ("M-n", moveToNSP) -- withFocused $ xReturn . (void <$> runQuery $ doShift "NSP"))
        -- , ("M-w", makeWorkspace dtXPConfig "" >> swapWith Prev AnyWS)
        , ("M-S-w", removeEmptyWorkspace)
        , ("M-S-<Delete>", spawn "shutdown now")

    -- Grid Select (CTRL-g followed by a key)
 --       , ("C-g g", spawnSelected' myAppGrid)                 -- grid select favorite apps
 --       , ("C-g m", spawnSelected' myBookmarkGrid)            -- grid select some bookmarks
 --       , ("C-g c", spawnSelected' myConfigGrid)              -- grid select useful config files
        , ("C-g t", goToSelected $ mygridConfig myColorizer)  -- goto selected window
        , ("C-g b", bringSelected $ mygridConfig myColorizer) -- bring selected window

    -- Windows navigation
        , ("M-m", windows W.focusMaster)     -- Move focus to the master window
        , ("M-j", windows W.focusDown)       -- Move focus to the next window
        , ("M-k", windows W.focusUp)         -- Move focus to the prev window
        , ("M-S-m", windows W.swapMaster)    -- Swap the focused window and the master window
        , ("M-S-j", windows W.swapDown)      -- Swap focused window with next window
        , ("M-S-k", windows W.swapUp)        -- Swap focused window with prev window
        , ("M-<Backspace>", promote)         -- Moves focused window to master, others maintain order
        , ("M1-S-<Tab>", rotSlavesDown)      -- Rotate all windows except master and keep focus in place
        , ("M1-C-<Tab>", rotAllDown)         -- Rotate all the windows in the current stack
        , ("M-C-s", killAllOtherCopies)

    -- Layouts
        , ("M-<Tab>", sendMessage NextLayout)                -- Switch to next layout
        , ("M-C-M1-<Up>", sendMessage Arrange)
        , ("M-C-M1-<Down>", sendMessage DeArrange)
        , ("M-S-<Space>", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full
        , ("M-S-n", sendMessage $ MT.Toggle NOBORDERS)      -- Toggles noborder
        , ("M-<KP_Multiply>", sendMessage (IncMasterN 1))   -- Increase number of clients in master pane
        , ("M-<KP_Divide>", sendMessage (IncMasterN (-1)))  -- Decrease number of clients in master pane
        , ("M-S-<KP_Multiply>", increaseLimit)              -- Increase number of windows
        , ("M-S-<KP_Divide>", decreaseLimit)                -- Decrease number of windows
		, ("M-S-s", spawn "flameshot gui")
        , ("M-h", sendMessage Shrink)                       -- Shrink horiz window width
        , ("M-l", sendMessage Expand)                       -- Expand horiz window width
        , ("M-S-h", foldr1 (>>) (replicate 4 (sendMessage Shrink))) -- Shrink horiz window width
        , ("M-S-l", foldr1 (>>) (replicate 4 (sendMessage Expand))) -- Shrink horiz window width
        , ("M-C-j", sendMessage MirrorShrink)               -- Shrink vert window width
        , ("M-C-k", sendMessage MirrorExpand)               -- Exoand vert window width

    -- Workspaces
        , ("M-.", moveTo Next AnyWS)  -- Switch focus to next monitor
        , ("M-,", moveTo Prev AnyWS)  -- Switch focus to prev monitor
        , ("M-S-.", shiftTo Next nonNSP >> moveTo Next nonNSP)       -- Shifts focused window to next ws
        , ("M-S-,", shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Shifts focused window to prev ws
        ]
        -- The following lines are needed for named scratchpads.
        where nonNSP          = WSIs (return (\ws -> W.tag ws /= "nsp"))
              nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "nsp"))

i_hate_nsps :: (String -> String) -> String -> String
i_hate_nsps f str = if str /= "NSP"
                        then f str
                        else ""

------------------------------------------------------------------------
-- MAIN
------------------------------------------------------------------------
main :: IO ()
main = do
    -- Launching xmobar
    xmproc0 <- spawnPipe "/home/shrey/.local/bin/xmobar /home/shrey/.config/xmobar/xmobarrc0"
    -- the xmonad, ya know...what the WM is named after!
    xmonad $ ewmh def
        { manageHook = ( isFullscreen --> doFullFloat ) <+> myManageHook <+> manageDocks 
        -- Run xmonad commands from command line with "xmonadctl command". Commands include:
        -- shrink, expand, next-layout, default-layout, restart-wm, xterm, kill, refresh, run,
        -- focus-up, focus-down, swap-up, swap-down, swap-master, sink, quit-wm. You can run
        -- "xmonadctl 0" to generate full list of commands written to ~/.xsession-errors.
        , handleEventHook    = serverModeEventHookCmd
                               <+> serverModeEventHook
                               <+> serverModeEventHookF "XMONAD_PRINT" (io . putStrLn)
                               <+> docksEventHook
                               <+> spotifyHandleEventHook
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormColor
        , focusedBorderColor = myFocusColor
        , logHook = workspaceHistoryHook <+> myLogHook <+> dynamicLogWithPP xmobarPP
                        { ppOutput = \x -> hPutStrLn xmproc0 x
                        , ppCurrent = xmobarColor "#293BC4" "#A3BE8C" . wrap "[" "]" -- Current workspace in xmobar
                        , ppVisible = i_hate_nsps (\id -> xmobarColor "#c3e88d" "" id)               -- Visible but not current workspace
                        , ppHidden  = i_hate_nsps (\id -> xmobarColor "#82AAFF" "" (wrap "*" "" id)) -- \_ -> ""   -- Hidden workspaces in xmobar
                        , ppHiddenNoWindows = i_hate_nsps (\id -> xmobarColor "#cba3d9" "" id)        -- Hidden workspaces (no windows)
                        , ppTitle = xmobarColor "#d0d0d0" "" . shorten 40     -- Title of active window in xmobar
                        , ppSep =  "<fc=#666666> | </fc>"                     -- Separators in xmobar
                        , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
                        , ppExtras  = [windowCount]                           -- # of windows current workspace
                        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        , ppSort = getSortByOrder
                        }
        } `additionalKeysP` myKeys
