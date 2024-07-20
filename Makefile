AS := nasm
ASFLAGS := -f elf32
LD := ld
LDFLAGS := -m elf_i386
TARGET := 2happyOs
OBJS = $(patsubst %.asm,%.o,$(wildcard src/*.asm))

.PHONY: all clean build qemu test grub bin

all: qemu

build: src/$(TARGET).bin

src/$(TARGET).bin: link

%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@

link: $(OBJS)
	$(LD) $(LDFLAGS) -T src/linker.ld -o src/$(TARGET).bin $(OBJS)

grub: src/$(TARGET).bin
	mkdir --parents src/iso/boot/grub
	cp src/grub.cfg src/iso/boot/grub/
	mv src/$(TARGET).bin src/iso/boot/
	grub-mkrescue -o 2happyOs.iso src/iso/

qemu: grub
	qemu-system-i386 -cdrom 2happyOs.iso -display gtk

clean:
	@ rm -fr src/*.o $(TARGET).iso src/iso

