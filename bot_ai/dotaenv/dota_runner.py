import time
import subprocess
import pyautogui as gui

SHOT_TO_DISPLAY_X = 1440.0 / 2880
SHOT_TO_DISPLAY_Y = 900.0 / 1800

LOWER_BAR_X = 711
LOWER_BAR_Y = 872

LOWER_BUTTON_X = 1062
LOWER_BUTTON_Y = 799

CONFIRM_BUTTON_X = 646
CONFIRM_BUTTON_Y = 490

INTERVAL = 0.1
DURATION = 1
PAUSE = 1
flag = False

import os

os.environ['KMP_DUPLICATE_LIB_OK'] = 'True'


def prepare_steam_client():
    if _is_steam_launched():
        _focus_steam_window()
    else:
        # bring up spotlight search
        gui.hotkey('command', 'space')
        time.sleep(INTERVAL)
        gui.typewrite('steam', interval=INTERVAL, pause=PAUSE)

        # Run the first option
        gui.press('enter', pause=PAUSE)
        time.sleep(10)
        prepare_steam_client()


def prepare_dota_client():
    if _is_dota_launched():
        _focus_dota_window()
    else:

        # Search for Dota 2 in the library
        gui.click(x=62, y=108)
        gui.typewrite('dota', interval=INTERVAL)

        # Press play
        gui.click(x=343, y=225, pause=30)
        calibrate_dota_client()
        start_game()
        time.sleep(15)


def start_game():
    # Start
    gui.click(x=1198, y=813, duration=DURATION, pause=PAUSE)
    # Create lobby
    gui.click(x=1128, y=299, duration=DURATION, pause=PAUSE)
    # Join coaches
    gui.click(x=1045, y=372, duration=DURATION, pause=PAUSE)
    # Start game
    gui.click(x=1198, y=813, duration=DURATION, pause=PAUSE)


def restart_game():
    prepare_steam_client()
    prepare_dota_client()


def close_steam_client():
    if not _is_steam_launched():
        return
    _focus_steam_window()
    # exit the steam client
    gui.hotkey('command', 'q')
    time.sleep(10)


def close_dota_client():
    if not _is_dota_launched():
        return
    _focus_dota_window()
    # Bring up the menu
    gui.click(x=230, y=83, pause=2 * PAUSE)
    # Disconnect
    gui.click(x=LOWER_BUTTON_X, y=LOWER_BUTTON_Y, pause=2 * PAUSE)
    # Confirm it
    gui.click(x=647, y=511, pause=4 * PAUSE)
    # Exit
    gui.click(x=1213, y=85, pause=2 * PAUSE)
    # Confirm it and wait for complete closure
    gui.click(x=CONFIRM_BUTTON_X, y=CONFIRM_BUTTON_Y, pause=PAUSE)
    time.sleep(10)


def calibrate_dota_client():
    gui.press('\\', pause=PAUSE)
    gui.typewrite('sv_cheats 1', interval=INTERVAL)
    gui.press('enter', pause=PAUSE)
    gui.typewrite('host_timescale 5', interval=INTERVAL)
    gui.press('enter', pause=PAUSE)
    gui.press('\\', pause=PAUSE)


def _is_steam_launched():
    return _run_cmd('ps -ef | grep steam').find('Steam Helper') != -1


def _is_dota_launched():
    return _run_cmd('ps -ef | grep dota').find('dota 2 beta') != -1


def _focus_steam_window():
    print()

# gui.moveTo(x=LOWER_BAR_X, y=LOWER_BAR_Y, pause=DURATION)
# gui.click(duration=0.5, button='left')
# gui.moveTo(x=268, y=312, pause=DURATION)
# gui.click(duration=0.5, button='left')


def _focus_dota_window():
    gui.press('\\', pause=PAUSE)
    gui.typewrite('host_timescale 10', interval=INTERVAL)
    gui.press('enter', pause=PAUSE)
    gui.typewrite('restart', interval=INTERVAL)
    gui.press('enter', pause=PAUSE)
    time.sleep(14)
    gui.typewrite('host_timescale 1', interval=INTERVAL)
    gui.press('enter', pause=PAUSE)
    gui.press('\\', pause=PAUSE)
    time.sleep(1)


def _run_cmd(cmd):
    ps = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
    output = ps.stdout.read()
    ps.stdout.close()
    ps.wait()
    return output.decode('utf-8')
