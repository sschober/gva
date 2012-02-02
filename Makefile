all:
	for file in *.gva; do ./gva.pl $$file; done
	for file in *.gv; do fdp -Tsvg -O $$file; done
clean:
	rm -f *.gv *.svg
