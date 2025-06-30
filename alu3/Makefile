.PHONY: all program clean

all:
	galette alu.pld

program: all
	minipro -p atf16v8b -w alu.jed

clean:
	rm -f *.chp *.fus *.jed *.pin
	