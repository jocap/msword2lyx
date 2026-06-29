This is a collection of tools to help with conversion from Microsoft
Word to LyX.

**Usage:** `make file.lyx` to convert `file.docx` in the same
directory

* `convertrefs(.pl)` translates bookmarks and references to a special
  syntax, in order to bypass Pandoc, which does not understand them.
  The special syntax is turned into LaTeX commands by `sed`.
* `fixcites.lua` fixes Pandoc's handling of Zotero citations
  (unnecessary since 3.10,
  [see](https://ankarstrom.se/~john/etc/msword2tex.html))
* `deduprefs` removes superfluous references and tries to rename the
  remaining ones into something more descriptive.
* `fixlyxcites` replaces the `\autocite` commands inserted by Pandoc
  with proper LyX citation commands.
* `fixlyxex` replaces `Enumerate` with Covington example environments.
* `fixlyxst` replaces `\st` with LyX strikeout.
* `lyxdef` inserts the user's default LyX template.

**Warning:** The programs that process LyX code (the last three in the
list above) are highly "makeshift" and specialized to my specific
needs. They also rely on the highly specific quirks in the output of
`tex2lyx`, which may change in the future. In addition, the programs
are designed for a Mac OS X environment.
