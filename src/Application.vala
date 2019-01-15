/*
* Copyright (c) 2017 Felipe Escoto (https://github.com/Philip-Scott/Spice-up)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 59 Temple Place - Suite 330,
* Boston, MA 02111-1307, USA.
*
* Authored by: Felipe Escoto <felescoto95@hotmail.com>
*/

namespace Spice {
    public Spice.Services.Settings settings;
    public string DATA_DIR;
}

public class Spice.Application : Granite.Application {
    public const string PROGRAM_NAME = N_("Spice-Up");
    public const string ABOUT_STOCK = N_("About Spice-Up");
    public const string APP_ID = "com.github.philip-scott.spice-up";
    public const string RESOURCE_PATH = "/com/github/philip-scott/spice-up/";

    public bool running = false;

    public static Spice.Application _instance = null;
    public static unowned Spice.Application instance {
        get {
            if (_instance == null) {
                _instance = new Spice.Application ();
            }
            return _instance;
        }
    }

    construct {
        flags |= ApplicationFlags.HANDLES_OPEN;

        application_id = APP_ID;
        program_name = PROGRAM_NAME;
        exec_name = APP_ID;
        app_launcher = APP_ID;

        build_version = "1.7";

        settings = Spice.Services.Settings.get_instance ();
        Granite.Staging.Services.Inhibitor.initialize (this);
    }

    public override void open (File[] files, string hint) {
        string[] uris = {};
        foreach (var file in files) {
            uris += file.get_uri ();
        }

        var window = get_active_spice_window ();
        if (window == null) {
            activate ();
            window = get_active_spice_window ();
        }

        window.open_file (File.new_for_uri (uris[0]));
        window.show_app ();
    }

    public override void activate () {
        if (!running) {
            weak Gtk.IconTheme default_theme = Gtk.IconTheme.get_default ();
            default_theme.add_resource_path (RESOURCE_PATH);

            var window = new Spice.Window (this);
            this.add_window (window);

            running = true;

            window.show_welcome ();
        }

        get_active_spice_window ().show_app ();
    }

    public static unowned Spice.Window get_active_spice_window () {
        return (Spice.Window) instance.get_active_window ();
    }
}
