all: main.S
	arm-none-eabi-gcc -mthumb-interwork -specs=gba.specs -B $(DEVKITARM)/arm-none-eabi/lib/ -lsysbase main.S -o main.out
	arm-none-eabi-objcopy main.out -O binary main.gba
	gbafix main.gba