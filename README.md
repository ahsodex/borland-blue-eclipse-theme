# Borland Blue Theme for Eclipse

An Eclipse IDE theme inspired by the classic Vim `blue` color scheme and the old
Borland C / blue-screen office-editor look of the 1980's IBM PC. It is the
Eclipse companion to the Borland Blue VS Code theme and uses the same palette.

## Visual Goals

- Cobalt blue editor background (`#00008B`, Vim `darkBlue`)
- High-contrast yellow default text (`#F2F200`)
- Cyan line numbers and accents
- Navy views and panels, a blue title bar and status bar

## What It Covers

| Area | How |
| --- | --- |
| Workbench chrome (views, tabs, dialogs, forms, title bar, status bar) | Eclipse CSS theme built on the stock Dark theme |
| Text editor basics (background, selection, current line, line numbers, annotations) | Editor preferences |
| Java editor (syntax and semantic highlighting, content assist, Javadoc hovers) | JDT preferences |
| Generic Editor files: YAML, JSON, XML, POM, shell, Perl, Markdown, ... | Bundled TextMate (TM4E) theme |
| Debug console, Ant editor, EGit diffs, Search, Compare, Mylyn WikiText | Preferences and theme colors |
| Terminal view (dark gray, like the VS Code terminal) | Terminal preferences |
| DBeaver SQL editor and result sets | DBeaver theme colors (ignored if DBeaver is absent) |

Fonts are not changed.

## Install

1. Build the plug-in jar (PowerShell 7):
   ```powershell
   ./build.ps1
   ```
   This produces `dist/io.github.ahsodex.borlandblue_0.0.1.jar`.

2. Copy the jar into the `dropins` folder of your Eclipse installation, or let
   the script do it:
   ```powershell
   ./build.ps1 -EclipseHome C:\Downloads\eclipse
   ```

3. Restart Eclipse.

4. Open **Window > Preferences > General > Appearance**, choose **Borland Blue**
   as the theme, click **Apply and Close**, and restart Eclipse when prompted.

## Uninstall

1. Switch back to another theme under **Window > Preferences > General >
   Appearance** and restart.
2. Delete `io.github.ahsodex.borlandblue_*.jar` from the `dropins` folder and
   restart again.

## Troubleshooting

### Some editor colors did not change

The theme only supplies defaults. Colors you changed yourself win. To pick up
the theme colors, press **Restore Defaults** on the relevant page:

- **General > Editors > Text Editors** (background, foreground, current line)
- **General > Editors > Text Editors > Annotations**
- **Java > Editor > Syntax Coloring**
- **General > Appearance > Colors and Fonts**
- **Terminal** (background and foreground colors)

### YAML, JSON or other Generic Editor files use another color scheme

These files are colored by TM4E. While Borland Blue is active it becomes the
default dark TextMate theme. If you picked a different TextMate theme earlier,
select **Borland Blue** under **Window > Preferences > TextMate > Theme**.

### Changes to the CSS do not show up

Eclipse caches installed plug-ins. After rebuilding with the same
`Bundle-Version`, start Eclipse once with the `-clean` option, or bump
`Bundle-Version` in `META-INF/MANIFEST.MF` before rebuilding.

## Layout

| Path | Purpose |
| --- | --- |
| `plugin.xml` | Registers the Eclipse theme and the TextMate theme |
| `css/borland-blue.css` | Workbench chrome; imports the files below |
| `css/borland-blue_colors.css` | Theme color definitions (tabs, links, debug console) |
| `css/borland-blue_preferences.css` | Editor, Java, debug, terminal, Ant, EGit and WikiText colors |
| `css/borland-blue_dbeaver.css` | DBeaver SQL editor and result set colors |
| `textmate/borland-blue-color-theme.json` | TextMate theme, same token colors as the VS Code theme |
| `build.ps1` | Packages the jar and optionally installs it into `dropins` |

## Notes

- The theme id contains `dark` on purpose. Eclipse uses it to switch native
  title bars, menus and scroll bars into dark mode.
- Table and tree selection colors are drawn by the operating system and cannot
  be changed by a theme.
- DBeaver mixes the selected result set header color 50% with white for every
  theme except its own Dark theme, so selected headers are a medium gray-blue
  with white text rather than a dark blue.
