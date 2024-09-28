#!/usr/bin/env python3
import argparse
import logging
import sys
import signal
import gi
import json

gi.require_version("Playerctl", "2.0")
from gi.repository import Playerctl, GLib

logger = logging.getLogger(__name__)


ICON = {
    "Playing": "⏸ ",
    "Paused": " ",
}


class OutputFormat:
    def __init__(self, **kwargs):
        self.json: bool = kwargs.get("json", False)
        self.length: int | None = kwargs.get("length", None)


def get_position(player) -> str:
    try:
        position = player.get_position()
        length = player.props.metadata["mpris:length"]
        position = round(position / length * 100)
        return f" ({position}%)"
    except (GLib.GError, KeyError):
        return ""


def write_output(text, player, output_format: OutputFormat):
    logger.info("Writing output")

    position = get_position(player)
    visible_text = text[: output_format.length] + position
    if output_format.json:
        output = {
            "text": visible_text,
            "class": "custom-" + player.props.player_name,
            "alt": player.props.status,
            "tooltip": player.props.player_name + "\n" + text,
        }
        output = json.dumps(output, ensure_ascii=False)
    else:
        output = ICON.get(player.props.status, "") + visible_text

    sys.stdout.write(output + "\n")
    sys.stdout.flush()


def watch_position(player, manager, output_format: OutputFormat):
    def tick_handler():
        if not player.props.can_control:
            return False
        on_metadata(player, player.props.metadata, manager, output_format)
        return player.props.status == "Playing"

    GLib.timeout_add_seconds(1, tick_handler)


def on_play(player, status, manager, output_format: OutputFormat):
    logger.info("Received new playback status")

    if status == Playerctl.PlaybackStatus.PLAYING:
        watch_position(player, manager, output_format)
    on_metadata(player, player.props.metadata, manager, output_format)


def on_metadata(player, metadata, manager, output_format: OutputFormat):
    logger.info("Received new metadata")
    track_info = ""

    artist = player.get_artist()
    title = player.get_title()
    if (
        player.props.player_name == "spotify"
        and isinstance(metadata, dict)
        and ":ad:" in player.props.metadata.get("mpris:trackid", "")
    ):
        track_info = "AD PLAYING"
    elif artist not in ("", None) and title != "":
        track_info = f"{artist} - {title}"
    else:
        track_info = title or ""

    write_output(track_info, player, output_format)


def on_player_appeared(manager, player, selected_player, output_format: OutputFormat):
    if player is not None and (
        selected_player is None or player.name == selected_player
    ):
        init_player(manager, player, output_format)
    else:
        logger.debug("New player appeared, but it's not the selected player, skipping")


def on_player_vanished(manager, player):
    logger.info("Player has vanished")
    sys.stdout.write("\n")
    sys.stdout.flush()


def init_player(manager, name, output_format: OutputFormat):
    logger.debug("Initialize player: {player}".format(player=name.name))
    player = Playerctl.Player.new_from_name(name)
    player.connect(
        "playback-status",
        on_play,
        manager,
        output_format,
    )

    player.connect(
        "metadata",
        on_metadata,
        manager,
        output_format,
    )
    player.connect(
        "seeked",
        on_metadata,
        manager,
        output_format,
    )

    watch_position(player, manager, output_format)
    manager.manage_player(player)
    on_metadata(player, player.props.metadata, manager, output_format)


def signal_handler(sig, frame):
    logger.debug("Received signal to stop, exiting")
    sys.stdout.write("\n")
    sys.stdout.flush()
    # loop.quit()
    sys.exit(0)


def parse_arguments():
    parser = argparse.ArgumentParser()

    # Increase verbosity with every occurance of -v
    parser.add_argument("-v", "--verbose", action="count", default=0)
    # Define for which player we're listening
    parser.add_argument("--player")
    # Use json output format for waybar (default is plaintext format for polybar)
    parser.add_argument("-j", "--json", action="store_true")
    # Use json output format for waybar (default is plaintext format for polybar)
    parser.add_argument("-l", "--length", type=int)

    return parser.parse_args()


def main():
    arguments = parse_arguments()
    output_format = OutputFormat(**arguments.__dict__)

    # Initialize logging
    logging.basicConfig(
        stream=sys.stderr,
        level=logging.DEBUG,
        format="%(name)s %(levelname)s %(message)s",
    )

    # Logging is set by default to WARN and higher.
    # With every occurrence of -v it's lowered by one
    logger.setLevel(max((3 - arguments.verbose) * 10, 0))

    # Log the sent command line arguments
    logger.debug("Arguments received {}".format(vars(arguments)))

    manager = Playerctl.PlayerManager()
    loop = GLib.MainLoop()

    manager.connect(
        "name-appeared",
        lambda manager, player: on_player_appeared(
            manager, player, arguments.player, output_format
        ),
    )
    manager.connect("player-vanished", on_player_vanished)

    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)

    for player in manager.props.player_names:
        if arguments.player is not None and arguments.player != player.name:
            logger.debug(
                "{player} is not the filtered player, skipping it".format(
                    player=player.name
                )
            )
            continue

        init_player(manager, player, output_format)

    loop.run()


if __name__ == "__main__":
    main()
