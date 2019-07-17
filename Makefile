clean:
	ocamlbuild -clean

test:
	ocamlbuild -use-ocamlfind test.byte && ./test.byte

compile:
	ocamlbuild -use-ocamlfind player.cmo
	ocamlbuild -use-ocamlfind state.cmo
	ocamlbuild -use-ocamlfind command.cmo
	ocamlbuild -use-ocamlfind gui.cmo
	ocamlbuild -use-ocamlfind test.cmo
	ocamlbuild -use-ocamlfind main.cmo
play:
	ocamlbuild -use-ocamlfind main.byte && ./main.byte
