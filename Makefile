%.tex: %.docx
	./convertrefs "$<" "$<.tmp"
	pandoc -t latex -f docx+citations --biblatex -L fixcites.lua --wrap=none -i "$<.tmp" -o "$@"
	rm "$<.tmp"
	sed -Ee 's/«REF ([^»]+)»/\\ref{\1}/g; s/«BOOKMARK ([^»]+)»/\\label{\1}/g' -i.bkp "$@"
	rm "$@.bkp"
	./deduprefs <"$@" >"$@.tmp" && mv "$@.tmp" "$@"

%.lyx: %.tex
	/Applications/LyX.app/Contents/MacOS/tex2lyx -e utf8 -f "$<"
	./fixlyxcites <"$@" >"$@.tmp" && mv "$@.tmp" "$@"
	./fixlyxex <"$@" >"$@.tmp" && mv "$@.tmp" "$@"
	./lyxdef <"$@" >"$@.tmp" && mv "$@.tmp" "$@"
