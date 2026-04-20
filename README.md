Ghost Scroll is a KDE PLASMA 6.6 Plasmoid. It is made to mimick the style of the PS3 XMB.

The coding architecture has been handled by Gemini and Claude. I acted as the human 
only to fix crashes and bugs. I do not know how to code.

[ FEATURES ]
-Simple Widgets, controlled by mouseover and mouse scroll.
-Fully customizable with QT menus user interface, no need to edit configs via text
-Up to 5 Ghost icons per Widget
-Custom Carousel animation made to be similar to how the PS3 presented the XMB UI
-Able to launch files, programs and some *commands******

[ LICENSING ]
It is fully open-source under the GPL 2.0 license.

[ DISCLAIMER ]
This plasmoid is delivered "as-is".

========================================================================================
                                   HOW TO USE
========================================================================================

Simply browse or cd into the folder you downloaded, install the .tar.gz like so:

     tar -xzf ghost-scroll.tar.gz
     bash ghost-scroll/install.sh

Once installed, just add as a normal widget. 
Right-click on it to show settings.

========================================================================================
                         SUPPORTED SHORTCUTS AND COMMANDS**
========================================================================================

Because of how plasma's QML works, you cannot run direct commands or bash scripts 
via this plasmoid's shortcuts. THIS IS A SAFETY FEATURE.

However, you can still open non-executable files on your computer, as long as your 
system knows what to do.

[ EXAMPLE: FILE EXECUTION ]
1. Click the search button for Icon 1 in Ghost Scroll settings.
2. Point to: /home/user/music/MySong.mp3
3. Ghost Scroll can play this normally.

[ EXAMPLE: URL PROTOCOLS ]
Ghost Scroll can also run anything that runs on the Qt.openUrlExternally protocol.
In the Icon 1 Command or Path setting, type:

    steam://rungameid/12345

(WHERE 12345 = STEAM APP ID OF A GAME INSTALLED ON YOUR SYSTEM)
Your Steam game will open normally.

========================================================================================
