ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM)
endif

ifeq ($(strip $(DEVKITPRO)),)
$(error "Please set DEVKITPRO in your environment. export DEVKITPRO=<path to>devkitPRO)
endif


all: src/*.s src/*.inc
	arm-none-eabi-gcc -mthumb-interwork -specs=gba.specs -B $(DEVKITARM)/arm-none-eabi/lib/ -lsysbase src/main.S -o build/main.out
	arm-none-eabi-objcopy build/main.out -O binary dfs.gba
	gbafix dfs.gba