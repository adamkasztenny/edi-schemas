generate: clean
	./generate-schemas.sh
	./verify-json-files.sh

clean:
	rm -rf bots-grammars x12 edifact

run-examples:
	make -C examples run

